import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

class CustomPopScope extends StatelessWidget {
  const CustomPopScope({
    required this.child,
    required this.moduleQualifier,
    required this.onPopInvoked,
    super.key,
  });
  final Widget child;
  final Object moduleQualifier;
  final void Function(bool isDestroyed) onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) async {
        final navigator = Navigator.of(context);
        bool isDestroyed = false;
        if (pop && navigator.canPop()) {
          await ddi.destroy(qualifier: moduleQualifier);
          isDestroyed = true;
        }

        onPopInvoked(isDestroyed);
      },
      child: child,
    );
  }
}
