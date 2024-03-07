import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class FlutterDDIRouter {
  static Map<String, WidgetBuilder> getRoutes({required List<FlutterDDIModuleDefine> modules}) {
    return Map.fromEntries(modules.expand((module) => _buildModules(module).entries));
  }

  static Map<String, WidgetBuilder> _buildModules(FlutterDDIModuleDefine module, [String? extraPath]) {
    String path = module.path;

    if (extraPath?.isNotEmpty ?? false) {
      path = '$extraPath$path';
    }

    return switch (module) {
      (final FlutterDDIPage m) => {path: m.page},
      (final FlutterDDIModule m) => {path: (_) => FlutterDDIModuleLoader(module: m, page: module.page)},
      (final FlutterDDIModuleRouter m) when m is DDIModule => {
          path: (_) => FlutterDDIModuleLoader(module: m as DDIModule, page: module.page),
          ...Map.fromEntries(m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
      (final FlutterDDIModuleRouter m) => {
          path: m.page,
          ...Map.fromEntries(m.modules.expand((sub) => _buildModules(sub, path).entries)),
        },
    };
  }
}
