import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'injection/injection_container.dart' as di;

/// Main entry point using Riverpod instead of BLoC/Provider
/// This demonstrates how to set up Riverpod for state management
/// 
/// Key differences from BLoC/Provider:
/// - Uses ProviderScope instead of MultiBlocProvider/MultiProvider
/// - Uses ConsumerWidget for widgets that need state
/// - Uses ref.watch() to read state
/// - Uses ref.read() to call methods
/// - Compile-time safe with better performance
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(
    // ProviderScope wraps the entire app (like MultiBlocProvider/MultiProvider)
    const ProviderScope(
      child: MyAppRiverpod(),
    ),
  );
}

class MyAppRiverpod extends ConsumerWidget {
  const MyAppRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme service for theme changes
    final themeService = ref.watch(themeServiceProvider);
    
    // Watch router provider
    final router = ref.watch(AppRouterRiverpod.routerProvider);

    return MaterialApp.router(
      title: 'Auth App (Riverpod)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      routerConfig: router,
    );
  }
}

/// Theme Service Provider (Riverpod)
/// Provides ThemeService instance
final themeServiceProvider = Provider<ThemeService>((ref) {
  return di.sl<ThemeService>();
});

