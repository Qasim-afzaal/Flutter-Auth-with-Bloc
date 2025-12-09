import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_bloc_state.dart';
import '../../../../features/theme/presentation/widgets/theme_toggle_button.dart';
import '../../../../features/theme/presentation/widgets/theme_selector.dart';

/// Profile Page
/// Displays user profile information and settings
/// Part of the dashboard navigation
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          const ThemeSelector(),
          const ThemeToggleButton(),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  
                  // Profile Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: user.avatar != null && user.avatar!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              user.avatar!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildAvatarIcon(context),
                            ),
                          )
                        : _buildAvatarIcon(context),
                  ),
                  const SizedBox(height: 16),
                  
                  // User Name
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // User Email
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Profile Information Card
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Full Name'),
                          subtitle: Text(user.name),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text('Email'),
                          subtitle: Text(user.email),
                        ),
                        if (user.authProvider != null) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.security),
                            title: const Text('Auth Provider'),
                            subtitle: Text(user.authProvider!),
                          ),
                        ],
                        if (user.gender != null) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.people_outline),
                            title: const Text('Gender'),
                            subtitle: Text(user.gender!),
                          ),
                        ],
                        if (user.age != null) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.cake_outlined),
                            title: const Text('Age'),
                            subtitle: Text(user.age!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildAvatarIcon(BuildContext context) {
    return Icon(
      Icons.person,
      size: 50,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

