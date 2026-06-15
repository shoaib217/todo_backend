import 'package:postgres/postgres.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

class PostgresTodoRepository implements TodoRepository {
  PostgresTodoRepository(this._connection);

  final Connection _connection;

  @override
  Future<List<Todo>> getAllTodos(int userId) async {
    try {
      final results = await _connection.execute(
        Sql.named('SELECT id, user_id, title, completed, due_date, priority FROM todos WHERE user_id = @userId ORDER BY id ASC'),
        parameters: {'userId': userId},
      );

      return results.map((row) {
        return Todo(
          id: row[0] as int,
          userId: row[1] as int,
          title: row[2] as String,
          completed: row[3] as bool,
          dueDate: row[4] as DateTime?,
          priority: row[5] as int,
        );
      }).toList();
    } catch (e) {
      throw TodoException('Failed to fetch todos: $e');
    }
  }

  @override
  Future<Todo> getTodoById(int id) async {
    try {
      final result = await _connection.execute(
        Sql.named('SELECT id, user_id, title, completed, due_date, priority FROM todos WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.isEmpty) {
        throw NotFoundException('Todo not found');
      }

      final row = result.first;
      return Todo(
        id: row[0] as int,
        userId: row[1] as int,
        title: row[2] as String,
        completed: row[3] as bool,
        dueDate: row[4] as DateTime?,
        priority: row[5] as int,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw TodoException('Failed to fetch todo: $e');
    }
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    try {
      final result = await _connection.execute(
        Sql.named(
          'INSERT INTO todos (user_id, title, completed, due_date, priority) '
          'VALUES (@userId, @title, @completed, @dueDate, @priority) '
          'RETURNING id, user_id, title, completed, due_date, priority',
        ),
        parameters: {
          'userId': todo.userId,
          'title': todo.title,
          'completed': todo.completed,
          'dueDate': todo.dueDate,
          'priority': todo.priority,
        },
      );

      final row = result.first;
      return Todo(
        id: row[0] as int,
        userId: row[1] as int,
        title: row[2] as String,
        completed: row[3] as bool,
        dueDate: row[4] as DateTime?,
        priority: row[5] as int,
      );
    } on ServerException catch (e) {
      if (e.code == '23503') {
        throw TodoException('User does not exist');
      }
      rethrow;
    } catch (e) {
      throw TodoException('Failed to create todo: $e');
    }
  }

  @override
  Future<Todo> updateTodo(int id, Todo todo) async {
    try {
      final result = await _connection.execute(
        Sql.named(
          'UPDATE todos SET title = @title, completed = @completed, '
          'due_date = @dueDate, priority = @priority '
          'WHERE id = @id '
          'RETURNING id, user_id, title, completed, due_date, priority',
        ),
        parameters: {
          'id': id,
          'title': todo.title,
          'completed': todo.completed,
          'dueDate': todo.dueDate,
          'priority': todo.priority,
        },
      );

      if (result.isEmpty) {
        throw NotFoundException('Todo not found');
      }

      final row = result.first;
      return Todo(
        id: row[0] as int,
        userId: row[1] as int,
        title: row[2] as String,
        completed: row[3] as bool,
        dueDate: row[4] as DateTime?,
        priority: row[5] as int,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw TodoException('Failed to update todo: $e');
    }
  }

  @override
  Future<bool> deleteTodo(int id) async {
    try {
      final result = await _connection.execute(
        Sql.named('DELETE FROM todos WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.affectedRows == 0) {
        throw NotFoundException('Todo not found');
      }
      return true;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw TodoException('Failed to delete todo: $e');
    }
  }
}
