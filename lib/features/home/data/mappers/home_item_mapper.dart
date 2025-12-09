import '../models/home_item_dto.dart';
import '../../domain/entities/home_item.dart';

/// Home Item Mapper
/// Converts between DTO (Data Transfer Object) and Domain Entity
/// Follows Clean Architecture - separates data layer from domain layer
class HomeItemMapper {
  /// Converts HomeItemDto to HomeItem domain entity
  /// 
  /// [dto] - The data transfer object from API
  /// Returns [HomeItem] domain entity
  static HomeItem toEntity(HomeItemDto dto) {
    // Parse date safely
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

    return HomeItem(
      id: dto.id ?? '',
      title: dto.title ?? '',
      description: dto.description ?? '',
      imageUrl: dto.imageUrl,
      createdAt: parseDate(dto.createdAt),
    );
  }

  /// Converts HomeItem domain entity to HomeItemDto
  /// 
  /// [entity] - The domain entity
  /// Returns [HomeItemDto] data transfer object
  static HomeItemDto toDto(HomeItem entity) {
    return HomeItemDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}

