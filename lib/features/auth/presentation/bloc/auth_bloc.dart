import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_bloc_state.dart';

/// Authentication BLoC
/// Manages authentication state and handles login, registration, logout, and auth check events
/// 
/// Events handled:
/// - LoginRequested: Attempts to authenticate user with email and password
/// - RegisterRequested: Creates a new user account
/// - LogoutRequested: Signs out the current user
/// - AuthCheckRequested: Checks if user is currently authenticated
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
  /// Emits loading state, then attempts to authenticate user
  /// On success: emits AuthAuthenticated state
  /// On failure: emits AuthError state with error message
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  /// Handles registration request event
  /// Emits loading state, then attempts to create new user account
  /// On success: emits AuthAuthenticated state with new user
  /// On failure: emits AuthError state with error message
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
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  /// Handles logout request event
  /// Emits loading state, then signs out current user
  /// On success: emits AuthUnauthenticated state
  /// On failure: emits AuthError state with error message
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  /// Handles auth check request event
  /// Checks if user is currently authenticated without showing loading state
  /// If user exists: emits AuthAuthenticated state
  /// If no user: emits AuthUnauthenticated state
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
