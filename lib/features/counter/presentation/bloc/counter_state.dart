import 'package:equatable/equatable.dart';

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
  const CounterMaxReached() : super(100);
  
  @override
  String toString() => 'CounterMaxReached(value: $value)';
}

/// State emitted when counter reaches minimum value
/// Indicates that the counter cannot be decremented further
class CounterMinReached extends CounterState {
  const CounterMinReached() : super(-50);
  
  @override
  String toString() => 'CounterMinReached(value: $value)';
}