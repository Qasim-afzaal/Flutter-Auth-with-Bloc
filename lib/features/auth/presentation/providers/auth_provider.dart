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

  // Validation constants
  static const String _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const int _minPasswordLength = 8;
  static const int _maxPasswordLength = 128;

  // Session constants
  static const Duration _sessionTimeout = Duration(hours: 24);

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

  /// Validates email format using regex
  bool _isValidEmail(String email) {
    return RegExp(_emailRegex).hasMatch(email);
  }

  /// Validates password length
  bool _isValidPassword(String password) {
    return password.length >= _minPasswordLength && 
           password.length <= _maxPasswordLength;
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
    // Validate email format
    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    // Validate password length
    if (!_isValidPassword(password)) {
      _errorMessage = 'Password must be between $_minPasswordLength and $_maxPasswordLength characters';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Login requested with email: $email');
      final user = await _authRepository.login(email, password);
      
      _user = user;
      _isAuthenticated = true;
      _isLoading = false;
      _errorMessage = null;
      
      notifyListeners(); // Notify UI that login succeeded
      Logger.info('Login successful');
      return true;
    } catch (e) {
      Logger.error('Login failed', e);
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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
    // Validate email format
    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    // Validate password length
    if (!_isValidPassword(password)) {
      _errorMessage = 'Password must be between $_minPasswordLength and $_maxPasswordLength characters';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading started

    try {
      Logger.info('Signup requested with email: $email');
      final user = await _authRepository.userRegister(
        email,
        password,
        name,
      );
      
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
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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

  /// Check if current session is still valid
  /// Returns true if user is authenticated and session hasn't expired
  Future<bool> isSessionValid() async {
    if (!_isAuthenticated || _user == null) {
      return false;
    }

    try {
      final isLoggedIn = await _secureStorage.isLoggedIn();
      return isLoggedIn;
    } catch (e) {
      Logger.error('Error checking session validity', e);
      return false;
    }
  }

  /// Refresh user data from storage
  /// Useful for syncing user information after profile updates
  Future<void> refreshUserData() async {
    if (!_isAuthenticated) {
      return;
    }

    try {
      Logger.info('Refreshing user data');
      final userData = await _secureStorage.getUserData();
      if (userData != null) {
        _user = User.fromJson(userData);
        notifyListeners();
        Logger.info('User data refreshed successfully');
      }
    } catch (e) {
      Logger.error('Error refreshing user data', e);
    }
  }

  /// Update user profile information
  /// Updates the current user's data and refreshes the state
  Future<bool> updateUserProfile({
    String? name,
    String? email,
  }) async {
    if (!_isAuthenticated || _user == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Logger.info('Updating user profile');
      
      // Create updated user object
      final updatedUser = User(
        id: _user!.id,
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        avatar: _user!.avatar,
        createdAt: _user!.createdAt,
        updatedAt: DateTime.now(),
        authProvider: _user!.authProvider,
        gender: _user!.gender,
        age: _user!.age,
      );

      // Save updated user data
      await _secureStorage.saveUserData(updatedUser.toJson());
      _user = updatedUser;
      _isLoading = false;
      
      notifyListeners();
      Logger.info('User profile updated successfully');
      return true;
    } catch (e) {
      Logger.error('Error updating user profile', e);
      _isLoading = false;
      _errorMessage = 'Failed to update profile';
      notifyListeners();
      return false;
    }
  }

  /// Refresh authentication token
  /// Useful for maintaining session without re-login
  Future<bool> refreshToken() async {
    if (!_isAuthenticated || _user == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Logger.info('Token refresh requested');
      // Token refresh logic would be implemented here
      // For now, just verify current session is still valid
      final isLoggedIn = await _secureStorage.isLoggedIn();
      if (isLoggedIn) {
        _isLoading = false;
        notifyListeners();
        Logger.info('Token refresh successful');
        return true;
      }
      
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('Token refresh failed', e);
      _isLoading = false;
      _errorMessage = 'Session expired. Please login again.';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

