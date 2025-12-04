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
  
  /// Validates if a phone number is in correct format
  /// Supports international format with optional country code
  /// Returns true if phone number is valid, false otherwise
  static bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Phone number should be between 10 and 15 digits
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }
  
  /// Validates if a URL is in correct format
  /// Returns true if URL is valid, false otherwise
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(url);
  }
  
  /// Validates if a credit card number is in correct format (Luhn algorithm)
  /// Returns true if credit card number is valid, false otherwise
  static bool isValidCreditCard(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    
    // Remove spaces and dashes
    final digitsOnly = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Must be 13-19 digits
    if (digitsOnly.length < 13 || digitsOnly.length > 19) return false;
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = digitsOnly.length - 1; i >= 0; i--) {
      int digit = int.parse(digitsOnly[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}

