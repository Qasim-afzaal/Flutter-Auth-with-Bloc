/// Counter events for the BLoC pattern
/// 
/// This library defines all events that can be dispatched to the counter BLoC
/// 
/// All events follow the BLoC pattern and are thread-safe
library;

import 'package:equatable/equatable.dart';

/// Base class for all counter events
/// All counter-related events must extend this class
/// 
/// Uses Equatable for value-based equality comparison
/// All events are immutable and can be safely reused
abstract class CounterEvent extends Equatable {
  /// Creates a new counter event instance
  const CounterEvent();

  /// Empty props list since base class has no fields
  @override
  List<Object?> get props => [];
}

/// Event to increase the counter value by 1
/// This event is dispatched when the user taps the increment button
/// The counter will increase by 1, up to a maximum value of 100
/// 
/// Increment amount: +1
class IncreaseNumber extends CounterEvent {
  /// Creates an event to increment the counter
  const IncreaseNumber();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'IncreaseNumber()';
}

/// Event to decrease the counter value by 1
/// This event is dispatched when the user taps the decrement button
/// The counter will decrease by 1, down to a minimum value of -50
/// 
/// Decrement amount: -1
class DecreaseNumber extends CounterEvent {
  /// Creates an event to decrement the counter
  const DecreaseNumber();

  @override
  String toString() => 'DecreaseNumber()';
}

/// Event to reset the counter value to 0
/// This event is dispatched when the user taps the reset button
/// The counter will be set back to its initial value of 0
/// 
/// Reset value: 0
class ResetNumber extends CounterEvent {
  /// Creates an event to reset the counter to zero
  const ResetNumber();

  @override
  String toString() => 'ResetNumber()';
}

/// Event to multiply the counter value by 2
/// This event is dispatched when the user wants to double the current value
/// The counter will be multiplied by 2, respecting max and min constraints
/// 
/// Multiplication factor: 2x
class MultiplyNumber extends CounterEvent {
  /// Creates an event to multiply the counter by 2
  const MultiplyNumber();

  @override
  String toString() => 'MultiplyNumber()';
}

/// Event to divide the counter value by 2
/// This event is dispatched when the user wants to halve the current value
/// The counter will be divided by 2, respecting max and min constraints
/// 
/// Division factor: ÷2
class DivideNumber extends CounterEvent {
  /// Creates an event to divide the counter by 2
  const DivideNumber();

  @override
  String toString() => 'DivideNumber()';
}

/// Event to set the counter to a specific value
/// This event allows setting the counter to any value within the allowed range
/// The value will be clamped to min/max constraints if outside bounds
/// 
/// Example: SetValue(42) sets the counter to 42
class SetValue extends CounterEvent {
  /// The target value to set the counter to
  final int value;

  /// Creates an event to set the counter to a specific value
  /// 
  /// [value] The target value to set the counter to
  const SetValue(this.value);

  /// Props used for equality comparison by Equatable
  @override
  List<Object?> get props => [value];

  /// Returns a string representation including the value for debugging
  @override
  String toString() => 'SetValue(value: $value)';
}
