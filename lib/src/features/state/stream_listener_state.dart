import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing a stream listener state.
/// This class should be extended when you want to listen for a stream.
/// [StateType] The type of the state that extends this class.
/// [StreamListenType] The type of the stream to listen.
///
abstract class StreamListenerState<StateType extends StatefulWidget,
    StreamListenType extends Object> extends State<StateType> {
  StreamListenType? _state;

  /// The current state of the stream.
  StreamListenType? get state => _state;

  void _onEvent(StreamListenType listen) {
    setState(() {
      _state = listen;
    });
  }

  @protected
  @mustCallSuper
  @override
  void initState() {
    ddiStream.subscribe<StreamListenType>(callback: _onEvent);
    super.initState();
  }

  @protected
  @mustCallSuper
  @override
  void dispose() {
    ddiStream.close<StreamListenType>();
    super.dispose();
  }
}
