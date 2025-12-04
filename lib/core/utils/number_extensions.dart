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
  
  /// Returns the absolute value of the number
  int get absolute => this < 0 ? -this : this;
  
  /// Raises the number to the power of exponent
  /// Returns the result of this^exponent
  int power(int exponent) {
    if (exponent < 0) return 0;
    if (exponent == 0) return 1;
    if (exponent == 1) return this;
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
  
  /// Returns the cube of the number (this³)
  int get cube => this * this * this;
}

