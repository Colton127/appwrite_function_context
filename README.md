# Appwrite Function Context

A Dart wrapper library for Appwrite Functions that provides type safety and a better developer experience when working with dart_appwrite Functions.

## Features

- Type-safe access to Appwrite function execution context
- Convenient access to request data, headers, and query parameters
- Simplified response creation (JSON, HTML, text, binary) with custom header support
- Helper methods for environment variables and parsing

## Installation

Add this package to your functions `pubspec.yaml`:

```yaml
dependencies:
  appwrite_function_context: ^1.1.0
```

## Usage

Import the package and wrap the raw Appwrite context to gain access to all the type-safe features:

```dart
import 'package:appwrite_function_context/appwrite_function_context.dart';

Future<dynamic> main(context) async {
  // Wrap the raw context
  final ctx = ExecutionContext(context);

  // Access request, headers, and send response
  ctx.log('Function executed');
  return ctx.res.json({
    'success': true,
    'message': 'Hello from Appwrite Functions',
  });
}
```

> This package is a lightweight, typed facade over the raw `context` object
> provided by the [Open Runtimes Dart runtime](https://github.com/open-runtimes/open-runtimes/tree/main/runtimes/dart/versions/latest).
> For canonical behavior, see the [Appwrite Functions docs](https://appwrite.io/docs/products/functions/develop).

## Reference

### EnvVar

Provides access to environment variables available in Appwrite Functions:

| Variable | Description |
|----------|-------------|
| `EnvVar.endPoint` | Appwrite API endpoint |
| `EnvVar.appwriteVersion` | Appwrite version running the function |
| `EnvVar.region` | Region where the function is running |
| `EnvVar.deploymentType` | Deployment source type (`manual`, `cli`, or `vcs`) |
| `EnvVar.apiKey` | Function/API key for server authentication (build time only) |
| `EnvVar.functionId` | Unique ID of the running function |
| `EnvVar.functionName` | Name of the running function |
| `EnvVar.deploymentId` | Deployment ID for the current function execution |
| `EnvVar.projectId` | Appwrite project ID the function belongs to |
| `EnvVar.runtimeName` | Runtime name (e.g., 'dart-3.0') |
| `EnvVar.runtimeVersion` | Runtime version of the function |
| `EnvVar.cpus` | CPUs allocated to the function (may be fractional, e.g. `0.5`) |
| `EnvVar.memory` | Memory, in MB, allocated to the function |

VCS metadata is only populated for Git-connected deployments; these getters
return `null` for manual or CLI deployments:

| Variable | Description |
|----------|-------------|
| `EnvVar.vcsRepositoryId` / `vcsRepositoryName` / `vcsRepositoryOwner` / `vcsRepositoryUrl` | Repository metadata |
| `EnvVar.vcsRepositoryBranch` / `vcsRepositoryBranchUrl` | Branch metadata |
| `EnvVar.vcsCommitHash` / `vcsCommitMessage` / `vcsCommitUrl` | Commit metadata |
| `EnvVar.vcsCommitAuthorName` / `vcsCommitAuthorUrl` | Commit author metadata |
| `EnvVar.vcsRootDirectory` | Root directory configured for the VCS deployment |

EnvVar exposes helpers to manually parse environment variables:

- `EnvVar.parseString(String key)`
- `EnvVar.parseOptionalString(String key)` — returns `null` instead of throwing if unset or empty
- `EnvVar.parseBool(String key)`
- `EnvVar.parseInt(String key)`
- `EnvVar.parseDouble(String key)`

Examples:

```dart
// Preferred: use typed EnvVar accessors
final endpoint = EnvVar.endPoint;
final projectId = EnvVar.projectId;

// Manual parsing for custom environment variables:
final isFeatureEnabled = EnvVar.parseBool('MY_FEATURE_FLAG');
final maxConnections = EnvVar.parseInt('MY_MAX_CONN');
final timeout = EnvVar.parseDouble('MY_TIMEOUT_SECS');
final customString = EnvVar.parseString('MY_CUSTOM_VALUE');
```

### ExecutionContext

ExecutionContext wraps the raw function context and provides typed access to:

- `req` — the `ExecutionRequest` containing the request data (body, headers, query).
- `res` — the `ExecutionResponse` helper for creating responses.
- `headers` — the `RequestHeaders` abstraction for request headers.
- Logging:
  - `log(Object? message)` — write an informational message to function logs.
  - `error(Object? message)` — write an error message to function logs.

Create an `ExecutionContext` from the raw context object passed to your function:

```dart
final ctx = ExecutionContext(context);
```

### ExecutionRequest

Access details about the incoming request using `ctx.req`:

| Property | Type | Description |
|----------|------|-------------|
| `bodyText` | `String` | Raw request body as a string. |
| `bodyJson` | `dynamic` | Parsed JSON body. Throws `FormatException` if the body isn't valid JSON. |
| `bodyBinary` | `List<int>` | Raw binary body bytes. |
| `headers` | `Map<String, dynamic>` | All request headers (lowercased keys). |
| `scheme` | `String` | Request scheme, e.g., 'http' or 'https'. |
| `method` | `String` | HTTP method, e.g., 'GET', 'POST'. |
| `url` | `String` | Full request URL. |
| `host` | `String` | Hostname from the 'host' header. |
| `port` | `int` | Port parsed from 'host' header. |
| `path` | `String` | The path part of the URL. |
| `queryString` | `String` | Raw query string, e.g., `a=1&b=2`. |
| `query` | `Map<String, String>` | Parsed query parameters. |

Examples:

```dart
if (ctx.req.method == 'POST') {
  final data = ctx.req.bodyJson;
  // process JSON
}

final limit = ctx.req.query['limit'];
final raw = ctx.req.bodyText;
```

### ExecutionResponse

`ctx.res` provides helper methods to send responses. All response methods accept
an optional status code and an optional map of response headers.

Methods:
- `empty()`
- `json(Map<String, dynamic> json, [int statusCode = 200, Map<String, dynamic> headers = const {}])`
- `binary(List<int> bytes, [int statusCode = 200, Map<String, dynamic> headers = const {}])`
- `redirect(String url, [int statusCode = 301, Map<String, dynamic> headers = const {}])`
- `html(String html, [int statusCode = 200, Map<String, dynamic> headers = const {}])`
- `text(String text, [int statusCode = 200, Map<String, dynamic> headers = const {}])`
- `success({String message = '', int statusCode = 200, Map<String, dynamic> headers = const {}})`
- `error({String message = '', int statusCode = 500, Map<String, dynamic> headers = const {}})`

Examples:

```dart
return ctx.res.json({'ok': true});
return ctx.res.json({'ok': false}, 500);
return ctx.res.text('Not Found', 404);
return ctx.res.redirect('https://example.com');
return ctx.res.empty();

// Custom response headers
return ctx.res.json(
  {'success': true},
  200,
  {
    'cache-control': 'no-store',
    'x-example': 'value',
  },
);
```

### RequestHeaders

Use `ctx.headers` to access request headers.

Getters exposed:
- `trigger` — how the function was executed (`http`, `schedule`, `event`).
- `event` — the triggering event, when `trigger` is `event` (`null` otherwise).
- `key` — optional dynamic API key used for authentication.
- `userId` — user ID for authenticated executions (when applicable).
- `userJwt` — JWT token from the invoking user's session (when applicable).
- `countryCode` — client country code (when available).
- `continentCode` — client continent code (when available).
- `continentEu` — whether the region is within the EU as `'true'`/`'false'`.
- `clientIp` — client IP address.
- `executionId` — unique ID for the current function execution.

`RequestHeaders` also supports map-style access — `headers['x-custom']`, `keys`,
`values`, `entries`, `containsKey`, `length`, `forEach` — for reading headers
that don't have a typed getter.

Type-safe assertion:
- `RequestHeaders.requireValue<T>(key)` validates presence and type — throws if missing or type mismatch.

Example:

```dart
final userId = ctx.headers.userId;
final trigger = ctx.headers.trigger;

final apiKey = ctx.headers.requireValue<String>('x-appwrite-key');
final custom = ctx.headers['x-custom-header'];
```
