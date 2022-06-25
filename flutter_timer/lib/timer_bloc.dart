import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'ticker.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(_duration)) {

    on<TimerStarted>((TimerStarted event, emit) {
      emit(TimerRunInProgress(event.duration));
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(ticks: event.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    });

    on<TimerPaused>((TimerPaused event, emit) {
      if (state is TimerRunInProgress) {
        _tickerSubscription?.pause();
        emit(TimerRunPause(state.duration));
      }
    });

    on<TimerResumed>((TimerResumed event, emit) {
      if (state is TimerRunPause) {
        _tickerSubscription?.resume();
        emit(TimerRunInProgress(state.duration));
      }
    });

    on<TimerReset>((TimerReset event, emit) {
      _tickerSubscription?.cancel();
      emit(TimerInitial(_duration));
    });

    on<TimerTicked>((TimerTicked event, emit) {
      emit(event.duration > 0
          ? TimerRunInProgress(event.duration)
          : TimerRunComplete());
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
