import 'dart:async';
import 'dart:io';

import 'package:appwrite_function_context/src/env_var.dart';
import 'package:appwrite_function_context/src/execution_context.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> main(final context) async {
  // Wrap the dynamic context in the strongly typed ExecutionContext
  final ExecutionContext exeContext = ExecutionContext(context);

  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  final client = Client().setEndpoint(EnvVar.endPoint).setProject(EnvVar.projectId).setKey(exeContext.headers.key ?? '');
  final users = Users(client);

  try {
    final response = await users.list();
    // Log messages and errors to the Appwrite Console
    // These logs won't be seen by your end users
    exeContext.log('Total users: ' + response.total.toString());
  } catch (e) {
    exeContext.error('Could not list users: ' + e.toString());
  }

  // The req object contains the request data
  if (exeContext.req.path == "/ping") {
    // Use res object to respond with text(), json(), or binary()
    // Don't forget to return a response!
    return exeContext.res.text('Pong');
  }

  return exeContext.res.json({
    'motto': 'Build like a team of hundreds_',
    'learn': 'https://appwrite.io/docs',
    'connect': 'https://appwrite.io/discord',
    'getInspired': 'https://builtwith.appwrite.io',
  });
}
