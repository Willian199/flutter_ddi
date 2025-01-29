import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/features/middleware/middleware_blocked.dart';

/// A middleware interface for intercepting and modifying the behavior of
/// `FlutterDDIModuleDefine` instances.
///
/// `FlutterDDIMiddleware` extends the `DDIInterceptor` class, providing
/// a mechanism to control the lifecycle and access of modules.
///
abstract class FlutterDDIMiddleware extends DDIInterceptor<FlutterDDIModuleDefine> {
  @nonVirtual
  @override
  FutureOr<void> onDispose(instance) {}

  @nonVirtual
  @override
  FutureOr<void> onDestroy(instance) {}

  @nonVirtual
  @override
  FutureOr<FlutterDDIModuleDefine> onGet(FlutterDDIModuleDefine instance) {
    return instance;
  }

  @nonVirtual
  @override
  Future<FlutterDDIModuleDefine> onCreate(FlutterDDIModuleDefine instance) async {
    final result = await onEnter(instance);

    if (result == MiddlewareResult.stop) {
      await onFail(instance);
      Navigator.of(instance.context).pop();
      throw const MiddlewareBlockedException('MiddlewareResult.stop');
    }

    if (result == MiddlewareResult.redirect) {
      await ddi.destroy<FlutterDDIModuleDefine>(
        qualifier: instance.moduleQualifier,
      );
      redirect(instance.context);
      throw const MiddlewareBlockedException('MiddlewareResult.redirect');
    }

    return instance;
  }

  FutureOr<MiddlewareResult> onEnter(FlutterDDIModuleDefine instance) {
    return MiddlewareResult.next;
  }

  FutureOr<void> onFail(FlutterDDIModuleDefine instance) {}

  FutureOr<void> redirect(BuildContext context) {}
}
