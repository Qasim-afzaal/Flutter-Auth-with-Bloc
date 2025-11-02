import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to increase the counter value by 1
class IncreaseNumber extends CounterEvent {
  @override
  String toString() => 'IncreaseNumber';
}

/// Event to decrease the counter value by 1
class DecreaseNumber extends CounterEvent {
  @override
  String toString() => 'DecreaseNumber';
}

/// Event to reset the counter value to 0
class ResetNumber extends CounterEvent {
  @override
  String toString() => 'ResetNumber';
}
