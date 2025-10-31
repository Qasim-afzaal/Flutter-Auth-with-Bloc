import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}
 
class IncreaseNumber extends  CounterEvent {}
class DecreaseNumber extends  CounterEvent {}
class ResetNumber extends  CounterEvent {}

