# Implementation Plan - Custom Error Handling

Refactor the backend to provide user-friendly error messages instead of raw SQL errors or generic messages.

## User Review Required
- Custom error messages for common failures (Invalid login, Duplicate email/loginId, Missing fields).
- Standardization of error response format: `{"error": "User friendly message"}`.

## Proposed Changes

### Core Repositories

#### [postgres_auth_repository.dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/lib/src/repositories/postgres_auth_repository.dart)
- Update `signUp` to catch `PostgreSQLException` and identify unique constraint violations (email, login_id).
- Ensure `login` returns a specific indicator or throws if user is not found vs other errors.

#### [postgres_todo_repository.dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/lib/src/repositories/postgres_todo_repository.dart)
- Catch database exceptions and rethrow them as custom application exceptions or handle them gracefully to avoid leaking SQL details.

---

### Route Handlers

#### [login.dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/routes/auth/login.dart)
- Return `{"error": "Invalid username or password"}` if login fails.
- Wrap in try-catch for unexpected server errors.

#### [signup.dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/routes/auth/signup.dart)
- Catch specific repository errors like "Email already in use" and return appropriate status codes.

#### [todos/index.dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/routes/todos/index.dart)
- Improve error messages for missing `userId` or failed database operations.

#### [todos/[id].dart](file:///F:/shoaib%20sayyed/Flutter/todo_backend/routes/todos/[id].dart)
- Ensure consistent error responses for invalid IDs or not-found resources.

## Verification Plan

### Manual Verification
- Test Login with:
  - Correct credentials.
  - Wrong password.
  - Non-existent user.
- Test Signup with:
  - Duplicate email.
  - Duplicate login ID.
  - Missing fields.
- Test Todos with:
  - Missing `userId` parameter.
  - Creating todo for non-existent user.
