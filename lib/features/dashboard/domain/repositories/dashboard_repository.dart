import '../entities/dashboard_data.dart';

/// Dashboard Repository Interface
/// Defines the contract for dashboard data operations
/// Follows Clean Architecture - Domain Layer
abstract class DashboardRepository {
  /// Gets dashboard data including user info and statistics
  /// 
  /// Returns [DashboardData] with user name, email, and stats
  /// Throws [Failure] if operation fails
  Future<DashboardData> getDashboardData();
}

