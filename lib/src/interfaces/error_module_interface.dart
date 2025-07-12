import 'package:flutter/widgets.dart';

/// Interface for creating custom error widgets to display when a module fails to load.
///
/// Implement this interface to provide custom error handling for your modules.
/// The [snapshot] parameter contains the error information from the failed operation.
abstract class ErrorModuleInterface extends StatelessWidget {
  /// Creates an ErrorModuleInterface with the given snapshot.
  ///
  /// [snapshot] - The AsyncSnapshot containing error information.
  const ErrorModuleInterface(this.snapshot);

  /// The snapshot containing error information from the failed operation.
  final AsyncSnapshot snapshot;
}
