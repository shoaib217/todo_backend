# Frontend Implementation Plan - Centralized Error Handling

Integrate the new backend error messages into the Flutter frontend using a clean, centralized approach.

## Proposed Changes

### 1. Custom Exception Class
Create `lib/src/exceptions/api_exception.dart` (or similar) to handle domain-specific API errors.

### 2. Dio Error Utility
Create a utility to parse `DioException` and extract the `{"error": "message"}` payload from the backend.

### 3. Update ApiServices
Refactor `TodoApiService` and `AuthApiService` to catch `DioException` and throw `ApiException`.

## Verification
- Test with invalid login to ensure the SnackBar shows the correct message.
- Test with duplicate signup.
- Test with server offline to verify timeout/connection error messages.
