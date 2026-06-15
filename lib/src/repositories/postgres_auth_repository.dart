import 'package:postgres/postgres.dart';
import 'package:todo_backend/src/exceptions/app_exceptions.dart';
import 'package:todo_backend/src/models/user.dart';
import 'package:todo_backend/src/repositories/auth_repository.dart';

class PostgresAuthRepository implements AuthRepository {
  PostgresAuthRepository(this._connection);

  final Connection _connection;

  @override
  Future<User> signUp(User user) async {
    try {
      final result = await _connection.execute(
        Sql.named(
          'INSERT INTO users (first_name, last_name, mobile_number, email, login_id, password) '
          'VALUES (@firstName, @lastName, @mobileNumber, @email, @loginId, @password) '
          'RETURNING id, first_name, last_name, mobile_number, email, login_id',
        ),
        parameters: {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'mobileNumber': user.mobileNumber,
          'email': user.email,
          'loginId': user.loginId,
          'password': user.password,
        },
      );

      final row = result.first;
      return User(
        id: row[0] as int,
        firstName: row[1] as String,
        lastName: row[2] as String,
        mobileNumber: row[3] as String,
        email: row[4] as String,
        loginId: row[5] as String,
      );
    } on ServerException catch (e) {
      if (e.code == '23505') {
        if (e.message.contains('email')) {
          throw UserAlreadyExistsException('Email already in use');
        } else if (e.message.contains('login_id')) {
          throw UserAlreadyExistsException('Login ID already in use');
        }
        throw UserAlreadyExistsException('User already exists');
      }
      rethrow;
    } catch (e) {
      throw AuthException('Failed to sign up: $e');
    }
  }

  @override
  Future<User> login(String loginId, String password) async {
    try {
      final result = await _connection.execute(
        Sql.named(
          'SELECT id, first_name, last_name, mobile_number, email, login_id FROM users '
          'WHERE login_id = @loginId AND password = @password',
        ),
        parameters: {
          'loginId': loginId,
          'password': password,
        },
      );

      if (result.isEmpty) {
        throw InvalidCredentialsException();
      }

      final row = result.first;
      return User(
        id: row[0] as int,
        firstName: row[1] as String,
        lastName: row[2] as String,
        mobileNumber: row[3] as String,
        email: row[4] as String,
        loginId: row[5] as String,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Login failed due to an unexpected error');
    }
  }
}
