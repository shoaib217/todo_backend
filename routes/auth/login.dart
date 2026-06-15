import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/repositories/auth_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final repository = context.read<AuthRepository>();
  
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final loginId = body['login_id'] as String?;
    final password = body['password'] as String?;

    if (loginId == null || password == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'login_id and password are required'},
      );
    }

    final user = await repository.login(loginId, password);
    return Response.json(body: user.toJson());
  } on InvalidCredentialsException {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Invalid login_id or password'},
    );
  } on AuthException catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.message},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request format'},
    );
  }
}
