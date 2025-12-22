import 'dart:async';
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
  // Constants
  static const String _exceptionPrefix = 'Exception: ';
  static const int _minPasswordLength = 6;
  static const Duration _operationTimeout = Duration(seconds: 30);

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
    // Input validation
    if (email.trim().isEmpty) {
      _errorMessage = 'Email cannot be empty';
      notifyListeners();
      return false;
    }
    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }
    if (password.isEmpty) {
      _errorMessage = 'Password cannot be empty';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Login requested with email: $email');
      final user = await _authRepository.login(email, password)
          .timeout(_operationTimeout, onTimeout: () {
        throw TimeoutException('Login request timed out');
      });
      
      // Save user data to secure storage for persistence
      await _secureStorage.saveUserData(user.toJson());
      Logger.info('User data saved to secure storage for user: ${user.email}');
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that login succeeded
      Logger.info('Login successful for user: ${user.email} (ID: ${user.id})');
      return true;
    } catch (e) {
      Logger.error('Login failed', e);
      _isLoading = false;
      _errorMessage = e.toString().replaceAll(_exceptionPrefix, '');
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
    // Input validation
    if (name.trim().isEmpty) {
      _errorMessage = 'Name cannot be empty';
      notifyListeners();
      return false;
    }
    if (email.trim().isEmpty) {
      _errorMessage = 'Email cannot be empty';
      notifyListeners();
      return false;
    }
    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }
    final passwordError = _validatePasswordStrength(password);
    if (passwordError != null) {
      _errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Signup requested with email: $email, name: $name');
      final user = await _authRepository.userRegister(
        email,
        password,
        name,
      );
      
      // Save user data to secure storage for persistence
      await _secureStorage.saveUserData(user.toJson());
      Logger.info('User data saved to secure storage for user: ${user.email}');
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that signup succeeded
      Logger.info('Signup successful for user: ${user.email} (ID: ${user.id})');
      return true;
    } catch (e) {
      Logger.error('Signup failed', e);
      _isLoading = false;
      _errorMessage = e.toString().replaceAll(_exceptionPrefix, '');
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

  /// Validates email format
  /// Returns true if email is valid, false otherwise
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Validates password strength
  /// Returns error message if password is weak, null if password is strong
  String? _validatePasswordStrength(String password) {
    if (password.length < _minPasswordLength) {
      return 'Password must be at least $_minPasswordLength characters long';
    }
    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null; // Password is strong
  }

  @override
  void dispose() {
    // Clean up resources when provider is disposed
    Logger.info('AuthProvider disposed');
    super.dispose();
  }
}

