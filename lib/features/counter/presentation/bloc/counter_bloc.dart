import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';
import '../../../../core/constants/app_constants.dart';

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  static const String _logPrefix = 'CounterBloc';
  CounterBloc() : super(const CounterInitial()) {
    on<CounterIncrementPressed>(_onIncrementPressed);
    on<CounterDecrementPressed>(_onDecrementPressed);
    on<CounterResetPressed>(_onResetPressed);
    on<CounterDoublePressed>(_onDoublePressed);
    on<CounterHalfPressed>(_onHalfPressed);
  }
  
  void _onIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value + AppConstants.incrementStep;
    if (_isValueWithinBounds(newValue)) {
      emit(CounterValueChanged(newValue));
    }
  }
  
  void _onDecrementPressed(
    CounterDecrementPressed event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value - AppConstants.decrementStep;
    if (_isValueWithinBounds(newValue)) {
      emit(CounterValueChanged(newValue));
    }
  }
  
  void _onResetPressed(
    CounterResetPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(const CounterValueChanged(0));
  }
  
  void _onDoublePressed(
    CounterDoublePressed event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value * AppConstants.doubleMultiplier;
    if (_isValueWithinBounds(newValue)) {
      emit(CounterValueChanged(newValue));
    }
  }
  
  void _onHalfPressed(
    CounterHalfPressed event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value ~/ AppConstants.halfDivisor;
    if (_isValueWithinBounds(newValue)) {
      emit(CounterValueChanged(newValue));
    }
  }
  
  bool _isValueWithinBounds(int value) {
    return value >= AppConstants.counterMinValue && 
           value <= AppConstants.counterMaxValue;
  }
}