import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_service.dart';

/// Theme Selector Widget
/// Provides a menu to select theme mode (Light, Dark, System)
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return PopupMenuButton<ThemeMode>(
          icon: const Icon(Icons.palette),
          tooltip: 'Theme Settings',
          onSelected: (ThemeMode mode) {
            switch (mode) {
              case ThemeMode.light:
                themeService.setLight();
                break;
              case ThemeMode.dark:
                themeService.setDark();
                break;
              case ThemeMode.system:
                themeService.setSystem();
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
                    color: themeService.themeMode == ThemeMode.light
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Light'),
                  if (themeService.themeMode == ThemeMode.light) ...[
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
                    color: themeService.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('Dark'),
                  if (themeService.themeMode == ThemeMode.dark) ...[
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
                    color: themeService.themeMode == ThemeMode.system
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  const Text('System'),
                  if (themeService.themeMode == ThemeMode.system) ...[
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

