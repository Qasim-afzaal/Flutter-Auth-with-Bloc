import 'package:flutter/material.dart';

/// Utility functions for color operations
/// Provides common color manipulation methods used across the application
class ColorUtils {
  /// Converts a hex color string to Color
  /// Accepts formats: "#RRGGBB" or "RRGGBB"
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Converts a Color to hex string
  /// Returns format: "#RRGGBB"
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
  
  /// Lightens a color by a given factor (0.0 to 1.0)
  static Color lighten(Color color, double factor) {
    assert(factor >= 0.0 && factor <= 1.0);
    return Color.fromARGB(
      color.alpha,
      (color.red + (255 - color.red) * factor).round(),
      (color.green + (255 - color.green) * factor).round(),
      (color.blue + (255 - color.blue) * factor).round(),
    );
  }
  
  /// Darkens a color by a given factor (0.0 to 1.0)
  static Color darken(Color color, double factor) {
    assert(factor >= 0.0 && factor <= 1.0);
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
    );
  }
  
  /// Checks if a color is dark (useful for determining text color)
  /// Returns true if color is dark, false if light
  static bool isDark(Color color) {
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }
  
  /// Gets the appropriate text color (black or white) based on background color
  /// Returns white if background is dark, black if light
  static Color getTextColor(Color backgroundColor) {
    return isDark(backgroundColor) ? Colors.white : Colors.black;
  }
}

