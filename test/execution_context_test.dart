import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  group('ExecutionContext', () {
    test('req forwards to the underlying request', () {
      final fake = FakeRuntimeContext(
        req: FakeRuntimeRequest(method: 'GET', path: '/ping'),
      );
      final ctx = ExecutionContext(fake);

      expect(ctx.req.method, 'GET');
      expect(ctx.req.path, '/ping');
    });

    test('res forwards to the underlying response', () {
      final fake = FakeRuntimeContext();
      final ctx = ExecutionContext(fake);

      ctx.res.text('hi');

      expect(fake.res.lastCall!.method, 'text');
      expect(fake.res.lastCall!.args, ['hi', 200, <String, dynamic>{}]);
    });

    test('headers forwards to the underlying request headers', () {
      final fake = FakeRuntimeContext(
        req: FakeRuntimeRequest(
          headers: {'x-appwrite-execution-id': 'exec1'},
        ),
      );
      final ctx = ExecutionContext(fake);

      expect(ctx.headers.executionId, 'exec1');
    });

    test('log forwards arbitrary loggable values', () {
      final fake = FakeRuntimeContext();
      final ctx = ExecutionContext(fake);

      ctx.log('a string');
      ctx.log(42);
      ctx.log({'nested': true});
      ctx.log(null);

      expect(fake.logs, [
        'a string',
        42,
        {'nested': true},
        null
      ]);
    });

    test('error forwards arbitrary loggable values', () {
      final fake = FakeRuntimeContext();
      final ctx = ExecutionContext(fake);

      ctx.error('boom');
      ctx.error(Exception('bad'));

      expect(fake.errors.length, 2);
      expect(fake.errors.first, 'boom');
    });
  });
}
