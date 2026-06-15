class AppException implements Exception {
  AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message);
}

class UserAlreadyExistsException extends AuthException {
  UserAlreadyExistsException(super.message);
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid login_id or password');
}

class TodoException extends AppException {
  TodoException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}
