import 'package:test/test.dart';
import 'package:todo_backend/src/models/todo.dart';

void main() {
  group('Todo', () {
    test('supports value comparisons', () {
      expect(
        Todo(id: 1, title: 'test', userId: 0),
        Todo(id: 1, title: 'test', userId: 0),
      );
    });

    test('fromJson works correctly', () {
      final json = {
        'id': 1,
        'title': 'test',
        'completed': true,
        'priority': 1,
      };
      final todo = Todo.fromJson(json);
      expect(todo.id, 1);
      expect(todo.title, 'test');
      expect(todo.completed, true);
      expect(todo.priority, 1);
    });

    test('toJson works correctly', () {
      final todo = Todo(id: 1, title: 'test', completed: true, userId: 0);
      final json = todo.toJson();
      expect(json['id'], 1);
      expect(json['title'], 'test');
      expect(json['completed'], true);
    });
  });
}
