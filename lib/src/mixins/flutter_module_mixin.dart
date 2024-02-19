import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

abstract class FlutterModule with DDIModule {
  @override
  Object get moduleQualifier => '/${runtimeType.toString()}';

  WidgetBuilder get view;

  void registerPage<BeanT extends Object>(
    FutureOr<BeanT> Function() clazzRegister, {
    Object? qualifier,
    void Function()? postConstruct,
    List<BeanT Function(BeanT)>? decorators,
    List<DDIInterceptor<BeanT> Function()>? interceptors,
    FutureOr<bool> Function()? registerIf,
    bool destroyable = true,
  }) {
    inject.addChildModules(child: qualifier ?? '/$BeanT', qualifier: moduleQualifier);

    knowRoutes.addAll({
      '/$BeanT': () => inject.registerApplication<BeanT>(
            clazzRegister,
            qualifier: qualifier ?? '/$BeanT',
            postConstruct: postConstruct,
            decorators: decorators,
            interceptors: interceptors,
            destroyable: destroyable,
            registerIf: registerIf,
          ),
    });
  }

  Map<String, void Function()> knowRoutes = {};
}
