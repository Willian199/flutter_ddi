import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIFutureModuleLoader extends StatefulWidget {
  /// The `module` parameter is the module to be loaded.
  const FlutterDDIFutureModuleLoader({
    required this.module,
    super.key,
  });

  /// The module to be loaded.
  final FlutterDDIFutureModuleRouter module;

  @override
  State<FlutterDDIFutureModuleLoader> createState() =>
      _FlutterDDIFutureModuleLoaderState();
}

class _FlutterDDIFutureModuleLoaderState
    extends State<FlutterDDIFutureModuleLoader> {
  final Completer _completer = Completer();

  @override
  void initState() {
    /// - Sometimes if you navigate so fast to the same route, the dispose wasn't called yet.
    /// So we check if the module is already registered and if it is, we destroy it.
    ///
    /// - If you need to register the module multiple times, you should use the `moduleQualifier` parameter.
    /// This is to ensure that the module is only registered once.
    ///
    /// - If you don't provide a `moduleQualifier`, the module will be registered with its default qualifier.
    if (ddi.isRegistered(qualifier: widget.module.moduleQualifier)) {
      ddi.destroy(qualifier: widget.module.moduleQualifier);
    }
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    try {
      await ddi.registerObject(
        widget.module,
        qualifier: widget.module.moduleQualifier,
      );

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    // If you don't provide a `moduleQualifier`, the module will be destroyed with its default qualifier
    ddi.destroy(qualifier: widget.module.moduleQualifier);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_completer.isCompleted) {
      return widget.module.page(context);
    }

    return FutureBuilder(
      /// Register the module as a Future
      future: _completer.future,
      builder: (context, snapshot) {
        return switch ((snapshot.hasError, snapshot.connectionState)) {
          (true, _) => widget.module.error,
          (false, ConnectionState.done) => widget.module.page(context),
          _ => widget.module.loading,
        };
      },
    );
  }
}
