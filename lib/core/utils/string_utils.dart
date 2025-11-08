/// Utility functions for string manipulation and formatting
/// Provides common string operations used across the application
class StringUtils {
  /// Capitalizes the first letter of a string
  /// Returns the string with first letter uppercase and rest lowercase
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  /// Truncates a string to a specified length
  /// If string is longer than maxLength, it's truncated and '...' is appended
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Removes all whitespace from a string
  /// Returns string with all spaces, tabs, and newlines removed
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }
  
  /// Checks if a string is a valid number
  /// Returns true if string can be parsed as a number, false otherwise
  static bool isNumeric(String text) {
    if (text.isEmpty) return false;
    return double.tryParse(text) != null;
  }
  
  /// Formats a string to title case
  /// Converts "hello world" to "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
}

