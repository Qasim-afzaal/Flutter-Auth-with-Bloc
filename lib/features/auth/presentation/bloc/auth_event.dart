import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event triggered when user requests to login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
  
  @override
  String toString() => 'LoginRequested(email: $email)';
}

/// Event triggered when user requests to register
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
  
  @override
  String toString() => 'RegisterRequested(email: $email, name: $name)';
}

/// Event triggered when user requests to logout
class LogoutRequested extends AuthEvent {
  @override
  String toString() => 'LogoutRequested';
}

/// Event triggered to check current authentication status
class AuthCheckRequested extends AuthEvent {
  @override
  String toString() => 'AuthCheckRequested';
}
