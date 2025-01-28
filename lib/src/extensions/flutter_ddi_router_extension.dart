import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_module_loader.dart';

/// Class responsible for generating routes from modules.
/// This class generates routes based on modules for the Flutter app.
///
extension FlutterDDIRouterExtension on FlutterDDIRouter {
  /// Builds a map of routes from a module definition.
  /// The method processes all types of modules, including nested and future-loaded modules.
  ///
  /// - `FlutterDDIPage`: Simple page with a direct WidgetBuilder.
  /// - `FlutterDDIRouter`: Loads a module with dependencies.
  /// - `FlutterDDIModule`: Supports nested modules.
  /// - `FlutterDDIFutureModuleRouter`: Supports future-loaded modules for lazy initialization.

  Map<String, WidgetBuilder> getRoutes() {
    return Map.fromEntries(_buildModules(this).entries);
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
      final FlutterDDIRouter m => {
          path: (_) => FlutterDDIRouterLoader(module: m),
          ...Map.fromEntries(
              m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
      final FlutterDDIPage m => {
          path: (_) => FlutterDDIBuilder(
                module: () => m,
                child: m.page,
                middlewares: m.middlewares,
                moduleName: m.moduleQualifier,
              ),
        },
    };
  }
}
