import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_bloc_state.dart';

/// Main authentication page
/// Handles login and registration UI
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _buildHomePage(context, state.user);
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return _buildLoginPage(context);
        }
      },
    );
  }

  Widget _buildLoginPage(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    bool isLogin = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(isLogin ? 'Login' : 'Register'),
            centerTitle: true,
          ),
          body: BlocListener<AuthBloc, AuthBlocState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLogin)
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (isLogin) {
                        context.read<AuthBloc>().add(
                              LoginRequested(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      } else {
                        context.read<AuthBloc>().add(
                              RegisterRequested(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              ),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Don\'t have an account? Register'
                          : 'Already have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage(BuildContext context, user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Welcome, ${user.name}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

