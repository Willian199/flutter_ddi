import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

extension FlutterDDIContext on BuildContext {
  /// Extension method to simplify retrieving dependencies using DDI.
  T get<T extends Object>([Object? qualifier]) => ddi.get<T>(qualifier: qualifier);
}