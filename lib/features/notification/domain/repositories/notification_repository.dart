import '../entities/notification_item.dart';

/// Notification Repository Interface
abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();
}

