part of 'counter_cubit.dart';

abstract class CounterState extends Equatable {
  const CounterState();
}

class CounterInitial extends CounterState {
  final int value = 0;

  @override
  List<Object> get props => [value];
}
