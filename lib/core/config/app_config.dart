/// App Configuration
/// Loads configuration from environment variables or default values
/// This file should NOT contain sensitive data - use .env file instead
class AppConfig {
  // API Configuration
  // Base URL should be set via environment variable or .env file
  // For local development, create a .env file (see .env.example)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3005/api',
  );
  
  static const String apiVersion = '';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}

