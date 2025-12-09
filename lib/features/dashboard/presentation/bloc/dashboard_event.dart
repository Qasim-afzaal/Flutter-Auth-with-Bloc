import 'package:equatable/equatable.dart';

/// Base class for all dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data
class DashboardDataRequested extends DashboardEvent {
  const DashboardDataRequested();
}

/// Event to change the selected tab
class DashboardTabChanged extends DashboardEvent {
  final int tabIndex;
  
  const DashboardTabChanged(this.tabIndex);
  
  @override
  List<Object?> get props => [tabIndex];
}

