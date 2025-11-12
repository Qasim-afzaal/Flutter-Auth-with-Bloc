/// Utility functions for number operations and formatting
/// Provides common number manipulation methods used across the application
/// 
/// This class contains static methods for number operations including clamping,
/// parity checking, formatting, and percentage calculations.
class NumberUtils {
  /// Clamps a number between min and max values
  /// Returns the number if within range, otherwise returns the boundary value
  static int clamp(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
  
  /// Checks if a number is even
  /// Returns true if number is even, false otherwise
  static bool isEven(int number) {
    return number % 2 == 0;
  }
  
  /// Checks if a number is odd
  /// Returns true if number is odd, false otherwise
  static bool isOdd(int number) {
    return number % 2 != 0;
  }
  
  /// Formats a number with thousand separators
  /// Example: 1000 becomes "1,000"
  static String formatWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  /// Calculates percentage of a value
  /// Returns the percentage value as a double
  static double calculatePercentage(int value, int total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }
}

