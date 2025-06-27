# RIT GrubPoint

A food ordering app for RIT students, built with Flutter and Firebase.

## Features

- User authentication (email/password)
- Browse food items
- Add items to cart
- Place orders
- Wallet management
- Table reservations
- Order history
- User profile management

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Firebase account
- Android Studio / VS Code with Flutter extensions

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/rit-grubpoint.git
cd rit-grubpoint
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Enable Authentication (Email/Password)
   - Create Firestore database

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
  ├── main.dart
  ├── providers/
  │   ├── auth_provider.dart
  │   ├── cart_provider.dart
  │   ├── order_provider.dart
  │   └── wallet_provider.dart
  ├── screens/
  │   ├── home_screen.dart
  │   ├── login_screen.dart
  │   ├── cart_screen.dart
  │   ├── orders_screen.dart
  │   ├── wallet_page.dart
  │   ├── profile_screen.dart
  │   ├── reservation_screen.dart
  │   └── payment_page.dart
  ├── services/
  │   └── firebase_service.dart
  └── widgets/
      └── app_drawer.dart
```

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase Authentication
- `cloud_firestore`: Cloud Firestore database
- `provider`: State management
- `intl`: Internationalization and formatting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- RIT for the inspiration 
