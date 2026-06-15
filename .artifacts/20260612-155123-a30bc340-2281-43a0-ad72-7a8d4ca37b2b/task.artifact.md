# Tasks

- [x] Refactor error handling in repository and routes
    - [x] Update `PostgresAuthRepository` to throw descriptive exceptions or handle errors better
    - [x] Update `PostgresTodoRepository` to throw descriptive exceptions
    - [x] Update route handlers to catch specific exceptions and return custom error messages
        - [x] `auth/login.dart`
        - [x] `auth/signup.dart`
        - [x] `todos/index.dart`
        - [x] `todos/[id].dart`
- [x] Verify changes with manual testing or unit tests
