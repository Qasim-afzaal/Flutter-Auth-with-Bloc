import 'package:equatable/equatable.dart';

/// Dashboard Data Entity
/// Represents dashboard-specific data
/// Domain layer entity - pure business logic
class DashboardData extends Equatable {
  final String userName;
  final String userEmail;
  final int totalItems;
  final int unreadNotifications;

  const DashboardData({
    required this.userName,
    required this.userEmail,
    required this.totalItems,
    required this.unreadNotifications,
  });

  @override
  List<Object?> get props => [userName, userEmail, totalItems, unreadNotifications];
}

