import 'package:equatable/equatable.dart';
import '../../domain/entities/home_item.dart';

/// Base class for all home states
/// All home-related states must extend this class
abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

/// Initial home state
/// Represents the state when home page first loads
class HomeInitial extends HomeState {}

/// Loading state during home items fetch
/// Shown when fetching home items
class HomeLoading extends HomeState {}

/// Loaded state with home items
/// Represents successfully loaded home items
class HomeLoaded extends HomeState {
  final List<HomeItem> items;
  
  const HomeLoaded(this.items);
  
  @override
  List<Object?> get props => [items];
}

/// Error state for home failures
/// Contains error message describing what went wrong
class HomeError extends HomeState {
  final String message;
  
  const HomeError(this.message);
  
  @override
  List<Object?> get props => [message];
}

