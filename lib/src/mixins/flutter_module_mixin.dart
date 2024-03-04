import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

abstract class FlutterModule with DDIModule {
  @override
  Object get moduleQualifier => '/$runtimeType';

  WidgetBuilder get view;

  void registerPage<BeanT extends Object>(
    FutureOr<BeanT> Function() clazzRegister, {
    Object? pageName,
    VoidCallback? postConstruct,
    List<BeanT Function(BeanT)>? decorators,
    List<DDIInterceptor<BeanT> Function()>? interceptors,
    FutureOr<bool> Function()? registerIf,
    bool destroyable = true,
  }) {
    //inject.addChildModules(child: pageName ?? '/$BeanT', qualifier: moduleQualifier);

    knowRoutes.addAll({
      '/$BeanT': () => inject.registerApplication<BeanT>(
            clazzRegister,
            qualifier: pageName ?? '/$BeanT',
            postConstruct: postConstruct,
            decorators: decorators,
            interceptors: interceptors,
            destroyable: destroyable,
            registerIf: registerIf,
          ),
    });
  }

  ///Should return a WidgetBuilder or void
  Map<String, dynamic Function()> knowRoutes = {};
}
