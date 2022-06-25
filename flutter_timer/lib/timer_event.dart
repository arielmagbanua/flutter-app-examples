import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

/// TimerStarted
///
/// Informs the TimerBloc that the timer should be started.
class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted({required this.duration});

  @override
  String toString() => "TimerStarted { duration: $duration }";
}

/// TimerPaused
///
/// Informs the TimerBloc that the timer should be paused.
class TimerPaused extends TimerEvent {}

/// TimerResumed
///
/// Informs the TimerBloc that the timer should be resumed.
class TimerResumed extends TimerEvent {}

/// TimerReset
///
/// Informs the TimerBloc that the timer should be reset to the original state.
class TimerReset extends TimerEvent {}

/// TimerTicked
///
/// Informs the TimerBloc that a tick has occurred and that it needs to
/// update its state accordingly.
class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked({required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "TimerTicked { duration: $duration }";
}
