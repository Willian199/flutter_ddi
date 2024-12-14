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
      onPopInvokedWithResult: (pop, _) async {
        //final navigator = Navigator.of(context);
        bool isDestroyed = false;
        //Naviagotor.canPop() seems to be broken. It returns false, even if there is a route to pop .
        if (pop /*&& navigator.canPop()*/) {
          await ddi.destroy(qualifier: moduleQualifier);
          isDestroyed = true;
        }

        onPopInvoked(isDestroyed);
      },
      child: child,
    );
  }
}
