import 'package:dart_ddi/dart_ddi.dart';
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
    required this.moduleQualifier,
    required this.onPopInvoked,
    super.key,
  });

  /// The child widget to wrap.
  final Widget child;

  /// The qualifier of the module to destroy.
  final Object moduleQualifier;

  /// Callback when pop is invoked.
  final void Function(bool isDestroyed) onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) async {
        final navigator = Navigator.of(context);
        if (!navigator.canPop() ||
            pop && !ddi.isRegistered(qualifier: moduleQualifier)) {
          return;
        }

        try {
          await ddi.destroy(qualifier: moduleQualifier);

          onPopInvoked(true);

          if (context.mounted && !pop) {
            navigator.pop(result);
          }
        } catch (e) {
          // Log error but don't throw to prevent app crashes
          debugPrint('Error destroying module $moduleQualifier: $e');
        }
      },
      child: child,
    );
  }
}
