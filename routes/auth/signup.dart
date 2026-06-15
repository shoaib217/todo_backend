import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/models/user.dart';
import 'package:todo_backend/src/repositories/auth_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final repository = context.read<AuthRepository>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final user = User.fromJson({...body, 'id': 0});
    final createdUser = await repository.signUp(user);

    return Response.json(
      statusCode: HttpStatus.created,
      body: createdUser.toJson(),
    );
  } on UserAlreadyExistsException catch (e) {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {'error': e.message},
    );
  } on AuthException catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.message},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request body or missing fields'},
    );
  }
}
