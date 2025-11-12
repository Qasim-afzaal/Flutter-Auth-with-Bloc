/// Extension methods for int class
/// Provides convenient methods for number operations
extension NumberExtensions on int {
  /// Checks if the number is even
  bool get isEven => this % 2 == 0;
  
  /// Checks if the number is odd
  bool get isOdd => this % 2 != 0;
  
  /// Checks if the number is positive
  bool get isPositive => this > 0;
  
  /// Checks if the number is negative
  bool get isNegative => this < 0;
  
  /// Formats the number with thousand separators
  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

