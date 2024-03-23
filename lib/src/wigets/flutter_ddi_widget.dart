import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Widget that handles dependency injection.
/// This widget is used to wrap a child widget and register its module with DDI.
final class FlutterDDIWidget<BeanT extends Object> extends StatefulWidget {
  /// The `module` parameter is a function returning an instance of the widget's module.
  /// The `moduleName` parameter is the name of the module.
  /// If `moduleName` is `null`, the module will be registered with the [BeanT].
  /// The `child` parameter is the child widget to be wrapped.
  const FlutterDDIWidget(
      {required this.module, required this.child, this.moduleName, super.key});

  /// The child widget to be wrapped.
  final Widget child;

  /// The module to register with DDI.
  final BeanT Function() module;

  /// The name of the module.
  final String? moduleName;

  @override
  State<FlutterDDIWidget> createState() => _FlutterDDIWidgetState<BeanT>();
}

class _FlutterDDIWidgetState<BeanT extends Object>
    extends State<FlutterDDIWidget> {
  @override
  void initState() {
    /// - Sometimes if you dispose and create the widget so fast, the dispose wasn't called yet.
    /// So we check if the instance is already registered and if it is, we destroy it.
    ///
    /// - If you need to register the instance multiple times, you should use the `moduleName` parameter.
    /// This is to ensure that the instance is only registered once.
    ///
    /// - If you don't provide a `moduleName`, the module will be registered with its default qualifier.
    if (ddi.isRegistered<BeanT>(qualifier: widget.moduleName)) {
      ddi.destroy<BeanT>(qualifier: widget.moduleName);
    }
    // Register the module when the widget is initialized
    ddi.registerSingleton<BeanT>(widget.module as BeanT Function(),
        qualifier: widget.moduleName);
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
