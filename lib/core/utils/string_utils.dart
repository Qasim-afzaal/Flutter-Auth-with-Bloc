/// Utility functions for string manipulation and formatting
/// Provides common string operations used across the application
/// 
/// This class contains static methods for manipulating and formatting strings
/// including capitalization, truncation, whitespace removal, and case conversion.
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
  
  /// Formats a number with thousand separators
  /// Converts 1000 to "1,000" and 1000000 to "1,000,000"
  static String formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  /// Masks sensitive information in a string
  /// Replaces characters with asterisks, keeping first and last characters visible
  /// Example: "password" becomes "p*****d"
  static String maskSensitive(String text, {int visibleChars = 1}) {
    if (text.length <= visibleChars * 2) return '*' * text.length;
    final start = text.substring(0, visibleChars);
    final end = text.substring(text.length - visibleChars);
    final masked = '*' * (text.length - visibleChars * 2);
    return '$start$masked$end';
  }
}

