import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/exception/interceptor_blocked.dart';

/// A Interceptor to modifying the behavior of
/// `FlutterDDIModuleDefine` instances.
///
/// `FlutterDDIInterceptor` extends the `DDIInterceptor` class, providing
/// a mechanism to control the lifecycle and access of modules.
///
abstract class FlutterDDIInterceptor extends DDIInterceptor<FlutterDDIModuleDefine> {
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

    if (result == InterceptorResult.stop) {
      await onFail(instance);
      Navigator.of(instance.context).pop();
      throw const InterceptorBlockedException('InterceptorResult.stop');
    }

    if (result == InterceptorResult.redirect) {
      await ddi.destroy<FlutterDDIModuleDefine>(
        qualifier: instance.moduleQualifier,
      );
      redirect(instance.context);
      throw const InterceptorBlockedException('InterceptorResult.redirect');
    }

    return instance;
  }

  FutureOr<InterceptorResult> onEnter(FlutterDDIModuleDefine instance) {
    return InterceptorResult.next;
  }

  FutureOr<void> onFail(FlutterDDIModuleDefine instance) {}

  FutureOr<void> redirect(BuildContext context) {}
}
