import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Class responsible for generating routes from modules.
/// This class generates routes based on modules for the Flutter app.
///
final class FlutterDDIRouter {
  /// Get routes from a list of modules.
  /// This method creates routes based on the provided list of modules.
  /// @param [List<FlutterDDIModuleDefine>] The list of modules to generate routes from.
  /// @return [Map<String, WidgetBuilder>] The generated routes.
  ///
  static Map<String, WidgetBuilder> getRoutes(
      {required List<FlutterDDIModuleDefine> modules}) {
    return Map.fromEntries(
        modules.expand((module) => _buildModules(module).entries));
  }

  static Map<String, WidgetBuilder> _buildModules(FlutterDDIModuleDefine module,
      [String? extraPath]) {
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
