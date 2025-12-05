import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_bloc_state.dart';
import '../../domain/entities/user.dart';
import '../../../theme/presentation/widgets/theme_toggle_button.dart';
import '../../../theme/presentation/widgets/theme_selector.dart';

/// Home Page
/// Displayed after successful authentication
/// Shows user information and logout option
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _buildHomeContent(context, state.user);
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildHomeContent(BuildContext context, User user) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to login page after logout
          context.go('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          actions: [
            // Theme selector (Light/Dark/System)
            const ThemeSelector(),
            // Theme toggle button (quick toggle)
            const ThemeToggleButton(),
            // Logout button
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      _buildInfoRow('User ID', user.id),
                      _buildInfoRow('Name', user.name),
                      _buildInfoRow('Email', user.email),
                      if (user.authProvider != null)
                        _buildInfoRow('Auth Provider', user.authProvider!),
                      if (user.gender != null)
                        _buildInfoRow('Gender', user.gender!),
                      if (user.age != null)
                        _buildInfoRow('Age', user.age!),
                      if (user.avatar != null)
                        _buildInfoRow('Profile Image', user.avatar!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

