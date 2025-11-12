/// Utility functions for date and time operations
/// Provides common date/time manipulation methods used across the application
class DateUtils {
  /// Formats a DateTime to a readable string
  /// Returns date in format: "YYYY-MM-DD HH:MM:SS"
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_padZero(dateTime.month)}-${_padZero(dateTime.day)} '
           '${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}:${_padZero(dateTime.second)}';
  }
  
  /// Formats a DateTime to date only string
  /// Returns date in format: "YYYY-MM-DD"
  static String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${_padZero(dateTime.month)}-${_padZero(dateTime.day)}';
  }
  
  /// Formats a DateTime to time only string
  /// Returns time in format: "HH:MM:SS"
  static String formatTime(DateTime dateTime) {
    return '${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}:${_padZero(dateTime.second)}';
  }
  
  /// Pads a number with leading zero if less than 10
  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }
  
  /// Gets current timestamp as milliseconds since epoch
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

