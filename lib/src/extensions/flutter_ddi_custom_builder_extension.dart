import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/src/factories/widget_factory.dart';

/// Extension for [CustomBuilder] that adds Widget Scope support.
extension FlutterDDICustomBuilderExtension<BeanT extends Widget>
    on CustomBuilder<BeanT> {
  /// Registers an instance as a Widget Scope.
  ///
  /// The Widget Scope creates a new instance every time it is requested,
  /// making it ideal for use in Widgets that need clean instances on each build.
  ///
  /// **Characteristics:**
  /// - Creates a new instance every time it is requested
  /// - Does not reuse instances and provides a fresh instance for each request
  /// - Does not support Interceptors
  /// - Does not support Decorators
  /// - Does not support Children (child modules)
  /// - Supports PostConstruct for initialization after creation
  ///
  /// **Note:** `PreDispose` and `PreDestroy` are not supported in this scope.
  /// This scope does not maintain state, so instances are created and discarded automatically.
  /// Since instances are not cached, there is no need to dispose of them.
  ///
  /// - `qualifier`: Optional qualifier name to distinguish between different instances of the same type.
  /// - `canRegister`: Optional function to conditionally register the instance.
  /// - `canDestroy`: Optional parameter to make the instance indestructible. Defaults to `true`.
  /// - `selector`: Optional function that allows conditional selection of instances based on specific criteria.
  ///
  ///   Useful for dynamically choosing an instance at runtime based on application context.
  ///
  Future<void> asWidget({
    FutureOr<bool> Function(Object)? selector,
    Object? qualifier,
    FutureOr<bool> Function()? canRegister,
    bool canDestroy = true,
  }) {
    return ddi.register<BeanT>(
      factory: WidgetFactory<BeanT>(
        builder: this,
        selector: selector,
        canDestroy: canDestroy,
      ),
      qualifier: qualifier,
      canRegister: canRegister,
    );
  }
}
