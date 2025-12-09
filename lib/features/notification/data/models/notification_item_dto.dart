/// Notification Item DTO
class NotificationItemDto {
  final String? id;
  final String? title;
  final String? message;
  final bool? isRead;
  final String? createdAt;

  NotificationItemDto({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
  });

  factory NotificationItemDto.fromJson(Map<String, dynamic> json) {
    return NotificationItemDto(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}

