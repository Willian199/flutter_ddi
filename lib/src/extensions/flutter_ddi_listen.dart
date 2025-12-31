import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

extension FlutterDDIListen on Widget {
  /// Wraps the current widget with a reactive listener that rebuilds
  /// whenever the specified [Listenable] changes.
  Widget listen<ListenT extends Listenable>([ListenT? listenable]) {
    assert(
      listenable != null || ListenT != Object,
      'The Listenable of type $ListenT is not allowed.',
    );
    final ListenT listen = listenable ?? ddi.get<ListenT>();

    return ListenableBuilder(
      builder: (_, __) => this,
      listenable: listen,
    );
  }
}
