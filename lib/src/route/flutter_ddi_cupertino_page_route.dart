import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/cupertino.dart';

/// Custom CupertinoPageRoute with dependency injection.
/// This route allows injecting dependencies into the specified page.
class FlutterDDICupertinoPageRoute<RouteType extends Object>
    extends CupertinoPageRoute<RouteType> {
  /// The `module` parameter is a function returning an instance of the route's module.
  /// This route can register the module using the DDI.
  FlutterDDICupertinoPageRoute({
    required super.builder,
    required RouteType Function()? module,
    RouteSettings? settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  }) : super(
          settings: settings ?? RouteSettings(name: RouteType.toString()),
        ) {
    // Register the module if provided
    if (module != null) {
      ddi.registerSingleton<RouteType>(module, qualifier: qualifier);
    }
  }

  /// The qualifier for the route type.
  Object get qualifier => RouteType;
}
