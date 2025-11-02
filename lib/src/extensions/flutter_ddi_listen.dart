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
    return _ReactiveListener<ListenT>(
      child: this,
      listenable: listenable,
    );
  }
}

class _ReactiveListener<ListenT extends Listenable> extends StatefulWidget {
  const _ReactiveListener({
    required this.child,
    this.listenable,
  });

  final Widget child;
  final Listenable? listenable;

  @override
  State<_ReactiveListener> createState() => __ReactiveListenerState<ListenT>();
}

class __ReactiveListenerState<ListenT extends Listenable>
    extends State<_ReactiveListener> {
  late final ListenT _listenable =
      (widget.listenable ?? ddi.get<ListenT>()) as ListenT;

  @override
  void initState() {
    super.initState();
    _listenable.addListener(_handleChange);
  }

  @override
  void dispose() {
    _listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
