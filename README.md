# RIT GrubPoint

A food ordering app for RIT students with wallet payment system and reservation features.

## Features

- Food ordering from campus eateries
- Wallet-based payment system
- Firebase Phone Auth for OTP verification
- UPI payment QR code generation
- Table reservations (6 AM - 6 PM)
- User profiles and favorites
- Cart management

## Getting Started

### Environment Setup

Create a file named `.env` in the `assets/` directory with the following content:

```
# Firebase Configuration
FIREBASE_API_KEY=your-api-key-here
FIREBASE_APP_ID=your-app-id-here  
FIREBASE_MESSAGING_SENDER_ID=your-sender-id-here
FIREBASE_PROJECT_ID=your-project-id-here
FIREBASE_STORAGE_BUCKET=your-storage-bucket-here

# Google Auth
GOOGLE_AUTH_CLIENT_ID=your-client-id-here
```

Replace the placeholder values with your actual Firebase project credentials.

### Running the App

1. Ensure Flutter SDK is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app in debug mode

## Development

This project uses Flutter and Firebase for backend services:

- Firebase Authentication for user accounts and phone verification
- Firestore for storing menu items, user data, and reservation information
- Firebase Storage for images

## Contribution

Contributions are welcome! Please create a pull request for any enhancements or bug fixes.
