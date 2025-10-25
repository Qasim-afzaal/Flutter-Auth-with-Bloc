import 'package:equatable/equatable.dart';

// States
abstract class CounterState extends Equatable {
  final int value;
  
  const CounterState(this.value);
  
  
  @override
  List<Object?> get props => [value];
}

class CounterInitial extends CounterState {
  const CounterInitial():super(0);
}

class CounterValueChanged extends CounterState {
  const CounterValueChanged(super.value);
}