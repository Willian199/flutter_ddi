import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/exception/null_context_exception.dart';

/// Sealed class representing the definition of a module.
/// This class should be extended to define the path of a module.
sealed class FlutterDDIModuleDefine with PreDestroy {
  /// Get the path of the module.
  /// Used to define the route of the module.
  String get path => '$runtimeType';

  /// Get the page associated with the module.
  WidgetBuilder get page;

  Object get moduleQualifier => runtimeType;

  List<ModuleInterceptor> get interceptors => [];

  BuildContext? _context;

  @nonVirtual
  BuildContext get context {
    if (_context == null) {
      throw NullContextException(path);
    }
    return _context!;
  }

  // Don't update this variable. Used internally by the package
  //@internal
  @nonVirtual
  set context(BuildContext value) {
    _context = value;
  }

  @override
  @mustCallSuper
  FutureOr<void> onPreDestroy() async {
    await Future.wait(interceptors.map((e) => e.destroy()));
  }

  Future<void> destroy();
}

/// Abstract class representing a Flutter page with dependency injection.
/// This class should be extended to define a page with dependency injection.
abstract class FlutterDDIPage extends FlutterDDIModuleDefine {
  /// Factory method to create a FlutterDDIPage.
  factory FlutterDDIPage.from({
    required String path,
    required WidgetBuilder page,
    List<ModuleInterceptor>? interceptors,
  }) {
    return _FactoryFlutterDDIPage(path, page, interceptors);
  }

  FlutterDDIPage();

  @override
  Future<void> destroy() async {
    await ddi.destroy(qualifier: moduleQualifier);

    Navigator.of(context).pop();
  }
}

/// Factory implementation of FlutterDDIPage.
/// This class implements the creation of a FlutterDDIPage.
class _FactoryFlutterDDIPage extends FlutterDDIPage {
  _FactoryFlutterDDIPage(this._path, this._page, this._interceptors);

  final String _path;
  final WidgetBuilder _page;
  final List<ModuleInterceptor>? _interceptors;

  @override
  String get path => _path;

  @override
  WidgetBuilder get page => _page;

  @override
  List<ModuleInterceptor> get interceptors => _interceptors ?? [];
}

abstract class FlutterDDIModuleRouter = FlutterDDIRouter with DDIModule;

abstract class FlutterDDIRouter extends FlutterDDIModuleDefine {
  /// Get the list of modules associated with the router.
  List<FlutterDDIModuleDefine> get modules => [];

  /// The error widget to be displayed if the module fails to be registered.
  Widget? get error => null;

  /// The loading widget to be displayed while the module is being registered.
  Widget? get loading => null;

  @override
  Future<void> destroy() async {
    await ddi.destroy<FlutterDDIModuleDefine>(qualifier: moduleQualifier);

    Navigator.of(context).pop();
  }
}
