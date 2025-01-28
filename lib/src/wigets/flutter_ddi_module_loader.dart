import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_custom_pop_scope.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIRouterLoader<ModuleT extends FlutterDDIRouter>
    extends StatefulWidget {
  /// The `module` parameter is the module to be loaded.
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

  late final FlutterDDIRouter _module = widget.module;

  late final Object moduleQualifier = _module.moduleQualifier;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
    super.initState();
  }

  Future<void> initialize() async {
    try {
      final List<Object> middlewaresQualifiers =
          await Future.wait(_module.middlewares.map((e) => e.register()));

      await ddi.registerObject<FlutterDDIRouter>(
        _module,
        qualifier: moduleQualifier,
        interceptors: middlewaresQualifiers.toSet(),
        decorators: [
          (FlutterDDIRouter b) {
            b.context = context;
            return b;
          },
        ],
      );

      await ddi.getAsync<FlutterDDIRouter>(qualifier: moduleQualifier);

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    // If you don't provide a `moduleQualifier`, the module will be destroyed with its default qualifier
    if (!isDestroyed &&
        ddi.isRegistered<FlutterDDIRouter>(qualifier: moduleQualifier)) {
      ddi.destroy<FlutterDDIRouter>(
        qualifier: moduleQualifier,
      );

      _module.middlewares.map((e) => e.destroy());
    }

    _cachedWidget = null;
    super.dispose();
  }

  Future<void> onPop(bool isDestroyed) async {
    await Future.wait(_module.middlewares.map((e) => e.destroy()));

    this.isDestroyed = isDestroyed;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onPopInvoked: onPop,
      moduleQualifier: moduleQualifier,
      child: FutureBuilder(
        /// Await the module's initialization
        future: _completer.future,
        builder: (context, snapshot) {
          return switch ((snapshot.hasError, snapshot.connectionState)) {
            (true, _) => _module.error ??
                ddi.getOptionalWith<ErrorModuleInterface, AsyncSnapshot>(
                    parameter: snapshot) ??
                Scaffold(
                  backgroundColor: Colors.red,
                  body: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
            (false, ConnectionState.done) => _cachedWidget ??=
                widget.module.page(context),
            _ => _module.loading ??
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
