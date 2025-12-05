import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

/// Theme Selector Widget
/// Provides a menu to select theme mode (Light, Dark, System)
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeMode>(
          icon: const Icon(Icons.palette),
          tooltip: 'Theme Settings',
          onSelected: (ThemeMode mode) {
            final bloc = context.read<ThemeBloc>();
            switch (mode) {
              case ThemeMode.light:
                bloc.add(const ThemeLightRequested());
                break;
              case ThemeMode.dark:
                bloc.add(const ThemeDarkRequested());
                break;
              case ThemeMode.system:
                bloc.add(const ThemeSystemRequested());
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: state.themeMode == ThemeMode.light
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Light'),
                  if (state.themeMode == ThemeMode.light) ...[
                    const Spacer(),
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: state.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Dark'),
                  if (state.themeMode == ThemeMode.dark) ...[
                    const Spacer(),
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.brightness_auto,
                    color: state.themeMode == ThemeMode.system
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('System'),
                  if (state.themeMode == ThemeMode.system) ...[
                    const Spacer(),
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

