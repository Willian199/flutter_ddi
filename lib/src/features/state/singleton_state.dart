import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Abstract class representing a singleton state.
/// This class should be extended when you want to register and manage singleton dependencies with DDI.
/// Recommended for most cases
abstract class SingletonState<StateType extends StatefulWidget,
    BeanType extends Object> extends State<StateType> {
  /// The `clazzRegister` function should return the instance of the bean to be registered.
  SingletonState(BeanType Function() clazzRegister) {
    ddi.registerSingleton(clazzRegister);
  }

  @override
  void dispose() {
    // Destroy the registered module
    ddi.destroy<BeanType>();
    super.dispose();
  }
}
