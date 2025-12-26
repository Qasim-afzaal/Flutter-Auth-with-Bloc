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
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  // State properties (equivalent to BLoC states)
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters (equivalent to accessing BLoC state)
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

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
          _user = User.fromJson(userData);
          _isAuthenticated = true;
          notifyListeners(); // Notify UI to rebuild (like emit in BLoC)
        }
      }
    } catch (e) {
      Logger.error('Error checking auth status', e);
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

    try {
      final sanitizedEmail = _sanitizeEmail(email);
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
    notifyListeners();

    try {
      Logger.info('Logout requested');
      await _secureStorage.clearAll();
      
      _user = null;
      _isAuthenticated = false;
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that logout succeeded
      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Logout failed', e);
      _isLoading = false;
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

    try {
      Logger.info('Token refresh requested');
      // In a real implementation, this would call the repository to refresh the token
      // For now, we'll just verify the current session is still valid
      final isLoggedIn = await _secureStorage.isLoggedIn();
      if (isLoggedIn) {
        Logger.info('Token refresh successful');
        return true;
      }
      return false;
    } catch (e) {
      Logger.error('Token refresh failed', e);
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
    if (errorString.contains('Exception: ')) {
      return errorString.replaceAll('Exception: ', '');
    }
    if (errorString.contains('TimeoutException')) {
      return AuthConstants.networkErrorMessage;
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
}

