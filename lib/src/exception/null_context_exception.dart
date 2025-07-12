/// Exception thrown when a module's context is null when it should be available.
///
/// This exception is thrown when trying to access the context of a module
/// that hasn't been properly initialized or has been disposed.
class NullContextException implements Exception {
  /// Creates a NullContextException with the given module type.
  ///
  /// [type] - The type or name of the module that has a null context.
  const NullContextException(this.type);

  /// The type or name of the module that has a null context.
  final String type;

  @override
  String toString() {
    return 'The context of $type is null. Verify your code or file an issue on GitHub.';
  }
}
