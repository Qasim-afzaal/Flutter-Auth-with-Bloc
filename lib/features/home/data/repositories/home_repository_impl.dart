import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/home_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_item_dto.dart';
import '../mappers/home_item_mapper.dart';

/// Home Repository Implementation
/// Implements the HomeRepository interface
/// Handles home data operations
/// Follows Clean Architecture - Data Layer
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl();

  @override
  Future<List<HomeItem>> getHomeItems() async {
    try {
      Logger.info('Fetching home items');

      // TODO: Replace with actual API call
      // For now, return dummy data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API delay

      final dummyData = _getDummyData();
      final items = dummyData
          .map((dto) => HomeItemMapper.toEntity(dto))
          .toList();

      Logger.info('Home items fetched successfully: ${items.length} items');
      return items;
    } catch (e) {
      Logger.error('Error fetching home items', e);
      throw ServerFailure('Failed to fetch home items: $e');
    }
  }

  /// Returns dummy data for demonstration
  /// In production, this would come from API
  List<HomeItemDto> _getDummyData() {
    return [
      HomeItemDto(
        id: '1',
        title: 'Welcome to Flutter',
        description: 'Learn Flutter development with Clean Architecture and BLoC pattern',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      HomeItemDto(
        id: '2',
        title: 'Clean Architecture',
        description: 'Build maintainable apps with proper layer separation',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      ),
      HomeItemDto(
        id: '3',
        title: 'BLoC Pattern',
        description: 'Manage state efficiently with Business Logic Component pattern',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      ),
      HomeItemDto(
        id: '4',
        title: 'State Management',
        description: 'Choose the right state management solution for your app',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      ),
      HomeItemDto(
        id: '5',
        title: 'Best Practices',
        description: 'Follow SOLID principles and Clean Architecture guidelines',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      ),
    ];
  }
}

