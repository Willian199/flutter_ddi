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
      canPop: false,
      onPopInvokedWithResult: (pop, result) async {
        //final navigator = Navigator.of(context);
        if (pop && !ddi.isRegistered(qualifier: moduleQualifier)) {
          return;
        }

        try {
          await ddi.destroy(qualifier: moduleQualifier);

          onPopInvoked(true);

          if (context.mounted && !pop) {
            Navigator.pop(context, result);
          }
        } catch (e) {
          /// Ignore catch
        }
      },
      child: child,
    );
  }
}
