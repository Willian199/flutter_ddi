import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Class responsible for generating routes from modules.
/// This class generates routes based on modules for the Flutter app.
///
extension FlutterDDIRouterExtension on FlutterDDIRouter {
  /// Builds a map of routes from a module definition.
  /// The method processes all types of modules, including nested and future-loaded modules.
  ///
  /// - `FlutterDDIPage`: Simple page with a direct WidgetBuilder.
  /// - `FlutterDDIRouter`: Supports nested modules.
  /// - `FlutterDDIModuleRouter`: Loads a module with dependencies.

  Map<String, WidgetBuilder> getRoutes() {
    return Map.fromEntries(_buildModules(this).entries);
  }

  Map<String, WidgetBuilder> getModules() {
    return Map.fromEntries(modules.expand((sub) => _buildModules(sub).entries));
  }

  static Map<String, WidgetBuilder>
      _buildModules<T extends FlutterDDIModuleDefine>(T module,
          [String? extraPath]) {
    assert(module.path.isNotEmpty, 'Module path cannot be empty');
    String path = module.path;

    if (extraPath?.isNotEmpty ?? false) {
      path = '$extraPath$path';
    }

    path = path.replaceAll('//', '/');

    return switch (module) {
      final FlutterDDIOutletModule m => {
          path: (_) => FlutterDDIOutletLoader(module: m),
        },
      final FlutterDDIRouter m => {
          path: (_) => FlutterDDIRouterLoader(module: m),
          ...Map.fromEntries(
              m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
      final FlutterDDIPage m => {
          path: (_) => FlutterDDIRouterLoader(module: m),
        },
    };
  }
}
