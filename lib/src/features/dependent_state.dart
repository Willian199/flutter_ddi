import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing a dependent state.
/// This class should be extended when you want to register and manage dependent dependencies with DDI.
/// Be Aware about registering the same instances more than once
abstract class DependentState<StateType extends StatefulWidget, BeanType extends Object> extends State<StateType> {
  /// The `clazzRegister` function should return the instance of the bean to be registered.
  DependentState(BeanType Function() clazzRegister) {
    _isModule = clazzRegister is DDIModule Function();
    ddi.registerDependent(clazzRegister);
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
