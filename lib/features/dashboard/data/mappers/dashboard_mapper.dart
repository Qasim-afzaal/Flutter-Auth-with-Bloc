import '../models/dashboard_data_dto.dart';
import '../../domain/entities/dashboard_data.dart';

/// Dashboard Mapper
/// Converts between DTO and Domain Entity
class DashboardMapper {
  static DashboardData toEntity(DashboardDataDto dto) {
    return DashboardData(
      userName: dto.userName ?? '',
      userEmail: dto.userEmail ?? '',
      totalItems: dto.totalItems ?? 0,
      unreadNotifications: dto.unreadNotifications ?? 0,
    );
  }

  static DashboardDataDto toDto(DashboardData entity) {
    return DashboardDataDto(
      userName: entity.userName,
      userEmail: entity.userEmail,
      totalItems: entity.totalItems,
      unreadNotifications: entity.unreadNotifications,
    );
  }
}

