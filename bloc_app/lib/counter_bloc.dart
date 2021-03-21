import 'dart:async';

import './counter_event.dart';

class CounterBlock {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  StreamSink<int> get _intCounter => _counterStateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // For events, exposing only a sink which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBlock() {
    // Whenever there is a new event, we want to map it to a new state
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else
      _counter--;

    _intCounter.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
