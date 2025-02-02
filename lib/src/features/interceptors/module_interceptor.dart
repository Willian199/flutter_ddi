import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class ModuleInterceptor<InterceptorT extends FlutterDDIInterceptor> {
  /// Use to register a new Interceptor.
  factory ModuleInterceptor.of({
    required ScopeFactory<InterceptorT> factory,
    Object? qualifier,
    FutureOr<bool> Function()? canRegister,
  }) {
    return ModuleInterceptor._(
      qualifier: qualifier ?? factory.type,
      factory: factory,
      canRegister: canRegister,
      isFactory: true,
    );
  }

  /// Use to reuse a Interceptor already registered.
  factory ModuleInterceptor.from({Object? qualifier}) {
    return ModuleInterceptor._(
      qualifier: qualifier ?? InterceptorT,
      isFactory: false,
    );
  }

  ModuleInterceptor._({
    required this.qualifier,
    required this.isFactory,
    this.factory,
    this.canRegister,
  });

  /// The type of the Interceptor.
  final Object qualifier;
  final ScopeFactory<InterceptorT>? factory;
  final FutureOr<bool> Function()? canRegister;
  final bool isFactory;

  /// Registers the interceptor asynchronously.
  ///
  /// If the interceptor is a factory, it will be registered with the provided
  /// factory method, qualifier, and conditional registration function.
  ///
  /// Returns the qualifier of the registered interceptor if provided, otherwise
  /// returns the type of the interceptor.
  @nonVirtual
  Future<Object> register() async {
    if (isFactory) {
      await ddi.register(
        factory: factory!,
        qualifier: qualifier,
        canRegister: canRegister,
      );
    }

    return qualifier;
  }

  /// Destroys the interceptor from the container.
  ///
  /// This method should be used when you want to remove the interceptor from the container.
  /// This is useful when you want to remove a interceptor from the container after it has been used.
  /// If [isFactory] is false, this method does nothing.
  @nonVirtual
  Future<void> destroy() async {
    if (isFactory) {
      ddi.destroy(qualifier: qualifier);
    }
  }
}
