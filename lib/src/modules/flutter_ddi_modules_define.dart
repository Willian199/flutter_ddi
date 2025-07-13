import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/exception/null_context_exception.dart';

/// Sealed class representing the definition of a module.
/// This class should be extended to define the path of a module.
///
/// A module encapsulates a set of related functionality, dependencies, and routes.
/// It provides a way to organize your application into logical units.
sealed class FlutterDDIModuleDefine with PreDestroy {
  /// Get the path of the module.
  /// Used to define the route of the module.
  ///
  /// By default, returns the runtime type name. Override this to provide
  /// a custom path for your module.
  String get path => '$runtimeType';

  /// Get the page associated with the module.
  ///
  /// This should return a WidgetBuilder that creates the main widget
  /// for this module.
  WidgetBuilder get page;

  /// Get the qualifier for this module.
  ///
  /// Used internally by the DDI system to identify this module instance.
  Object get moduleQualifier => runtimeType;

  /// Get the list of interceptors for this module.
  ///
  /// Interceptors can be used to add cross-cutting concerns like logging,
  /// or validation to your modules.
  List<ModuleInterceptor> get interceptors => [];

  /// Internal context.
  BuildContext? _context;

  /// Get the BuildContext for this module.
  ///
  /// Throws [NullContextException] if the context is not available.
  @nonVirtual
  BuildContext get context {
    if (_context == null) {
      throw NullContextException(path);
    }
    return _context!;
  }

  /// Set the BuildContext for this module.
  ///
  /// This is used internally by the package. Do not call directly.
  @nonVirtual
  set context(BuildContext value) {
    _context = value;
  }

  /// Called before the module is destroyed.
  ///
  /// Override this method to perform cleanup operations when the module
  /// is being disposed.
  @override
  @mustCallSuper
  FutureOr<void> onPreDestroy() async {
    await Future.wait(interceptors.map((e) => e.destroy()));
  }

  /// Destroy this module and clean up its resources.
  ///
  /// This method should be implemented to handle module-specific cleanup.
  Future<void> destroy();
}

/// Abstract class representing a Flutter page with dependency injection.
/// This class should be extended to define a page with dependency injection.
///
/// A page represents a single screen in your application. It can have its own
/// dependencies and interceptors, but typically doesn't contain other modules.
abstract class FlutterDDIPage extends FlutterDDIModuleDefine {
  /// Factory method to create a FlutterDDIPage.
  ///
  /// This factory method allows you to create a page without extending the class.
  /// Useful for simple pages that don't need custom logic.
  ///
  /// [path] - The route path for this page.
  /// [page] - The WidgetBuilder that creates the page widget.
  /// [interceptors] - Optional list of interceptors for this page.
  factory FlutterDDIPage.from({
    required String path,
    required WidgetBuilder page,
    List<ModuleInterceptor>? interceptors,
  }) {
    if (path.isEmpty) {
      throw ArgumentError('Path cannot be empty');
    }

    return _FactoryFlutterDDIPage(path, page, interceptors);
  }

  /// Creates a FlutterDDIPage.
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

/// Abstract class that combines router functionality with DDI module capabilities.
///
/// This class allows you to create modules that can contain other modules
/// and manage their dependencies through the DDI system.
abstract class FlutterDDIModuleRouter = FlutterDDIRouter with DDIModule;

/// Abstract class representing a Flutter router with dependency injection.
/// This class should be extended to define a router that can contain other modules.
///
/// A router represents a container for multiple related pages or modules.
/// It can have its own dependencies and can contain other modules as children.
abstract class FlutterDDIRouter extends FlutterDDIModuleDefine {
  /// Get the list of modules associated with the router.
  ///
  /// Override this to provide the child modules for this router.
  List<FlutterDDIModuleDefine> get modules => [];

  /// The error widget to be displayed if the module fails to be registered.
  ///
  /// Override this to provide a custom error widget for this router.
  Widget? get error => null;

  /// The loading widget to be displayed while the module is being registered.
  ///
  /// Override this to provide a custom loading widget for this router.
  Widget? get loading => null;

  @override
  Future<void> destroy() async {
    await ddi.destroy<FlutterDDIModuleDefine>(qualifier: moduleQualifier);

    Navigator.of(context).pop();
  }
}

/// Abstract class to implement a Router Outlet pattern.
///
/// An outlet module provides a nested navigation context within your application.
/// It maintains its own Navigator and can contain multiple child routes.
/// This is useful for implementing complex navigation patterns like tab bars
/// or nested navigation structures.
abstract class FlutterDDIOutletModule extends FlutterDDIRouter {
  /// The navigator key for the outlet.
  ///
  /// This key is used to control the nested Navigator within this outlet.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a specific route in the outlet.
  ///
  /// [routeName] - The name of the route to navigate to.
  /// [arguments] - Optional arguments to pass to the route.
  ///
  /// Returns a Future that completes when the navigation is finished.
  Future<T?> navigateTo<T extends Object?>(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState
            ?.pushNamed<T>(routeName, arguments: arguments) ??
        Future.value();
  }
}
