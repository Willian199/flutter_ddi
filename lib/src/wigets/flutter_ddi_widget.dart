import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Widget that handles dependency injection.
/// This widget is used to wrap a child widget and register its module with DDI.
final class FlutterDDIWidget<BeanT extends Object> extends StatefulWidget {
  /// The `module` parameter is a function returning an instance of the widget's module.
  const FlutterDDIWidget({required this.module, required this.child, this.moduleName, super.key});

  final Widget child;
  final BeanT Function() module;
  final String? moduleName;

  @override
  State<FlutterDDIWidget> createState() => _FlutterDDIWidgetState<BeanT>();
}

class _FlutterDDIWidgetState<BeanT extends Object> extends State<FlutterDDIWidget> {
  @override
  void initState() {
    // Register the module when the widget is initialized
    ddi.registerSingleton<BeanT>(widget.module as BeanT Function(), qualifier: widget.moduleName);
    super.initState();
  }

  @override
  void dispose() {
    // Destroy the registered module when the widget is disposed
    ddi.destroy<BeanT>(qualifier: widget.moduleName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
