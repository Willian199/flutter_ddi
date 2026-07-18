import 'package:flutter/material.dart';

/// Custom PopScope widget that handles module destruction when navigating back.
/// This widget ensures proper cleanup of DDI modules when the user navigates away.
class CustomPopScope extends StatefulWidget {
  /// Creates a CustomPopScope widget.
  ///
  /// [child] - The child widget to wrap.
  /// [onPopInvoked] - Callback invoked when the route is popped.
  const CustomPopScope({
    required this.child,
    required this.onPopInvoked,
    super.key,
  });

  /// The child widget to wrap.
  final Widget child;

  /// Callback when pop is invoked.
  final Future<void> Function() onPopInvoked;

  @override
  State<CustomPopScope> createState() => _CustomPopScopeState();
}

class _CustomPopScopeState extends State<CustomPopScope> {
  bool _skipNextSuccessfulPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        try {
          if (didPop) {
            if (_skipNextSuccessfulPop) {
              _skipNextSuccessfulPop = false;
              return;
            }

            await widget.onPopInvoked();
            return;
          }

          final nav = Navigator.of(context);

          if (!nav.canPop()) {
            return;
          }

          await widget.onPopInvoked();

          _skipNextSuccessfulPop = true;
          nav.pop(result);
        } catch (e) {
          // Log error but don't throw to prevent app crashes
          debugPrint(
            '[CustomPopScope ${identityHashCode(this)}] error destroying module: $e',
          );
        }
      },
      child: widget.child,
    );
  }
}
