import 'dart:convert';

/// Minimal stand-ins for Open Runtimes' `RuntimeRequest`, `RuntimeResponse`,
/// and `RuntimeContext` (see
/// open-runtimes/runtimes/dart/versions/latest/src/function_types.dart).
///
/// [ExecutionContext] and friends access the raw context dynamically (duck
/// typing), so these fakes let tests exercise the wrapper against
/// runtime-shaped objects without depending on `dart_appwrite`.
class FakeRuntimeRequest {
  String method;
  String scheme;
  String host;
  int port;
  String path;
  Map<String, String> query;
  String queryString;
  Map<String, dynamic> headers;
  List<int> bodyBinary;
  String url;

  FakeRuntimeRequest({
    this.method = '',
    this.scheme = '',
    this.host = '',
    this.port = 80,
    this.path = '',
    this.query = const {},
    this.queryString = '',
    this.headers = const {},
    this.bodyBinary = const [],
    this.url = '',
  });

  String get bodyText => utf8.decode(bodyBinary);

  dynamic get bodyJson => jsonDecode(bodyText);
}

/// Records the arguments of the most recent call for assertions.
class RecordedCall {
  final String method;
  final List<Object?> args;
  const RecordedCall(this.method, this.args);
}

class FakeRuntimeResponse {
  RecordedCall? lastCall;

  dynamic binary(
    List<int> bytes, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    lastCall = RecordedCall('binary', [bytes, statusCode, headers]);
    return lastCall;
  }

  dynamic text(
    String body, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    lastCall = RecordedCall('text', [body, statusCode, headers]);
    return lastCall;
  }

  dynamic json(
    Map<String, dynamic> json, [
    int statusCode = 200,
    Map<String, dynamic> headers = const {},
  ]) {
    lastCall = RecordedCall('json', [json, statusCode, headers]);
    return lastCall;
  }

  dynamic redirect(
    String url, [
    int statusCode = 301,
    Map<String, dynamic> headers = const {},
  ]) {
    lastCall = RecordedCall('redirect', [url, statusCode, headers]);
    return lastCall;
  }

  dynamic empty() {
    lastCall = const RecordedCall('empty', []);
    return lastCall;
  }
}

class FakeRuntimeContext {
  final FakeRuntimeRequest req;
  final FakeRuntimeResponse res;
  final List<Object?> logs = [];
  final List<Object?> errors = [];

  FakeRuntimeContext({FakeRuntimeRequest? req, FakeRuntimeResponse? res})
      : req = req ?? FakeRuntimeRequest(),
        res = res ?? FakeRuntimeResponse();

  void log(Object? message) => logs.add(message);
  void error(Object? message) => errors.add(message);
}
