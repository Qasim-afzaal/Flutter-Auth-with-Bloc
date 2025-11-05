import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_bloc_state.dart';

/// Authentication BLoC for managing user authentication state
/// Handles login, registration, logout, and authentication status checks
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final AuthRepository _authRepository;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  
  /// Handles login request event
  /// Validates credentials and emits authentication state
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on ValidationFailure catch (e) {
      emit(AuthError('Validation error: ${e.message}'));
    } on AuthFailure catch (e) {
      emit(AuthError('Authentication failed: ${e.message}'));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }
  
  /// Handles registration request event
  /// Creates new user account and emits authentication state
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
        event.name,
      );
      emit(AuthAuthenticated(user));
    } on ValidationFailure catch (e) {
      emit(AuthError('Validation error: ${e.message}'));
    } on AuthFailure catch (e) {
      emit(AuthError('Registration failed: ${e.message}'));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }
  
  /// Handles logout request event
  /// Clears user session and emits unauthenticated state
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout error: ${e.toString()}'));
    }
  }
  
  /// Handles authentication check request event
  /// Verifies if user is currently authenticated
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
