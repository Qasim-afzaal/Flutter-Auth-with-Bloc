import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';
 

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<IncreaseNumber>(_onIncrementPressed);
    on<DecreaseNumber>(_onDecrementPressed);
    on<ResetNumber>(_onResetPressed);
  }
  
  void _onIncrementPressed(
    IncreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value + 1));
  }
  
  void _onDecrementPressed(
    DecreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterValueChanged(state.value - 1));
  }
  
  void _onResetPressed(
    ResetNumber event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterValueChanged(0));
  }
}