import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import '../utils/logger.dart';

/// Theme Service
/// Simple and professional theme management
/// Uses ValueNotifier for reactive updates
/// No BLoC needed for simple state like theme
class ThemeService extends ChangeNotifier {
  final SecureStorageService _storage;
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeService(this._storage) {
    _loadTheme();
  }

  /// Loads saved theme preference
  Future<void> _loadTheme() async {
    try {
      final themeString = await _storage.getString(_themeKey);
      _themeMode = _parseThemeMode(themeString);
      Logger.info('Theme loaded: ${_themeMode.name}');
      notifyListeners();
    } catch (e) {
      Logger.error('Error loading theme', e);
      _themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  /// Sets theme mode and saves to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    try {
      _themeMode = mode;
      final themeString = _themeModeToString(mode);
      await _storage.saveString(_themeKey, themeString);
      Logger.info('Theme saved: ${mode.name}');
      notifyListeners();
    } catch (e) {
      Logger.error('Error saving theme', e);
    }
  }

  /// Toggles between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // If system, default to light
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Sets theme to light mode
  Future<void> setLight() => setThemeMode(ThemeMode.light);

  /// Sets theme to dark mode
  Future<void> setDark() => setThemeMode(ThemeMode.dark);

  /// Sets theme to system default
  Future<void> setSystem() => setThemeMode(ThemeMode.system);

  /// Converts ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parses string to ThemeMode
  ThemeMode _parseThemeMode(String? themeString) {
    if (themeString == null || themeString.isEmpty) {
      return ThemeMode.system;
    }

    switch (themeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

