import 'package:todo_backend/src/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodoById(int id);
  Future<Todo> createTodo(Todo todo);
  Future<Todo?> updateTodo(int id, Todo todo);
  Future<bool> deleteTodo(int id);
}
