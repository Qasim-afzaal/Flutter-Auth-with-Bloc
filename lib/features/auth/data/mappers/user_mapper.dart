import '../models/user_data_dto.dart';
import '../../domain/entities/user.dart';

/// User Mapper
/// Converts between DTO (Data Transfer Object) and Domain Entity
/// Follows Clean Architecture - separates data layer from domain layer
class UserMapper {
  /// Converts UserDataDto to User domain entity
  /// 
  /// [dto] - The data transfer object from API
  /// Returns [User] domain entity
  static User toEntity(UserDataDto dto) {
    // Parse dates safely
    DateTime parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) {
        return DateTime.now();
      }
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return DateTime.now();
      }
    }

    return User(
      id: dto.id ?? '',
      email: dto.email ?? '',
      name: dto.name ?? '',
      avatar: dto.profileImageUrl,
      createdAt: parseDate(dto.createdAt),
      updatedAt: parseDate(dto.updatedAt),
      authProvider: dto.authProvider,
      gender: dto.gender,
      age: dto.age,
    );
  }

  /// Converts User domain entity to UserDataDto
  /// 
  /// [entity] - The domain entity
  /// Returns [UserDataDto] data transfer object
  static UserDataDto toDto(User entity) {
    return UserDataDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      profileImageUrl: entity.avatar,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      authProvider: entity.authProvider,
      gender: entity.gender,
      age: entity.age,
    );
  }
}

