/// Dashboard Data DTO (Data Transfer Object)
/// Represents the dashboard data structure from API response
class DashboardDataDto {
  final String? userName;
  final String? userEmail;
  final int? totalItems;
  final int? unreadNotifications;

  DashboardDataDto({
    this.userName,
    this.userEmail,
    this.totalItems,
    this.unreadNotifications,
  });

  factory DashboardDataDto.fromJson(Map<String, dynamic> json) {
    return DashboardDataDto(
      userName: json['user_name']?.toString() ?? json['userName']?.toString(),
      userEmail: json['user_email']?.toString() ?? json['userEmail']?.toString(),
      totalItems: json['total_items'] ?? json['totalItems'],
      unreadNotifications: json['unread_notifications'] ?? json['unreadNotifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_email': userEmail,
      'total_items': totalItems,
      'unread_notifications': unreadNotifications,
    };
  }
}

