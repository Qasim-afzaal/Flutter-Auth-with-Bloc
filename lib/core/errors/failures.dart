import 'package:equatable/equatable.dart';

/// Base class for all failure types in the application
/// Used to represent error states throughout the app
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
  
  @override
  String toString() => message;
}

/// Failure representing server-side errors (5xx, 4xx responses)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure representing network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure representing authentication/authorization errors
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure representing input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
