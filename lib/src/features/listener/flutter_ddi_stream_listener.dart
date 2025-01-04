import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing a stream listener.
/// This mixin should be used when you want to listen for a stream.
/// [StreamListenType] The type of the stream to listen.
mixin StreamListener<StateType extends StatefulWidget,
    StreamListenType extends Object> on State<StateType> {
  StreamListenType? _state;
  StreamListenType? get state => _state;

  @protected
  @mustCallSuper
  void onEvent(StreamListenType listen) {
    setState(() {
      _state = listen;
    });
  }

  @protected
  @mustCallSuper
  @override
  void initState() {
    ddiStream.subscribe<StreamListenType>(callback: onEvent);
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
