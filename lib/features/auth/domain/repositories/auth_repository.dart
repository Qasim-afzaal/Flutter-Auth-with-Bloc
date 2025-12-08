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
  Future<User> userRegister(String email, String password, String name);
  // Future<User> UserLogout();
  // Future<User> UserForgotPassword(String email);
  // Future<User> UserResetPassword(String email, String password);
  // Future<User> UserChangePassword(String email, String password);
  // Future<User> UserChangeEmail(String email, String password);
  // Future<User> UserChangeName(String email, String password);
  // Future<User> UserChangePhone(String email, String password);
}
