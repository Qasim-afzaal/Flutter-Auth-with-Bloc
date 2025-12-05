import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// App Theme Configuration
/// Defines light and dark themes for the application
/// Follows Material Design 3 guidelines
class AppTheme {
  // Primary color for the app
  static const Color _primaryColor = Colors.deepPurple;
  
  // Light Theme Colors
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightSurface = Color(0xFFF5F5F5);
  static const Color _lightOnSurface = Color(0xFF1C1B1F);
  
  // Dark Theme Colors
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkOnSurface = Color(0xFFE6E1E5);

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        primary: _primaryColor,
        secondary: Colors.deepPurpleAccent,
        surface: _lightSurface,
        background: _lightBackground,
        error: Colors.red,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: AppConstants.defaultElevation,
        scrolledUnderElevation: 4.0,
        backgroundColor: _lightSurface,
        foregroundColor: _lightOnSurface,
        iconTheme: IconThemeData(color: _lightOnSurface),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.defaultElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        color: _lightSurface,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        filled: true,
        fillColor: _lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: _lightOnSurface,
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(Brightness.light),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        primary: _primaryColor,
        secondary: Colors.deepPurpleAccent,
        surface: _darkSurface,
        background: _darkBackground,
        error: Colors.redAccent,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: AppConstants.defaultElevation,
        scrolledUnderElevation: 4.0,
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnSurface,
        iconTheme: IconThemeData(color: _darkOnSurface),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.defaultElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        color: _darkSurface,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        filled: true,
        fillColor: _darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: _darkOnSurface,
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(Brightness.dark),
    );
  }

  /// Builds text theme based on brightness
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.light
        ? Typography.material2021(platform: TargetPlatform.android).black
        : Typography.material2021(platform: TargetPlatform.android).white;

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}

