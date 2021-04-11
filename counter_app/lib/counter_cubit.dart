import 'package:flutter_bloc/flutter_bloc.dart';

/// CounterCubit
///
/// The type of state the CounterCubit is managing
/// is just an int and the initial state is 0.
class CounterCubit extends Cubit<int> {
  /// Constructor
  CounterCubit() : super(0);

  /// Add 1 to the current state.
  void increment() => emit(state + 1);

  /// Subtract 1 from the current state.
  void decrement() => emit(state - 1);
}
