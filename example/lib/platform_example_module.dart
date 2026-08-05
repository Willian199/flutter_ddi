import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

abstract interface class ExamplePlatformService {
  String get platform;
}

final class AndroidExamplePlatformService implements ExamplePlatformService {
  @override
  String get platform => 'AndroidExamplePlatformService';
}

final class IosExamplePlatformService implements ExamplePlatformService {
  @override
  String get platform => 'IosExamplePlatformService';
}

final class WebExamplePlatformService implements ExamplePlatformService {
  @override
  String get platform => 'WebExamplePlatformService';
}

final class FallbackExamplePlatformService implements ExamplePlatformService {
  @override
  String get platform => 'FallbackExamplePlatformService';
}

class ExamplePlatformModule with DDIModule, DDIPlatformModule {
  @override
  Future<void> onAndroid() async {
    await singleton<ExamplePlatformService>(AndroidExamplePlatformService.new);
    debugPrint('DDI platform registration: Android');
  }

  @override
  Future<void> onIos() async {
    await singleton<ExamplePlatformService>(IosExamplePlatformService.new);
    debugPrint('DDI platform registration: iOS');
  }

  @override
  Future<void> onWeb() async {
    await singleton<ExamplePlatformService>(WebExamplePlatformService.new);
    debugPrint('DDI platform registration: Web');
  }
}
