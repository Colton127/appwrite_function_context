import 'dart:io';

abstract class EnvVar {
  ///The API endpoint of the running function
  static String get endPoint => parseString('APPWRITE_FUNCTION_API_ENDPOINT');

  /// The Appwrite version being used to run the function.
  /// Available at Build and Run Time.
  static String get appwriteVersion => parseString('APPWRITE_VERSION');

  /// The region where the function is running.
  /// Available at Build and Run Time.
  static String get region => parseString('APPWRITE_REGION');

  /// The function's API key, used for server authentication.
  /// Available at Build Time.
  static String get apiKey => parseString('APPWRITE_FUNCTION_API_KEY');

  /// The unique ID of the running function.
  /// Available at Build and Run Time.
  static String get functionId => parseString('APPWRITE_FUNCTION_ID');

  /// The name of the running function.
  /// Available at Build and Run Time.
  static String get functionName => parseString('APPWRITE_FUNCTION_NAME');

  /// The deployment ID for the current execution of the function.
  /// Available at Build and Run Time.
  static String get deploymentId => parseString('APPWRITE_FUNCTION_DEPLOYMENT');

  /// The project ID that the function belongs to.
  /// Available at Build and Run Time.
  static String get projectId => parseString('APPWRITE_FUNCTION_PROJECT_ID');

  /// The name of the function's runtime (e.g., 'dart-3.0').
  /// Available at Build and Run Time.
  static String get runtimeName => parseString('APPWRITE_FUNCTION_RUNTIME_NAME');

  /// The version of the function's runtime.
  /// Available at Build and Run Time.
  static String get runtimeVersion => parseString('APPWRITE_FUNCTION_RUNTIME_VERSION');

  /// Parses a string value from the environment variables by its [key].
  ///
  /// Throws an [Exception] if the environment variable is not found.
  static String parseString(String key) {
    final String? value = Platform.environment[key];
    if (value == null) {
      throw Exception('Environment variable $key is not set');
    }
    return value;
  }

  static bool parseBool(final String key) {
    final val = parseString(key).toLowerCase();
    switch (val) {
      case 'true' || "1":
        return true;
      case 'false' || "0":
        return false;
      default:
        throw ArgumentError('parseBool: Key $key with value $val is not a valid boolean');
    }
  }

  static int parseInt(final String key) {
    final val = parseString(key);
    try {
      return int.parse(val);
    } catch (e) {
      throw ArgumentError('parseInt: Key $key with value $val is not a valid integer');
    }
  }

  static double parseDouble(final String key) {
    final val = parseString(key);
    try {
      return double.parse(val);
    } catch (e) {
      throw ArgumentError('parseDouble: Key $key with value $val is not a valid double');
    }
  }
}
