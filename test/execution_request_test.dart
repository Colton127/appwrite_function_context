import 'dart:convert';

import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  group('ExecutionRequest', () {
    test('bodyText decodes the binary body as UTF-8', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(bodyBinary: utf8.encode('hello world')),
        ),
      );

      expect(ctx.req.bodyText, 'hello world');
    });

    test('bodyJson parses valid JSON bodies', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(
            bodyBinary: utf8.encode('{"ok":true,"count":2}'),
          ),
        ),
      );

      expect(ctx.req.bodyJson, {'ok': true, 'count': 2});
    });

    test('bodyJson throws FormatException for invalid JSON', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(bodyBinary: utf8.encode('not json')),
        ),
      );

      expect(() => ctx.req.bodyJson, throwsFormatException);
    });

    test('bodyBinary returns the raw bytes', () {
      final bytes = utf8.encode('binary');
      final ctx = ExecutionContext(
        FakeRuntimeContext(req: FakeRuntimeRequest(bodyBinary: bytes)),
      );

      expect(ctx.req.bodyBinary, bytes);
    });

    test('headers returns the raw lowercase-keyed header map', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(headers: {'content-type': 'text/plain'}),
        ),
      );

      expect(ctx.req.headers, {'content-type': 'text/plain'});
    });

    test('method returns the HTTP method', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(req: FakeRuntimeRequest(method: 'POST')),
      );

      expect(ctx.req.method, 'POST');
    });

    test('url, host, port, path, scheme are forwarded', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(
            url: 'https://awesome.appwrite.io:8000/v1/hooks?limit=12',
            host: 'awesome.appwrite.io',
            port: 8000,
            path: '/v1/hooks',
            scheme: 'https',
          ),
        ),
      );

      expect(ctx.req.url, 'https://awesome.appwrite.io:8000/v1/hooks?limit=12');
      expect(ctx.req.host, 'awesome.appwrite.io');
      expect(ctx.req.port, 8000);
      expect(ctx.req.path, '/v1/hooks');
      expect(ctx.req.scheme, 'https');
    });

    test('queryString returns the raw query string', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(queryString: 'limit=12&offset=50'),
        ),
      );

      expect(ctx.req.queryString, 'limit=12&offset=50');
    });

    test('query returns parsed string-valued query parameters', () {
      final ctx = ExecutionContext(
        FakeRuntimeContext(
          req: FakeRuntimeRequest(
            query: {'limit': '12', 'offset': '50'},
          ),
        ),
      );

      expect(ctx.req.query, {'limit': '12', 'offset': '50'});
      expect(ctx.req.query['limit'], isA<String>());
    });
  });
}
