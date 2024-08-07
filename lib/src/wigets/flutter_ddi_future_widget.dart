import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Widget that handles dependency injection.
/// This widget is used to wrap a child widget and register its module with DDI.
final class FlutterDDIFutureWidget<BeanT extends Object>
    extends StatefulWidget {
  /// The `module` parameter is a function returning an instance of the widget's module.
  /// The `moduleName` parameter is the name of the module.
  /// If `moduleName` is `null`, the module will be registered with the [BeanT].
  /// The `child` parameter is the child widget to be wrapped.
  const FlutterDDIFutureWidget({
    required this.module,
    required this.child,
    this.moduleName,
    super.key,
    this.error,
    this.loading,
  });

  /// The child widget to be wrapped.
  final WidgetBuilder child;

  /// The error widget to be displayed if the module fails to be registered.
  final Widget? error;

  /// The loading widget to be displayed while the module is being registered.
  final Widget? loading;

  /// The module to register with DDI.
  final BeanT Function() module;

  /// The name of the module.
  final String? moduleName;

  @override
  State<FlutterDDIFutureWidget> createState() =>
      _FlutterDDIFutureWidgetState<BeanT>();
}

class _FlutterDDIFutureWidgetState<BeanT extends Object>
    extends State<FlutterDDIFutureWidget> {
  final Completer _completer = Completer();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    try {
      await ddi.registerSingleton<BeanT>(
        widget.module as BeanT Function(),
        qualifier: widget.moduleName,
      );
      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    ddi.destroy<BeanT>(qualifier: widget.moduleName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_completer.isCompleted) {
      return widget.child(context);
    }

    return FutureBuilder(
      future: _completer.future,
      builder: (context, snapshot) {
        return switch ((snapshot.hasError, snapshot.connectionState)) {
          (true, _) => widget.error ?? const SizedBox.shrink(),
          (false, ConnectionState.done) => widget.child(context),
          _ =>
            widget.loading ?? const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}
