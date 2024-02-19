import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DDIGeneratorRoute {
  static String? _lastRoute;
  static MaterialPageRoute generateRoutes(RouteSettings settings) {
    if ((_lastRoute?.isNotEmpty ?? false) && DDI.instance.isRegistered(qualifier: _lastRoute)) {
      final FlutterModule lastInstance = DDI.instance.get(qualifier: _lastRoute);

      lastInstance.knowRoutes[settings.name]?.call();
    }

    final FlutterModule instance = DDI.instance.get(qualifier: settings.name);
    log('Navigating to /${instance.runtimeType}');
    _lastRoute = settings.name;

    return MaterialPageRoute(
      settings: settings,
      builder: instance.view,
    );
  }
}
