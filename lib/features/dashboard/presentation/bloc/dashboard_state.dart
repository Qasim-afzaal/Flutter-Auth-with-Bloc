import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_data.dart';

/// Base class for all dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

/// Initial dashboard state
class DashboardInitial extends DashboardState {
  final int currentTabIndex;
  
  const DashboardInitial({this.currentTabIndex = 0});
  
  @override
  List<Object?> get props => [currentTabIndex];
}

/// Loading state
class DashboardLoading extends DashboardState {
  final int currentTabIndex;
  
  const DashboardLoading({this.currentTabIndex = 0});
  
  @override
  List<Object?> get props => [currentTabIndex];
}

/// Loaded state with dashboard data
class DashboardLoaded extends DashboardState {
  final DashboardData data;
  final int currentTabIndex;
  
  const DashboardLoaded(this.data, {this.currentTabIndex = 0});
  
  @override
  List<Object?> get props => [data, currentTabIndex];
}

/// Error state
class DashboardError extends DashboardState {
  final String message;
  final int currentTabIndex;
  
  const DashboardError(this.message, {this.currentTabIndex = 0});
  
  @override
  List<Object?> get props => [message, currentTabIndex];
}

