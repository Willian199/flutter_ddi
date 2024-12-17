import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_future_module_loader.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_module_loader.dart';

/// Class responsible for generating routes from modules.
/// This class generates routes based on modules for the Flutter app.
///
final class FlutterDDIRouter {
  /// Builds a map of routes from a module definition.
  /// The method processes all types of modules, including nested and future-loaded modules.
  ///
  /// - `FlutterDDIPage`: Simple page with a direct WidgetBuilder.
  /// - `FlutterDDIModule`: Loads a module with dependencies.
  /// - `FlutterDDIModuleRouter`: Supports nested modules.
  /// - `FlutterDDIFutureModuleRouter`: Supports future-loaded modules for lazy initialization.

  static Map<String, WidgetBuilder> getRoutes(
      {required List<FlutterDDIModuleDefine> modules}) {
    return Map.fromEntries(
        modules.expand((module) => _buildModules(module).entries));
  }

  static Map<String, WidgetBuilder> _buildModules(FlutterDDIModuleDefine module,
      [String? extraPath]) {
    assert(module.path.isNotEmpty, 'Module path cannot be empty');
    String path = module.path;

    if (extraPath?.isNotEmpty ?? false) {
      path = '$extraPath$path';
    }

    path = path.replaceAll('//', '/');

    return switch (module) {
      (final FlutterDDIPage m) => {path: m.page},
      (final FlutterDDIModule m) => {
          path: (_) => FlutterDDIModuleLoader(module: m, page: module.page)
        },
      (final FlutterDDIModuleRouter m) when m is DDIModule => {
          path: (_) =>
              FlutterDDIModuleLoader(module: m as DDIModule, page: module.page),
          ...Map.fromEntries(
              m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
      (final FlutterDDIModuleRouter m) => {
          path: m.page,
          ...Map.fromEntries(
              m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
      (final FlutterDDIFutureModuleRouter m) => {
          path: (_) => FlutterDDIFutureModuleLoader(module: m),
          ...Map.fromEntries(
              m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
    };
  }
}
