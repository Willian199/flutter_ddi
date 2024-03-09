import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

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

  final DDIModule module;
  final WidgetBuilder page;

  @override
  State<FlutterDDIModuleLoader> createState() => _FlutterDDIModuleLoaderState();
}

class _FlutterDDIModuleLoaderState extends State<FlutterDDIModuleLoader> {
  @override
  void initState() {
    // Sometimes if you navigate so fast to the same route, the dispose isn't called.
    if (ddi.isRegistered(qualifier: widget.module.moduleQualifier)) {
      ddi.destroy(qualifier: widget.module.moduleQualifier);
    }
    // Register the module with its qualifier when the widget is initialized
    ddi.registerObject(widget.module, qualifier: widget.module.moduleQualifier);

    super.initState();
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    ddi.destroy(qualifier: widget.module.moduleQualifier);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page(context);
  }
}
