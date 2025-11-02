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