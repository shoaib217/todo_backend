import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:todo_backend/src/repositories/postgres_todo_repository.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

// Use a singleton for the repository in a real production app or handle connection pooling
TodoRepository? _todoRepository;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<TodoRepository>((context) => _todoRepository!))
      .use(
        (handler) {
          return (context) async {
            if (_todoRepository == null) {
              final connection = await Connection.open(
                Endpoint(
                  host: '127.0.0.1',
                  database: 'todo_db',
                  username: 'postgres',
                  password: 'shoaibsayyed',
                ),
                settings: const ConnectionSettings(sslMode: SslMode.disable),
              );
              _todoRepository = PostgresTodoRepository(connection);
            }
            return handler(context);
          };
        },
      );
}
