import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

/// Base state class for counter
/// Contains the current counter value
abstract class CounterState extends Equatable {
  final int value;

  const CounterState(this.value);

  @override
  List<Object?> get props => [value];
}

/// Initial state when counter is first created
/// Counter starts at 0
class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
  
  @override
  String toString() => 'CounterInitial(value: $value)';
}

/// State emitted when counter value changes
/// Contains the new counter value
class CounterValueChanged extends CounterState {
  const CounterValueChanged(int value) : super(value);
  
  @override
  String toString() => 'CounterValueChanged(value: $value)';
}

/// State emitted when counter reaches maximum value
/// Indicates that the counter cannot be incremented further
class CounterMaxReached extends CounterState {
  const CounterMaxReached() : super(AppConstants.counterMaxValue);
  
  @override
  String toString() => 'CounterMaxReached(value: $value)';
}

/// State emitted when counter reaches minimum value
/// Indicates that the counter cannot be decremented further
class CounterMinReached extends CounterState {
  const CounterMinReached() : super(AppConstants.counterMinValue);
  
  @override
  String toString() => 'CounterMinReached(value: $value)';
}

/// State emitted when counter history is requested
/// Contains a list of previous counter values
class CounterHistory extends CounterState {
  final List<int> history;
  
  const CounterHistory(this.history, int currentValue) : super(currentValue);
  
  @override
  List<Object?> get props => [history, value];
  
  @override
  String toString() => 'CounterHistory(value: $value, history: $history)';
}