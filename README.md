# TotalX

## Why am i using both firebase and supabase in this project.

Initially, as per the task document, I implemented phone authentication using MSG91 and managed user data (add, search, sort) using Supabase so I can use images as well when adding data.
Later, due to DLT registration requirements (which require organization-level approval), I was advised to switch to Google Sign-In and keep the MSG91 code without removing it.
To implement Google Sign In with Supabase, it requires Google Cloud OAuth setup (client ID), which needs billing access. Since that was not feasible, I integrated Firebase Authentication for Google Sign-In instead.
After successful login via Firebase, user data is stored and managed in Supabase as before.
Current flow:
Firebase Authentication → Supabase Database


## Packages Used
- provider → State management
- sendotp_flutter_sdk → MSG91 OTP authentication
- flutter_dotenv → Secure API key management
- dio → API handling
- shared_preferences → Local storage
- supabase_flutter → Backend (users, search, pagination)
- image_picker → Image selection
- google_sign_in → Google authentication
- firebase_auth → Firebase authentication

---

## Architecture
Used MVVM with Clean Architecture principles for clear separation of concerns.

### Folder Structure
lib/
 ├── core/
 │   ├── enums/
 │   ├── utils/
 │   └── widgets/
 ├── features/
 │   ├── auth/
 │   │   ├── data/
 │   │   ├── domain/
 │   │   └── presentation/
 │   └── users/
 │       ├── data/
 │       ├── domain/
 │       └── presentation/
 └── main.dart

---

## Error Handling
- No internet → shows error message with retry button  
- Supports retry when connection is restored  

---

## Authentication Flow

### Old Flow (Reference)
- Phone number login (10 digits)
- OTP via MSG91 (API returns 200 OK)
- SMS not delivered due to pending DLT approval
- Demo OTP used: **123456**

### Current Flow
- Google Sign-In using Firebase
- Firebase UID generated
- User stored in Supabase
- Navigate to Home screen

---

## User Features

### Add User
- Form dialog with:
  - Name
  - Age
  - Image (validated)

### Data Handling
- Supabase (no auth)
- API keys stored in `.env`

### Features
- Pagination implemented 
- Search (name & age)
- Sort users (above/below 60)
- Double back press to exit
- PopScope for search handling

---

## Key Highlights
- Clean architecture implemented
- Scalable structure
- Secure environment variables
- Efficient data loading with pagination
- no intrenet error handled with retry button and triggering data again once data back.
