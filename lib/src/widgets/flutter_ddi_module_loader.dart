import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/widgets/flutter_ddi_custom_pop_scope.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIRouterLoader<ModuleT extends FlutterDDIModuleDefine>
    extends StatefulWidget {
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

  late final Object moduleQualifier = _module.moduleQualifier;

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

    _loading ??= ddi.getOptional<LoaderModuleInterface>() ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Future<void> initialize() async {
    try {
      final List<Object> interceptorsQualifiers =
          await Future.wait(_module.interceptors.map((e) => e.register()));

      _module.context = context;

      await ddi.object<FlutterDDIModuleDefine>(
        _module,
        qualifier: moduleQualifier,
        interceptors: interceptorsQualifiers.toSet(),
      );

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }

  @override
  void dispose() async {
    super.dispose();

    // Destroy the registered module when the widget is disposed
    // If you don't provide a `moduleQualifier`, the module will be destroyed with its default qualifier
    if (!isDestroyed) {
      await ddi.destroy<FlutterDDIModuleDefine>(
        qualifier: moduleQualifier,
      );
      await Future.wait(_module.interceptors.map((e) => e.destroy()));
    }

    _cachedWidget = null;
  }

  Future<void> onPop(bool isDestroyed) async {
    await ddi.destroy<FlutterDDIModuleDefine>(
      qualifier: moduleQualifier,
    );
    this.isDestroyed = isDestroyed;
    await Future.wait(_module.interceptors.map((e) => e.destroy()));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onPopInvoked: onPop,
      child: FutureBuilder(
        /// Await the module's initialization
        future: _completer.future,
        builder: (context, snapshot) =>
            switch ((snapshot.hasError, snapshot.connectionState)) {
          // Widget to show when there's an error during module initialization
          (true, _) => _error ??=
              ddi.getOptionalWith<ErrorModuleInterface, AsyncSnapshot>(
                      parameter: snapshot) ??
                  Scaffold(
                    backgroundColor: Colors.red,
                    body: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  ),
          // Widget to show when the module is successfully initialized
          (false, ConnectionState.done) => _cachedWidget ??=
              widget.module.page(context),
          // Widget to show while the module is being initialized
          _ => _loading!,
        },
      ),
    );
  }
}
