import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

sealed class FlutterDDIModuleDefine {
  String get path => '$runtimeType';
}

abstract class FlutterDDIModule extends FlutterDDIModuleDefine with DDIModule {
  WidgetBuilder get page;
}

abstract class FlutterDDIPage extends FlutterDDIModuleDefine {
  Widget get page;
}
