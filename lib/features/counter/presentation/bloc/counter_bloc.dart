import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// BLoC for managing counter state
/// Handles increment, decrement, and reset operations
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncreaseNumber>(_onIncrementPressed);
    on<DecreaseNumber>(_onDecrementPressed);
    on<ResetNumber>(_onResetPressed);
  }
  
  /// Handles increment event - increases counter by 1
  /// Prevents counter from exceeding maximum value
  void _onIncrementPressed(
    IncreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    if (state.value < AppConstants.counterMaxValue) {
      emit(CounterValueChanged(state.value + AppConstants.incrementStep));
    }
  }
  
  /// Handles decrement event - decreases counter by 1
  /// Prevents counter from going below minimum value
  void _onDecrementPressed(
    DecreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    if (state.value > AppConstants.counterMinValue) {
      emit(CounterValueChanged(state.value - AppConstants.decrementStep));
    }
  }
  
  /// Handles reset event - sets counter to 0
  void _onResetPressed(
    ResetNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterValueChanged(0));
  }
}