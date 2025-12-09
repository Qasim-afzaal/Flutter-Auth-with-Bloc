import 'package:equatable/equatable.dart';

/// Base class for all home events
/// All home-related events must extend this class
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load home items
/// Fetches and displays home items
class HomeItemsRequested extends HomeEvent {
  const HomeItemsRequested();
}

