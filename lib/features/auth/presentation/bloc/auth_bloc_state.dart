import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class for all authentication states
/// All authentication-related states must extend this class
abstract class AuthBlocState extends Equatable {
  const AuthBlocState();
  
  @override
  List<Object?> get props => [];
}

/// Initial authentication state
/// Represents the state when the app first loads
class AuthInitial extends AuthBlocState {}

/// Loading state during authentication operations
/// Shown when login, register, or logout is in progress
class AuthLoading extends AuthBlocState {}

/// Authenticated state
/// Represents a successfully authenticated user session
class AuthAuthenticated extends AuthBlocState {
  final User user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
/// Represents a state where no user is logged in
class AuthUnauthenticated extends AuthBlocState {}

/// Error state for authentication failures
/// Contains error message describing what went wrong
class AuthError extends AuthBlocState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}
