# Use the official Dart image
FROM dart:stable AS build

WORKDIR /app

# Copy pubspec.yaml and pubspec.lock
COPY pubspec.* ./
RUN dart pub get

# Copy the rest of the application
COPY . .

# Generate serialization code
RUN dart run build_runner build --delete-conflicting-outputs

# Create a production build
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Final stage
FROM dart:stable

WORKDIR /app
COPY --from=build /app/build /app/build

# Start the server
EXPOSE 8080
CMD ["dart", "build/bin/main.dart"]
