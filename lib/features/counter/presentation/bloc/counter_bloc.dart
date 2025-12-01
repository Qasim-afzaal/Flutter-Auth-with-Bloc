import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// BLoC for managing counter state
/// Handles increment, decrement, reset, multiply, and divide operations
/// All operations respect the min and max value constraints defined in AppConstants
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  /// History of counter values for undo/redo functionality
  final List<int> _history = [0];
  int _historyIndex = 0;

  CounterBloc() : super(const CounterInitial()) {
    on<IncreaseNumber>(_onIncrementPressed);
    on<DecreaseNumber>(_onDecrementPressed);
    on<ResetNumber>(_onResetPressed);
    on<MultiplyNumber>(_onMultiplyPressed);
    on<DivideNumber>(_onDividePressed);
    on<SetValue>(_onSetValue);
  }
  
  /// Adds a value to the history
  void _addToHistory(int value) {
    // Remove any future history if we're not at the end
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(value);
    _historyIndex = _history.length - 1;
    // Limit history size to prevent memory issues
    if (_history.length > 100) {
      _history.removeAt(0);
      _historyIndex--;
    }
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
  /// Handles division by zero error
  void _onDividePressed(
    DivideNumber event,
    Emitter<CounterState> emit,
  ) {
    if (AppConstants.halfDivisor == 0) {
      emit(CounterError('Cannot divide by zero', state.value));
      return;
    }
    final newValue = state.value ~/ AppConstants.halfDivisor;
    if (newValue >= AppConstants.counterMinValue) {
      emit(CounterValueChanged(newValue));
    } else {
      emit(const CounterValueChanged(AppConstants.counterMinValue));
    }
  }
  
  /// Handles set value event - sets counter to a specific value
  /// Clamps the value to min/max constraints if outside bounds
  /// Validates the input value before setting
  void _onSetValue(
    SetValue event,
    Emitter<CounterState> emit,
  ) {
    if (!_isWithinBounds(event.value)) {
      final clampedValue = _clampValue(event.value);
      emit(CounterValueChanged(clampedValue));
    } else {
      emit(CounterValueChanged(event.value));
    }
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
  
  /// Undoes the last operation by restoring the previous value from history
  /// Returns true if undo was successful, false if no history available
  bool undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      final previousValue = _history[_historyIndex];
      emit(CounterValueChanged(previousValue));
      return true;
    }
    return false;
  }
  
  /// Redoes the last undone operation by restoring the next value from history
  /// Returns true if redo was successful, false if no future history available
  bool redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      final nextValue = _history[_historyIndex];
      emit(CounterValueChanged(nextValue));
      return true;
    }
    return false;
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
}