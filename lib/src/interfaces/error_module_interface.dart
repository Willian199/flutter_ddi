import 'package:flutter/widgets.dart';

/// Use this interface to create a default widget to show when a module fails.
abstract class ErrorModuleInterface extends StatelessWidget {
  const ErrorModuleInterface(this.snapshot);
  final AsyncSnapshot snapshot;
}
