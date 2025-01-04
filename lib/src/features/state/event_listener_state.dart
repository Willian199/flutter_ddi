import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing an event listener state.
/// This class should be extended when you want to listen for an event.
/// [StateType] The type of the state that extends this class.
/// [EventListenType] The type of the event to listen.
///
abstract class EventListenerState<StateType extends StatefulWidget,
    EventListenType extends Object> extends State<StateType> {
  EventListenType? _state;

  /// The current state of the event listener.
  EventListenType? get state => _state ??= ddiEvent.getValue<EventListenType>();

  @protected
  @mustCallSuper
  void onEvent(EventListenType listen) {
    _state = listen;
    setState(() {});
  }

  @protected
  @mustCallSuper
  @override
  void initState() {
    ddiEvent.subscribe<EventListenType>(onEvent);
    super.initState();
  }

  @protected
  @mustCallSuper
  @override
  void dispose() {
    ddiEvent.unsubscribe<EventListenType>(onEvent);
    super.dispose();
  }
}
