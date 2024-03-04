import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class FlutterDDICupertinoGeneratorRoute {
  static String? _lastRoute;
  static CupertinoPageRoute? generateRoutes(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }

    if ((_lastRoute?.isNotEmpty ?? false) && DDI.instance.isRegistered(qualifier: _lastRoute)) {
      final FlutterModule lastInstance = DDI.instance.get(qualifier: _lastRoute);

      //lastInstance.knowRoutes[settings.name]?.call();
    }

    final FlutterModule instance = DDI.instance.get(qualifier: settings.name);
    log('Navigating to /${instance.runtimeType}');

    _lastRoute = settings.name;

    return CupertinoPageRoute(
      settings: settings,
      builder: instance.view,
    );
  }
}
