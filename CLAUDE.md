# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Development Commands
- **Install dependencies**: `flutter pub get`
- **Code generation**: `flutter packages pub run build_runner build --delete-conflicting-outputs`
- **Run app**: `flutter run`
- **Run tests**: `flutter test`
- **Analyze code**: `flutter analyze`
- **Clean project**: `flutter clean`

### Build Commands
- **Debug APK**: `flutter build apk --debug`
- **Release APK**: `flutter build apk --release`
- **Release AAB**: `flutter build appbundle --release`
- **Automated release build**: `./build_release.bat` (generates icons, splash, AAB, and APK)

### Testing Commands
- **Run all tests**: `flutter test`
- **Run widget tests**: `flutter test test/widget_test/`
- **Run integration tests**: `flutter test test/integration_test/`
- **OneSignal integration test**: `./test_onesignal_integration.sh`

### Code Generation Commands
- **Generate app icons**: `flutter pub run flutter_launcher_icons`
- **Generate splash screen**: `flutter pub run flutter_native_splash:create`
- **Watch mode for code generation**: `flutter packages pub run build_runner watch`

## Architecture Overview

### State Management
- **Primary**: Riverpod 2.0 with code generation (`riverpod_annotation`, `riverpod_generator`)
- **Pattern**: AsyncNotifier providers with proper error handling
- **Structure**: Each feature has dedicated providers in `providers/` folder

### Code Organization (Feature-First Architecture)
```
lib/
├── core/                    # Shared utilities and services
│   ├── config/             # App configuration (Supabase, router)
│   ├── providers/          # Global providers (auth, analytics, notifications)
│   ├── services/           # Core services (Firebase, Google Auth, analytics)
│   ├── theme/              # App theming and UI constants
│   └── utils/              # Utilities, constants, common widgets
└── features/               # Feature modules
    ├── [feature_name]/
    │   ├── controllers/    # UI controllers
    │   ├── models/         # Freezed data models
    │   ├── providers/      # Feature-specific providers
    │   ├── screens/        # UI screens
    │   ├── service/        # Supabase data services
    │   └── widgets/        # Feature-specific widgets
```

### Key Architectural Decisions
- **Routing**: GoRouter with comprehensive auth guards and state-based redirects
- **Backend**: Supabase for authentication, database, real-time features, and file storage
- **Data Models**: Freezed for immutable data classes with JSON serialization
- **Notifications**: Firebase + OneSignal dual integration with edge function webhooks
- **Image Handling**: Built-in image picker with temporary file cleanup system
- **Authentication**: Phone-based OTP with Google Sign-In fallback

### Data Flow Pattern
1. **Models**: Freezed classes with `fromJson`/`toJson` in `models/`
2. **Services**: Supabase data access in `service/` folder, returns Freezed models
3. **Providers**: AsyncNotifier providers in `providers/` with error handling
4. **Controllers**: UI logic controllers in `controllers/` for complex interactions
5. **Screens**: UI screens consuming providers in `screens/`
6. **Widgets**: Reusable components in `widgets/`

## Code Development Principles
- Always write clean, industry-level, and scalable code
- Maintain code quality and adhere to best practices
- Separate UI and business logic
  - Use Riverpod providers for business logic
  - Create providers to manage logic in UI files
- Maximum code file length: 1000 lines
- UI files should not contain business logic
- Create separate providers for complex interactions
- Use controllers to manage UI logic

## Feature Development Workflow

When creating new features, follow this exact structure from `.cursor/rules/flutter-rules.mdc`:

1. **Create folder structure**: `screens/`, `providers/`, `controllers/`, `models/`, `widgets/`, `service/`
2. **Create Freezed models first**: Define data structures with JSON serialization using `@freezed`
3. **Run code generation**: `flutter packages pub run build_runner build --delete-conflicting-outputs`
4. **Implement services**: Supabase data access in `service/` folder returning Freezed models via `fromJson`/`toJson`
5. **Create providers**: AsyncNotifier providers in `providers/` with proper error handling
6. **Build screens**: UI in `screens/` consuming providers
7. **Add controllers**: UI logic controllers in `controllers/` for complex interactions

### Development Principles from Cursor Rules
- Follow feature-first layer approach
- Keep user interface minimal and clean
- Avoid complex code and maintain proper separations
- Always use AsyncNotifier pattern for providers

## Important Configuration

### Supabase Integration
- Configuration in `lib/core/config/supabase_config.dart`
- Row Level Security (RLS) policies are critical for data access
- Real-time subscriptions used throughout the app

### Authentication Flow
- Phone-based OTP authentication via Supabase with PKCE flow
- Google Sign-In integration available as fallback
- Comprehensive auth guards in router configuration with `GoRouterRefreshStream`
- Vendor verification workflow: Authentication → Onboarding → Verification → Home
- Auth state managed through `authStateProvider` and `vendorProvider`

### Code Generation Requirements
- Run code generation after model changes: `flutter packages pub run build_runner build --delete-conflicting-outputs`
- Freezed models require `@freezed` annotation
- Riverpod providers use `@riverpod` annotation for code generation

### Build System
- Uses automated build script (`build_release.bat`) for release builds
- Includes app icon and splash screen generation
- Supports both APK and AAB output formats
- Configured for core library desugaring (Android API compatibility)

### Notification System (OneSignal + Firebase)
- **OneSignal**: Primary push notification service with edge function integration
- **Firebase**: Backup notification system and analytics
- **Edge Functions**: Supabase functions in `supabase/functions/order-notifications-onesignal/`
- **Database Webhooks**: Automatic order notification triggers via PostgreSQL functions
- **Testing**: Use `./test_onesignal_integration.sh` for comprehensive integration testing

## Development Notes

### State Management Best Practices
- Always use AsyncNotifier for data providers
- Implement proper error handling in all providers
- Use `ref.invalidate()` to refresh data when needed
- Keep UI state separate from business logic

### Navigation Guidelines
- All routes defined in `lib/core/config/router_config.dart`
- Auth guards prevent unauthorized access
- State-based redirects handle complex authentication flows
- Use `context.go()` for navigation, `context.push()` for modal flows

### Performance Considerations
- Automatic temp file cleanup system in place (cleans files older than 1 day)
- Image picker creates temporary files in `temp_images/` directory
- Real-time subscriptions are used judiciously to avoid performance issues

### Testing
- Unit tests: `flutter test`
- Widget tests in `test/widget_test/`
- Integration tests in `test/integration_test/`

## Key Dependencies

### Core Flutter Stack
- **Flutter SDK**: 3.2.3+ with Dart 3.2.3+
- **State Management**: `flutter_riverpod: ^2.4.9` with `riverpod_annotation: ^2.6.1`
- **Navigation**: `go_router: ^13.0.1` for declarative routing
- **Backend**: `supabase_flutter: ^2.3.2` for database and auth

### Notification Services
- **Firebase**: `firebase_core: ^2.24.2` + `firebase_messaging: ^14.7.10`
- **OneSignal**: `onesignal_flutter: ^5.1.2` for primary push notifications
- **Local Notifications**: `flutter_local_notifications: ^18.0.1`

### Code Generation
- **Data Classes**: `freezed: ^2.4.6` + `freezed_annotation: ^2.4.1`
- **JSON Serialization**: `json_serializable: ^6.7.1` + `json_annotation: ^4.8.1`
- **Riverpod**: `riverpod_generator: ^2.4.0` for provider code generation
- **Build Runner**: `build_runner: ^2.4.8` for running code generation

### UI and Forms
- **Forms**: `flutter_form_builder: ^9.4.1` + `form_builder_validators: ^10.0.1`
- **OTP Input**: `pin_code_fields: ^8.0.1` (replaces pinput to avoid smart_auth crashes)
- **Images**: `image_picker: ^1.0.7` + `cached_network_image: ^3.3.1`

### Development Notes
- Uses dependency overrides for `custom_lint_core: ^0.6.0` and `intl: ^0.19.0`
- Requires Android SDK 23+ due to core library desugaring
- When changing model files, remember we are using Freezed - don't edit model files that have `.g.dart` extension as they will auto-create when running `dart run build_runner build --delete-conflicting-outputs`