import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page_provider.dart';
import '../../features/auth/presentation/pages/signup_page_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../utils/logger.dart';

/// App Router Configuration using Provider
/// This demonstrates how to use Provider instead of BLoC for routing
class AppRouterProvider {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: loginPath,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        try {
          // Access AuthProvider using Provider.of (instead of context.read<AuthBloc>)
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final isAuthenticated = authProvider.isAuthenticated;
          final isLoginPage = state.matchedLocation == loginPath;
          final isSignupPage = state.matchedLocation == signupPath;
          final isDashboardPage = state.matchedLocation == dashboardPath;

          Logger.info('Navigation: ${state.matchedLocation}, Authenticated: $isAuthenticated');

          // If user is authenticated and trying to access login/signup, redirect to dashboard
          if (isAuthenticated && (isLoginPage || isSignupPage)) {
            Logger.info('Redirecting authenticated user to dashboard');
            return dashboardPath;
          }

          // If user is not authenticated and trying to access dashboard, redirect to login
          if (!isAuthenticated && isDashboardPage) {
            Logger.info('Redirecting unauthenticated user to login');
            return loginPath;
          }

          return null; // No redirect needed
        } catch (e) {
          Logger.error('Error in router redirect', e);
          return loginPath;
        }
      },
      routes: [
        GoRoute(
          path: loginPath,
          name: 'login',
          builder: (context, state) => const LoginPageProvider(),
        ),
        GoRoute(
          path: signupPath,
          name: 'signup',
          builder: (context, state) => const SignupPageProvider(),
        ),
        GoRoute(
          path: dashboardPath,
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
  
  // Route paths
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String dashboardPath = '/dashboard';
}

