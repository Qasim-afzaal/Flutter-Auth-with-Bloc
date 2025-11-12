import '../../../../core/constants/app_constants.dart';

/// Helper class for counter statistics and calculations
/// Provides methods to calculate various statistics about counter values
class CounterStatistics {
  /// Calculates the percentage of current value relative to max value
  /// Returns a value between 0.0 and 100.0
  static double getPercentageFromMax(int currentValue) {
    if (AppConstants.counterMaxValue == 0) return 0.0;
    final percentage = (currentValue / AppConstants.counterMaxValue) * 100;
    return percentage.clamp(0.0, 100.0);
  }
  
  /// Calculates the percentage of current value relative to min value
  /// Returns a value between 0.0 and 100.0
  static double getPercentageFromMin(int currentValue) {
    if (AppConstants.counterMinValue == 0) return 0.0;
    final minAbs = AppConstants.counterMinValue.abs();
    final currentAbs = currentValue.abs();
    final percentage = (currentAbs / minAbs) * 100;
    return percentage.clamp(0.0, 100.0);
  }
  
  /// Gets the distance from zero
  /// Returns the absolute value of the counter
  static int getDistanceFromZero(int value) {
    return value.abs();
  }
  
  /// Checks if the value is at the midpoint between min and max
  static bool isAtMidpoint(int value) {
    final midpoint = (AppConstants.counterMaxValue + AppConstants.counterMinValue) ~/ 2;
    return value == midpoint;
  }
}

