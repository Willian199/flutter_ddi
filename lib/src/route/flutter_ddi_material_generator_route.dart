import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class FlutterDDIMaterialGeneratorRoute {
  static MaterialPageRoute? generateRoutes(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }
    final List<String> lastRoute = DDI.instance.get<List<String>>(qualifier: 'routes');

    if (lastRoute.isNotEmpty &&
        lastRoute.last.isNotEmpty &&
        lastRoute.last != settings.name &&
        DDI.instance.isRegistered(qualifier: lastRoute.last)) {
      final FlutterModule lastInstance = DDI.instance.get(qualifier: lastRoute.last);

      if (lastInstance.knowRoutes[settings.name] is Widget Function() && !DDI.instance.isRegistered(qualifier: settings.name)) {
        log('Generating route ${settings.name}');
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => lastInstance.knowRoutes[settings.name]?.call() as Widget,
        );
      }

      if (lastInstance.knowRoutes[settings.name] is FlutterModule Function()) {
        DDI.instance
            .registerApplication<FlutterModule>(() => lastInstance.knowRoutes[settings.name]?.call() as FlutterModule, qualifier: settings.name);
      } else {
        lastInstance.knowRoutes[settings.name]?.call();
      }
    }

    final FlutterModule instance = DDI.instance.get(qualifier: settings.name);
    log('Generating route ${settings.name}');
    DDI.instance.get<List<String>>(qualifier: 'routes').add(settings.name!);

    return MaterialPageRoute(
      settings: settings,
      builder: instance.view,
    );
  }
}
