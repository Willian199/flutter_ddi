import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DDINavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Route Push: ${route.settings.name}');
    if (route is! DDIMaterialPageRoute && (route.settings.name?.isNotEmpty ?? false) && DDI.instance.isRegistered(qualifier: route.settings.name)) {
      DDI.instance.get(qualifier: route.settings.name);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Route pop: ${route.settings.name}');
    if (route is DDIMaterialPageRoute) {
      DDI.instance.destroy(qualifier: route.qualifier);
    } else if ((route.settings.name?.isNotEmpty ?? false) && DDI.instance.isRegistered(qualifier: route.settings.name)) {
      DDI.instance.destroy(qualifier: route.settings.name);
    }
    super.didPop(route, previousRoute);
  }
}
