import 'package:postgres/postgres.dart';
import 'package:todo_backend/src/models/todo.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

class PostgresTodoRepository implements TodoRepository {
  PostgresTodoRepository(this._connection);

  final Connection _connection;

  @override
  Future<List<Todo>> getAllTodos() async {
    final results = await _connection.execute(
      'SELECT id, title, completed, due_date, priority FROM todos ORDER BY id ASC',
    );

    return results.map((row) {
      return Todo(
        id: row[0] as int,
        title: row[1] as String,
        completed: row[2] as bool,
        dueDate: row[3] as DateTime?,
        priority: row[4] as int,
      );
    }).toList();
  }

  @override
  Future<Todo?> getTodoById(int id) async {
    final result = await _connection.execute(
      Sql.named('SELECT id, title, completed, due_date, priority FROM todos WHERE id = @id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return Todo(
      id: row[0] as int,
      title: row[1] as String,
      completed: row[2] as bool,
      dueDate: row[3] as DateTime?,
      priority: row[4] as int,
    );
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    final result = await _connection.execute(
      Sql.named(
        'INSERT INTO todos (title, completed, due_date, priority) '
        'VALUES (@title, @completed, @dueDate, @priority) '
        'RETURNING id, title, completed, due_date, priority',
      ),
      parameters: {
        'title': todo.title,
        'completed': todo.completed,
        'dueDate': todo.dueDate,
        'priority': todo.priority,
      },
    );

    final row = result.first;
    return Todo(
      id: row[0] as int,
      title: row[1] as String,
      completed: row[2] as bool,
      dueDate: row[3] as DateTime?,
      priority: row[4] as int,
    );
  }

  @override
  Future<Todo?> updateTodo(int id, Todo todo) async {
    final result = await _connection.execute(
      Sql.named(
        'UPDATE todos SET title = @title, completed = @completed, '
        'due_date = @dueDate, priority = @priority '
        'WHERE id = @id '
        'RETURNING id, title, completed, due_date, priority',
      ),
      parameters: {
        'id': id,
        'title': todo.title,
        'completed': todo.completed,
        'dueDate': todo.dueDate,
        'priority': todo.priority,
      },
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return Todo(
      id: row[0] as int,
      title: row[1] as String,
      completed: row[2] as bool,
      dueDate: row[3] as DateTime?,
      priority: row[4] as int,
    );
  }

  @override
  Future<bool> deleteTodo(int id) async {
    final result = await _connection.execute(
      Sql.named('DELETE FROM todos WHERE id = @id'),
      parameters: {'id': id},
    );

    return result.affectedRows > 0;
  }
}
