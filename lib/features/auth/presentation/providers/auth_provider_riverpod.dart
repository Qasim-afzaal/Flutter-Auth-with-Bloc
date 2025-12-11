import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../injection/injection_container.dart' as di;

/// Auth State for Riverpod
/// Represents the authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  // CopyWith method for immutable updates
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth Notifier
/// Manages authentication state using Riverpod StateNotifier
/// This is the Riverpod equivalent of AuthBloc/AuthProvider
/// 
/// Key differences from BLoC/Provider:
/// - Uses StateNotifier instead of Bloc/ChangeNotifier
/// - Uses state = newState instead of emit()/notifyListeners()
/// - Compile-time safe with code generation
/// - Better performance with automatic rebuilds
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  AuthNotifier({
    required AuthRepository authRepository,
    required SecureStorageService secureStorage,
  })  : _authRepository = authRepository,
        _secureStorage = secureStorage,
        super(const AuthState()) {
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
          final user = User.fromJson(userData);
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
          );
        }
      }
    } catch (e) {
      Logger.error('Error checking auth status', e);
    }
  }

  /// Login method
  /// Equivalent to LoginRequested event in BLoC
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      Logger.info('Login requested with email: $email');
      final user = await _authRepository.login(email, password);
      
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
      
      Logger.info('Login successful');
      return true;
    } catch (e) {
      Logger.error('Login failed', e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isAuthenticated: false,
      );
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      Logger.info('Signup requested with email: $email');
      final user = await _authRepository.userRegister(
        email,
        password,
        name,
      );
      
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
      
      Logger.info('Signup successful');
      return true;
    } catch (e) {
      Logger.error('Signup failed', e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isAuthenticated: false,
      );
      return false;
    }
  }

  /// Logout method
  /// Equivalent to LogoutRequested event in BLoC
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      Logger.info('Logout requested');
      await _secureStorage.clearAll();
      
      state = const AuthState();
      
      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Logout failed', e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth Provider (Riverpod)
/// Provides AuthNotifier instance
/// This is the Riverpod way of dependency injection
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authRepository: di.sl<AuthRepository>(),
    secureStorage: di.sl<SecureStorageService>(),
  );
});

/// Convenience providers for accessing specific state values
/// These allow widgets to listen to only what they need (optimization)
final authUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

final authIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

final authIsAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

final authErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).errorMessage;
});

