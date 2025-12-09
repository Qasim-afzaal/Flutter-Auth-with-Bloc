import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../utils/logger.dart';

/// App Router Configuration
/// Handles all navigation in the app using GoRouter
/// Implements route guards for authentication
class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/login',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        try {
          final authBloc = context.read<AuthBloc>();
          final isAuthenticated = authBloc.state is AuthAuthenticated;
          final isLoginPage = state.matchedLocation == '/login';
          final isSignupPage = state.matchedLocation == '/signup';
          final isDashboardPage = state.matchedLocation == '/dashboard';

          Logger.info('Navigation: ${state.matchedLocation}, Authenticated: $isAuthenticated');

          // If user is authenticated and trying to access login/signup, redirect to dashboard
          if (isAuthenticated && (isLoginPage || isSignupPage)) {
            Logger.info('Redirecting authenticated user to dashboard');
            return '/dashboard';
          }

          // If user is not authenticated and trying to access dashboard, redirect to login
          if (!isAuthenticated && isDashboardPage) {
            Logger.info('Redirecting unauthenticated user to login');
            return '/login';
          }

          return null; // No redirect needed
        } catch (e) {
          Logger.error('Error in router redirect', e);
          return '/login';
        }
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    );
  }

  static final router = createRouter();
}

