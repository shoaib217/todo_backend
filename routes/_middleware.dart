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
      )
      .use(_corsMiddleware);
}

Handler _corsMiddleware(Handler handler) {
  return (context) async {
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS, PATCH',
      'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization, Accept, X-Requested-With',
    };

    if (context.request.method == HttpMethod.options) {
      return Response(
        statusCode: 204,
        headers: corsHeaders,
      );
    }
    
    try {
      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          ...corsHeaders,
        },
      );
    } catch (e, stackTrace) {
      print('Error in backend: $e\n$stackTrace');
      return Response.json(
        statusCode: 500,
        body: {'error': 'Internal Server Error: $e'},
        headers: corsHeaders,
      );
    }
  };
}
