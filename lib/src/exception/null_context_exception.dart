/// [NullContextException] is an exception that is thrown because the context is null
class NullContextException implements Exception {
  const NullContextException(this.type);
  final String type;

  @override
  String toString() {
    return 'The context of $type is null. Verify your code or fill a issue on github.';
  }
}
