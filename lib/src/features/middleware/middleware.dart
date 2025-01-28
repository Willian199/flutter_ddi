import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class Middleware<MiddlewareT extends FlutterDDIMiddleware> {
  /// Use to register a new Middleware.
  factory Middleware.of({
    required ScopeFactory<MiddlewareT> factory,
    Object? qualifier,
    FutureOr<bool> Function()? canRegister,
  }) {
    return Middleware._(
      qualifier: qualifier ?? factory.type,
      factory: factory,
      canRegister: canRegister,
      isFactory: true,
    );
  }

  /// Use to reuse a Middleware already registered.
  factory Middleware.from({Object? qualifier}) {
    return Middleware._(
      qualifier: qualifier ?? MiddlewareT,
      isFactory: false,
    );
  }

  Middleware._({
    required this.qualifier,
    required this.isFactory,
    this.factory,
    this.canRegister,
  });

  /// The type of the Middleware.
  final Object qualifier;
  final ScopeFactory<MiddlewareT>? factory;
  final FutureOr<bool> Function()? canRegister;
  final bool isFactory;

  /// Registers the middleware asynchronously.
  ///
  /// If the middleware is a factory, it will be registered with the provided
  /// factory method, qualifier, and conditional registration function.
  ///
  /// Returns the qualifier of the registered middleware if provided, otherwise
  /// returns the type of the middleware.
  @nonVirtual
  Future<Object> register() async {
    if (isFactory) {
      await ddi.register(
          factory: factory!, qualifier: qualifier, canRegister: canRegister);
    }

    return qualifier;
  }

  /// Destroys the middleware from the container.
  ///
  /// This method should be used when you want to remove the middleware from the container.
  /// This is useful when you want to remove a middleware from the container after it has been used.
  /// If [isFactory] is false, this method does nothing.
  @nonVirtual
  Future<void> destroy() async {
    if (isFactory) {
      await ddi.destroy(qualifier: qualifier);
    }
  }
}
