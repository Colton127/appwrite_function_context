# Appwrite Function Context

A Dart wrapper library for Appwrite Functions that provides type safety and a better developer experience when working with Appwrite serverless functions.

## Features

- Type-safe access to Appwrite function execution context
- Convenient access to request data, headers, and query parameters
- Simplified response creation (JSON, HTML, text, binary)
- Helper methods for environment variables

## Usage

Import the package and wrap the raw Appwrite context to gain access to all the type-safe features:

```dart
import 'package:appwrite_function_context/appwrite_function_context.dart';

void main(context) {
  // Wrap the raw context
  final ctx = ExecutionContext(context);
  
  // Access request, headers, and send response
  ctx.log('Function executed');
  return ctx.res.json({
    'success': true,
    'message': 'Hello from Appwrite Functions'
  });
}
```

## Reference

### EnvVar

Provides access to environment variables available in Appwrite Functions:

| Variable | Description | Available At |
|----------|-------------|--------------|
| `EnvVar.appwriteEndpoint` | The Appwrite API endpoint | Runtime |
| `EnvVar.appwriteFunction` | The ID of the current function | Runtime |
| `EnvVar.appwriteFunctionId` | The ID of the current function | Runtime |
| `EnvVar.appwriteFunctionName` | The name of the current function | Runtime |
| `EnvVar.appwriteFunctionDeploymentId` | The ID of the current function deployment | Runtime |
| `EnvVar.appwriteFunctionTrigger` | The function trigger type | Runtime |
| `EnvVar.appwriteFunctionProject` | The project ID | Runtime |
| `EnvVar.appwriteFunctionProjectId` | The project ID | Runtime |
| `EnvVar.appwriteFunctionJwt` | The JWT for accessing Appwrite APIs | Runtime |
| `EnvVar.appwriteFunctionUserAgent` | The user agent string for SDK identification | Runtime |

Access an environment variable:

```dart
final endpoint = EnvVar.appwriteEndpoint;
```

### ExecutionContext

Main wrapper around the raw Appwrite function context.

```dart
// Create from raw context object passed to your function
final ctx = ExecutionContext(context);
```

Properties:
- `req` - Access the request details
- `res` - Create and send responses
- `headers` - Access request headers

Methods:
- `log(String message)` - Log an informational message
- `error(String message)` - Log an error message

### ExecutionRequest

Access information about the incoming request through `ctx.req`:

| Property | Type | Description |
|----------|------|-------------|
| `bodyText` | `String` | Raw request body as string |
| `bodyJson` | `dynamic` | Parsed JSON request body |
| `bodyBinary` | `List<int>` | Raw binary request body |
| `headers` | `Map<String, dynamic>` | All request headers |
| `scheme` | `String` | Request scheme (http/https) |
| `method` | `String` | HTTP method (GET, POST, etc.) |
| `url` | `String` | Full URL of the request |
| `host` | `String` | Hostname from the 'host' header |
| `port` | `int` | Port from the 'host' header |
| `path` | `String` | URL path |
| `queryString` | `String` | Raw query parameters string |
| `query` | `Map<String, dynamic>` | Parsed query parameters |

Examples:

```dart
// Check request method
if (ctx.req.method == 'POST') {
  // Handle POST request
}

// Access JSON body
final data = ctx.req.bodyJson;
final username = data['username'];

// Access query parameters
final limit = ctx.req.query['limit'];
```

### ExecutionResponse

Create and send responses through `ctx.res`:

| Method | Description | Example |
|--------|-------------|---------|
| `empty()` | Send an empty response | `return ctx.res.empty();` |
| `json(Map<String, dynamic>)` | Send a JSON response | `return ctx.res.json({'status': 'success'});` |
| `binary(Uint8List)` | Send binary data | `return ctx.res.binary(fileBytes);` |
| `redirect(String)` | Redirect to URL | `return ctx.res.redirect('https://example.com');` |
| `html(String)` | Send HTML content | `return ctx.res.html('<h1>Hello</h1>');` |
| `text(String)` | Send plain text | `return ctx.res.text('Hello world');` |
| `success([String])` | Send success (200) | `return ctx.res.success('Operation completed');` |
| `error([String])` | Send error (500) | `return ctx.res.error('Something went wrong');` |

### ExecutionHeaders

Access request headers through `ctx.headers`:

| Property | Type | Description |
|----------|------|-------------|
| `trigger` | `String` | How function was invoked (http, schedule, event) |
| `event` | `dynamic` | Event data if triggered by an event |
| `key` | `String?` | Dynamic API key used for authentication |
| `userId` | `String?` | ID of authenticated user who triggered execution |
| `userJwt` | `String?` | JWT token from invoking user's session |
| `countryCode` | `String?` | Country code of configured locale |
| `continentCode` | `String?` | Continent code of configured locale |
| `continentEu` | `String?` | Whether locale is within EU ('true'/'false') |
| `clientIp` | `String?` | IP address of client that triggered execution |
| `executionId` | `String` | Unique ID of current function execution |

You can also access any header using the index operator:

```dart
// Access a custom header
final customHeader = ctx.headers['x-custom-header'];

// Check execution trigger type
if (ctx.headers.trigger == 'event') {
  final eventData = ctx.headers.event;
}

// Get user ID if authenticated
final userId = ctx.headers.userId;
```

## Example

Here's a complete example of using the package in an Appwrite function:

```dart
import 'package:appwrite_function_context/appwrite_function_context.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

void main(final context) {
  // Wrap the context for type safety and better developer experience
  final ctx = ExecutionContext(context);

  ctx.log('Function executing...');

  try {
    // Get execution trigger type
    final triggerType = ctx.headers.trigger;
    ctx.log('Trigger type: $triggerType');

    // Initialize Appwrite SDK using environment variables
    final client = Client()
        .setEndpoint(EnvVar.appwriteEndpoint)
        .setProject(EnvVar.appwriteFunctionProject)
        .setKey(EnvVar.appwriteFunctionApiKey);

    // Access request data
    if (ctx.req.method == 'POST') {
      final data = ctx.req.bodyJson;
      ctx.log('Received data: $data');
      
      // Process data and return response
      return ctx.res.json({
        'success': true,
        'message': 'Data processed successfully',
        'data': data
      });
    } else {
      // Return simple text for other methods
      return ctx.res.text('Send a POST request with JSON data');
    }
  } catch (e) {
    ctx.error('Error: $e');
    return ctx.res.error('An error occurred during execution');
  }
}
```
