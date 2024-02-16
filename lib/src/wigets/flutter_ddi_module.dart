import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

final class FlutterDDIModule<BeanT extends Object> extends StatefulWidget {
  const FlutterDDIModule({required this.module, required this.child, this.moduleName, super.key});

  final Widget child;
  final BeanT Function() module;
  final String? moduleName;

  @override
  State<FlutterDDIModule> createState() => _FlutterDDIModuleState<BeanT>();
}

class _FlutterDDIModuleState<BeanT extends Object> extends State<FlutterDDIModule> {
  @override
  void initState() {
    super.initState();
    DDI.instance.registerApplication<BeanT>(widget.module as BeanT Function(), qualifier: widget.moduleName);
  }

  @override
  void dispose() {
    DDI.instance.destroy<BeanT>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
