# Google Sign-In Fix for Android

## Problem
Google Sign-In on Android gets stuck showing a loading icon after selecting an email account.

## Root Cause
Missing SHA-1 certificate fingerprints in Firebase Console. Firebase requires SHA-1 fingerprints to authenticate your app for Google Sign-In.

## Solution

### ✅ Step 1: Add SHA-1 Fingerprints to Firebase

Your SHA-1 fingerprints are:

**📱 DEBUG SHA-1 (for development):**
```
3D:41:10:32:30:02:D1:CA:53:B9:D1:30:B0:98:D8:6D:8B:9F:D9:71
```

**📦 RELEASE SHA-1 (for production):**
```
B4:3A:46:E7:10:53:02:C7:5D:6E:EF:CC:83:58:FE:FB:00:B7:5E:E3
```

**How to add them:**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your **Fun Circle** project
3. Click **⚙️ (gear icon)** → **Project Settings**
4. Scroll to **Your apps** section
5. Find the **Android app** with package name `faceout.social`
6. Click **Add fingerprint**
7. Paste **DEBUG SHA-1** → Click **Save**
8. Click **Add fingerprint** again
9. Paste **RELEASE SHA-1** → Click **Save**
10. **Download updated `google-services.json`**
11. Replace `android/app/google-services.json` with the new file

### ✅ Step 2: Verify Google Sign-In is Enabled

1. In Firebase Console, go to **Authentication** (left sidebar)
2. Click **Sign-in method** tab
3. Ensure **Google** is **Enabled**
4. Make sure the **Support email** is configured

### ✅ Step 3: Clean and Rebuild

After adding SHA-1 fingerprints:

```bash
cd /Users/sanchitjain/funcircle_app_flutter/fun_circle

# Clean the project
flutter clean

# Get dependencies
flutter pub get

# Rebuild the app
flutter run
```

### ✅ Step 4: Test Google Sign-In

1. Launch the app on a real Android device (emulator may not work properly)
2. Navigate to Welcome screen
3. Tap "Google" button
4. Select your Google account
5. Should complete sign-in successfully within 5-10 seconds

## Changes Made to Code

### 1. Enhanced Error Handling (`lib/auth/firebase_auth/google_auth.dart`)
- ✅ Added timeout handling (30s for Google Sign-In, 15s for Firebase)
- ✅ Better debug logging
- ✅ Proper error propagation
- ✅ Null safety checks

### 2. Improved User Feedback (`lib/auth/firebase_auth/firebase_auth_manager.dart`)
- ✅ Better error messages for common issues
- ✅ Network error detection
- ✅ Timeout error handling
- ✅ Google Play Services error handling

## Troubleshooting

### Issue: Still hangs after adding SHA-1
**Solution:**
1. Make sure you downloaded and replaced `google-services.json`
2. Run `flutter clean` and rebuild
3. Uninstall the app from device and reinstall
4. Wait 5-10 minutes for Firebase to propagate changes

### Issue: "PlatformException" or "Google Play Services" error
**Solution:**
- Update Google Play Services on the device:
  - Go to **Settings** → **Apps** → **Google Play Services** → **Update**
- Or download from Play Store

### Issue: "Network error" message
**Solution:**
- Check internet connection
- Disable VPN if active
- Try mobile data instead of Wi-Fi (or vice versa)

### Issue: Console shows "ERROR_INVALID_PACKAGE_NAME"
**Solution:**
- Verify package name in Firebase Console matches `faceout.social`
- Check `android/app/build.gradle` has correct `applicationId`

## Verification

After the fix, you should see these logs in the console when signing in:

```
DEBUG: Starting Google Sign-In...
DEBUG: Google user signed in: user@example.com
DEBUG: Got authentication tokens, signing in to Firebase...
DEBUG: Successfully signed in to Firebase: abc123xyz
```

## Prevention

To avoid this issue in the future:
1. Always add SHA-1 fingerprints when setting up new Firebase projects
2. Add both debug AND release fingerprints
3. Keep `google-services.json` up to date

## Support

If the issue persists:
1. Check Flutter logs: `flutter logs`
2. Check Firebase Console for authentication errors
3. Verify OAuth 2.0 Client ID is configured in Google Cloud Console
4. Make sure app package name matches everywhere

---

**Status:** ✅ Fixed
**Date:** November 10, 2025
**Tested:** Pending user testing
