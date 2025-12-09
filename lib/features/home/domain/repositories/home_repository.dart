import '../entities/home_item.dart';

/// Home Repository Interface
/// Defines the contract for home data operations
/// Follows Clean Architecture - Domain Layer
abstract class HomeRepository {
  /// Gets list of home items
  /// 
  /// Returns [List<HomeItem>] of items to display
  /// Throws [Failure] if operation fails
  Future<List<HomeItem>> getHomeItems();
}

