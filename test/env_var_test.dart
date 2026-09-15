import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:test/test.dart';

/// A key that is essentially guaranteed not to be set in any real
/// environment, used to exercise the "variable is missing" code paths
/// without needing to mutate `Platform.environment` (which Dart does not
/// allow at runtime).
const _unsetKey = 'APPWRITE_FUNCTION_CONTEXT_TEST_DOES_NOT_EXIST_12345';

void main() {
  group('EnvVar key-based parsing (missing variable)', () {
    test('parseString throws when the variable is not set', () {
      expect(() => EnvVar.parseString(_unsetKey), throwsException);
    });

    test('parseBool throws when the variable is not set', () {
      expect(() => EnvVar.parseBool(_unsetKey), throwsException);
    });

    test('parseInt throws when the variable is not set', () {
      expect(() => EnvVar.parseInt(_unsetKey), throwsException);
    });

    test('parseDouble throws when the variable is not set', () {
      expect(() => EnvVar.parseDouble(_unsetKey), throwsException);
    });

    test('parseOptionalString returns null instead of throwing', () {
      expect(EnvVar.parseOptionalString(_unsetKey), isNull);
    });
  });

  group('EnvVar.parseBoolValue', () {
    test('accepts true/false', () {
      expect(EnvVar.parseBoolValue('k', 'true'), isTrue);
      expect(EnvVar.parseBoolValue('k', 'false'), isFalse);
    });

    test('accepts 1/0', () {
      expect(EnvVar.parseBoolValue('k', '1'), isTrue);
      expect(EnvVar.parseBoolValue('k', '0'), isFalse);
    });

    test('is case-insensitive', () {
      expect(EnvVar.parseBoolValue('k', 'TRUE'), isTrue);
      expect(EnvVar.parseBoolValue('k', 'False'), isFalse);
    });

    test('throws FormatException for an invalid value', () {
      expect(
        () => EnvVar.parseBoolValue('k', 'maybe'),
        throwsFormatException,
      );
    });
  });

  group('EnvVar.parseIntValue', () {
    test('parses valid integers', () {
      expect(EnvVar.parseIntValue('k', '42'), 42);
      expect(EnvVar.parseIntValue('k', '-7'), -7);
    });

    test('throws FormatException for an invalid value', () {
      expect(() => EnvVar.parseIntValue('k', 'abc'), throwsFormatException);
      expect(() => EnvVar.parseIntValue('k', '1.5'), throwsFormatException);
    });
  });

  group('EnvVar.parseDoubleValue', () {
    test('parses valid doubles, including fractional values', () {
      expect(EnvVar.parseDoubleValue('k', '0.5'), 0.5);
      expect(EnvVar.parseDoubleValue('k', '2'), 2.0);
    });

    test('throws FormatException for an invalid value', () {
      expect(
        () => EnvVar.parseDoubleValue('k', 'abc'),
        throwsFormatException,
      );
    });
  });
}
