import '../models/notification_item_dto.dart';
import '../../domain/entities/notification_item.dart';

/// Notification Mapper
class NotificationMapper {
  static NotificationItem toEntity(NotificationItemDto dto) {
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

    return NotificationItem(
      id: dto.id ?? '',
      title: dto.title ?? '',
      message: dto.message ?? '',
      isRead: dto.isRead ?? false,
      createdAt: parseDate(dto.createdAt),
    );
  }
}

