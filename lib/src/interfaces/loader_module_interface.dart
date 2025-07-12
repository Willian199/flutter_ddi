import 'package:flutter/widgets.dart';

/// Interface for creating custom loading widgets to display while a module is being initialized.
///
/// Implement this interface to provide custom loading indicators for your modules.
/// This allows you to maintain consistent loading UI across your application.
abstract class LoaderModuleInterface extends StatelessWidget {
  /// Creates a LoaderModuleInterface.
  const LoaderModuleInterface();
}
