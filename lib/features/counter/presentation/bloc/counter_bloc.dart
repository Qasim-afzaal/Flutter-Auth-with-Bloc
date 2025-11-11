import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// BLoC for managing counter state
/// Handles increment, decrement, reset, multiply, and divide operations
/// All operations respect the min and max value constraints defined in AppConstants
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncreaseNumber>(_onIncrementPressed);
    on<DecreaseNumber>(_onDecrementPressed);
    on<ResetNumber>(_onResetPressed);
    on<MultiplyNumber>(_onMultiplyPressed);
    on<DivideNumber>(_onDividePressed);
  }
  
  /// Handles increment event - increases counter by 1
  /// Prevents counter from exceeding maximum value defined in AppConstants
  void _onIncrementPressed(
    IncreaseNumber event,
    Emitter<CounterState> emit,
  ) {
    if (state.value < AppConstants.counterMaxValue) {
      emit(CounterValueChanged(state.value + AppConstants.incrementStep));
    }
  }
  
  /// Handles decrement event - decreases counter by 1
  /// Prevents counter from going below minimum value defined in AppConstants
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
  
  /// Handles multiply event - multiplies counter by 2
  /// Prevents counter from exceeding maximum value defined in AppConstants
  void _onMultiplyPressed(
    MultiplyNumber event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value * AppConstants.doubleMultiplier;
    if (newValue <= AppConstants.counterMaxValue) {
      emit(CounterValueChanged(newValue));
    } else {
      emit(const CounterValueChanged(AppConstants.counterMaxValue));
    }
  }
  
  /// Handles divide event - divides counter by 2
  /// Prevents counter from going below minimum value defined in AppConstants
  void _onDividePressed(
    DivideNumber event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value ~/ AppConstants.halfDivisor;
    if (newValue >= AppConstants.counterMinValue) {
      emit(CounterValueChanged(newValue));
    } else {
      emit(const CounterValueChanged(AppConstants.counterMinValue));
    }
  }
  
  /// Helper method to check if counter value is within bounds
  /// Returns true if value is between min and max, false otherwise
  bool _isWithinBounds(int value) {
    return value >= AppConstants.counterMinValue && 
           value <= AppConstants.counterMaxValue;
  }
}