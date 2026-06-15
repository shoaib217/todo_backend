import 'package:todo_backend/src/models/user.dart';

abstract class AuthRepository {
  /// Signs up a new user.
  /// Throws [AuthException] if signup fails.
  Future<User> signUp(User user);

  /// Logs in a user.
  /// Throws [AuthException] if login fails.
  Future<User> login(String loginId, String password);
}
