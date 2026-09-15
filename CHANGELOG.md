# 1.1.0

- Added response header support to `text`, `json`, `binary`, `redirect`, `html`, `success`, and `error` responses, matching the current Open Runtimes Dart runtime signatures.
- `ExecutionResponse.binary` now accepts `List<int>` instead of `Uint8List`, and `html`/`success`/`error` now route through the public `text()` method.
- `ExecutionRequest.query` is now `Map<String, String>` (was `Map<String, dynamic>`), matching the runtime.
- `ExecutionContext.log`/`error` now accept `Object?` instead of `String`, matching the runtime.
- `RequestHeaders.event` is now `String?` (was `dynamic`); `RequestHeaders` map-style accessors (`values`, `entries`, `forEach`) now use `Object?` instead of `dynamic`.
- `RequestHeaders.requireValue<T>()` now gives a clearer error when the header is missing entirely, versus present with the wrong type.
- Added `EnvVar.deploymentType`, `EnvVar.cpus`, `EnvVar.memory`, and nullable VCS metadata getters (`vcsRepositoryId`, `vcsRepositoryBranch`, `vcsCommitHash`, etc.) for currently documented Appwrite environment variables.
- Added `EnvVar.parseOptionalString()` plus testable `parseBoolValue`/`parseIntValue`/`parseDoubleValue` helpers.
- Fixed example code for newer Dart syntax (untyped `main(context)` parameter can no longer be `final`), and gave `example/` its own `pubspec.yaml` so it resolves and analyzes cleanly.
- Enabled `package:lints/recommended.yaml` in `analysis_options.yaml` (previously present only as a comment) and added a unit test suite.

# 1.0.1

- Add optional HTTP status code parameters to ExecutionResponse helpers
- Add RequestHeaders.requireValue<T>(key) helper to validate headers and enforce types.
- Lower minimum Dart SDK constraint to Dart 3.0.

# 1.0.0

- Initial release
