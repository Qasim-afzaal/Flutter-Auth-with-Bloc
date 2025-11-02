import 'package:flutter_bloc/flutter_bloc.dart';
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
  void _onIncrementPressed(
    IncreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value + 1));
  }
  
  /// Handles decrement event - decreases counter by 1
  void _onDecrementPressed(
    DecreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value - 1));
  }
  
  /// Handles reset event - sets counter to 0
  void _onResetPressed(
    ResetNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterValueChanged(0));
  }
}