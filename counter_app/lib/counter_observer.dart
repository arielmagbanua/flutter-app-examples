import 'package:flutter_bloc/flutter_bloc.dart';

/// CounterObserver
///
/// The first thing we're going to take a look at is how to create a
/// `BlocObserver` which will help us
/// observe all state changes in the application.
///
/// [BlocObserver] for the counter application which
/// observes all [Bloc] state changes.
class CounterObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}
