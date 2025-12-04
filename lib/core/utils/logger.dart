/// Simple logging utility for the application
/// Provides methods to log messages at different levels
class Logger {
  /// Gets the current timestamp in ISO format
  static String _getTimestamp() {
    return DateTime.now().toIso8601String();
  }
  
  /// Logs a debug message
  static void debug(String message) {
    print('[DEBUG] [${_getTimestamp()}] $message');
  }
  
  /// Logs an info message
  static void info(String message) {
    print('[INFO] [${_getTimestamp()}] $message');
  }
  
  /// Logs a warning message
  static void warning(String message) {
    print('[WARNING] [${_getTimestamp()}] $message');
  }
  
  /// Logs an error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('[ERROR] [${_getTimestamp()}] $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
  
  /// Logs a verbose message (for detailed debugging)
  static void verbose(String message) {
    print('[VERBOSE] [${_getTimestamp()}] $message');
  }
}

