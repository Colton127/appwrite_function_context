///Full documentation: https://appwrite.io/docs/products/functions/develop#request
library;

import 'dart:typed_data';

// ignore_for_file: unused_local_variable

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
  void log(String message) => _context.log(message);

  /// Logs an error message to the execution log.
  void error(String message) => _context.error(message);
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
  /// This will be an object if the request body was valid JSON, otherwise it will be a string.
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
  Map<String, dynamic> get query => _req.query;
}

class ExecutionResponse {
  final dynamic _res;
  const ExecutionResponse._(this._res);

  ///Sends a response with a code 204 No Content status.
  dynamic empty() {
    return _res.empty();
  }

  /// Converts the data into a JSON string and sets the content-type header to [application/json] with [statusCode].
  dynamic json(final Map<String, dynamic> json, [int statusCode = 200]) {
    return _res.json(json, statusCode);
  }

  ///Packages binary bytes, the status code, and the headers into an object with [statusCode].
  dynamic binary(Uint8List content, [int statusCode = 200]) {
    return _res.binary(content, statusCode);
  }

  ///Redirects the client to the specified URL link with [statusCode].
  dynamic redirect(String url, [int statusCode = 301]) {
    return _res.redirect(url, statusCode);
  }

  /// Sends an HTML response with the content-type header set to [text/html] with [statusCode].
  dynamic html(String html, [int statusCode = 200]) {
    return _res.text(html, statusCode, {'content-type': 'text/html'});
  }

  ///Converts the body using UTF-8 encoding into a binary Buffer and sends it with [statusCode].
  dynamic text(String text, [int statusCode = 200]) {
    return _res.text(text, statusCode);
  }

  /// Sends a success response with an optional message and [statusCode].
  dynamic success({String message = '', int statusCode = 200}) {
    return _res.text(message, statusCode);
  }

  /// Sends an error response with an optional message and [statusCode].
  dynamic error({String message = '', int statusCode = 500}) {
    return _res.text(message, statusCode);
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
  /// Possible values are `http`, `schedule`, or `event`.
  String get trigger => _headers['x-appwrite-trigger'];

  /// If the function execution was triggered by an event, this describes the triggering event.
  dynamic get event => _headers['x-appwrite-event'];

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

  T requireValue<T>(String key) {
    final value = _headers[key];
    if (value is! T) {
      throw Exception(
          'Expected header "$key" to be of type $T but got ${value.runtimeType}');
    }
    return value;
  }

  operator [](String key) => _headers[key];
  Iterable<String> get keys => _headers.keys;
  Iterable<dynamic> get values => _headers.values;
  Iterable<MapEntry<String, dynamic>> get entries => _headers.entries;
  bool containsKey(String key) => _headers.containsKey(key);
  int get length => _headers.length;
  forEach(void Function(String key, dynamic value) action) =>
      _headers.forEach(action);
}
