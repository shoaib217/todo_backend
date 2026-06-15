import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final repository = context.read<TodoRepository>();
  final params = context.request.uri.queryParameters;
  final userId = int.tryParse(params['userId'] ?? '');

  if (userId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'userId is required as a query parameter'},
    );
  }

  try {
    final todos = await repository.getAllTodos(userId);
    return Response.json(body: todos.map((e) => e.toJson()).toList());
  } on TodoException catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.message},
    );
  }
}

Future<Response> _post(RequestContext context) async {
  final repository = context.read<TodoRepository>();
  
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    // ID is ignored as it's auto-generated in DB
    final todo = Todo.fromJson({...body, 'id': 0});
    final createdTodo = await repository.createTodo(todo);
    return Response.json(
      statusCode: HttpStatus.created,
      body: createdTodo.toJson(),
    );
  } on TodoException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.message},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request body'},
    );
  }
}
