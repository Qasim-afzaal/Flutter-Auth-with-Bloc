import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class for all authentication states
abstract class AuthBlocState extends Equatable {
  const AuthBlocState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state when authentication BLoC is first created
class AuthInitial extends AuthBlocState {
  @override
  String toString() => 'AuthInitial';
}

/// State emitted when authentication operation is in progress
class AuthLoading extends AuthBlocState {
  @override
  String toString() => 'AuthLoading';
}

/// State emitted when user is successfully authenticated
class AuthAuthenticated extends AuthBlocState {
  final User user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
  
  @override
  String toString() => 'AuthAuthenticated(user: ${user.email})';
}

/// State emitted when user is not authenticated
class AuthUnauthenticated extends AuthBlocState {
  @override
  String toString() => 'AuthUnauthenticated';
}

/// State emitted when an authentication error occurs
class AuthError extends AuthBlocState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'AuthError(message: $message)';
}
