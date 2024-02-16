import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

abstract class SingletonState<StateType extends StatefulWidget, BeanType extends Object> extends State<StateType> {
  SingletonState(BeanType Function() clazzRegister) {
    DDI.instance.registerSingleton(clazzRegister);
  }

  @override
  void dispose() {
    DDI.instance.destroy<BeanType>();
    super.dispose();
  }
}
