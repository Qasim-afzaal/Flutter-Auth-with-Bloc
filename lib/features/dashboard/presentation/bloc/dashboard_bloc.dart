import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC
/// Manages dashboard state and handles dashboard events
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc({
    required DashboardRepository dashboardRepository,
  })  : _dashboardRepository = dashboardRepository,
        super(const DashboardInitial()) {
    on<DashboardDataRequested>(_onDashboardDataRequested);
    on<DashboardTabChanged>(_onDashboardTabChanged);
  }

  Future<void> _onDashboardDataRequested(
    DashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final currentTabIndex = _getCurrentTabIndex(state);
    emit(DashboardLoading(currentTabIndex: currentTabIndex));

    try {
      Logger.info('Dashboard data requested');
      final data = await _dashboardRepository.getDashboardData();
      Logger.info('Dashboard data loaded successfully');
      emit(DashboardLoaded(data, currentTabIndex: currentTabIndex));
    } on Exception catch (e) {
      Logger.error('Dashboard data failed', e);
      emit(DashboardError(e.toString(), currentTabIndex: currentTabIndex));
    } catch (e) {
      Logger.error('Unexpected error loading dashboard data', e);
      emit(DashboardError('Failed to load dashboard data: $e', currentTabIndex: currentTabIndex));
    }
  }

  void _onDashboardTabChanged(
    DashboardTabChanged event,
    Emitter<DashboardState> emit,
  ) {
    Logger.info('Dashboard tab changed to index: ${event.tabIndex}');
    
    // Preserve current state data while updating tab index
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(DashboardLoaded(currentState.data, currentTabIndex: event.tabIndex));
    } else if (state is DashboardLoading) {
      emit(DashboardLoading(currentTabIndex: event.tabIndex));
    } else if (state is DashboardError) {
      final currentState = state as DashboardError;
      emit(DashboardError(currentState.message, currentTabIndex: event.tabIndex));
    } else {
      emit(DashboardInitial(currentTabIndex: event.tabIndex));
    }
  }

  /// Helper method to get current tab index from any state
  int _getCurrentTabIndex(DashboardState state) {
    if (state is DashboardLoaded) {
      return state.currentTabIndex;
    } else if (state is DashboardLoading) {
      return state.currentTabIndex;
    } else if (state is DashboardError) {
      return state.currentTabIndex;
    } else if (state is DashboardInitial) {
      return state.currentTabIndex;
    }
    return 0;
  }
}

