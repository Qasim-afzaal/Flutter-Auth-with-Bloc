import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'injection/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide AuthBloc at the root level
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        // Provide HomeBloc at the root level
        BlocProvider(
          create: (context) => di.sl<HomeBloc>(),
        ),
        // Provide ProfileBloc at the root level
        BlocProvider(
          create: (context) => di.sl<ProfileBloc>(),
        ),
        // Provide NotificationBloc at the root level
        BlocProvider(
          create: (context) => di.sl<NotificationBloc>(),
        ),
        // Provide ThemeService at the root level
        ChangeNotifierProvider.value(
          value: di.sl<ThemeService>(),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            title: 'Auth BLoC - Flutter Clean Architecture',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
