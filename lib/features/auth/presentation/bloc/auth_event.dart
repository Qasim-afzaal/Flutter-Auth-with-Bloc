import 'package:equatable/equatable.dart';

/// Base class for all authentication events
/// All authentication-related events must extend this class
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to request user login
/// Contains email and password for authentication
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

/// Event to request user registration
/// Contains email, password, and name for creating a new account
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
  
  @override
  List<Object?> get props => [email, password, name];
}

/// Event to request user logout
/// Signs out the currently authenticated user
class LogoutRequested extends AuthEvent {}

/// Event to check current authentication status
/// Verifies if a user is currently authenticated
class AuthCheckRequested extends AuthEvent {}
