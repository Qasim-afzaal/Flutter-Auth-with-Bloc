/// Extension methods for String class
/// Provides convenient methods for string operations
extension StringExtensions on String {
  /// Checks if the string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }
  
  /// Checks if the string is empty or contains only whitespace
  bool get isNullOrEmpty => trim().isEmpty;
  
  /// Capitalizes the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
  
  /// Reverses the string
  String get reversed => split('').reversed.join();
  
  /// Removes all special characters, keeping only alphanumeric characters
  String get alphanumericOnly => replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
}

