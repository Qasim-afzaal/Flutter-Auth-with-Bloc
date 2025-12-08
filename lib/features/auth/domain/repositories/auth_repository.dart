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
  
  /// Registers a new user with email, password, and name
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// [name] - User's full name
  /// 
  /// Returns [User] if registration successful
  /// Throws [Failure] if registration fails
  Future<User> userRegister(String email, String password, String name);
}
