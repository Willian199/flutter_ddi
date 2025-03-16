import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Extension method to simplify retrieving dependencies using DDI.
extension FlutterDDIContext on BuildContext {
  /// Extension method to simplify retrieving data from the current route.
  /// @param [RouteArgumentT] The type of the data to retrieve.
  RouteArgumentT? arguments<RouteArgumentT>() {
    return ModalRoute.of(this)?.settings.arguments as RouteArgumentT?;
  }

  /// Retrieves an instance of the registered class from [DDI].
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances
  ///    of the same type.
  ///
  /// This is a standard method to retrieve instances using type inference.
  /// If multiple instances of the same type exist, the qualifier can be used to
  /// retrieve the correct instance.
  BeanT get<BeanT extends Object>([Object? qualifier]) {
    return ddi.get<BeanT>(qualifier: qualifier);
  }

  /// Retrieves an instance of the registered class asynchronously.
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances.
  ///
  /// This method is particularly useful when instance creation involves asynchronous operations.
  Future<BeanT> getAsync<BeanT extends Object>([Object? qualifier]) {
    return ddi.getAsync<BeanT>(qualifier: qualifier);
  }

  /// Optionally retrieves an instance of the registered class.
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances.
  ///
  /// This method checks if the class is registered before retrieving the instance.
  BeanT? getOptional<BeanT extends Object>([Object? qualifier]) {
    return ddi.getOptional<BeanT>(qualifier: qualifier);
  }

  /// Optionally retrieves an instance with a parameter of the registered class.
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances.
  /// - `parameter`: (Optional) Parameter to pass during instance creation.
  ///
  /// This method allows optional retrieval of instances with parameters.
  BeanT? getOptionalWith<BeanT extends Object, ParameterT extends Object>({
    ParameterT? parameter,
    Object? qualifier,
  }) {
    return ddi.getOptionalWith<BeanT, ParameterT>(
        qualifier: qualifier, parameter: parameter);
  }

  /// Asynchronously retrieves an optional instance of the registered class.
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances.
  ///
  /// This method performs an asynchronous retrieval if the instance is registered.
  Future<BeanT?> getOptionalAsync<BeanT extends Object>([Object? qualifier]) {
    return ddi.getOptionalAsync<BeanT>(qualifier: qualifier);
  }

  /// Asynchronously retrieves an optional instance with a parameter.
  ///
  /// - `qualifier`: (Optional) Qualifier to distinguish between different instances.
  /// - `parameter`: (Optional) Parameter to pass during instance creation.
  ///
  /// This method supports asynchronous retrieval with a parameter.
  Future<BeanT?>
      getOptionalWithAsync<BeanT extends Object, ParameterT extends Object>({
    ParameterT? parameter,
    Object? qualifier,
  }) {
    return ddi.getOptionalAsyncWith<BeanT, ParameterT>(
        qualifier: qualifier, parameter: parameter);
  }
}
