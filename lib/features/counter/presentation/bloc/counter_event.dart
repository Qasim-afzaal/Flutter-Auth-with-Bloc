import 'package:equatable/equatable.dart';

/// Base class for all counter events
/// All counter-related events must extend this class
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to increase the counter value by 1
/// This event is dispatched when the user taps the increment button
/// The counter will increase by 1, up to a maximum value of 100
class IncreaseNumber extends CounterEvent {
  @override
  String toString() => 'IncreaseNumber';
}

/// Event to decrease the counter value by 1
/// This event is dispatched when the user taps the decrement button
/// The counter will decrease by 1, down to a minimum value of -50
class DecreaseNumber extends CounterEvent {
  @override
  String toString() => 'DecreaseNumber';
}

/// Event to reset the counter value to 0
/// This event is dispatched when the user taps the reset button
/// The counter will be set back to its initial value of 0
class ResetNumber extends CounterEvent {
  @override
  String toString() => 'ResetNumber';
}

/// Event to multiply the counter value by 2
/// This event is dispatched when the user wants to double the current value
/// The counter will be multiplied by 2, respecting max and min constraints
class MultiplyNumber extends CounterEvent {
  @override
  String toString() => 'MultiplyNumber';
}

/// Event to divide the counter value by 2
/// This event is dispatched when the user wants to halve the current value
/// The counter will be divided by 2, respecting max and min constraints
class DivideNumber extends CounterEvent {
  @override
  String toString() => 'DivideNumber';
}

/// Event to set the counter to a specific value
/// This event allows setting the counter to any value within the allowed range
/// The value will be clamped to min/max constraints if outside bounds
class SetValue extends CounterEvent {
  final int value;
  
  const SetValue(this.value);
  
  @override
  List<Object?> get props => [value];
  
  @override
  String toString() => 'SetValue(value: $value)';
}
