import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:todo_backend/src/repositories/postgres_auth_repository.dart';
import 'package:todo_backend/src/repositories/postgres_todo_repository.dart';
import 'package:todo_backend/src/repositories/auth_repository.dart';
import 'package:todo_backend/src/repositories/todo_repository.dart';

TodoRepository? _todoRepository;
AuthRepository? _authRepository;
Connection? _connection;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<TodoRepository>((context) => _todoRepository!))
      .use(provider<AuthRepository>((context) => _authRepository!))
      .use(
        (handler) {
          return (context) async {
            if (_connection == null) {
              _connection = await Connection.open(
                Endpoint(
                  host: '127.0.0.1',
                  database: 'todo_db',
                  username: 'postgres',
                  password: 'shoaibsayyed',
                ),
                settings: const ConnectionSettings(sslMode: SslMode.disable),
              );
              _todoRepository = PostgresTodoRepository(_connection!);
              _authRepository = PostgresAuthRepository(_connection!);
            }
            return handler(context);
          };
        },
      );
}
