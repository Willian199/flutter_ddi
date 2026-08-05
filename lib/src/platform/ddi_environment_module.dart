import 'dart:async';

import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/foundation.dart';

/// A module whose registrations are selected by a compile-time boolean.
///
/// This is intended for values supplied with `--dart-define`, not for a
/// dotenv file read while the application is running. Keep the value passed
/// to the constructor compile-time constant so the Dart compiler can remove
/// the disabled branch from the resulting application.
///
/// Example:
///
/// ```dart
/// class AnalyticsModule extends DDIEnvironmentModule {
///   AnalyticsModule()
///       : super(enabled: const bool.fromEnvironment('ENABLE_ANALYTICS'));
///
///   @override
///   Future<void> onEnabled() => singleton<Analytics>(Analytics.new);
/// }
/// ```
///
/// Build with:
///
/// ```shell
/// flutter build apk --dart-define=ENABLE_ANALYTICS=true
/// ```
abstract class DDIEnvironmentModule with DDIModule {
  /// Creates an environment-controlled module.
  DDIEnvironmentModule({required this.enabled});

  /// The compile-time value that selects this module's registrations.
  final bool enabled;

  /// Called when [enabled] is `true`.
  FutureOr<void> onEnabled() {}

  /// Called when [enabled] is `false`.
  FutureOr<void> onDisabled() {}

  @override
  @mustCallSuper
  Future<void> onPostConstruct() async {
    if (enabled) {
      await onEnabled();
      return;
    }

    await onDisabled();
  }
}
