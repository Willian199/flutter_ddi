import 'package:flutter/material.dart';

/// Custom PopScope widget that handles module destruction when navigating back.
/// This widget ensures proper cleanup of DDI modules when the user navigates away.
class CustomPopScope extends StatelessWidget {
  /// Creates a CustomPopScope widget.
  ///
  /// [child] - The child widget to wrap.
  /// [moduleQualifier] - The qualifier of the module to destroy.
  /// [onPopInvoked] - Callback when pop is invoked.
  const CustomPopScope({
    required this.child,
    required this.onPopInvoked,
    super.key,
  });

  /// The child widget to wrap.
  final Widget child;

  /// Callback when pop is invoked.
  final Future<void> Function(bool isDestroyed) onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) async {
        try {
          await onPopInvoked(true);
        } catch (e) {
          // Log error but don't throw to prevent app crashes
          debugPrint('Error destroying module: $e');
        }
      },
      child: child,
    );
  }
}
