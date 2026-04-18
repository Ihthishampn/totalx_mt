# totalx

### Packages Used

- **provider: ^6.1.5+1** - State management solution for Flutter, used for managing app state across screens.
- **sendotp_flutter_sdk: ^0.0.2** - SDK for MSG91 phone authentication, handles OTP sending and verification.
- **flutter_dotenv: ^5.0.4** - Loads environment variables from a .env file for secure API keys and configurations.
- **dio: ^5.9.2** - HTTP client for making API requests, used for MSG91 OTP services.
- **shared_preferences: ^2.2.2** - Local storage for simple key-value data, used for saving login sessions and OTP responses.
- **supabase_flutter: ^2.12.4** - Flutter client for Supabase, used for storing user data, active sort, search, and pagination.
- **image_picker: ^1.2.1** - Allows picking images from gallery or camera for user profile uploads.

### Architecture & Folder Structure

Used **MVVM (Model-View-ViewModel)** architecture for clean separation of concerns. Folder structure follows Clean Architecture principles:

- **lib/features/** - Feature-based organization (auth, users).
  - **auth/** - Authentication logic (domain, data, presentation layers).
  - **users/** - User management (domain, data, presentation layers).
- **lib/core/** - Shared utilities (enums, utils, widgets).
- **lib/main.dart** - App entry point.
- **assets/** - Static assets like images.
- **.env** - Environment variables for API keys.

### Login Flow

1. **Login Screen**: User enters phone number (10 digits max).
2. **OTP Screen**: Sends OTP via MSG91 server (returns 200 success). Shows 60-second timer.
3. **Resend**: Can resend after 60 seconds (timer resets).
4. **Demo OTP**: After 3 sec OTP sends, `123456` becomes available for login. This is because we have no DLT template (no organization owned by me), so real OTPs don't reach the device. Code shows server success (200), but no actual SMS delivery. Demo OTP bypasses this for testing.

### User Screen

- **Add Floating Button**: Opens dialog for adding users with proper form validation (name, phone, age, image).
- **Data Fetching**: Uses Supabase with direct URL (no auth required), keys stored in .env file. Implements lazy loading with pagination via Supabase `.range()`, search by name/phone, and sorting by age (above/below 60).
