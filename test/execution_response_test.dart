import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  group('ExecutionResponse', () {
    late FakeRuntimeResponse fakeRes;
    late ExecutionResponse res;

    setUp(() {
      fakeRes = FakeRuntimeResponse();
      res = ExecutionContext(FakeRuntimeContext(res: fakeRes)).res;
    });

    test('text forwards body, status code, and headers', () {
      res.text('hello', 201, {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'text');
      expect(fakeRes.lastCall!.args, [
        'hello',
        201,
        {'x-custom': 'value'},
      ]);
    });

    test('text defaults statusCode to 200 and headers to empty', () {
      res.text('hello');

      expect(fakeRes.lastCall!.args, ['hello', 200, <String, dynamic>{}]);
    });

    test('json forwards the map, status code, and headers', () {
      res.json({'ok': true}, 400, {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'json');
      expect(fakeRes.lastCall!.args, [
        {'ok': true},
        400,
        {'x-custom': 'value'},
      ]);
    });

    test('binary forwards bytes, status code, and headers', () {
      final bytes = [1, 2, 3];
      res.binary(bytes, 206, {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'binary');
      expect(fakeRes.lastCall!.args, [
        bytes,
        206,
        {'x-custom': 'value'},
      ]);
    });

    test('redirect forwards url, status code, and headers', () {
      res.redirect('https://appwrite.io', 302, {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'redirect');
      expect(fakeRes.lastCall!.args, [
        'https://appwrite.io',
        302,
        {'x-custom': 'value'},
      ]);
    });

    test('redirect defaults statusCode to 301', () {
      res.redirect('https://appwrite.io');

      expect(fakeRes.lastCall!.args[1], 301);
    });

    test('empty takes no arguments and forwards nothing', () {
      res.empty();

      expect(fakeRes.lastCall!.method, 'empty');
      expect(fakeRes.lastCall!.args, isEmpty);
    });

    test('html sends through text() with a text/html content-type', () {
      res.html('<h1>Hi</h1>', 200, {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'text');
      expect(fakeRes.lastCall!.args, [
        '<h1>Hi</h1>',
        200,
        {'x-custom': 'value', 'content-type': 'text/html'},
      ]);
    });

    test('html preserves caller headers and does not require them', () {
      res.html('<p>Hi</p>');

      expect(fakeRes.lastCall!.args, [
        '<p>Hi</p>',
        200,
        {'content-type': 'text/html'},
      ]);
    });

    test('success sends through text() with a 200 default', () {
      res.success(message: 'all good', headers: {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'text');
      expect(fakeRes.lastCall!.args, [
        'all good',
        200,
        {'x-custom': 'value'},
      ]);
    });

    test('success defaults message to empty string', () {
      res.success();

      expect(fakeRes.lastCall!.args, ['', 200, <String, dynamic>{}]);
    });

    test('error sends through text() with a 500 default', () {
      res.error(message: 'oh no', headers: {'x-custom': 'value'});

      expect(fakeRes.lastCall!.method, 'text');
      expect(fakeRes.lastCall!.args, [
        'oh no',
        500,
        {'x-custom': 'value'},
      ]);
    });

    test('error defaults message to empty string', () {
      res.error();

      expect(fakeRes.lastCall!.args, ['', 500, <String, dynamic>{}]);
    });
  });
}
