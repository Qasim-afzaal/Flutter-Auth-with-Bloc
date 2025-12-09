import 'package:equatable/equatable.dart';

/// Base class for all notification events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load notifications
class NotificationsRequested extends NotificationEvent {
  const NotificationsRequested();
}

