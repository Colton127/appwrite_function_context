///Full documentation: https://appwrite.io/docs/products/functions/develop#request
library;

///Wrapper around context to provide type safety and better developer experience.
///Every execution has a unique context that contains the request and response objects.
class ExecutionContext {
  final dynamic _context;
  const ExecutionContext(this._context);

  /// The request object containing details about the function invocation.
  ExecutionRequest get req => ExecutionRequest._(_context.req);

  /// The response object used to send data back from the function.
  ExecutionResponse get res => ExecutionResponse._(_context.res);

  /// The request headers associated with the function execution.
  RequestHeaders get headers => RequestHeaders._(_context.req.headers);

  /// Logs a message to the execution log.
  ///
  /// Accepts any loggable value; it is forwarded to the runtime as-is.
  void log(Object? message) => _context.log(message);

  /// Logs an error message to the execution log.
  ///
  /// Accepts any loggable value; it is forwarded to the runtime as-is.
  void error(Object? message) => _context.error(message);
}

/// A wrapper for the request object from the Appwrite function execution context (`context.req`).
///
/// This class provides convenient and type-safe access to the incoming HTTP request's properties.
class ExecutionRequest {
  final dynamic _req;
  const ExecutionRequest._(this._req);

  /// The raw request body as a string.
  ///
  /// This contains the raw data sent in the request body.
  String get bodyText => _req.bodyText;

  /// The parsed JSON request body.
  ///
  /// Throws a [FormatException] if the body is not valid JSON. Check
  /// [bodyText] first, or catch the exception, if the body may not be JSON.
  dynamic get bodyJson => _req.bodyJson;

  /// Returns the raw binary body of the request.
  List<int> get bodyBinary => _req.bodyBinary;

  /// Raw request headers map (lowercased keys).
  Map<String, dynamic> get headers => _req.headers;

  /// The request headers as a [RequestHeaders] object.
  RequestHeaders get requestHeaders => RequestHeaders._(_req.headers);

  /// The scheme of the request, such as 'http' or 'https'.
  ///
  /// This value is derived from the 'x-forwarded-proto' header.
  String get scheme => _req.scheme;

  /// The HTTP method of the request.
  ///
  /// Examples include 'GET', 'POST', 'PUT', 'DELETE', 'PATCH'.
  String get method => _req.method;

  /// The full URL of the request.
  ///
  /// For example: 'http://awesome.appwrite.io:8000/v1/hooks?limit=12&offset=50'
  String get url => _req.url;

  /// The hostname from the 'host' header.
  ///
  /// For example: 'awesome.appwrite.io'
  String get host => _req.host;

  /// The port from the 'host' header.
  int get port => _req.port;

  /// The path part of the URL.
  ///
  /// For example: '/v1/hooks'
  String get path => _req.path;

  /// The raw query parameters string.
  ///
  /// For example: "limit=12&offset=50"
  String get queryString => _req.queryString;

  /// The parsed query parameters.
  ///
  /// For example, to access the 'limit' parameter from the URL `/v1/hooks?limit=12`, you would use `query['limit']`.
  Map<String, String> get query => _req.query;
}

/// A wrapper for the response object from the Appwrite function execution context (`context.res`).
///
/// This class provides convenient helpers for building HTTP responses.
class ExecutionResponse {
  final dynamic _res;
  const ExecutionResponse._(this._res);

  /// Sends a response with a code 204 No Content status.
  dynamic empty() {
    return _res.empty();
  }

  /// Converts [json] into a JSON string and sets the content-type header to
  /// `application/json` with [statusCode] and any additional [headers].
  dynamic json(
    Map<String, dynamic> json, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    return _res.json(json, statusCode, headers);
  }

  /// Packages binary [bytes] into a response with [statusCode] and [headers].
  dynamic binary(
    List<int> bytes, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    return _res.binary(bytes, statusCode, headers);
  }

  /// Redirects the client to the specified [url] with [statusCode].
  dynamic redirect(
    String url, [
    int statusCode = 301,
    Map<String, dynamic> headers = const {},
  ]) {
    return _res.redirect(url, statusCode, headers);
  }

  /// Sends an HTML response with the content-type header set to `text/html`
  /// with [statusCode]. Any caller-provided [headers] are preserved, and
  /// `content-type` is set unless already present.
  dynamic html(
    String html, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    return text(html, statusCode, {
      ...headers,
      'content-type': 'text/html',
    });
  }

  /// Converts [text] using UTF-8 encoding into a binary buffer and sends it
  /// with [statusCode] and [headers].
  dynamic text(
    String text, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    return _res.text(text, statusCode, headers);
  }

  /// Sends a success response with an optional [message], [statusCode], and
  /// [headers].
  dynamic success({
    String message = '',
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  }) {
    return text(message, statusCode, headers);
  }

  /// Sends an error response with an optional [message], [statusCode], and
  /// [headers].
  dynamic error({
    String message = '',
    int statusCode = 500,
    Map<String, dynamic> headers = const {},
  }) {
    return text(message, statusCode, headers);
  }
}

/// Execution Request headers
///
/// All keys are lowercase.
class RequestHeaders {
  final Map<String, dynamic> _headers;
  const RequestHeaders._(this._headers);

  /// Describes how the function execution was invoked.
  ///
  /// Possible values are `http`, `schedule`, or `event`. Kept as a [String],
  /// rather than an enum, so future trigger types don't break at runtime.
  String get trigger => _headers['x-appwrite-trigger'];

  /// If the function execution was triggered by an event, this describes the
  /// triggering event. `null` for other trigger types.
  String? get event => _headers['x-appwrite-event'];

  /// The dynamic API key used for server authentication.
  /// https://appwrite.io/docs/products/functions/develop#dynamic-api-key
  String? get key => _headers['x-appwrite-key'];

  /// If the function execution was invoked by an authenticated user, this is the user's ID.
  ///
  /// This will be `null` for executions triggered by the Appwrite Console or API keys.
  String? get userId => _headers['x-appwrite-user-id'];

  /// The JWT token generated from the invoking user's session.
  ///
  /// This is used to authenticate Server SDKs to respect user access permissions.
  String? get userJwt => _headers['x-appwrite-user-jwt'];

  /// The country code of the configured locale.
  String? get countryCode => _headers['x-appwrite-country-code'];

  /// The continent code of the configured locale.
  String? get continentCode => _headers['x-appwrite-continent-code'];

  /// Describes if the configured locale is within the EU.
  ///
  /// The value will be a string, such as 'true' or 'false'.
  String? get continentEu => _headers['x-appwrite-continent-eu'];

  /// The IP address of the client that triggered the execution.
  String? get clientIp => _headers['x-appwrite-client-ip'];

  /// The unique ID of the current function execution.
  String get executionId => _headers['x-appwrite-execution-id'];

  /// Returns the header value for [key], asserting it is of type [T].
  ///
  /// Throws an [Exception] if the header is missing, or if it is present but
  /// not of type [T].
  T requireValue<T>(String key) {
    if (!_headers.containsKey(key)) {
      throw Exception('Header "$key" is not present.');
    }
    final value = _headers[key];
    if (value is! T) {
      throw Exception(
        'Expected header "$key" to be of type $T but got ${value.runtimeType}.',
      );
    }
    return value;
  }

  Object? operator [](String key) => _headers[key];
  Iterable<String> get keys => _headers.keys;
  Iterable<Object?> get values => _headers.values;
  Iterable<MapEntry<String, Object?>> get entries => _headers.entries;
  bool containsKey(String key) => _headers.containsKey(key);
  int get length => _headers.length;
  void forEach(void Function(String key, Object? value) action) =>
      _headers.forEach(action);
}
