# Todo Backend (Dart Frog)

This is a production-ready Dart Frog backend for the Todo Application.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart)
- [Dart Frog CLI](https://dartfrog.vgv.dev/docs/overview#installation)
- [PostgreSQL](https://www.postgresql.org/)

## Getting Started

1.  **Install dependencies:**
    ```bash
    dart pub get
    ```

2.  **Generate JSON serialization code:**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Setup Database:**
    - Create a PostgreSQL database named `todo_db`.
    - Run the schema script in `database.sql`.

4.  **Configure Connection:**
    - Update `routes/_middleware.dart` with your database credentials (host, user, password).

5.  **Run the server:**
    ```bash
    dart_frog dev
    ```

## API Endpoints

- `GET /todos` - Get all todos
- `POST /todos` - Create a new todo
- `GET /todos/<id>` - Get a specific todo
- `PUT /todos/<id>` - Update a todo
- `DELETE /todos/<id>` - Delete a todo

## Testing

Run tests with:
```bash
dart test
```
