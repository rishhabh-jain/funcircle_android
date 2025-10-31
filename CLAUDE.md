# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fun Circle (faceout social) is a Flutter mobile application for connecting people to play badminton and other social activities. The app is built using FlutterFlow and uses Firebase for authentication, Firestore for chat/notifications, and Supabase as the primary database for user profiles, venues, groups, requests, and ticketing.

## Build Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run on device/emulator (debug mode)
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Hot reload is available during development (press 'r' in terminal)
```

### Testing
```bash
# Run tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

### Building
```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android - for Play Store)
flutter build appbundle

# Build iOS (requires macOS and Xcode)
flutter build ios

# Build for web
flutter build web
```

### Linting
```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format .
```

## Architecture

### Data Layer - Dual Backend System

The app uses a **dual backend architecture**:

1. **Firebase (Firestore)** - Legacy chat and notifications:
   - `/backend/backend.dart` - Firestore queries and pagination
   - Collections: `users`, `chats`, `chat_messages`, `notifications`, `contact`, `glitches`
   - Schema definitions in `/backend/schema/`
   - Authentication via Firebase Auth with email, Google, Apple sign-in
   - **Note**: Firebase chat is legacy - new chat system is in Supabase

2. **Supabase (PostgreSQL)** - Primary database for:
   - **Chat System** (`chat` schema in Supabase):
     - `chat.rooms` - Single and group chat rooms
     - `chat.room_members` - Room membership with roles (admin/moderator/member)
     - `chat.messages` - Messages with media, replies, reactions, sharing
     - `chat.message_reactions` - Emoji reactions
     - `chat.message_read_status` - Read receipts
     - `chat.typing_indicators` - Real-time typing status
     - Views: `chat.room_details`, `chat.message_details` for aggregated data
     - See `Schemma.md` for complete schema
   - User profiles and profile completion status
   - Venues and venue information
   - Groups (squads) and group categories
   - Tickets and orders
   - Requests (game requests and duo requests)
   - User interests, prompts, likes, and connections
   - Database tables in `/backend/supabase/database/tables/`
   - Initialization in `/backend/supabase/supabase.dart`

### State Management

- **Provider pattern** for global state
- `FFAppState` (`/app_state.dart`) manages:
  - Shopping cart for tickets
  - User location data
  - Tutorial/onboarding status
  - Temporary UI state
  - Uses `SharedPreferences` for persistence

### Authentication Flow

- Multi-provider authentication managed by `/auth/auth_manager.dart`
- Firebase Auth providers: Email, Google (`google_auth.dart`), Apple (`apple_auth.dart`), Anonymous, JWT
- `firebase_user_provider.dart` creates the auth user stream
- Automatic Firestore user document creation on first login (`maybeCreateUser`)
- Integration with RevenueCat for subscription management

### Navigation

- **GoRouter** for declarative routing
- Main navigation structure in `lib/index.dart`
- Bottom navigation bar with 4 tabs:
  - `HomeNew` - Home feed
  - `findPlayersNew` - Player discovery
  - `playnew` - Game/play section
  - `VenuesNew` - Venue listings
- Deep linking support via Firebase Dynamic Links (`/backend/firebase_dynamic_links/`)

### Chat System Architecture

The app has a comprehensive chat system built on Supabase (see `Schemma.md`):

- **Main Chat Screen**: `chatsnew` - displays all chat rooms user has joined
- **Chat Types**:
  - Single (1-on-1 DMs)
  - Group (multi-user rooms with max_members limit)
- **Key Features**:
  - Rich media messages (text, image, video, file)
  - Special message types: match_share, ticket_share, system notifications
  - Message reactions with emoji
  - Read receipts via `message_read_status`
  - Real-time typing indicators (10 second expiry)
  - Reply/threading support
  - Message editing and soft deletion
  - Room member roles: admin, moderator, member
  - Mute and ban functionality
  - Sport-type specific rooms
  - Venue-linked chat rooms
- **Database Views**:
  - `chat.room_details` - Aggregates room info with member count, last message
  - `chat.message_details` - Joins messages with sender info, reactions, reply context
- **Indexes**: Optimized for room_id, sender_id, created_at queries

### Feature Organization

```
lib/
├── mainscreens/          # Primary app screens (home, search, social, chat)
├── sidescreens/          # Secondary screens (settings, premium, notifications, etc.)
├── pages/                # Special pages (onboarding)
├── profilequestions1/    # Profile setup flow (name, images, preferences)
├── profillequestions2/   # Extended profile (interests, prompts, bio)
├── verification/         # Auth screens (signup, login, OTP)
├── funcirclefinalapp/    # Main app features (home, venues, play)
├── funcirclewebview/     # WebView-based screens for web content
├── components/           # Reusable UI components (navbar, modals)
├── custom_code/          # Custom Flutter widgets and actions
│   ├── widgets/          # Custom widgets (webview controllers, form fields)
│   └── actions/          # Custom actions (GPS, status bar, cart updates)
├── flutter_flow/         # FlutterFlow generated utilities
│   ├── flutter_flow_theme.dart
│   ├── flutter_flow_util.dart
│   ├── internationalization.dart  # i18n (English, Hindi)
│   └── revenue_cat_util.dart
└── backend/
    ├── backend.dart           # Firestore integration
    ├── supabase/             # Supabase integration
    ├── firebase/             # Firebase config
    ├── razorpay/             # Payment integration
    ├── push_notifications/   # FCM notifications
    └── cloud_functions/      # Firebase Cloud Functions
```

### Custom Code

- Custom actions in `/custom_code/actions/`:
  - `turnOnGPS()` - Location services
  - `changeStatusBarColor()` - UI customization (called on app start)
  - `updateCart()` - Shopping cart logic

- Custom widgets in `/custom_code/widgets/`:
  - Form field widgets for profile setup (height select, radio buttons)
  - WebView wrappers with URL tracking
  - Safe area spacers

### Payment Integration

- **Razorpay** for payments (`/backend/razorpay/`)
- Platform-specific implementations (web vs mobile)
- Order processing and response handling
- Ticket purchase flow through cart system

### Theme & Styling

- `FlutterFlowTheme` provides consistent theming
- Dark theme with primary color `#121212`
- Custom icon fonts in `assets/fonts/`
- Material Design with `useMaterial3: false`

### Internationalization

- Supported locales: English (`en`), Hindi (`hi`)
- `FFLocalizations` in `flutter_flow/internationalization.dart`
- Translations integrated throughout the app

## Key Patterns

### FlutterFlow Code Structure
This is a **FlutterFlow-generated project**. Key implications:
- Each screen has a `_widget.dart` and `_model.dart` pair
- Models extend `FlutterFlowModel` for state management
- Widgets use FlutterFlow's component system
- Custom code is isolated in `/custom_code/`
- When modifying screens, preserve FlutterFlow's generation structure

### Data Fetching
- **Firebase**: Stream-based for real-time updates (`queryUsersRecord`, `queryChatsRecord`)
- **Supabase**:
  - Table-specific query methods in `/backend/supabase/database/tables/`
  - Chat system uses Supabase real-time subscriptions for live updates
  - Database views (`chat.room_details`, `chat.message_details`) provide pre-joined data
  - Direct SQL queries via `SupaFlow.client` for complex operations
- Infinite scroll pagination using `infinite_scroll_pagination` package
- Both backends use proper error handling and null safety

### Error Handling
- Firebase Crashlytics for crash reporting (non-web)
- `safeGet()` utility for safe data deserialization
- Error callbacks in query functions

## Important Notes

- **Firebase config**: Contains hardcoded API keys in `firebase_config.dart` and `supabase.dart` - these are public anon keys
- **FlutterFlow sync**: Be cautious when modifying generated files - changes may be overwritten
- **Platform differences**: Web vs mobile implementations differ for payments, webviews, and auth
- **RevenueCat keys**: Subscription keys are in `main.dart`
- The app requires both Firebase and Supabase to be properly initialized on startup
- Location permissions must be granted for venue discovery features
- Push notifications are configured via FCM
- **Chat system migration**: The app has both Firebase Firestore chat (legacy) and Supabase chat (current). The main chat screen (`chatsnew`) uses the Supabase chat schema. Refer to `Schemma.md` for the complete database schema.
