import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<CounterIncrementPressed>(_onIncrementPressed);
    on<CounterDecrementPressed>(_onDecrementPressed);
    on<CounterResetPressed>(_onResetPressed);
  }
  
  void _onIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value + 1));
  }
  
  void _onDecrementPressed(
    CounterDecrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value - 1));
  }
  
  void _onResetPressed(
    CounterResetPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterValueChanged(0));
  }
}