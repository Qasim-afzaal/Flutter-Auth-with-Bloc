import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'injection/injection_container.dart' as di;
import 'features/auth/presentation/providers/auth_provider.dart';

/// Main entry point using Provider instead of BLoC
/// This demonstrates how to set up Provider for state management
/// 
/// Key differences from BLoC setup:
/// - Uses MultiProvider instead of MultiBlocProvider
/// - Uses ChangeNotifierProvider for AuthProvider
/// - Uses Consumer/Selector instead of BlocBuilder/BlocListener
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyAppProvider());
}

class MyAppProvider extends StatelessWidget {
  const MyAppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provide all providers at root level
      providers: [
        // Auth Provider - manages authentication state
        ChangeNotifierProvider(
          create: (_) => di.sl<AuthProvider>(),
        ),
        // Theme Service - manages theme state
        ChangeNotifierProvider(
          create: (_) => di.sl<ThemeService>(),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            title: 'Auth App (Provider)',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            routerConfig: AppRouterProvider.router,
          );
        },
      ),
    );
  }
}

