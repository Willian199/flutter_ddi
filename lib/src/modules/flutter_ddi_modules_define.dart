import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Sealed class representing the definition of a module.
/// This class should be extended to define the path of a module.
sealed class FlutterDDIModuleDefine {
  /// Get the path of the module.
  /// Used to define the route of the module.
  String get path => '$runtimeType';
}

/// Abstract class representing a Flutter module with dependency injection.
/// This class should be extended to define a module with a corresponding page.
abstract class FlutterDDIModule extends FlutterDDIModuleDefine with DDIModule {
  /// Get the page associated with the module.
  WidgetBuilder get page;
}

/// Abstract class representing a Flutter page with dependency injection.
/// This class should be extended to define a page with dependency injection.
abstract class FlutterDDIPage extends FlutterDDIModuleDefine {
  /// Factory method to create a FlutterDDIPage.
  factory FlutterDDIPage.from(
      {required String path, required WidgetBuilder page}) {
    return _FactoryFlutterDDIPage(path, page);
  }

  FlutterDDIPage();

  /// Get the page associated with the module.
  WidgetBuilder get page;
}

/// Factory implementation of FlutterDDIPage.
/// This class implements the creation of a FlutterDDIPage.
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

/// Abstract class representing a module router with dependency injection.
/// This class should be extended to define a router with modules.
abstract class FlutterDDIModuleRouter extends FlutterDDIModuleDefine {
  /// Get the page associated with the module.
  WidgetBuilder get page;

  /// Get the list of modules associated with the router.
  List<FlutterDDIModuleDefine> get modules;
}

abstract class FlutterDDIFutureModuleRouter extends FlutterDDIModuleDefine
    with DDIModule {
  /// Get the page associated with the module.
  WidgetBuilder get page;

  /// Get the list of modules associated with the router.
  List<FlutterDDIModuleDefine> get modules => [];

  /// The error widget to be displayed if the module fails to be registered.
  Widget get error => const SizedBox.shrink();

  /// The loading widget to be displayed while the module is being registered.
  Widget get loading => const Center(child: CircularProgressIndicator());
}
