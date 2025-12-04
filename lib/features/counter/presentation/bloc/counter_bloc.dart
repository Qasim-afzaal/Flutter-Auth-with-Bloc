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
    on<SetValue>(_onSetValue);
    on<SquareNumber>(_onSquarePressed);
    on<AbsoluteValue>(_onAbsoluteValuePressed);
    on<PowerNumber>(_onPowerPressed);
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
  
  /// Handles set value event - sets counter to a specific value
  /// Clamps the value to min/max constraints if outside bounds
  void _onSetValue(
    SetValue event,
    Emitter<CounterState> emit,
  ) {
    final clampedValue = _clampValue(event.value);
    emit(CounterValueChanged(clampedValue));
  }
  
  /// Handles square event - squares the counter value
  /// Prevents counter from exceeding maximum value defined in AppConstants
  void _onSquarePressed(
    SquareNumber event,
    Emitter<CounterState> emit,
  ) {
    final newValue = state.value * state.value;
    if (newValue <= AppConstants.counterMaxValue) {
      emit(CounterValueChanged(newValue));
    } else {
      emit(const CounterValueChanged(AppConstants.counterMaxValue));
    }
  }
  
  /// Handles absolute value event - converts counter to its absolute value
  /// The absolute value is always positive or zero
  void _onAbsoluteValuePressed(
    AbsoluteValue event,
    Emitter<CounterState> emit,
  ) {
    final absoluteValue = state.value < 0 ? -state.value : state.value;
    emit(CounterValueChanged(absoluteValue));
  }
  
  /// Handles power event - raises counter to a specific power
  /// Prevents counter from exceeding maximum value defined in AppConstants
  void _onPowerPressed(
    PowerNumber event,
    Emitter<CounterState> emit,
  ) {
    if (event.exponent < 0) {
      // Negative exponents not supported for integers
      return;
    }
    final newValue = _power(state.value, event.exponent);
    final clampedValue = _clampValue(newValue);
    emit(CounterValueChanged(clampedValue));
  }
  
  /// Calculates base raised to the power of exponent
  /// Returns the result of base^exponent
  int _power(int base, int exponent) {
    if (exponent == 0) return 1;
    if (exponent == 1) return base;
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
  
  /// Helper method to check if counter value is within bounds
  /// Returns true if value is between min and max, false otherwise
  bool _isWithinBounds(int value) {
    return value >= AppConstants.counterMinValue && 
           value <= AppConstants.counterMaxValue;
  }
  
  /// Clamps a value to the allowed counter range
  /// Returns the value clamped between min and max
  int _clampValue(int value) {
    if (value < AppConstants.counterMinValue) {
      return AppConstants.counterMinValue;
    } else if (value > AppConstants.counterMaxValue) {
      return AppConstants.counterMaxValue;
    }
    return value;
  }
  
  /// Gets the current counter status as a string
  /// Returns descriptive status based on current value
  String getCounterStatus() {
    final value = state.value;
    if (value == AppConstants.counterMaxValue) {
      return 'Maximum reached';
    } else if (value == AppConstants.counterMinValue) {
      return 'Minimum reached';
    } else if (value == 0) {
      return 'Reset';
    } else if (value > 0) {
      return 'Positive';
    } else {
      return 'Negative';
    }
  }
  
  /// Gets whether the counter is at its maximum value
  /// Returns true if counter is at max, false otherwise
  bool isAtMax() {
    return state.value >= AppConstants.counterMaxValue;
  }
  
  /// Gets whether the counter is at its minimum value
  /// Returns true if counter is at min, false otherwise
  bool isAtMin() {
    return state.value <= AppConstants.counterMinValue;
  }
  
  /// Gets the percentage of the counter value relative to max value
  /// Returns a value between 0.0 and 1.0
  double getProgressPercentage() {
    final range = AppConstants.counterMaxValue - AppConstants.counterMinValue;
    if (range == 0) return 0.0;
    final progress = state.value - AppConstants.counterMinValue;
    return progress / range;
  }
}