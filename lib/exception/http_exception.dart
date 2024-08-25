class ServerException implements Exception {
  final String message;
  final int statusCode;

  @pragma("vm:entry-point")
  ServerException(
    this.message,
    this.statusCode,
  );

  @override
  String toString() {
    Object? message = this.message;
    return "Message: $message / StatusCode: $statusCode";
  }
}
