import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

final class FlutterDDIWidget<BeanT extends Object> extends StatefulWidget {
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
    DDI.instance.registerSingleton<BeanT>(widget.module as BeanT Function(), qualifier: widget.moduleName);
    super.initState();
  }

  @override
  void dispose() {
    DDI.instance.destroy<BeanT>(qualifier: widget.moduleName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
