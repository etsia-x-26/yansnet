/// Thrown if an exception occurs while making an `http` request.
class HttpException implements Exception {
  const HttpException(this.message);

  final String? message;
}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode, this.message);

  /// The status code of the response.
  final int statusCode;
  final String? message;
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}