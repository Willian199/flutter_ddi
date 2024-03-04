import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

extension FlutterDDIContext on BuildContext {
  T get<T extends Object>([Object? qualifier]) => DDI.instance.get<T>(qualifier: qualifier);
}