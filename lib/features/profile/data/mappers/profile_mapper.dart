import '../models/profile_dto.dart';
import '../../domain/entities/profile.dart';

/// Profile Mapper
/// Converts between DTO and Domain Entity
class ProfileMapper {
  static Profile toEntity(ProfileDto dto) {
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

    return Profile(
      id: dto.id ?? '',
      name: dto.name ?? '',
      email: dto.email ?? '',
      avatar: dto.avatar,
      bio: dto.bio,
      createdAt: parseDate(dto.createdAt),
    );
  }

  static ProfileDto toDto(Profile entity) {
    return ProfileDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      bio: entity.bio,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}

