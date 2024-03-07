import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

sealed class FlutterDDIModuleDefine {
  String get path => '$runtimeType';
}

abstract class FlutterDDIModule extends FlutterDDIModuleDefine with DDIModule {
  WidgetBuilder get page;
}

abstract class FlutterDDIPage extends FlutterDDIModuleDefine {
  factory FlutterDDIPage.from({required String path, required WidgetBuilder page}) {
    return _FactoryFlutterDDIPage(path, page);
  }

  FlutterDDIPage();

  WidgetBuilder get page;
}

class _FactoryFlutterDDIPage extends FlutterDDIPage {
  _FactoryFlutterDDIPage(String path, WidgetBuilder page) {
    _path = path;
    _page = page;
  }

  late String _path;
  late WidgetBuilder _page;

  @override
  String get path => _path;

  @override
  WidgetBuilder get page => _page;
}

abstract class FlutterDDIModuleRouter extends FlutterDDIModuleDefine {
  WidgetBuilder get page;

  List<FlutterDDIModuleDefine> get modules;
}
