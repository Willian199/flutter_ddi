import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/material.dart';

class CustomPopScope extends StatelessWidget {
  const CustomPopScope({required this.child, required this.moduleQualifier});
  final Widget child;
  final Object moduleQualifier;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) async {
        final navigator = Navigator.of(context);

        if (pop && navigator.canPop()) {
          await ddi.destroy(qualifier: moduleQualifier);
        }
      },
      child: child,
    );
  }
}
