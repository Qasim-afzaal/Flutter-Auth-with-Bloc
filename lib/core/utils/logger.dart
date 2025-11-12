/// Simple logging utility for the application
/// Provides methods to log messages at different levels
class Logger {
  /// Logs a debug message
  static void debug(String message) {
    print('[DEBUG] $message');
  }
  
  /// Logs an info message
  static void info(String message) {
    print('[INFO] $message');
  }
  
  /// Logs a warning message
  static void warning(String message) {
    print('[WARNING] $message');
  }
  
  /// Logs an error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('[ERROR] $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}

