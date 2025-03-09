/// [InterceptorBlockedException] is an exception that is thrown when the [Interceptor] fails to Enter.
class InterceptorBlockedException implements Exception {
  const InterceptorBlockedException(this.reason);
  final String reason;

  @override
  String toString() {
    return 'The Interceptor not allowed to acces. Reason: $reason.';
  }
}
