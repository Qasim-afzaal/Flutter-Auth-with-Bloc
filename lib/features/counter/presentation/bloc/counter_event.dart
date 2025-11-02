import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}
 
class IncreaseNumber extends CounterEvent {
  @override
  String toString() => 'IncreaseNumber';
}

class DecreaseNumber extends CounterEvent {
  @override
  String toString() => 'DecreaseNumber';
}

class ResetNumber extends CounterEvent {
  @override
  String toString() => 'ResetNumber';
}

