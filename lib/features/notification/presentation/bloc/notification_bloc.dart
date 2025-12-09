import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

/// Notification BLoC
/// Manages notification state
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        super(NotificationInitial()) {
    on<NotificationsRequested>(_onNotificationsRequested);
  }

  Future<void> _onNotificationsRequested(
    NotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      Logger.info('Notifications requested');
      final notifications = await _notificationRepository.getNotifications();
      Logger.info('Notifications loaded: ${notifications.length}');
      emit(NotificationLoaded(notifications));
    } on Exception catch (e) {
      Logger.error('Notifications failed', e);
      emit(NotificationError(e.toString()));
    } catch (e) {
      Logger.error('Unexpected error loading notifications', e);
      emit(NotificationError('Failed to load notifications: $e'));
    }
  }
}

