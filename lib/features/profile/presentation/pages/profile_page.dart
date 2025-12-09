import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_bloc_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../../features/theme/presentation/widgets/theme_toggle_button.dart';
import '../../../../features/theme/presentation/widgets/theme_selector.dart';

/// Profile Page
/// Displays user profile information and settings
/// Part of the dashboard navigation
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile - ${authState.user.name}'),
              centerTitle: true,
              actions: [
                const ThemeSelector(),
                const ThemeToggleButton(),
              ],
            ),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(const ProfileRequested());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProfileLoaded) {
                  final profile = state.profile;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        
                        // Profile Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: profile.avatar != null && profile.avatar!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    profile.avatar!,
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
                          profile.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        
                        // User Email
                        Text(
                          profile.email,
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
                                subtitle: Text(profile.name),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.email_outlined),
                                title: const Text('Email'),
                                subtitle: Text(profile.email),
                              ),
                              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.info_outline),
                                  title: const Text('Bio'),
                                  subtitle: Text(profile.bio!),
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
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
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
