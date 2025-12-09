import '../entities/profile.dart';

/// Profile Repository Interface
/// Defines the contract for profile data operations
/// Follows Clean Architecture - Domain Layer
abstract class ProfileRepository {
  /// Gets user profile
  /// 
  /// Returns [Profile] of the current user
  /// Throws [Failure] if operation fails
  Future<Profile> getProfile();
}

