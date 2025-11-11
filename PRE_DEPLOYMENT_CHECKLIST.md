# Pre-Deployment Checklist

## ⚠️ CRITICAL - DO BEFORE BUILDING

### Test Account Setup (APP STORE REQUIREMENT)
- [ ] Created Firebase test account
- [ ] Email/Phone: `___________________`
- [ ] Password: `___________________`
- [ ] Account has working login (no OTP issues)

### Pre-Populate Test Data
- [ ] **Chat: 4+ conversations with 5+ messages each** ⭐ MOST IMPORTANT
- [ ] Profile: Complete with name, photo, bio, sports
- [ ] Find Players: 2-3 player requests created
- [ ] My Games: Showed interest in 2-3 games
- [ ] Venues: Nearby venues visible

### Code Ready
- [ ] `Info.plist` updated with new privacy strings
- [ ] Version number incremented in `pubspec.yaml`
- [ ] All recent changes committed to git
- [ ] App tested on real device
- [ ] No console errors or warnings

---

## 🚀 BUILD COMMANDS

### iOS (App Store)
```bash
# 1. Clean and prepare
flutter clean
flutter pub get
cd ios && pod install && cd ..

# 2. Build
flutter build ios --release

# 3. Open in Xcode to archive
open ios/Runner.xcworkspace
```

Then in Xcode:
- Product → Archive
- Distribute → App Store Connect

### Android (Play Store)
```bash
# 1. Clean and prepare
flutter clean
flutter pub get

# 2. Build App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

Then upload to Play Console.

---

## 📝 APP STORE CONNECT SUBMISSION

### 1. Upload Build via Xcode
- Archive → Distribute → Upload

### 2. In App Store Connect
- Select your build
- Fill in "What's New" text

### 3. **App Review Information** (CRITICAL)
```
Demo Account Credentials:
Email: [YOUR_TEST_ACCOUNT]
Password: [YOUR_PASSWORD]

Notes:
Test account has pre-populated chat conversations,
player requests, and complete profile. All features
are fully functional.

IMPORTANT: This app does NOT have in-app purchases.
All features are free.
```

### 4. Reply to Previous Rejection
Copy content from `APP_REVIEW_RESPONSE.md`

### 5. Submit for Review

---

## 📱 PLAY CONSOLE SUBMISSION

### 1. Create New Release
- Production → Create release

### 2. Upload App Bundle
- Select: `build/app/outputs/bundle/release/app-release.aab`

### 3. Release Notes
```
What's New:
- Enhanced chat with read receipts and user profiles
- Improved player matching and game discovery
- Better location-based venue search
- Bug fixes and performance improvements
```

### 4. Review and Rollout
- Start rollout to Production

---

## ✅ FINAL CHECKS

### Before Submitting
- [ ] Build completed without errors
- [ ] Version number is incremented
- [ ] Test account credentials ready
- [ ] App Store Connect reply prepared
- [ ] Screenshots uploaded (if needed)

### Test Account Quick Test
1. [ ] Login works immediately
2. [ ] Chats tab shows 4+ conversations ⭐
3. [ ] Each chat has multiple messages ⭐
4. [ ] Profile is complete with photo
5. [ ] Find Players shows map with requests
6. [ ] My Games has games listed

### Documentation Ready
- [ ] `APP_REVIEW_RESPONSE.md` - Copy this for App Store reply
- [ ] Test account credentials saved
- [ ] Ready to respond to any Apple questions

---

## 🎯 MOST IMPORTANT

### For App Store Success:
1. **Chat messages are pre-populated** - Apple WILL check this
2. **Test account works instantly** - No waiting for OTP
3. **Clear "NO in-app purchases" statement**

### Timeline
- **iOS:** 1-3 days review (with clear response to previous rejection)
- **Android:** 1-3 hours to 1 day

---

## 🚨 IF ANYTHING FAILS

### iOS Build Issues
```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

### Android Build Issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Signing Issues
- **iOS:** Check Xcode → Signing & Capabilities
- **Android:** Verify `android/key.properties` exists

---

## Ready to Deploy? ✅

If all checkboxes above are ✅, you're ready to:

1. **Build iOS:** Run iOS build commands → Archive in Xcode
2. **Build Android:** Run Android build command → Upload to Play Console
3. **Submit iOS:** Add test credentials → Reply to rejection → Submit
4. **Submit Android:** Add release notes → Rollout to production

**Good luck! 🚀**

You can track status at:
- App Store: https://appstoreconnect.apple.com
- Play Store: https://play.google.com/console
