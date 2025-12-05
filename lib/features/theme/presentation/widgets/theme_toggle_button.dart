import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

/// Theme Toggle Button Widget
/// Provides a button to toggle between light and dark themes
/// Shows appropriate icon based on current theme
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(const ThemeToggled());
          },
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}

