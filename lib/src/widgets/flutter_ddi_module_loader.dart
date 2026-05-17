import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/widgets/flutter_ddi_custom_pop_scope.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIRouterLoader<ModuleT extends FlutterDDIModuleDefine> extends StatefulWidget {
  /// Creates a FlutterDDIRouterLoader widget.
  ///
  /// [module] - The module to be loaded.
  const FlutterDDIRouterLoader({
    required this.module,
    super.key,
  });

  /// The module to be loaded.
  final ModuleT module;

  @override
  State<FlutterDDIRouterLoader> createState() => _FlutterDDIRouterLoaderState();
}

class _FlutterDDIRouterLoaderState extends State<FlutterDDIRouterLoader> {
  _FlutterDDIRouterLoaderState();
  late final Completer _completer = Completer();
  bool isDestroyed = false;
  Widget? _cachedWidget;

  late final FlutterDDIModuleDefine _module = widget.module;

  late final Object moduleRouterQualifier = _module.routeQualifier;

  late final Object? moduleContextQualifier = _module is DDIModule ? (_module as DDIModule).moduleQualifier : null;

  Widget? _error;
  Widget? _loading;

  @override
  void initState() {
    super.initState();
    if (_module is FlutterDDIRouter) {
      _error = _module.error;
      _loading = _module.loading;
    }

    Future.microtask(initialize);

    _loading ??=
        ddi.getOptional<LoaderModuleInterface>() ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Future<void> initialize() async {
    try {
      final List<Object> interceptorsQualifiers = await Future.wait(_module.interceptors.map((e) => e.register()));

      _module.context = context;

      await ddi.object<FlutterDDIModuleDefine>(
        _module,
        qualifier: moduleRouterQualifier,
        interceptors: interceptorsQualifiers.toSet(),
      );

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }

  @override
  void dispose() {
    // `dispose` must stay synchronous so `super.dispose()` is reached before
    // Flutter finalizes the State lifecycle.
    unawaited(_destroyModule());

    _cachedWidget = null;

    super.dispose();
  }

  Future<void> _destroyModule() async {
    // Destroy the registered module when the widget is disposed
    // If you don't provide a custom `routeQualifier`, the module will be
    // destroyed with its default qualifier.
    if (isDestroyed) {
      return;
    }

    await ddi.destroy<FlutterDDIModuleDefine>(
      qualifier: moduleRouterQualifier,
    );

    isDestroyed = true;

    await Future.wait(_module.interceptors.map((e) => e.destroy()));
  }

  Future<void> onPop() {
    return _destroyModule();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onPopInvoked: onPop,
      child: FutureBuilder(
        /// Await the module's initialization
        future: _completer.future,
        builder: (context, snapshot) => switch ((snapshot.hasError, snapshot.connectionState)) {
          // Widget to show when there's an error during module initialization
          (true, _) =>
            _error ??=
                ddi.getOptionalWith<ErrorModuleInterface, AsyncSnapshot>(parameter: snapshot) ??
                Scaffold(
                  backgroundColor: Colors.red,
                  body: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
          // Widget to show when the module is successfully initialized
          (false, ConnectionState.done) => _cachedWidget ??= widget.module.page(context),
          // Widget to show while the module is being initialized
          _ => _loading!,
        },
      ),
    );
  }
}
