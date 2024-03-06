import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

class FlutterDDIModuleLoader extends StatefulWidget {
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
  late Object qualifier;
  @override
  void initState() {
    DDI.instance.registerObject(widget.module, qualifier: widget.module.moduleQualifier);

    super.initState();
  }

  @override
  void dispose() {
    DDI.instance.destroy(qualifier: widget.module.moduleQualifier);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page(context);
  }
}
