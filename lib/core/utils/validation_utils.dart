/// Utility functions for input validation
/// Provides common validation methods used across the application
/// 
/// This class contains static methods for validating various types of user input
/// including emails, passwords, names, and other common data formats.
class ValidationUtils {
  /// Validates if an email address is in correct format
  /// Returns true if email is valid, false otherwise
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  
  /// Validates if a password meets minimum requirements
  /// Password must be at least 8 characters long
  /// Returns true if password is valid, false otherwise
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 8;
  }
  
  /// Validates if a name is not empty and has at least 2 characters
  /// Returns true if name is valid, false otherwise
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return name.trim().length >= 2;
  }
  
  /// Validates if a string is not empty
  /// Returns true if string is not empty, false otherwise
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
  
  /// Validates if a number is within a specified range
  /// Returns true if number is within range [min, max], false otherwise
  static bool isInRange(int value, int min, int max) {
    return value >= min && value <= max;
  }
}

