# Walkthrough - Custom Error Handling

I have refactored the backend to provide descriptive, user-friendly error messages instead of raw database errors.

## Changes Overview

### 1. Custom Exceptions
Created a centralized exception system in `lib/src/exceptions/app_exceptions.dart`:
- `AuthException`: Base for all authentication errors.
- `InvalidCredentialsException`: Thrown when login fails.
- `UserAlreadyExistsException`: Thrown when signup fails due to duplicate email or login ID.
- `TodoException`: Base for all todo-related errors.
- `NotFoundException`: Thrown when a resource (like a specific todo) is not found.

### 2. Repository Refactoring
Updated `PostgresAuthRepository` and `PostgresTodoRepository` to:
- Catch specific PostgreSQL error codes (e.g., `23505` for unique violations).
- Throw the new custom exceptions with descriptive messages.
- Hide raw SQL details from being passed up to the UI.

### 3. Route Handler Updates
Updated all route handlers to catch these specific exceptions and return appropriate HTTP status codes and JSON error bodies:
- **Login**: Now returns `401 Unauthorized` with `{"error": "Invalid login_id or password"}` if the user is not found.
- **Signup**: Returns `409 Conflict` with specific messages like `{"error": "Email already in use"}`.
- **Todos**: Returns `404 Not Found` for missing items and `400 Bad Request` for invalid operations.

## Verification Results
- Verified that `PostgresAuthRepository` correctly identifies unique violations for `email` and `login_id`.
- Verified that route handlers catch these exceptions and return the standard `{"error": "message"}` format.
- Code analysis confirms all files are syntactically correct and follow the new repository interfaces.
