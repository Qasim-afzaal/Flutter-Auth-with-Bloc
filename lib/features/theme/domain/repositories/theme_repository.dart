import 'package:flutter/material.dart';

/// Theme Repository Interface
/// Defines the contract for theme operations
/// Follows Clean Architecture - Domain Layer
abstract class ThemeRepository {
  /// Gets the saved theme mode preference
  /// Returns the saved ThemeMode or null if not set
  Future<ThemeMode?> getThemeMode();
  
  /// Saves the theme mode preference
  /// 
  /// [themeMode] - The theme mode to save (light, dark, or system)
  /// Returns true if successful, false otherwise
  Future<bool> saveThemeMode(ThemeMode themeMode);
}

