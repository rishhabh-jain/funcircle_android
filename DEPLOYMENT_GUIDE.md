# Deployment Guide - App Store & Play Store

## Pre-Deployment Checklist ✅

### Critical Items (MUST DO)
- [ ] Test account created with pre-populated data
- [ ] Chat conversations have messages (CRITICAL for App Store)
- [ ] Profile is complete with photos
- [ ] Player requests exist in "Find Players"
- [ ] Games exist in "My Games"
- [ ] All features tested and working
- [ ] Privacy strings updated in Info.plist (iOS)
- [ ] Build version number incremented

### Test Account Details
Fill this in for App Store Connect:
```
Email/Phone: _____________________________
Password: _____________________________
Notes: Account has pre-populated chats, games, and profile data
```

---

## iOS App Store Deployment

### 1. Clean and Get Dependencies
```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
```

### 2. Build iOS Release
```bash
flutter build ios --release
```

### 3. Open in Xcode and Archive
```bash
open ios/Runner.xcworkspace
```

**In Xcode:**
1. Select "Any iOS Device" as target
2. Product → Archive
3. Wait for archive to complete
4. Window → Organizer
5. Select your archive → "Distribute App"
6. Choose "App Store Connect"
7. Upload to App Store Connect

### 4. Submit for Review in App Store Connect

**Go to:** https://appstoreconnect.apple.com

1. **App Information:**
   - Verify app name: "Fun Circle"
   - Verify bundle ID matches

2. **Prepare for Submission:**
   - Select the build you just uploaded
   - Add screenshots (if not already uploaded)
   - Enter "What's New" description

3. **App Review Information:**
   - **Demo Account (REQUIRED):**
     - Username: [YOUR_TEST_EMAIL]
     - Password: [YOUR_TEST_PASSWORD]
   - **Notes:**
     ```
     Test account has pre-populated:
     - 4+ chat conversations with message history
     - Player requests in Find Players
     - Games in My Games
     - Complete profile with photos

     NOTE: This app does NOT have in-app purchases.
     All features are completely free.
     ```

4. **Reply to Previous Rejection:**
   - Copy content from `APP_REVIEW_RESPONSE.md`
   - Paste into reply field
   - Update with your test account credentials

5. **Submit for Review**

---

## Android Play Store Deployment

### 1. Clean and Get Dependencies
```bash
flutter clean
flutter pub get
```

### 2. Build App Bundle (Recommended)
```bash
flutter build appbundle --release
```

**Output location:**
```
build/app/outputs/bundle/release/app-release.aab
```

**Alternative - Build APK:**
```bash
flutter build apk --release
```

### 3. Upload to Play Console

**Go to:** https://play.google.com/console

1. **Select your app**

2. **Production → Create new release**

3. **Upload app bundle:**
   - Click "Upload"
   - Select: `build/app/outputs/bundle/release/app-release.aab`

4. **Release details:**
   - Release name: Auto-generated or custom
   - Release notes:
     ```
     What's New:
     - Enhanced chat functionality with read receipts
     - Improved player matching and game discovery
     - Better location-based venue search
     - Bug fixes and performance improvements
     ```

5. **Review and rollout:**
   - Review summary
   - Click "Start rollout to Production"
   - Confirm rollout

### 4. Additional Play Store Settings (If First Release)

**Store presence → Main store listing:**
- App name: Fun Circle
- Short description: (50 chars)
- Full description: (4000 chars max)
- Screenshots (required)
- Feature graphic (required)

**Content rating:**
- Complete questionnaire
- App is for sports/social connections

**Target audience:**
- Age rating: Select appropriate ages

**Privacy Policy:**
- Add URL to your privacy policy

---

## Version Numbers

Update these files before building:

### iOS (ios/Runner/Info.plist)
Already set via Flutter, but verify:
```xml
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
```

### Android (android/app/build.gradle)
Already set via Flutter, but verify:
```gradle
def flutterVersionName = localProperties.getProperty('flutter.versionName')
def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
```

### Set version in pubspec.yaml
```yaml
version: 1.0.1+2
         ^     ^
         |     └─ Build number (increment for each build)
         └─ Version name (increment for new features)
```

---

## Build Troubleshooting

### iOS Issues

**Pod Install Fails:**
```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

**Signing Error:**
- Open Xcode
- Select Runner target
- Signing & Capabilities
- Verify Team is selected
- Verify Provisioning Profile

**Archive Not Showing:**
- Ensure "Any iOS Device" is selected (not simulator)
- Clean: Cmd+Shift+K
- Build: Cmd+B
- Then archive again

### Android Issues

**Gradle Build Fails:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Signing Key Issues:**
Verify `android/key.properties` exists and contains:
```
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/path/to/your/upload-keystore.jks
```

---

## Post-Deployment Checklist

### After iOS Submission
- [ ] Check "App Store Connect" for build processing status
- [ ] Wait for "Ready for Review" status
- [ ] Monitor for any review messages
- [ ] Respond quickly to any Apple requests

### After Android Submission
- [ ] Check "Play Console" for processing status
- [ ] Wait for "Pending publication" → "Published"
- [ ] Usually takes 1-3 hours for Play Store
- [ ] Monitor for any policy violations

### Both Platforms
- [ ] Test download from stores once published
- [ ] Check all features work in production
- [ ] Monitor crash reports
- [ ] Monitor user reviews

---

## Important Notes

### App Store Review Time
- **Expected:** 1-3 days
- **With previous rejection:** May be faster if issues are resolved
- **Response to Apple:** Reply promptly to any questions

### Play Store Review Time
- **Expected:** 1-3 hours to 1 day
- Usually much faster than App Store
- Automated review first, then manual if flagged

### Critical for App Store Success
1. ✅ **Chat messages MUST be pre-populated** - This is #1 rejection reason
2. ✅ **Test account must work immediately** - No OTP delays
3. ✅ **Clear response about no in-app purchases**

### Monitor These
- App Store Connect: https://appstoreconnect.apple.com
- Play Console: https://play.google.com/console
- Your test email for review messages

---

## Quick Command Reference

### iOS
```bash
# Clean build
flutter clean && flutter pub get && cd ios && pod install && cd ..

# Build
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace
```

### Android
```bash
# Clean build
flutter clean && flutter pub get

# Build App Bundle
flutter build appbundle --release

# Build APK
flutter build apk --release
```

---

## Need Help?

If builds fail or you get stuck:
1. Check error messages carefully
2. Run `flutter doctor` to check setup
3. Clean and rebuild
4. Check signing certificates (iOS) or keystore (Android)

Good luck with your deployment! 🚀
