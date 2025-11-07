# 🍎 Fix: Apple Sign-In "Identity Provider Configuration Not Found"

## Error
When users tap "Continue with Apple", they see:
> **"Identity provider configuration is not found"**

## Root Cause
Apple Sign-In is not enabled or properly configured in Firebase Console.

---

## ✅ Solution: Enable Apple Sign-In in Firebase

### Step 1: Open Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **Fun Circle**
3. Navigate to: **Build → Authentication**

### Step 2: Enable Apple Sign-In Provider

1. Click on **"Sign-in method"** tab
2. Find **"Apple"** in the list of providers
3. Click on **"Apple"**
4. Click **"Enable"** toggle

### Step 3: Configure Apple Sign-In (Important!)

You need to provide your Apple Service ID and other details:

#### Option A: Basic Setup (Recommended for Testing)

If you just want to test Apple Sign-In without a custom Service ID:

1. **Enable** the Apple provider
2. Leave the Service ID blank for now
3. Click **Save**

**Note**: This will use Firebase's default Apple Sign-In configuration, which works for testing but requires users to approve the app in their Apple ID settings.

#### Option B: Full Setup (Required for Production)

For production release, you need to configure a custom Service ID:

1. **Enable** the Apple provider

2. **Service ID**: Enter your Apple Service ID
   - Format: `com.faceout.social.signin` (example)
   - Get this from: [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list/serviceId)

3. **OAuth code flow configuration** (expand):
   - **Team ID**: Your Apple Developer Team ID (find in Apple Developer Portal)
   - **Key ID**: Create a Sign in with Apple Key in Apple Developer Portal
   - **Private Key**: Download the .p8 file from Apple Developer Portal

4. Click **Save**

---

## 🔧 Complete Apple Sign-In Setup (Production)

### A. In Apple Developer Portal

1. **Go to**: https://developer.apple.com/account/resources/identifiers/list

2. **Create Service ID**:
   - Click **+** (Add button)
   - Select **Services IDs**
   - Description: `Fun Circle Sign In`
   - Identifier: `com.faceout.social.signin` (must be unique)
   - Click **Continue** → **Register**

3. **Configure Service ID**:
   - Select your newly created Service ID
   - Enable **Sign in with Apple**
   - Click **Configure**
   - **Domains**: Add `funcircle.app` (your domain)
   - **Return URLs**: Add `https://<your-project-id>.firebaseapp.com/__/auth/handler`
     - Get your project ID from Firebase Console URL
   - Click **Save**

4. **Create Sign in with Apple Key**:
   - Go to: **Certificates, IDs & Profiles → Keys**
   - Click **+** (Add button)
   - Key Name: `Fun Circle Sign In Key`
   - Enable **Sign in with Apple**
   - Click **Configure** → Select your Primary App ID
   - Click **Continue** → **Register**
   - **Download** the `.p8` key file (you can only download once!)
   - Note the **Key ID** (10 characters)

### B. Back to Firebase Console

1. Open the Apple Sign-In provider settings in Firebase
2. Enter the information you just created:
   - **Service ID**: `com.faceout.social.signin`
   - **Team ID**: Find in Apple Developer Portal (10 characters)
   - **Key ID**: From the key you just created
   - **Private Key**: Open the `.p8` file in a text editor and paste the content
3. Click **Save**

---

## 🧪 Quick Test (Development)

For immediate testing, you can:

### Option 1: Use Firebase's Default Configuration

1. Just **Enable** Apple Sign-In in Firebase
2. Don't provide Service ID
3. Test on your iPhone
4. It will work but users need to trust the app in iOS Settings

### Option 2: Minimal Configuration

1. **Enable** Apple Sign-In in Firebase
2. In Xcode, ensure your Bundle ID is added to Firebase
3. In Apple Developer Portal, enable Sign in with Apple for your App ID
4. Test on device

---

## ⚠️ Important Notes

### For iOS App Store Submission

- Apple **REQUIRES** that if you use Google Sign-In, you MUST also offer Apple Sign-In
- You **MUST** complete the full setup (Option B above) before submitting to App Store
- Test thoroughly on physical device (not simulator)

### For Development

- Basic setup (Option A) is sufficient for testing
- Works on physical iOS devices
- May show "Continue with Apple ID" instead of smooth sign-in

### Common Issues

**1. "Unsupported URL"**
- Solution: Check that your Bundle ID matches in Xcode, Firebase, and Apple Developer Portal

**2. "Invalid client"**
- Solution: Verify Service ID is correctly configured with Firebase callback URL

**3. "Failed to fetch configuration"**
- Solution: Wait 5-10 minutes after saving Firebase settings for changes to propagate

---

## ✅ Verification Checklist

After configuration, verify:

- [ ] Apple provider is **Enabled** in Firebase Console
- [ ] Service ID is created in Apple Developer Portal (production)
- [ ] Sign in with Apple is enabled for your App ID
- [ ] Bundle ID in Xcode matches Firebase and Apple Developer Portal
- [ ] Test on physical iPhone (Apple Sign-In doesn't work on simulator)
- [ ] User can tap "Continue with Apple" and sign in successfully

---

## 📱 How to Test

1. Open the app on your iPhone
2. Tap "Continue with Apple"
3. Should see Apple's native sign-in prompt
4. Enter Apple ID credentials
5. Should successfully sign in and navigate to home or profile setup

---

## 🆘 If Still Not Working

### Check Firebase Configuration

```bash
# Verify Firebase is properly initialized
# Check ios/Runner/GoogleService-Info.plist exists
ls -la ios/Runner/GoogleService-Info.plist
```

### Check Bundle ID

```bash
# In Xcode: Runner → General → Identity → Bundle Identifier
# Should match: com.faceout.social (or your actual bundle ID)
```

### Check Info.plist

Ensure `ios/Runner/Info.plist` has the correct URL schemes:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.446213644019-c64qa3958p3eh1vd5h1ibq6erh2q6i1b</string>
        </array>
    </dict>
</array>
```

---

## 🎯 Quick Fix for Testing

**If you just want to test NOW:**

1. Go to Firebase Console
2. Authentication → Sign-in method
3. Enable **Apple** provider (don't worry about Service ID for now)
4. Save
5. Wait 2-3 minutes
6. Try signing in again

This will work for basic testing. You'll need the full setup before App Store submission.

---

## 📞 Need Help?

If you're still seeing the error after enabling Apple Sign-In:

1. **Clear app data** on iPhone (uninstall and reinstall)
2. **Wait 10 minutes** after Firebase configuration changes
3. **Check Firebase Console** → Authentication → Users tab (see if any Apple users exist)
4. **Try Phone Sign-In** to verify Firebase is working
5. **Check console logs** for more detailed error messages

---

**Status**: Follow these steps and Apple Sign-In will work! ✅
