import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class FlutterDDINavigatorObserver extends NavigatorObserver {
  FlutterDDINavigatorObserver() {
    DDI.instance.registerSingleton<List<String>>(() => [], qualifier: 'routes');
  }
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name case final String name? when name.isNotEmpty) {
      log('Route Push: $name');
      if (route is! FlutterDDIMaterialPageRoute && route is! FlutterDDICupertinoPageRoute && DDI.instance.isRegistered(qualifier: name)) {
        DDI.instance.get(qualifier: name);
      }
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name case final String name? when name.isNotEmpty) {
      log('Route pop: $name');

      switch (route) {
        case FlutterDDIMaterialPageRoute(qualifier: final qualifier):
          DDI.instance.destroy(qualifier: qualifier);
          break;
        case FlutterDDICupertinoPageRoute(qualifier: final qualifier):
          DDI.instance.destroy(qualifier: qualifier);
        case Route(settings: RouteSettings(name: final rota?)) when rota.isNotEmpty:
          if (DDI.instance.isRegistered(qualifier: rota)) {
            DDI.instance.destroy(qualifier: rota);
          }
      }

      DDI.instance.get<List<String>>(qualifier: 'routes').removeWhere((r) => r == name);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute?.settings.name case final String name? when name.isNotEmpty) {
      log('Route replace: $name');
      DDI.instance.get<List<String>>(qualifier: 'routes').removeWhere((r) => r == name);
      if (DDI.instance.isRegistered(qualifier: name)) {
        DDI.instance.destroy(qualifier: name);
      }
    }

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (route.settings.name case final String name? when name.isNotEmpty) {
      log('Route Removed: $name');
      DDI.instance.get<List<String>>(qualifier: 'routes').removeWhere((r) => r == name);

      if (DDI.instance.isRegistered(qualifier: name)) {
        DDI.instance.destroy(qualifier: name);
      }
    }
    super.didRemove(route, previousRoute);
  }
}
