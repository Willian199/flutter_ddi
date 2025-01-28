import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// A middleware interface for intercepting and modifying the behavior of
/// `FlutterDDIModuleDefine` instances in the `flutter_ddi` package.
///
/// `FlutterDDIMiddleware` extends the `DDIInterceptor` class, providing
/// a mechanism to control the lifecycle and access of modules.
///
///
/// **Interceptor Methods:**
/// - `onCreate`: Invoked during the module creation process. This runs before the module becomes available. Also you can't access `instance.context`.
/// - `onGet`: Invoked when retrieving an instance. You can access `instance.context`.
/// - `onDestroy`: Invoked when an instance is being destroyed. Called when removed from the tree.
/// - `onDispose`: It will only be invoked if you call dispose manually. Not used by the package.
///
/// **Default Behavior:**
/// By default, all interceptor methods return the original instance, allowing you to override only the methods needed.
///
/// ///
/// **Example Usage:**
///
/// ```dart
/// class CustomMiddleware extends FlutterDDIMiddleware {
///
///   @override
///   FutureOr<FlutterDDIModuleDefine> onGet(FlutterDDIModuleDefine instance) {
///     Navigator.of(instance.context).pop();
///
///     ScaffoldMessenger.of(instance.context).showSnackBar(
///      const SnackBar(
///         content: Text('You are not allowed to access this page'),
///         duration: Duration(seconds: 3),
///      ),
///     );
///
///     throw Exception('You are not allowed to access this page');
///   }
/// }
abstract class FlutterDDIMiddleware
    extends DDIInterceptor<FlutterDDIModuleDefine> {
  @nonVirtual
  @override
  FutureOr<void> onDispose(instance) {}

  @nonVirtual
  @override
  FutureOr<void> onDestroy(instance) {}
}
