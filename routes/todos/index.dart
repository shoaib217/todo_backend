import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final repository = context.read<TodoRepository>();
  final todos = await repository.getAllTodos();
  return Response.json(body: todos.map((e) => e.toJson()).toList());
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
  } catch (e, st) {
    print('Error in POST /todos: $e');
    print(st);
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request body', 'details': e.toString()},
    );
  }
}
