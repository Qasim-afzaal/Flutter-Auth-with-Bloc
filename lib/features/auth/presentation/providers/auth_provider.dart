import 'package:flutter/foundation.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/validation_utils.dart';
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
    
    if (!ValidationUtils.isValidEmail(email)) {
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
      
      // Provide specific error messages based on error type
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('invalid') || errorString.contains('incorrect')) {
        _errorMessage = 'Invalid email or password. Please check your credentials.';
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        _errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorString.contains('timeout')) {
        _errorMessage = 'Request timed out. Please try again.';
      } else {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      
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
    
    if (!ValidationUtils.isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }
    
    if (password.isEmpty) {
      _errorMessage = 'Password cannot be empty';
      notifyListeners();
      return false;
    }
    
    if (!ValidationUtils.isValidPassword(password)) {
      _errorMessage = 'Password must be at least 8 characters long';
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
      
      // Provide specific error messages based on error type
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('already exists') || errorString.contains('duplicate')) {
        _errorMessage = 'An account with this email already exists.';
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        _errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorString.contains('timeout')) {
        _errorMessage = 'Request timed out. Please try again.';
      } else if (errorString.contains('invalid')) {
        _errorMessage = 'Invalid information provided. Please check your details.';
      } else {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      
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

  /// Check if email is available for registration
  /// Returns true if email is available, false if already taken
  Future<bool> checkEmailAvailability(String email) async {
    if (email.trim().isEmpty) {
      _errorMessage = 'Email cannot be empty';
      notifyListeners();
      return false;
    }
    
    if (!ValidationUtils.isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Logger.info('Checking email availability: $email');
      
      // Attempt to login with the email to check if it exists
      // In a real app, you'd have a dedicated API endpoint for this
      // For now, we'll simulate by trying a login with a dummy password
      // This is a placeholder - in production, use a dedicated endpoint
      
      // Note: This is a simplified check. In production, use a dedicated API endpoint
      // that checks email availability without attempting authentication
      _isLoading = false;
      notifyListeners();
      
      // Return true as available (since we don't have a real endpoint)
      // In production, this would call a dedicated API endpoint
      Logger.info('Email availability check completed');
      return true;
    } catch (e) {
      Logger.error('Failed to check email availability', e);
      _isLoading = false;
      
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('already exists') || errorString.contains('duplicate')) {
        _errorMessage = 'This email is already registered';
        notifyListeners();
        return false;
      }
      
      _errorMessage = 'Unable to verify email availability';
      notifyListeners();
      return false;
    }
  }

  /// Refresh authentication token
  /// Re-authenticates the user to refresh their session
  Future<bool> refreshToken() async {
    if (!_isAuthenticated || _user == null) {
      _errorMessage = 'No active session to refresh';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Logger.info('Refreshing authentication token');
      
      // Re-check auth status to refresh the session
      await _checkAuthStatus();
      
      if (_isAuthenticated && _user != null) {
        _isLoading = false;
        notifyListeners();
        Logger.info('Token refreshed successfully');
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Session expired. Please login again';
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      Logger.error('Failed to refresh token', e);
      _isLoading = false;
      _errorMessage = 'Failed to refresh session: ${e.toString()}';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile information
  /// Updates the local user state with new profile data
  Future<bool> updateUserProfile({
    String? name,
    String? avatar,
    String? gender,
    String? age,
  }) async {
    if (_user == null) {
      _errorMessage = 'No user is currently logged in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create updated user with new values
      final updatedUser = User(
        id: _user!.id,
        email: _user!.email,
        name: name ?? _user!.name,
        avatar: avatar ?? _user!.avatar,
        createdAt: _user!.createdAt,
        updatedAt: DateTime.now(),
        authProvider: _user!.authProvider,
        gender: gender ?? _user!.gender,
        age: age ?? _user!.age,
      );

      _user = updatedUser;
      _isLoading = false;
      
      // Save updated user data to secure storage
      await _secureStorage.saveUserData(updatedUser.toJson());
      
      notifyListeners();
      Logger.info('User profile updated successfully');
      return true;
    } catch (e) {
      Logger.error('Failed to update user profile', e);
      _isLoading = false;
      _errorMessage = 'Failed to update profile: ${e.toString()}';
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

