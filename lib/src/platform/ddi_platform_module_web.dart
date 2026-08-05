import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/foundation.dart';

/// Platform-aware registration module for Web builds.
///
/// The platform values are deliberately fixed to Web-compatible values. This
/// file does not import `dart:io`, so it remains valid for Web compilation.
mixin DDIPlatformModule on DDIModule {
  FutureOr<void> onAndroid() {}

  FutureOr<void> onIos() {}

  FutureOr<void> onLinux() {}

  FutureOr<void> onMacOs() {}

  FutureOr<void> onWindows() {}

  FutureOr<void> onFuchsia() {}

  FutureOr<void> onWeb() {}

  @override
  @mustCallSuper
  FutureOr<void> onPostConstruct() => onWeb();
}
