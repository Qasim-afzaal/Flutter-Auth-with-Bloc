class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Counter Configuration
  static const int counterMaxValue = 100;
  static const int counterMinValue = -50;
  
  // Counter Step Values
  static const int incrementStep = 1;
  static const int decrementStep = 1;
  static const int doubleMultiplier = 2;
  static const int halfDivisor = 2;
}
