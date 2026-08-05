import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/widgets/flutter_ddi_custom_pop_scope.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIOutletLoader<ModuleT extends FlutterDDIOutletModule> extends StatefulWidget {
  /// Creates a FlutterDDIOutletLoader widget.
  ///
  /// [module] - The module to be loaded.
  const FlutterDDIOutletLoader({
    required this.module,
    super.key,
  });

  /// The module to be loaded.
  final ModuleT module;

  @override
  State<FlutterDDIOutletLoader> createState() => _FlutterDDIOutletLoaderState();
}

class _FlutterDDIOutletLoaderState extends State<FlutterDDIOutletLoader> {
  _FlutterDDIOutletLoaderState();
  late final Completer _completer = Completer();
  bool isDestroyed = false;
  Widget? _cachedWidget;

  late final FlutterDDIOutletModule _module = widget.module;

  late final Object moduleRouterQualifier = _module.routeQualifier;

  Widget? _error;
  Widget? _loading;

  late final Map<String, Widget Function(BuildContext)> _routes;

  @override
  void initState() {
    _error = _module.error;
    _loading = _module.loading;

    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
    super.initState();
  }

  Future<void> initialize() async {
    try {
      final List<Object> interceptorsQualifiers = await Future.wait(_module.interceptors.map((e) => e.register()));

      _module.context = context;

      await ddi.object<FlutterDDIOutletModule>(
        _module,
        qualifier: moduleRouterQualifier,
        interceptors: interceptorsQualifiers.toSet(),
      );

      _routes = _module.getModules();

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

    isDestroyed = true;

    await ddi.destroy<FlutterDDIOutletModule>(
      qualifier: moduleRouterQualifier,
    );

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
        builder: (context, snapshot) {
          return switch ((snapshot.hasError, snapshot.connectionState)) {
            (true, _) =>
              _error ??
                  ddi.getOptionalWith<ErrorModuleInterface, AsyncSnapshot>(parameter: snapshot) ??
                  Scaffold(
                    backgroundColor: Colors.red,
                    body: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  ),
            (false, ConnectionState.done) => _cachedWidget ??= Navigator(
              key: _module.navigatorKey,
              initialRoute: _module.path,
              onGenerateRoute: (settings) {
                if ([_module.path, '/'].contains(settings.name)) {
                  return MaterialPageRoute(
                    builder: (context) => _module.page(context),
                    settings: settings,
                  );
                }

                final builder = _routes[settings.name];

                if (builder != null) {
                  return MaterialPageRoute(
                    builder: builder,
                    settings: settings,
                  );
                }
                return null;
              },
            ),
            _ =>
              _loading ??
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
