# Firebase reCAPTCHA Configuration Guide

## Current Status

The app now uses **invisible reCAPTCHA** for web platform, which makes the bot verification automatic and less intrusive.

## Understanding reCAPTCHA in Phone Authentication

When users sign in with phone numbers, Firebase uses reCAPTCHA to prevent bot abuse and protect your app. On mobile devices (Android/iOS), this appears as a Chrome Custom Tab showing "Verifying you are not a bot".

### Why reCAPTCHA Appears

Firebase requires reCAPTCHA for phone authentication as a security measure to:
- Prevent automated bot attacks
- Protect against SMS abuse
- Ensure legitimate users

## What We've Implemented

### ✅ Web Platform
- **Invisible reCAPTCHA** is now configured
- Users won't see the "I'm not a robot" checkbox
- Verification happens automatically in the background
- Located in `/web/index.html` and `/web/recaptcha_config.js`

### 🔧 Mobile Platform (Android/iOS)
The Chrome Custom Tab that appears is controlled by Firebase SDK. We cannot completely remove it, but we can reduce its frequency.

## Reducing reCAPTCHA Frequency on Mobile

### Option 1: Firebase App Check (Recommended)

Firebase App Check can significantly reduce reCAPTCHA challenges by verifying that requests come from your authentic app.

#### For Android - Play Integrity API:

1. **Enable Play Integrity API in Google Cloud Console:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Select your project: `faceout-b996d`
   - Enable the **Play Integrity API**

2. **Configure App Check in Firebase Console:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project
   - Navigate to **Build** → **App Check**
   - Register your Android app
   - Select **Play Integrity** as the provider
   - Enable enforcement for **Phone Auth**

3. **Add App Check to your Flutter app:**
   ```bash
   flutter pub add firebase_app_check
   ```

4. **Initialize App Check in `lib/main.dart`:**
   ```dart
   import 'package:firebase_app_check/firebase_app_check.dart';

   // In main() before runApp():
   await FirebaseAppCheck.instance.activate(
     androidProvider: AndroidProvider.playIntegrity,
   );
   ```

#### For iOS - App Attest:

1. **Configure App Check in Firebase Console:**
   - Navigate to **Build** → **App Check**
   - Register your iOS app
   - Select **App Attest** as the provider

2. **Update initialization:**
   ```dart
   await FirebaseAppCheck.instance.activate(
     androidProvider: AndroidProvider.playIntegrity,
     appleProvider: AppleProvider.appAttest,
   );
   ```

### Option 2: SafetyNet (Android - Being deprecated)

SafetyNet is Google's older integrity checking API. It's being replaced by Play Integrity API, but can still be used:

1. Enable SafetyNet API in Google Cloud Console
2. Follow similar steps as Play Integrity API

### Option 3: Better iOS Configuration

Ensure APNs (Apple Push Notification service) is properly configured:
- This allows Firebase to use silent notifications for phone auth
- Reduces or eliminates reCAPTCHA on iOS
- Guide: https://firebase.google.com/docs/auth/ios/phone-auth#start-receiving-silent-notifications

## Testing Changes

After implementing App Check:

1. **Test on a real device** (not emulator initially)
2. **First-time users** may still see reCAPTCHA
3. **Returning users** should rarely or never see it
4. Monitor in Firebase Console → App Check → Metrics

## Current Configuration Files

1. **`/web/index.html`** - Contains reCAPTCHA container div
2. **`/web/recaptcha_config.js`** - Invisible reCAPTCHA configuration
3. **`/lib/auth/firebase_auth/firebase_auth_manager.dart`** - Phone auth implementation

## Important Notes

- **Cannot completely remove reCAPTCHA**: Firebase requires it for security
- **Invisible reCAPTCHA is the best UX**: Users don't see the checkbox
- **App Check significantly reduces challenges**: But doesn't eliminate them completely
- **First-time users may still see verification**: This is normal security behavior

## Quick Wins

For immediate improvement without complex setup:

1. ✅ **Already done**: Invisible reCAPTCHA for web
2. ✅ **Already done**: Optimized navigation flow
3. 🔧 **To do**: Enable Firebase App Check (requires Google Cloud Console access)

## Questions?

If you need help with Firebase Console configuration or enabling App Check, let me know!
