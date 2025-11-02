import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {
  final int value;

  const CounterState(this.value);

  @override
  List<Object?> get props => [value];
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
  
  @override
  String toString() => 'CounterInitial(value: $value)';
}

class CounterValueChanged extends CounterState {
  const CounterValueChanged(int value) : super(value);
  
  @override
  String toString() => 'CounterValueChanged(value: $value)';
}