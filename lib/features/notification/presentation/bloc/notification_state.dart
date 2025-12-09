import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_item.dart';

/// Base class for all notification states
abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationInitial extends NotificationState {}

/// Loading state
class NotificationLoading extends NotificationState {}

/// Loaded state
class NotificationLoaded extends NotificationState {
  final List<NotificationItem> notifications;
  
  const NotificationLoaded(this.notifications);
  
  @override
  List<Object?> get props => [notifications];
}

/// Error state
class NotificationError extends NotificationState {
  final String message;
  
  const NotificationError(this.message);
  
  @override
  List<Object?> get props => [message];
}

