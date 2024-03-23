import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing an event listener.
/// This mixin should be used when you want to listen for a event.
/// [EventListenType] The type of the event to listen.
mixin EventListener<StateType extends StatefulWidget,
    EventListenType extends Object> on State<StateType> {
  EventListenType? _state;
  EventListenType? get state => _state;

  void _onEvent(EventListenType listen) {
    setState(() {
      _state = listen;
    });
  }

  @protected
  @mustCallSuper
  @override
  void initState() {
    ddiEvent.subscribe<EventListenType>(_onEvent);
    super.initState();
  }

  @protected
  @mustCallSuper
  @override
  void dispose() {
    ddiEvent.unsubscribe<EventListenType>(_onEvent);
    super.dispose();
  }
}
