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
- **Notifications**: Firebase + OneSignal integration
- **Image Handling**: Built-in image picker with temporary file cleanup system

### Data Flow Pattern
1. **Models**: Freezed classes with `fromJson`/`toJson` in `models/`
2. **Services**: Supabase data access in `service/` folder, returns Freezed models
3. **Providers**: AsyncNotifier providers in `providers/` with error handling
4. **Controllers**: UI logic controllers in `controllers/` for complex interactions
5. **Screens**: UI screens consuming providers in `screens/`
6. **Widgets**: Reusable components in `widgets/`

## Feature Development Workflow

When creating new features, follow this exact structure from `.cursor/rules/flutter-rules.mdc`:

1. **Create folder structure**: `screens/`, `providers/`, `controllers/`, `models/`, `widgets/`, `service/`
2. **Create Freezed models**: Define data structures with JSON serialization
3. **Implement services**: Supabase data access returning Freezed models
4. **Create providers**: AsyncNotifier providers with error handling
5. **Build screens**: UI consuming providers
6. **Add controllers**: UI logic control for complex interactions

## Important Configuration

### Supabase Integration
- Configuration in `lib/core/config/supabase_config.dart`
- Row Level Security (RLS) policies are critical for data access
- Real-time subscriptions used throughout the app

### Authentication Flow
- Phone-based OTP authentication via Supabase
- Google Sign-In integration available
- Comprehensive auth guards in router configuration
- Vendor verification workflow: Authentication → Onboarding → Verification → Home

### Code Generation Requirements
- Run code generation after model changes: `flutter packages pub run build_runner build --delete-conflicting-outputs`
- Freezed models require `@freezed` annotation
- Riverpod providers use `@riverpod` annotation for code generation

### Build System
- Uses automated build script (`build_release.bat`) for release builds
- Includes app icon and splash screen generation
- Supports both APK and AAB output formats
- Configured for core library desugaring (Android API compatibility)

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