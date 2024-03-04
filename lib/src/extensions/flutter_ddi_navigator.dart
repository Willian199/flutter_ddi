import 'dart:developer';

import 'package:flutter/widgets.dart';

extension FlutterDDINavigator on NavigatorState {
  Future pushType<DestinyType extends Object>({
    Object? arguments,
  }) {
    log('Navigating to /$DestinyType');
    return pushNamed('/$DestinyType', arguments: arguments);
  }

  Future pushReplacementType<DestinyType extends Object>({
    Object? arguments,
    Object? result,
  }) {
    log('Navigating to /$DestinyType');
    return pushReplacementNamed('/$DestinyType', result: result, arguments: arguments);
  }

  Future pushTypeAndRemoveUntil<DestinyType extends Object>(
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    log('Navigating to /$DestinyType');
    return pushNamedAndRemoveUntil('/$DestinyType', predicate, arguments: arguments);
  }

  Future popAndPushType<DestinyType extends Object?>({
    Object? result,
    Object? arguments,
  }) {
    pop<Object>(result);
    return pushNamed('/$DestinyType', arguments: arguments);
  }

  String restorablePopAndPushType<DestinyType extends Object>({
    Object? result,
    Object? arguments,
  }) {
    pop(result);
    return restorablePushNamed('/$DestinyType', arguments: arguments);
  }

  String restorablePushType<DestinyType extends Object>({
    Object? result,
    Object? arguments,
  }) {
    return restorablePushNamed('/$DestinyType', arguments: arguments);
  }

  String restorablePushTypeAndRemoveUntil<DestinyType extends Object>(
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return restorablePushNamedAndRemoveUntil('/$DestinyType', predicate, arguments: arguments);
  }

  String restorablePushReplacementType<DestinyType extends Object>({
    Object? result,
    Object? arguments,
  }) {
    return restorablePushReplacementNamed('/$DestinyType', result: result, arguments: arguments);
  }

  void popUntilType<DestinyType extends Object>() {
    popUntil(ModalRoute.withName('/$DestinyType'));
  }
}
