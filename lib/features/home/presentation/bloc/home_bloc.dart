import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Home BLoC
/// Manages home state and handles home events
/// 
/// Events handled:
/// - HomeItemsRequested: Fetches and displays home items
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(HomeInitial()) {
    on<HomeItemsRequested>(_onHomeItemsRequested);
  }

  /// Handles home items request event
  /// Emits loading state, then fetches home items
  /// On success: emits HomeLoaded state
  /// On failure: emits HomeError state with error message
  Future<void> _onHomeItemsRequested(
    HomeItemsRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      Logger.info('Home items requested');
      final items = await _homeRepository.getHomeItems();
      Logger.info('Home items loaded successfully: ${items.length} items');
      emit(HomeLoaded(items));
    } on Exception catch (e) {
      Logger.error('Home items failed', e);
      emit(HomeError(e.toString()));
    } catch (e) {
      Logger.error('Unexpected error loading home items', e);
      emit(HomeError('Failed to load home items: $e'));
    }
  }
}

