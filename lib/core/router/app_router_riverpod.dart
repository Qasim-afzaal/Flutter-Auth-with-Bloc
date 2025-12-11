import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider_riverpod.dart';
import '../../features/auth/presentation/pages/login_page_riverpod.dart';
import '../../features/auth/presentation/pages/signup_page_riverpod.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../utils/logger.dart';

/// App Router Configuration using Riverpod
/// This demonstrates how to use Riverpod instead of BLoC/Provider for routing
class AppRouterRiverpod {
  // Route paths
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String dashboardPath = '/dashboard';

  /// Create router provider for Riverpod
  /// Uses Provider to access auth state in redirect
  static final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: loginPath,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        try {
          // Access AuthNotifier using ref.read (Riverpod way)
          final authState = ref.read(authNotifierProvider);
          final isAuthenticated = authState.isAuthenticated;
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
          builder: (context, state) => const LoginPageRiverpod(),
        ),
        GoRoute(
          path: signupPath,
          name: 'signup',
          builder: (context, state) => const SignupPageRiverpod(),
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
  });
}
