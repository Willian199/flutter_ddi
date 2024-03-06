import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/src/modules/flutter_ddi_modules_define.dart';
import 'package:flutter_ddi/src/wigets/flutter_ddi_module_loader.dart';

final class FlutterDDIRouter {
  static Map<String, WidgetBuilder> getRoutes({required List<FlutterDDIModuleDefine> modules}) {
    return Map.fromEntries(
      modules.map(
        (module) => MapEntry(
          module.path,
          (_) => switch (module) {
            (final FlutterDDIModule m) => FlutterDDIModuleLoader(module: m, page: module.page),
            (final FlutterDDIPage m) => m.page,
          },
        ),
      ),
    );
  }
}
