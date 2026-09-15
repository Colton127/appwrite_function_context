import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:test/test.dart';

import 'fakes.dart';

RequestHeaders headersFor(Map<String, dynamic> raw) {
  return ExecutionContext(
    FakeRuntimeContext(req: FakeRuntimeRequest(headers: raw)),
  ).headers;
}

void main() {
  group('RequestHeaders typed getters', () {
    test('trigger, executionId are read from their headers', () {
      final headers = headersFor({
        'x-appwrite-trigger': 'http',
        'x-appwrite-execution-id': 'exec1',
      });

      expect(headers.trigger, 'http');
      expect(headers.executionId, 'exec1');
    });

    test('optional headers resolve their values when present', () {
      final headers = headersFor({
        'x-appwrite-event': 'databases.*.create',
        'x-appwrite-key': 'dynamic-key',
        'x-appwrite-user-id': 'user1',
        'x-appwrite-user-jwt': 'jwt-token',
        'x-appwrite-country-code': 'US',
        'x-appwrite-continent-code': 'NA',
        'x-appwrite-continent-eu': 'false',
        'x-appwrite-client-ip': '127.0.0.1',
      });

      expect(headers.event, 'databases.*.create');
      expect(headers.key, 'dynamic-key');
      expect(headers.userId, 'user1');
      expect(headers.userJwt, 'jwt-token');
      expect(headers.countryCode, 'US');
      expect(headers.continentCode, 'NA');
      expect(headers.continentEu, 'false');
      expect(headers.clientIp, '127.0.0.1');
    });

    test('optional headers are null when absent', () {
      final headers = headersFor({'x-appwrite-trigger': 'schedule'});

      expect(headers.event, isNull);
      expect(headers.key, isNull);
      expect(headers.userId, isNull);
      expect(headers.userJwt, isNull);
      expect(headers.countryCode, isNull);
      expect(headers.continentCode, isNull);
      expect(headers.continentEu, isNull);
      expect(headers.clientIp, isNull);
    });
  });

  group('RequestHeaders.requireValue', () {
    test('returns the value when present and correctly typed', () {
      final headers = headersFor({'x-appwrite-user-id': 'user1'});

      expect(headers.requireValue<String>('x-appwrite-user-id'), 'user1');
    });

    test('throws when the header is missing', () {
      final headers = headersFor({});

      expect(
        () => headers.requireValue<String>('x-appwrite-user-id'),
        throwsException,
      );
    });

    test('throws when the header is present but the wrong type', () {
      final headers = headersFor({'x-appwrite-user-id': 42});

      expect(
        () => headers.requireValue<String>('x-appwrite-user-id'),
        throwsException,
      );
    });
  });

  group('RequestHeaders map-style access', () {
    test('operator [] reads raw values', () {
      final headers = headersFor({'x-custom': 'value'});

      expect(headers['x-custom'], 'value');
      expect(headers['missing'], isNull);
    });

    test('keys, values, entries, length reflect the header map', () {
      final headers = headersFor({'a': '1', 'b': '2'});

      expect(headers.keys, containsAll(['a', 'b']));
      expect(headers.values, containsAll(['1', '2']));
      expect(
        headers.entries.map((e) => '${e.key}=${e.value}'),
        containsAll(['a=1', 'b=2']),
      );
      expect(headers.length, 2);
    });

    test('containsKey reflects presence', () {
      final headers = headersFor({'a': '1'});

      expect(headers.containsKey('a'), isTrue);
      expect(headers.containsKey('b'), isFalse);
    });

    test('forEach iterates every entry', () {
      final headers = headersFor({'a': '1', 'b': '2'});
      final seen = <String, Object?>{};

      headers.forEach((key, value) => seen[key] = value);

      expect(seen, {'a': '1', 'b': '2'});
    });
  });
}
