import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing the application state.
/// This class should be extended when you want to register and manage dependencies with DDI.
abstract class ApplicationState<StateType extends StatefulWidget, BeanType extends Object> extends State<StateType> {
  /// The `clazzRegister` function should return the instance of the bean to be registered.
  ApplicationState(BeanType Function() clazzRegister) {
    _isModule = clazzRegister is DDIModule Function();
    ddi.registerApplication(clazzRegister);
  }

  late bool _isModule;

  @override
  void initState() {
    super.initState();
    // Auto load the module if it's a module type
    if (_isModule) {
      ddi.get<BeanType>();
    }
  }

  @override
  void dispose() {
    // Destroy the registered module
    ddi.destroy<BeanType>();
    super.dispose();
  }
}
