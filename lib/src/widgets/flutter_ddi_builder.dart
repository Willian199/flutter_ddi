import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/src/interfaces/error_module_interface.dart';
import 'package:flutter_ddi/src/interfaces/loader_module_interface.dart';
import 'package:flutter_ddi/src/widgets/flutter_ddi_custom_pop_scope.dart';

/// Widget that handles dependency injection.
/// This widget is used to wrap a child widget and register its module with DDI.
final class FlutterDDIBuilder<BeanT extends Object> extends StatefulWidget {
  /// The `module` parameter is a function returning an instance of the widget's module.
  /// The `moduleName` parameter is the name of the module.
  /// If `moduleName` is `null`, the module will be registered with the [BeanT].
  /// The `child` parameter is the child widget to be wrapped.
  const FlutterDDIBuilder({
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
  State<FlutterDDIBuilder> createState() => _FlutterDDIBuilderState<BeanT>();
}

class _FlutterDDIBuilderState<BeanT extends Object>
    extends State<FlutterDDIBuilder> {
  final Completer completer = Completer();

  bool isDestroyed = false;

  Widget? _cachedWidget;

  @override
  void initState() {
    // Use microtask to defer initialization until after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initialize();
      }
    });

    super.initState();
  }

  Future<void> initialize() async {
    try {
      await ddi.singleton<BeanT>(
        widget.module as BeanT Function(),
        qualifier: widget.moduleName,
      );

      completer.complete();
    } catch (e) {
      completer.completeError(e);
    }
  }

  @override
  void dispose() {
    _cachedWidget = null;

    if (!completer.isCompleted) {
      completer.completeError('Widget disposed during initialization');
    }

    // Destroy the registered module when the widget is disposed
    if (!isDestroyed) {
      ddi.destroy<BeanT>(qualifier: widget.moduleName);
    }

    super.dispose();
  }

  void onPop(bool isDestroyed) {
    this.isDestroyed = isDestroyed;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onPopInvoked: onPop,
      moduleQualifier: widget.moduleName ?? BeanT,
      child: FutureBuilder(
        /// Await the module's initialization
        future: completer.future,
        builder: (context, AsyncSnapshot snapshot) {
          return switch ((snapshot.hasError, snapshot.connectionState)) {
            (true, _) => widget.error ??
                ddi.getOptionalWith<ErrorModuleInterface, AsyncSnapshot>(
                    parameter: snapshot) ??
                Scaffold(
                  backgroundColor: Colors.red,
                  body: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
            (false, ConnectionState.done) => _cachedWidget ??=
                widget.child(context),
            _ => widget.loading ??
                ddi.getOptional<LoaderModuleInterface>() ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
          };
        },
      ),
    );
  }
}
