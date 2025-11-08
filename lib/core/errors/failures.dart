import 'package:equatable/equatable.dart';

/// Base class for all failure types in the application
/// All custom failures should extend this class
/// 
/// Failures represent error conditions that can occur during app execution
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Failure representing server-side errors
/// Typically thrown when API returns error status codes (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure representing network-related errors
/// Thrown when network requests fail, timeout, or connection issues occur
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure representing authentication errors
/// Thrown when user authentication fails (invalid credentials, unauthorized access)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure representing validation errors
/// Thrown when input validation fails (invalid email, weak password, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Helper extension to get user-friendly error messages from failures
extension FailureMessage on Failure {
  /// Returns a user-friendly error message
  /// Converts technical error messages to more readable format
  String get userMessage {
    if (this is NetworkFailure) {
      return 'Network error. Please check your connection and try again.';
    } else if (this is AuthFailure) {
      return 'Authentication failed. Please check your credentials.';
    } else if (this is ValidationFailure) {
      return 'Invalid input: $message';
    } else if (this is ServerFailure) {
      return 'Server error. Please try again later.';
    }
    return message;
  }
}
