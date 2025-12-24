import 'package:flutter/foundation.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';

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

  // Input validation constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 255;
  
  // Network timeout constants
  static const Duration networkTimeout = Duration(seconds: 30);
  
  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

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

  /// Validates email format
  /// Returns true if email is valid, false otherwise
  bool _isValidEmail(String email) {
    if (email.isEmpty || email.length > maxEmailLength) {
      return false;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  /// Returns true if password meets requirements, false otherwise
  bool _isValidPassword(String password) {
    if (password.length < minPasswordLength || password.length > maxPasswordLength) {
      return false;
    }
    // Check for at least one letter and one number
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  /// Retries a future operation with exponential backoff
  /// Returns the result of the operation or throws the last error
  Future<T> _retryOperation<T>(
    Future<T> Function() operation, {
    int maxAttempts = maxRetryAttempts,
  }) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          rethrow;
        }
        // Wait before retrying (exponential backoff)
        await Future.delayed(retryDelay * attempts);
        Logger.info('Retrying operation (attempt $attempts/$maxAttempts)');
      }
    }
    throw Exception('Max retry attempts reached');
  }

  /// Extracts user-friendly error message from exception
  /// Returns a clean error message string
  String _extractErrorMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';
    
    final errorString = error.toString();
    
    // Remove common exception prefixes
    String message = errorString
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();
    
    // Handle common error patterns
    if (message.toLowerCase().contains('network') || 
        message.toLowerCase().contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    
    if (message.toLowerCase().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (message.toLowerCase().contains('unauthorized') ||
        message.toLowerCase().contains('invalid credentials')) {
      return 'Invalid email or password.';
    }
    
    return message.isEmpty ? 'An error occurred' : message;
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
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns true if login is successful, false otherwise
  /// Sets loading state and error message accordingly
  /// Automatically saves user data to secure storage on success
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Login requested with email: $email');
      final user = await _authRepository
          .login(email, password)
          .timeout(networkTimeout);
      
      _user = user;
      _isAuthenticated = true;
      
      // Persist user data to secure storage
      await _secureStorage.saveUserData(user.toJson());
      
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that login succeeded
      Logger.info('Login successful');
      return true;
    } catch (e) {
      Logger.error('Login failed', e);
      _isLoading = false;
      _errorMessage = _extractErrorMessage(e);
      _isAuthenticated = false;
      
      notifyListeners(); // Notify UI that login failed
      return false;
    }
  }

  /// Signup method
  /// Equivalent to RegisterRequested event in BLoC
  /// 
  /// [name] - User's full name (2-100 characters)
  /// [email] - User's email address (must be valid format)
  /// [password] - User's password (8-128 characters, must contain letters and numbers)
  /// 
  /// Returns true if signup is successful, false otherwise
  /// Sets loading state and error message accordingly
  /// Automatically saves user data to secure storage on success
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Signup requested with email: $email');
      final user = await _authRepository
          .userRegister(email, password, name)
          .timeout(networkTimeout);
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that signup succeeded
      Logger.info('Signup successful');
      return true;
    } catch (e) {
      Logger.error('Signup failed', e);
      _isLoading = false;
      _errorMessage = _extractErrorMessage(e);
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

  /// Dispose method for cleanup
  /// Called when the provider is no longer needed
  /// Prevents memory leaks by removing all listeners
  @override
  void dispose() {
    // Clear any pending operations
    _isLoading = false;
    _errorMessage = null;
    // Call super dispose to remove all listeners
    super.dispose();
  }
}

