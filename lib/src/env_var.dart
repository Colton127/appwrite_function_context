import 'dart:io';

/// Full documentation:
/// https://appwrite.io/docs/products/functions/environment-variables
abstract class EnvVar {
  ///The API endpoint of the running function
  static String get endPoint => parseString('APPWRITE_FUNCTION_API_ENDPOINT');

  /// The Appwrite version being used to run the function.
  static String get appwriteVersion => parseString('APPWRITE_VERSION');

  /// The region where the function is running.
  static String get region => parseString('APPWRITE_REGION');

  /// The deployment source type, such as `manual`, `cli`, or `vcs`.
  ///
  /// Kept as a [String], rather than an enum, so future deployment types
  /// don't break at runtime.
  static String get deploymentType => parseString('APPWRITE_DEPLOYMENT_TYPE');

  /// The function's API key, used for server authentication. Only available at Build Time.
  ///
  /// To access the dynamic API key at Runtime, use `ctx.headers.key`.
  static String? get apiKey =>
      Platform.environment['APPWRITE_FUNCTION_API_KEY'];

  /// The unique ID of the running function.
  static String get functionId => parseString('APPWRITE_FUNCTION_ID');

  /// The name of the running function.
  static String get functionName => parseString('APPWRITE_FUNCTION_NAME');

  /// The deployment ID for the current execution of the function.
  static String get deploymentId => parseString('APPWRITE_FUNCTION_DEPLOYMENT');

  /// The project ID that the function belongs to.
  static String get projectId => parseString('APPWRITE_FUNCTION_PROJECT_ID');

  /// The name of the function's runtime (e.g., 'dart-3.0').
  static String get runtimeName =>
      parseString('APPWRITE_FUNCTION_RUNTIME_NAME');

  /// The version of the function's runtime.
  static String get runtimeVersion =>
      parseString('APPWRITE_FUNCTION_RUNTIME_VERSION');

  /// The number of CPUs allocated to the running function.
  ///
  /// This may be fractional (Appwrite's default spec is `0.5`), so it is
  /// parsed as a [double] rather than an [int].
  static double get cpus => parseDouble('APPWRITE_FUNCTION_CPUS');

  /// The amount of memory, in megabytes, allocated to the running function.
  static int get memory => parseInt('APPWRITE_FUNCTION_MEMORY');

  /// The VCS provider's repository ID, for Git deployments.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryId =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_ID');

  /// The VCS provider's repository name, for Git deployments.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryName =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_NAME');

  /// The owner of the VCS provider's repository, for Git deployments.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryOwner =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_OWNER');

  /// The URL of the VCS provider's repository, for Git deployments.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryUrl =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_URL');

  /// The branch used for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryBranch =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_BRANCH');

  /// The URL of the branch used for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRepositoryBranchUrl =>
      parseOptionalString('APPWRITE_VCS_REPOSITORY_BRANCH_URL');

  /// The commit hash used for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsCommitHash =>
      parseOptionalString('APPWRITE_VCS_COMMIT_HASH');

  /// The commit message used for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsCommitMessage =>
      parseOptionalString('APPWRITE_VCS_COMMIT_MESSAGE');

  /// The URL of the commit used for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsCommitUrl =>
      parseOptionalString('APPWRITE_VCS_COMMIT_URL');

  /// The name of the VCS commit author.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsCommitAuthorName =>
      parseOptionalString('APPWRITE_VCS_COMMIT_AUTHOR_NAME');

  /// The URL of the VCS commit author.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsCommitAuthorUrl =>
      parseOptionalString('APPWRITE_VCS_COMMIT_AUTHOR_URL');

  /// The root directory configured for the VCS deployment.
  ///
  /// `null` for manual or CLI deployments.
  static String? get vcsRootDirectory =>
      parseOptionalString('APPWRITE_VCS_ROOT_DIRECTORY');

  /// Parses a string value from the environment variables by its [key].
  ///
  /// Throws an [Exception] if the environment variable is not set.
  static String parseString(String key) {
    final String? value = Platform.environment[key];
    if (value == null) {
      throw Exception('Environment variable $key is not set');
    }
    return value;
  }

  /// Reads the environment variable by its [key], returning `null` if it is
  /// unset or empty rather than throwing.
  ///
  /// Useful for optional metadata, such as VCS variables, that Appwrite does
  /// not guarantee for every deployment.
  static String? parseOptionalString(String key) {
    final String? value = Platform.environment[key];
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  /// Parses a boolean value from the environment variables by its [key].
  ///
  /// Throws an [Exception] if the environment variable is not set, or a
  /// [FormatException] if its value is not a valid boolean.
  static bool parseBool(String key) => parseBoolValue(key, parseString(key));

  /// Parses a boolean from a raw [value], attributing errors to [key].
  ///
  /// Extracted from [parseBool] so the parsing logic can be unit tested
  /// without needing to set real process environment variables.
  static bool parseBoolValue(String key, String value) {
    final String normalized = value.toLowerCase();
    switch (normalized) {
      case 'true' || '1':
        return true;
      case 'false' || '0':
        return false;
      default:
        throw FormatException(
          'parseBool: Key $key with value $normalized is not a valid boolean',
        );
    }
  }

  /// Parses an integer value from the environment variables by its [key].
  ///
  /// Throws an [Exception] if the environment variable is not set, or a
  /// [FormatException] if its value is not a valid integer.
  static int parseInt(String key) => parseIntValue(key, parseString(key));

  /// Parses an integer from a raw [value], attributing errors to [key].
  ///
  /// Extracted from [parseInt] so the parsing logic can be unit tested
  /// without needing to set real process environment variables.
  static int parseIntValue(String key, String value) {
    final int? parsed = int.tryParse(value);
    if (parsed == null) {
      throw FormatException(
        'parseInt: Key $key with value $value is not a valid integer',
      );
    }
    return parsed;
  }

  /// Parses a double value from the environment variables by its [key].
  ///
  /// Throws an [Exception] if the environment variable is not set, or a
  /// [FormatException] if its value is not a valid double.
  static double parseDouble(String key) =>
      parseDoubleValue(key, parseString(key));

  /// Parses a double from a raw [value], attributing errors to [key].
  ///
  /// Extracted from [parseDouble] so the parsing logic can be unit tested
  /// without needing to set real process environment variables.
  static double parseDoubleValue(String key, String value) {
    final double? parsed = double.tryParse(value);
    if (parsed == null) {
      throw FormatException(
        'parseDouble: Key $key with value $value is not a valid double',
      );
    }
    return parsed;
  }
}
