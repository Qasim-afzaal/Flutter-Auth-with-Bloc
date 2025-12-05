import '../config/app_config.dart';

class AppConstants {
  // API Configuration - Uses AppConfig to load from environment
  static String get baseUrl => AppConfig.baseUrl;
  static String get apiVersion => AppConfig.apiVersion;
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Timeouts - Uses AppConfig
  static int get connectionTimeout => AppConfig.connectionTimeout;
  static int get receiveTimeout => AppConfig.receiveTimeout;
  
  // Counter Configuration
  static const int counterMaxValue = 100;
  static const int counterMinValue = -50;
  
  // Counter Step Values
  static const int incrementStep = 1;
  static const int decrementStep = 1;
  static const int doubleMultiplier = 2;
  static const int halfDivisor = 2;
  static const int squareExponent = 2;
  static const int defaultPowerExponent = 2;
  static const int cubeExponent = 3;
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 2.0;
  
  // Animation Durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 300; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds
  
  // Animation Curves
  static const String curveEaseIn = 'easeIn';
  static const String curveEaseOut = 'easeOut';
  static const String curveEaseInOut = 'easeInOut';
  
  // Animation Helpers
  static Duration shortDuration = const Duration(milliseconds: shortAnimationDuration);
  static Duration mediumDuration = const Duration(milliseconds: mediumAnimationDuration);
  static Duration longDuration = const Duration(milliseconds: longAnimationDuration);
  
  // App Version
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appName = 'Auth BLoC';
  
  // Error Messages
  static const String errorNetworkConnection = 'Network connection error. Please check your internet connection.';
  static const String errorServerError = 'Server error occurred. Please try again later.';
  static const String errorAuthenticationFailed = 'Authentication failed. Please check your credentials.';
  static const String errorValidationFailed = 'Validation failed. Please check your input.';
  static const String errorUnknown = 'An unknown error occurred. Please try again.';
  static const String errorCounterLimitReached = 'Counter limit reached. Cannot perform this operation.';
  static const String errorInvalidInput = 'Invalid input provided. Please check your data.';
  
  // Success Messages
  static const String successOperationCompleted = 'Operation completed successfully.';
  static const String successDataSaved = 'Data saved successfully.';
}
