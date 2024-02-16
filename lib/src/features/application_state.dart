import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

abstract class ApplicationState<StateType extends StatefulWidget, BeanType extends Object> extends State<StateType> {
  late bool _isModule;
  ApplicationState(BeanType Function() clazzRegister) {
    _isModule = clazzRegister is DDIModule Function();
    DDI.instance.registerApplication(clazzRegister);
  }

  @override
  void initState() {
    super.initState();
    //Auto load the module
    if (_isModule) {
      DDI.instance.get<BeanType>();
    }

  }

  @override
  void dispose() {
    DDI.instance.destroy<BeanType>();
    super.dispose();
  }
}
