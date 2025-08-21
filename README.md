# 🛍️ SyloNow Vendor

**A powerful Flutter-based mobile application for service vendors to manage their business operations seamlessly.**

[![Flutter](https://img.shields.io/badge/Flutter-3.2.3+-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2.3+-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=flat)](LICENSE)

---

## 📱 About

SyloNow Vendor is a comprehensive mobile application designed to empower service vendors with tools to efficiently manage their business operations. From service listings to order management, the app provides a complete ecosystem for vendors to grow their business.

### 🎯 Key Features

- **🏠 Dashboard** - Comprehensive business analytics and overview
- **📋 Service Management** - Create, edit, and manage service listings
- **📦 Order Management** - Track and fulfill customer orders
- **👤 Profile Management** - Vendor profile and business information
- **💰 Wallet Integration** - Financial transactions and earnings tracking
- **🔔 Notifications** - Real-time updates and alerts
- **📞 Support System** - Customer support and help desk

### 🏗️ Architecture

Built with **Clean Architecture** principles and modern Flutter practices:

- **State Management**: Riverpod 2.0 with code generation
- **Routing**: GoRouter for declarative navigation
- **Backend**: Supabase for authentication, database, and real-time features
- **UI/UX**: Material Design 3 with custom theming
- **Code Generation**: Freezed for immutable data classes

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.2.3 or higher
- **Dart SDK**: 3.2.3 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK**: API level 23+ (Android 6.0+)
- **iOS**: iOS 12.0+ (for iOS development)

### 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/sylonow_vendor.git
   cd sylonow_vendor
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Setup Supabase Configuration**
   - Copy `lib/core/config/supabase_config.dart.example` to `lib/core/config/supabase_config.dart`
   - Add your Supabase URL and API keys

5. **Run the app**
   ```bash
   flutter run
   ```

### 🔧 Configuration

#### Supabase Setup
```dart
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

#### Android Configuration
The app requires Android SDK 23+ and includes:
- Core library desugaring for modern Java APIs
- Local notifications support
- Image picker capabilities
- Permission handling

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── providers/       # Global providers
│   ├── services/        # Core services
│   ├── theme/           # App theming
│   └── utils/           # Utilities and constants
├── features/
│   ├── home/            # Dashboard and home screen
│   ├── onboarding/      # Authentication and onboarding
│   ├── orders/          # Order management
│   ├── profile/         # User profile management
│   ├── service_listings/# Service creation and management
│   ├── support/         # Customer support
│   └── wallet/          # Financial management
├── splash/              # Splash screen
└── main.dart           # App entry point
```

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Riverpod** - State management with code generation
- **GoRouter** - Declarative routing
- **Freezed** - Immutable data classes

### Backend & Services
- **Supabase** - Backend-as-a-Service
  - Authentication
  - PostgreSQL Database
  - Real-time subscriptions
  - File storage
- **Local Notifications** - Push notifications

### Development Tools
- **Build Runner** - Code generation
- **Flutter Launcher Icons** - App icon generation
- **Flutter Native Splash** - Splash screen generation
- **Flutter Lints** - Code analysis

---

## 🔐 Authentication

The app supports multiple authentication methods:

- **📱 Phone Authentication** - OTP-based verification
- **🔐 Supabase Auth** - Secure authentication backend

---

## 📊 Features Overview

### 🏠 Dashboard
- Business performance metrics
- Recent orders summary
- Revenue analytics
- Quick action buttons

### 📋 Service Management
- Create new service listings
- Upload service images
- Set pricing and availability
- Manage service categories

### 📦 Order Management
- View incoming orders
- Update order status
- Customer communication
- Order history

### 👤 Profile Management
- Vendor information
- Business verification
- Contact details
- Settings and preferences

### 💰 Wallet
- Earnings tracking
- Transaction history
- Payout management
- Financial reports

---

## 🧪 Testing

Run tests using:

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test/

# Integration tests
flutter test test/integration_test/
```

---

## 📱 Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Run `flutter analyze` before committing

---

## 🐛 Troubleshooting

### Common Issues

**Build Failures**
- Ensure Flutter SDK is updated
- Run `flutter clean && flutter pub get`
- Check Android SDK requirements

**Core Library Desugaring Issues**
- Verify Android configuration includes desugaring
- Check `android/app/build.gradle.kts` settings

**State Management**
- Regenerate code: `flutter packages pub run build_runner build --delete-conflicting-outputs`

---

## 📞 Support

For support and questions:
- 📧 Email: support@sylonow.com
- 📱 Documentation: [docs.sylonow.com](https://docs.sylonow.com)
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/sylonow_vendor/issues)

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the powerful backend
- Riverpod community for excellent state management
- All contributors and beta testers

---

<div align="center">
  <img src="assets/images/app_logo_new.png" alt="SyloNow Logo" width="64">
  
  **Built with ❤️ using Flutter**
  
  [Website](https://sylonow.com) • [Support](mailto:support@sylonow.com) • [Privacy](https://sylonow.com/privacy)
</div>
