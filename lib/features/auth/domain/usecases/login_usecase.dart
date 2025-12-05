import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validation_utils.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Login Use Case
/// Represents a single business action: "Login a user"
/// Contains business rules for login operation
/// 
/// This is an example of a Use Case in Clean Architecture
/// Use Cases contain business logic and rules
/// They use repositories to access data
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executes the login use case
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns [User] if login successful
  /// Throws [Failure] if validation fails or login fails
  Future<User> call(String email, String password) async {
    // Business Rule 1: Validate email format
    if (email.isEmpty) {
      throw ValidationFailure('Email is required');
    }
    
    if (!ValidationUtils.isValidEmail(email)) {
      throw ValidationFailure('Invalid email format');
    }

    // Business Rule 2: Validate password
    if (password.isEmpty) {
      throw ValidationFailure('Password is required');
    }
    
    if (password.length < 8) {
      throw ValidationFailure('Password must be at least 8 characters');
    }

    // Business Rule 3: Execute login via repository
    // The repository handles the actual API call and data operations
    return await _repository.login(email, password);
  }
}

