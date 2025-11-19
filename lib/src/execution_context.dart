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

  /// The headers associated with the function execution.
  ExecutionHeaders get headers => ExecutionHeaders._(_context.req.headers);

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

  /// Key-value pairs of all request headers.
  ///
  /// The keys for the headers are in lowercase.
  Map<String, dynamic> get headers => _req.headers;

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

  dynamic empty() {
    return _res.empty();
  }

  dynamic json(final Map<String, dynamic> json) {
    return _res.json(json);
  }

  dynamic binary(Uint8List content) {
    return _res.binary(content);
  }

  dynamic redirect(String url) {
    return _res.redirect(url, 301);
  }

  dynamic html(String html) {
    return _res.text(html, 200, {'content-type': 'text/html'});
  }

  dynamic text(String text) {
    return _res.text(text);
  }

  dynamic success([String message = '']) {
    return _res.text(message, 200);
  }

  dynamic error([String message = '']) {
    return _res.text(message, 500);
  }
}

class ExecutionHeaders {
  final Map<String, dynamic> headers;
  const ExecutionHeaders._(this.headers);

  operator [](String key) => headers[key];

  /// Describes how the function execution was invoked.
  ///
  /// Possible values are `http`, `schedule`, or `event`.
  String get trigger => headers['x-appwrite-trigger'];

  /// If the function execution was triggered by an event, this describes the triggering event.
  dynamic get event => headers['x-appwrite-event'];

  /// The dynamic API key used for server authentication.
  /// https://appwrite.io/docs/products/functions/develop#dynamic-api-key
  String? get key => headers['x-appwrite-key'];

  /// If the function execution was invoked by an authenticated user, this is the user's ID.
  ///
  /// This will be `null` for executions triggered by the Appwrite Console or API keys.
  String? get userId => headers['x-appwrite-user-id'];

  /// The JWT token generated from the invoking user's session.
  ///
  /// This is used to authenticate Server SDKs to respect user access permissions.
  String? get userJwt => headers['x-appwrite-user-jwt'];

  /// The country code of the configured locale.
  String? get countryCode => headers['x-appwrite-country-code'];

  /// The continent code of the configured locale.
  String? get continentCode => headers['x-appwrite-continent-code'];

  /// Describes if the configured locale is within the EU.
  ///
  /// The value will be a string, such as 'true' or 'false'.
  String? get continentEu => headers['x-appwrite-continent-eu'];

  /// The IP address of the client that triggered the execution.
  String? get clientIp => headers['x-appwrite-client-ip'];

  /// The unique ID of the current function execution.
  String get executionId => headers['x-appwrite-execution-id'];
}
