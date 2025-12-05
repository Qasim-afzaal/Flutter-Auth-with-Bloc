import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_bloc_state.dart';

/// Authentication BLoC
/// Manages authentication state and handles login events
/// Uses secure storage to check if user is already logged in
/// 
/// Events handled:
/// - LoginRequested: Attempts to authenticate user with email and password
/// - LogoutRequested: Signs out the current user and clears secure storage
/// - AuthCheckRequested: Checks if user is currently authenticated using secure storage
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  AuthBloc({
    required AuthRepository authRepository,
    required SecureStorageService secureStorage,
  })  : _authRepository = authRepository,
        _secureStorage = secureStorage,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  /// Handles login request event
  /// Emits loading state, then attempts to authenticate user
  /// On success: emits AuthAuthenticated state
  /// On failure: emits AuthError state with error message
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());

    try {
      Logger.info('Login requested for email: ${event.email}');
      final user = await _authRepository.login(event.email, event.password);
      Logger.info('Login successful for user: ${user.email}');
      emit(AuthAuthenticated(user));
    } on Exception catch (e) {
      Logger.error('Login failed', e);
      emit(AuthError(e.toString()));
    } catch (e) {
      Logger.error('Unexpected error during login', e);
      emit(AuthError('Login failed: $e'));
    }
  }

  /// Handles logout request event
  /// Clears secure storage and emits unauthenticated state
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());

    try {
      Logger.info('Logout requested');
      await _secureStorage.clearAll();
      Logger.info('Secure storage cleared');
      emit(AuthUnauthenticated());
    } catch (e) {
      Logger.error('Logout failed', e);
      emit(AuthError('Logout failed: $e'));
    }
  }

  /// Handles auth check request event
  /// Checks secure storage to see if user is already logged in
  /// If user data exists: emits AuthAuthenticated state
  /// If no user data: emits AuthUnauthenticated state
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      Logger.info('Checking authentication status');
      final isLoggedIn = await _secureStorage.isLoggedIn();

      if (isLoggedIn) {
        final userData = await _secureStorage.getUserData();
        if (userData != null && userData.isNotEmpty) {
          // Try to reconstruct user from stored data
          try {
            final user = User.fromJson(userData);
            if (user.email.isNotEmpty && user.id.isNotEmpty) {
              Logger.info('User found in secure storage: ${user.email}');
              emit(AuthAuthenticated(user));
            } else {
              Logger.info('Invalid user data in secure storage');
              emit(AuthUnauthenticated());
            }
          } catch (e) {
            Logger.error('Failed to parse user data from storage', e);
            emit(AuthUnauthenticated());
          }
        } else {
          Logger.info('No user data found in secure storage');
          emit(AuthUnauthenticated());
        }
      } else {
        Logger.info('User is not logged in');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      Logger.error('Error checking authentication status', e);
      emit(AuthUnauthenticated());
    }
  }
}
