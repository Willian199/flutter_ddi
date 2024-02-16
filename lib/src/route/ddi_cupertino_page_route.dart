import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/cupertino.dart';

class DDICupertinoPageRoute<RouteType extends Object> extends CupertinoPageRoute<RouteType> {
  DDICupertinoPageRoute({
    required super.builder,
    RouteSettings? settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
    RouteType Function()? module,
  }) : super(
          settings: settings ?? RouteSettings(name: RouteType.toString()),
        ) {
    if (module != null) {
      DDI.instance.registerSingleton<RouteType>(module);
    }
  }

  Object get qualifier => RouteType;
}
