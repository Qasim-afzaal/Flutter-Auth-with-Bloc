import '../entities/user.dart';

/// Auth Repository Interface
/// Defines the contract for authentication operations
/// Follows Clean Architecture - Domain Layer
abstract class AuthRepository {
  /// Logs in a user with email and password
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns [User] if login successful
  /// Throws [Failure] if login fails
  Future<User> login(String email, String password);
}
