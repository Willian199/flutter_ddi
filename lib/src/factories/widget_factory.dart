import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

/// Creates a new instance every time it is requested, focused for use in Widgets.
///
/// This scope defines its behavior on the [getWith] or [getAsyncWith] methods.
///
/// It will do the following:
/// * Create the instance.
/// * Run the PostConstruct for the instance (if implemented).
///
/// **Characteristics:**
/// * Does not support Interceptors
/// * Does not support Decorators
/// * Does not support Children (child modules)
/// * Does not support PreDispose or PreDestroy
/// * Ideal for Widgets that need a clean instance on each build
///
/// **Note:** `PreDispose` and `PreDestroy` are not supported in this scope.
/// This scope does not maintain state, so instances are created and discarded automatically.
/// Since instances are not cached, there is no need to dispose of them.
///
/// **Use cases:**
/// - Widgets that need fresh instances on each build
/// - Stateless widgets that require dependency injection
/// - Simple widgets that don't need lifecycle management
///
///  Useful for dynamically choosing an instance at runtime based on application context.
///
class WidgetFactory<BeanT extends Widget> extends DDIBaseFactory<BeanT> {
  WidgetFactory({
    required CustomBuilder<FutureOr<BeanT>> builder,
    required bool canDestroy,
    super.selector,
  })  : _builder = builder,
        _canDestroy = canDestroy;

  /// The factory builder responsible for creating the Bean.
  final CustomBuilder<FutureOr<BeanT>> _builder;

  /// A flag that indicates whether the Bean can be destroyed after its usage.
  final bool _canDestroy;

  /// The current state of this factory in its lifecycle.
  BeanStateEnum _state = BeanStateEnum.none;

  @override
  BeanStateEnum get state => _state;

  /// Verifies if this factory creates Future instances.
  @override
  bool get isFuture => _builder.isFuture || BeanT is Future;

  /// Verifies if this factory is ready (Created).
  ///
  /// For WidgetFactory, always returns `false` because a new instance is created on each get.
  @override
  bool get isReady => false;

  @override
  bool get isRegistered => BeanStateEnum.registered == _state;

  /// Registers the instance in [DDI].
  @override
  Future<void> register({required Object qualifier}) async {
    _state = BeanStateEnum.registered;
  }

  /// Gets or creates this instance.
  ///
  /// - `qualifier`: Qualifier name to identify the object.
  /// - `parameter`: Optional parameter to pass during the instance creation.
  ///
  /// **Note:** The `parameter` will be ignored if the constructor doesn't match the parameter type.
  @override
  BeanT getWith<ParameterT extends Object>({
    required Object qualifier,
    ParameterT? parameter,
  }) {
    _checkState(qualifier);

    final BeanT widgetInstance = createInstance<BeanT, ParameterT>(
      builder: _builder,
      parameter: parameter,
    );

    // Run PostConstruct if implemented
    if (widgetInstance is PostConstruct) {
      (widgetInstance as PostConstruct).onPostConstruct();
    } else if (widgetInstance is Future<PostConstruct>) {
      (widgetInstance as Future<PostConstruct>).then(
        (PostConstruct postConstruct) => postConstruct.onPostConstruct(),
      );
    }

    return widgetInstance;
  }

  /// Creates this instance as Future.
  ///
  /// - `qualifier`: Qualifier name to identify the object.
  /// - `parameter`: Optional parameter to pass during the instance creation.
  @override
  Future<BeanT> getAsyncWith<ParameterT extends Object>({
    required Object qualifier,
    ParameterT? parameter,
  }) async {
    _checkState(qualifier);

    final BeanT widgetInstance = await createInstanceAsync<BeanT, ParameterT>(
      builder: _builder,
      parameter: parameter,
    );

    // Run PostConstruct if implemented
    if (widgetInstance is PostConstruct) {
      (widgetInstance as PostConstruct).onPostConstruct();
    } else if (widgetInstance is Future<PostConstruct>) {
      final PostConstruct postConstruct =
          await (widgetInstance as Future<PostConstruct>);

      await postConstruct.onPostConstruct();
    }

    return widgetInstance;
  }

  /// Removes the instance of the registered class in [DDI].
  ///
  /// - `apply`: Function to call after successful destruction.
  ///
  /// **Note:** For WidgetFactory, instances are not cached, so destruction only removes
  /// the factory registration if `canDestroy` is `true`.
  @override
  FutureOr<void> destroy(void Function() apply) {
    if (_canDestroy) {
      apply();
      _state = BeanStateEnum.destroyed;
    }
    return Future.value();
  }

  /// Disposes of the instance of the registered class in [DDI].
  ///
  /// **Note:** Since instances are not kept in reference, there is no need for disposal.
  /// Instances are created and discarded automatically on each get request.
  @override
  Future<void> dispose() {
    return Future.value();
  }

  void _checkState(Object qualifier) {
    if (_state == BeanStateEnum.beingDestroyed ||
        _state == BeanStateEnum.destroyed) {
      throw BeanDestroyedException(qualifier.toString());
    }
  }
}
