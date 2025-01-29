/// [MiddlewareBlockedException] is an exception that is thrown when the [Middleware] fails to Enter.
class MiddlewareBlockedException implements Exception {
  const MiddlewareBlockedException(this.reason);
  final String reason;

  @override
  String toString() {
    return 'The Middleware not allowed to acces. Reason: $reason.';
  }
}
