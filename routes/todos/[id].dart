import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final todoId = int.tryParse(id);
  if (todoId == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, todoId);
    case HttpMethod.put:
      return _put(context, todoId);
    case HttpMethod.delete:
      return _delete(context, todoId);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();
  final todo = await repository.getTodoById(id);

  if (todo == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: todo.toJson());
}

Future<Response> _put(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final todo = Todo.fromJson({...body, 'id': id});
    final updatedTodo = await repository.updateTodo(id, todo);

    if (updatedTodo == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response.json(body: updatedTodo.toJson());
  } catch (e, st) {
    print('Error in PUT /todos/$id: $e');
    print(st);
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request body', 'details': e.toString()},
    );
  }
}

Future<Response> _delete(RequestContext context, int id) async {
  final repository = context.read<TodoRepository>();
  final deleted = await repository.deleteTodo(id);

  if (!deleted) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response(statusCode: HttpStatus.noContent);
}
