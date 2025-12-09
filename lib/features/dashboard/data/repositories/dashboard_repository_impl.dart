import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Dashboard Repository Implementation
/// Implements the DashboardRepository interface
/// Gets user data from storage and calculates statistics
class DashboardRepositoryImpl implements DashboardRepository {
  final SecureStorageService _secureStorage;

  DashboardRepositoryImpl({
    required SecureStorageService secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<DashboardData> getDashboardData() async {
    try {
      Logger.info('Fetching dashboard data');

      // Get user data from secure storage
      final userData = await _secureStorage.getUserData();
      
      if (userData == null || userData.isEmpty) {
        throw AuthFailure('No user data found');
      }

      // Extract user name and email from stored data
      final userName = userData['name']?.toString() ?? '';
      final userEmail = userData['email']?.toString() ?? '';

      // TODO: Get actual statistics from API or calculate from other repositories
      // For now, return dummy stats
      final dashboardData = DashboardData(
        userName: userName,
        userEmail: userEmail,
        totalItems: 5, // TODO: Get from HomeRepository
        unreadNotifications: 2, // TODO: Get from NotificationRepository
      );

      Logger.info('Dashboard data fetched successfully');
      return dashboardData;
    } catch (e) {
      Logger.error('Error fetching dashboard data', e);
      throw ServerFailure('Failed to fetch dashboard data: $e');
    }
  }
}

