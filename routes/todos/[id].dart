import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final todoId = int.tryParse(id);
  if (todoId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid ID format'},
    );
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, todoId);
    case HttpMethod.put:
      return _put(context, todoId);
    case HttpMethod.delete:
      return _delete(context, todoId);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();
  try {
    final todo = await repository.getTodoById(id);
    return Response.json(body: todo.toJson());
  } on NotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } on TodoException catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.message},
    );
  }
}

Future<Response> _put(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final todo = Todo.fromJson({...body, 'id': id});
    final updatedTodo = await repository.updateTodo(id, todo);

    return Response.json(body: updatedTodo.toJson());
  } on NotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
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

Future<Response> _delete(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();
  try {
    await repository.deleteTodo(id);
    return Response(statusCode: HttpStatus.noContent);
  } on NotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } on TodoException catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.message},
    );
  }
}
