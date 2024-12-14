import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_custom_pop_scope.dart';

/// Widget that loads a module with dependency injection.
/// This widget is used to load a module's page with its dependencies resolved.
class FlutterDDIModuleLoader extends StatefulWidget {
  /// The `module` parameter is the module to be loaded.
  /// The `page` parameter is the page builder associated with the module.
  const FlutterDDIModuleLoader({
    required this.module,
    required this.page,
    super.key,
  });

  /// The module to be loaded.
  final DDIModule module;

  /// The page builder associated with the module.
  final WidgetBuilder page;

  @override
  State<FlutterDDIModuleLoader> createState() => _FlutterDDIModuleLoaderState();
}

class _FlutterDDIModuleLoaderState extends State<FlutterDDIModuleLoader> {
  bool isDestroyed = false;
  @override
  void initState() {
    ddi.registerObject(
      widget.module,
      qualifier: widget.module.moduleQualifier,
    );

    super.initState();
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    // If you don't provide a `moduleQualifier`, the module will be destroyed with its default qualifier
    if (!isDestroyed) {
      ddi.destroy(qualifier: widget.module.moduleQualifier);
    }

    super.dispose();
  }

  void onPop(bool isDestroyed) {
    this.isDestroyed = isDestroyed;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      moduleQualifier: widget.module.moduleQualifier,
      child: widget.page(context),
      onPopInvoked: onPop,
    );
  }
}
