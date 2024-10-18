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
  @override
  void initState() {
    /// - Sometimes if you navigate so fast to the same route, the dispose wasn't called yet.
    /// So we check if the module is already registered and if it is, we destroy it.
    ///
    /// - If you need to register the module multiple times, you should use the `moduleQualifier` parameter.
    /// This is to ensure that the module is only registered once.
    ///
    /// - If you don't provide a `moduleQualifier`, the module will be registered with its default qualifier.
    // if (ddi.isRegistered(qualifier: widget.module.moduleQualifier)) {
    //   ddi.refreshObject(widget.module, qualifier: widget.module.moduleQualifier);
    // } else {
    //   /// Register the module with its qualifier when the widget is initialized
    ddi.registerObject(widget.module, qualifier: widget.module.moduleQualifier);
    // }

    super.initState();
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
    return CustomPopScope(
      moduleQualifier: widget.module.moduleQualifier,
      child: widget.page(context),
    );
  }
}
