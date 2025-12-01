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
  const CounterEvent();

  /// Empty props list since the base class has no fields to compare
  @override
  List<Object?> get props => [];
}

/// Event to increase the counter value by 1
/// This event is dispatched when the user taps the increment button
/// The counter will increase by 1, up to a maximum value of 100
/// 
/// Increment amount: +1
class IncreaseNumber extends CounterEvent {
  /// Creates a new [IncreaseNumber] event instance
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
  /// Creates a new [DecreaseNumber] event instance
  const DecreaseNumber();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'DecreaseNumber()';
}

/// Event to reset the counter value to 0
/// This event is dispatched when the user taps the reset button
/// The counter will be set back to its initial value of 0
/// 
/// Reset value: 0
class ResetNumber extends CounterEvent {
  /// Creates a new [ResetNumber] event instance
  const ResetNumber();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'ResetNumber()';
}

/// Event to multiply the counter value by 2
/// This event is dispatched when the user wants to double the current value
/// The counter will be multiplied by 2, respecting max and min constraints
/// 
/// Multiplication factor: 2x
class MultiplyNumber extends CounterEvent {
  /// Creates a new [MultiplyNumber] event instance
  const MultiplyNumber();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'MultiplyNumber()';
}

/// Event to divide the counter value by 2
/// This event is dispatched when the user wants to halve the current value
/// The counter will be divided by 2, respecting max and min constraints
/// 
/// Division factor: ÷2
class DivideNumber extends CounterEvent {
  /// Creates a new [DivideNumber] event instance
  const DivideNumber();

  /// Returns a string representation for debugging purposes
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

  /// Creates a new [SetValue] event instance with the specified [value]
  const SetValue(this.value);

  /// Props used for equality comparison by Equatable
  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'SetValue(value: $value)';
}

/// Event to add a custom amount to the counter value
/// This event allows incrementing the counter by any specified amount
/// The value will be clamped to min/max constraints if outside bounds
/// 
/// Example: AddByAmount(5) adds 5 to the current counter value
class AddByAmount extends CounterEvent {
  /// The amount to add to the counter
  final int amount;

  /// Creates a new [AddByAmount] event instance with the specified [amount]
  const AddByAmount(this.amount);

  /// Props used for equality comparison by Equatable
  @override
  List<Object?> get props => [amount];

  @override
  String toString() => 'AddByAmount(amount: $amount)';
}

/// Event to subtract a custom amount from the counter value
/// This event allows decrementing the counter by any specified amount
/// The value will be clamped to min/max constraints if outside bounds
/// 
/// Example: SubtractByAmount(5) subtracts 5 from the current counter value
class SubtractByAmount extends CounterEvent {
  /// The amount to subtract from the counter
  final int amount;

  /// Creates a new [SubtractByAmount] event instance with the specified [amount]
  const SubtractByAmount(this.amount);

  /// Props used for equality comparison by Equatable
  @override
  List<Object?> get props => [amount];

  @override
  String toString() => 'SubtractByAmount(amount: $amount)';
}

/// Event to square the counter value
/// This event multiplies the counter by itself
/// The value will be clamped to min/max constraints if outside bounds
/// 
/// Example: SquareNumber() squares the current counter value
class SquareNumber extends CounterEvent {
  /// Creates a new [SquareNumber] event instance
  const SquareNumber();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'SquareNumber()';
}

/// Event to get the absolute value of the counter
/// This event sets the counter to its absolute value (removes negative sign)
/// 
/// Example: AbsoluteValue() converts -5 to 5
class AbsoluteValue extends CounterEvent {
  /// Creates a new [AbsoluteValue] event instance
  const AbsoluteValue();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'AbsoluteValue()';
}

/// Event to increase the counter value by 10
/// This event is dispatched when the user wants to increment by 10
/// The counter will increase by 10, up to a maximum value of 100
/// 
/// Increment amount: +10
class IncrementByTen extends CounterEvent {
  /// Creates a new [IncrementByTen] event instance
  const IncrementByTen();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'IncrementByTen()';
}

/// Event to decrease the counter value by 10
/// This event is dispatched when the user wants to decrement by 10
/// The counter will decrease by 10, down to a minimum value of -50
/// 
/// Decrement amount: -10
class DecrementByTen extends CounterEvent {
  /// Creates a new [DecrementByTen] event instance
  const DecrementByTen();

  /// Returns a string representation for debugging purposes
  @override
  String toString() => 'DecrementByTen()';
}
