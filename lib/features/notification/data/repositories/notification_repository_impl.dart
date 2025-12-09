import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_item_dto.dart';
import '../mappers/notification_mapper.dart';

/// Notification Repository Implementation
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl();

  @override
  Future<List<NotificationItem>> getNotifications() async {
    try {
      Logger.info('Fetching notifications');

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      final dummyData = _getDummyData();
      final notifications = dummyData
          .map((dto) => NotificationMapper.toEntity(dto))
          .toList();

      Logger.info('Notifications fetched: ${notifications.length}');
      return notifications;
    } catch (e) {
      Logger.error('Error fetching notifications', e);
      throw ServerFailure('Failed to fetch notifications: $e');
    }
  }

  List<NotificationItemDto> _getDummyData() {
    return [
      NotificationItemDto(
        id: '1',
        title: 'Welcome!',
        message: 'Thank you for joining our app. We\'re excited to have you!',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      NotificationItemDto(
        id: '2',
        title: 'New Feature Available',
        message: 'Check out our new dashboard with improved navigation.',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      NotificationItemDto(
        id: '3',
        title: 'Profile Updated',
        message: 'Your profile information has been successfully updated.',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      ),
      NotificationItemDto(
        id: '4',
        title: 'Security Alert',
        message: 'Your account security settings have been reviewed.',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      ),
    ];
  }
}

