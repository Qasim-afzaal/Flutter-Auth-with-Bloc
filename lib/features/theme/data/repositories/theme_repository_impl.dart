import 'package:flutter/material.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/theme_repository.dart';

/// Theme Repository Implementation
/// Implements the ThemeRepository interface
/// Handles theme preference storage operations
/// Follows Clean Architecture - Data Layer
class ThemeRepositoryImpl implements ThemeRepository {
  final SecureStorageService _secureStorage;
  
  // Storage key for theme preference
  static const String _themeKey = 'theme_mode';

  ThemeRepositoryImpl({
    required SecureStorageService secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<ThemeMode?> getThemeMode() async {
    try {
      Logger.info('Loading theme preference from storage');
      
      final themeString = await _secureStorage.getString(_themeKey);
      
      if (themeString == null || themeString.isEmpty) {
        Logger.info('No theme preference found, using system default');
        return ThemeMode.system;
      }
      
      final themeMode = _parseThemeMode(themeString);
      Logger.info('Theme preference loaded: ${themeMode.name}');
      return themeMode;
    } catch (e) {
      Logger.error('Failed to load theme preference', e);
      return ThemeMode.system; // Default to system on error
    }
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    try {
      Logger.info('Saving theme preference: ${themeMode.name}');
      
      final themeString = _themeModeToString(themeMode);
      final success = await _secureStorage.saveString(_themeKey, themeString);
      
      if (success) {
        Logger.info('Theme preference saved successfully');
      } else {
        Logger.warning('Failed to save theme preference');
      }
      
      return success;
    } catch (e) {
      Logger.error('Error saving theme preference', e);
      return false;
    }
  }

  /// Converts ThemeMode to string
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parses string to ThemeMode
  ThemeMode _parseThemeMode(String themeString) {
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

