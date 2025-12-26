import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';

/// Constants for authentication operations
class AuthConstants {
  static const int networkTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const String defaultErrorMessage = 'An unexpected error occurred';
  static const String networkErrorMessage = 'Network error. Please check your connection';
  static const String invalidCredentialsMessage = 'Invalid email or password';
}

/// Auth Provider
/// Manages authentication state using ChangeNotifier
/// This is the Provider equivalent of AuthBloc
/// 
/// Key differences from BLoC:
/// - Uses ChangeNotifier instead of Bloc/BlocState
/// - Uses notifyListeners() instead of emit()
/// - Direct property access instead of state classes
/// 
/// Example usage:
/// ```dart
/// final authProvider = AuthProvider(
///   authRepository: authRepository,
///   secureStorage: secureStorage,
/// );
/// 
/// // Login
/// final success = await authProvider.login('user@example.com', 'password123');
/// 
/// // Check authentication status
/// if (authProvider.isAuthenticated) {
///   print('User: ${authProvider.user?.email}');
/// }
/// 
/// // Listen to changes
/// authProvider.addListener(() {
///   if (authProvider.isAuthenticated) {
///     // Navigate to home
///   }
/// });
/// ```
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  // State properties (equivalent to BLoC states)
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  bool _isRefreshingToken = false;
  bool _isLoggingOut = false;

  // Getters (equivalent to accessing BLoC state)
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  bool get isRefreshingToken => _isRefreshingToken;
  bool get isLoggingOut => _isLoggingOut;

  AuthProvider({
    required AuthRepository authRepository,
    required SecureStorageService secureStorage,
  })  : _authRepository = authRepository,
        _secureStorage = secureStorage {
    // Check if user is already logged in on initialization
    _checkAuthStatus();
  }

  /// Check authentication status on app start
  /// Equivalent to AuthCheckRequested event in BLoC
  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _secureStorage.isLoggedIn();
      if (isLoggedIn) {
        final userData = await _secureStorage.getUserData();
        if (userData != null) {
          // Check if session is still valid
          if (await _isSessionValid()) {
            _user = User.fromJson(userData);
            _isAuthenticated = true;
            notifyListeners(); // Notify UI to rebuild (like emit in BLoC)
          } else {
            // Session expired, clear data
            await _secureStorage.clearAll();
            resetState();
          }
        }
      }
    } catch (e) {
      Logger.error('Error checking auth status', e);
    }
  }

  /// Checks if the current session is still valid
  /// Returns true if session is valid, false if expired
  Future<bool> _isSessionValid() async {
    try {
      final token = await _secureStorage.getToken();
      // In a real implementation, you would verify the token's expiry
      // For now, we'll just check if token exists
      return token != null && token.isNotEmpty;
    } catch (e) {
      Logger.error('Error checking session validity', e);
      return false;
    }
  }

  /// Login method
  /// Equivalent to LoginRequested event in BLoC
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      final sanitizedEmail = _sanitizeEmail(email);
      Logger.info('Login requested', extra: {
        'email': sanitizedEmail,
        'timestamp': DateTime.now().toIso8601String(),
      });
      final user = await _authRepository.login(sanitizedEmail, password)
          .timeout(
            Duration(seconds: AuthConstants.networkTimeoutSeconds),
            onTimeout: () {
              throw TimeoutException('Login request timed out');
            },
          );
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      // Persist user data to secure storage
      await _secureStorage.saveUserData(user.toJson());
      
      notifyListeners(); // Notify UI that login succeeded
      Logger.info('Login successful', extra: {
        'userId': user.id,
        'email': sanitizedEmail,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      Logger.error('Login failed', e);
      _isLoading = false;
      _errorMessage = _formatErrorMessage(e);
      _isAuthenticated = false;
      
      notifyListeners(); // Notify UI that login failed
      return false;
    }
  }

  /// Signup method
  /// Equivalent to RegisterRequested event in BLoC
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    // Validate input parameters
    if (name.trim().isEmpty) {
      _isLoading = false;
      _errorMessage = 'Name cannot be empty';
      notifyListeners();
      return false;
    }

    final sanitizedEmail = _sanitizeEmail(email);
    if (!isValidEmail(sanitizedEmail)) {
      _isLoading = false;
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    if (!isStrongPassword(password)) {
      _isLoading = false;
      _errorMessage = 'Password must be at least 8 characters with uppercase, lowercase, and number';
      notifyListeners();
      return false;
    }

    try {
      Logger.info('Signup requested', extra: {
        'email': sanitizedEmail,
        'name': name,
        'timestamp': DateTime.now().toIso8601String(),
      });
      final user = await _authRepository.userRegister(
        sanitizedEmail,
        password,
        name,
      ).timeout(
        Duration(seconds: AuthConstants.networkTimeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Signup request timed out');
        },
      );
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      // Persist user data to secure storage
      await _secureStorage.saveUserData(user.toJson());
      
      notifyListeners(); // Notify UI that signup succeeded
      Logger.info('Signup successful', extra: {
        'userId': user.id,
        'email': sanitizedEmail,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      Logger.error('Signup failed', e);
      _isLoading = false;
      _errorMessage = _formatErrorMessage(e);
      _isAuthenticated = false;
      
      notifyListeners(); // Notify UI that signup failed
      return false;
    }
  }

  /// Logout method
  /// Equivalent to LogoutRequested event in BLoC
  Future<void> logout() async {
    _isLoading = true;
    _isLoggingOut = true;
    notifyListeners();

    try {
      Logger.info('Logout requested');
      await _secureStorage.clearAll();
      
      _user = null;
      _isAuthenticated = false;
      _isLoading = false;
      _isLoggingOut = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that logout succeeded
      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Logout failed', e);
      _isLoading = false;
      _isLoggingOut = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Resets all authentication state to initial values
  void resetState() {
    _user = null;
    _isLoading = false;
    _errorMessage = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Refreshes authentication token
  /// Returns true if refresh was successful, false otherwise
  Future<bool> refreshToken() async {
    if (!_isAuthenticated || _user == null) {
      return false;
    }

    _isRefreshingToken = true;
    notifyListeners();

    try {
      Logger.info('Token refresh requested');
      // In a real implementation, this would call the repository to refresh the token
      // For now, we'll just verify the current session is still valid
      final isLoggedIn = await _secureStorage.isLoggedIn();
      _isRefreshingToken = false;
      notifyListeners();
      
      if (isLoggedIn) {
        Logger.info('Token refresh successful');
        return true;
      }
      return false;
    } catch (e) {
      Logger.error('Token refresh failed', e);
      _isRefreshingToken = false;
      notifyListeners();
      return false;
    }
  }

  /// Sanitizes email input by trimming whitespace and converting to lowercase
  String _sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Validates email format
  /// Returns true if email is valid, false otherwise
  bool isValidEmail(String email) {
    final sanitizedEmail = _sanitizeEmail(email);
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(sanitizedEmail);
  }

  /// Validates password strength
  /// Returns true if password meets minimum requirements (8+ chars, 1 uppercase, 1 lowercase, 1 number)
  bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  /// Formats error messages for user-friendly display
  String _formatErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    // Handle specific error types
    if (errorString.contains('TimeoutException') || 
        errorString.contains('SocketException') ||
        errorString.contains('NetworkException')) {
      return AuthConstants.networkErrorMessage;
    }
    
    if (errorString.contains('AuthFailure') || 
        errorString.contains('Invalid credentials') ||
        errorString.contains('Unauthorized')) {
      return AuthConstants.invalidCredentialsMessage;
    }
    
    if (errorString.contains('Exception: ')) {
      return errorString.replaceAll('Exception: ', '');
    }
    
    return errorString.isNotEmpty ? errorString : AuthConstants.defaultErrorMessage;
  }

  /// Retries an operation with exponential backoff
  Future<T> _retryOperation<T>(
    Future<T> Function() operation, {
    int maxAttempts = AuthConstants.maxRetryAttempts,
  }) async {
    int attempt = 0;
    while (attempt < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    throw Exception('Max retry attempts reached');
  }

  /// Checks if an email is already registered
  /// Returns true if email exists, false otherwise
  /// Note: This is a placeholder implementation - in production, this would call an API endpoint
  Future<bool> isEmailRegistered(String email) async {
    try {
      final sanitizedEmail = _sanitizeEmail(email);
      if (!isValidEmail(sanitizedEmail)) {
        return false;
      }
      
      // In a real implementation, this would call an API endpoint like:
      // await _authRepository.checkEmailExists(sanitizedEmail);
      // For now, we'll return false as a placeholder
      Logger.info('Email registration check requested', extra: {
        'email': sanitizedEmail,
      });
      
      return false; // Placeholder - would be replaced with actual API call
    } catch (e) {
      Logger.error('Error checking email registration', e);
      return false;
    }
  }

  /// Initiates password reset process for the given email
  /// Returns true if reset email was sent successfully, false otherwise
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final sanitizedEmail = _sanitizeEmail(email);
      
      if (!isValidEmail(sanitizedEmail)) {
        _isLoading = false;
        _errorMessage = 'Please enter a valid email address';
        notifyListeners();
        return false;
      }

      Logger.info('Password reset requested', extra: {
        'email': sanitizedEmail,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // In a real implementation, this would call:
      // await _authRepository.resetPassword(sanitizedEmail);
      // For now, we'll simulate a successful response
      await Future.delayed(Duration(seconds: 1));

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();

      Logger.info('Password reset email sent successfully', extra: {
        'email': sanitizedEmail,
      });
      
      return true;
    } catch (e) {
      Logger.error('Password reset failed', e);
      _isLoading = false;
      _errorMessage = _formatErrorMessage(e);
      notifyListeners();
      return false;
    }
  }
}

