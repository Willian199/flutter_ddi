import 'dart:async';
import 'dart:io' show Platform;

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

/// Platform-aware registration module for Dart IO builds.
///
/// `Platform.isAndroid` and `Platform.isIOS` are already annotated with
/// `vm:platform-const` by the Dart SDK. Keeping the checks directly in this
/// method gives the AOT compiler the best opportunity to remove unreachable
/// platform branches.
mixin DDIPlatformModule on DDIModule {
  FutureOr<void> onAndroid() {}

  FutureOr<void> onIos() {}

  FutureOr<void> onLinux() {}

  FutureOr<void> onMacOs() {}

  FutureOr<void> onWindows() {}

  FutureOr<void> onFuchsia() {}

  FutureOr<void> onWeb() {}

  /// Registers the implementation for the current IO platform.
  Future<void> _registerPlatform() async {
    if (Platform.isAndroid) {
      await onAndroid();
      return;
    }

    if (Platform.isIOS) {
      await onIos();
      return;
    }

    if (Platform.isLinux) {
      await onLinux();
      return;
    }

    if (Platform.isMacOS) {
      await onMacOs();
      return;
    }

    if (Platform.isWindows) {
      await onWindows();
      return;
    }

    if (Platform.isFuchsia) {
      await onFuchsia();
      return;
    }
  }

  @override
  @mustCallSuper
  FutureOr<void> onPostConstruct() => _registerPlatform();
}
