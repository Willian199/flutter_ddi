import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Extension method to simplify retrieving dependencies using DDI.
extension FlutterDDIContext on BuildContext {
  /// Extension method to simplify retrieving dependencies using DDI.
  /// @param [BeanT] The type of the dependency to retrieve.
  /// @param [Object? qualifier] The qualifier of the dependency to retrieve.
  ///
  BeanT get<BeanT extends Object>([Object? qualifier]) => ddi.get<BeanT>(qualifier: qualifier);

  /// Extension method to simplify retrieving data from the current route.
  /// @param [RouteArgumentT] The type of the data to retrieve.
  RouteArgumentT? arguments<RouteArgumentT>() {
    return ModalRoute.of(this)?.settings.arguments as RouteArgumentT?;
  }
}
