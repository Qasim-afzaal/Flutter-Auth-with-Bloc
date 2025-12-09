import 'package:equatable/equatable.dart';

/// Notification Item Entity
/// Represents a notification
class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, message, isRead, createdAt];
}

