# Navigation Testing Guide

## Issue: Profile Icon Not Navigating

### Current Setup ✅
- HomeNew profile button calls: `context.pushNamed('MyProfileScreen')`
- Route registered in nav.dart: `NewProfile.MyProfileWidget.routeName` = `'MyProfileScreen'`
- Route path: `/myProfileScreen`

---

## Solution: Full App Restart Required

**IMPORTANT:** Route changes require a **full restart**, not a hot reload!

### Step 1: Stop the App
```bash
# Press 'q' in the terminal where flutter run is running
# OR
# Stop from your IDE
```

### Step 2: Full Restart
```bash
flutter run
```

**Do NOT use:**
- ❌ Hot reload (r)
- ❌ Hot restart (R)

These won't pick up routing changes!

---

## Verification Steps

### 1. Check Routes are Loaded
When app starts, you should see in console:
```
GoRouter is in debug mode
```

### 2. Test Profile Navigation
1. Open HomeNew screen
2. Look for profile icon (top-left, user icon in circle)
3. Tap profile icon
4. **Expected:** Navigate to My Profile Screen
5. **Verify:** You see profile screen with user stats

### 3. Test Settings Navigation
1. From Profile screen
2. Look for Settings icon (top-right, gear icon)
3. Tap settings icon
4. **Expected:** Navigate to Settings Screen
5. **Verify:** You see "Quick Access" section

---

## If It Still Doesn't Work

### Debug Method 1: Check Route Registration

Run this to verify routes are registered:
```bash
flutter run --verbose 2>&1 | grep "MyProfileScreen"
```

### Debug Method 2: Add Debug Print

Add this to HomeNew profile button (line 274-278):

```dart
onTap: () async {
  logFirebaseEvent('Icon_navigate_to');
  print('🔍 DEBUG: Attempting to navigate to MyProfileScreen');
  print('🔍 DEBUG: Available routes:');
  print(GoRouter.of(context).routeInformationProvider);

  // Navigate to My Profile Screen
  context.pushNamed('MyProfileScreen');

  print('🔍 DEBUG: Navigation called');
},
```

Then check console output when you tap.

### Debug Method 3: Check Current Route

Add this in HomeNew build method to see current route:
```dart
@override
Widget build(BuildContext context) {
  print('🔍 Current route: ${GoRouterState.of(context).uri.toString()}');
  // ... rest of build
}
```

### Debug Method 4: Try Absolute Path

If named route doesn't work, try using the path directly:

```dart
// Instead of:
context.pushNamed('MyProfileScreen');

// Try:
context.push('/myProfileScreen');
```

---

## Common Issues

### Issue 1: "Route Not Found"
**Symptom:** Black screen or error message
**Solution:**
1. Verify `flutter pub get` was run
2. Full restart (not hot reload)
3. Check no typos in route name

### Issue 2: "Nothing Happens"
**Symptom:** Tap does nothing
**Solution:**
1. Check if `onTap` is being called (add print statement)
2. Verify context is valid
3. Check if any Navigator is blocking

### Issue 3: "Goes to Wrong Screen"
**Symptom:** Opens old profile instead of new
**Solution:**
1. Verify route name is exactly `'MyProfileScreen'` (case-sensitive)
2. Check there's no route name collision
3. Clear app data and reinstall

---

## Quick Test: Direct Navigation

Add this test button somewhere visible in HomeNew to test navigation:

```dart
ElevatedButton(
  onPressed: () {
    print('🧪 TEST: Navigating to MyProfileScreen');
    context.pushNamed('MyProfileScreen');
  },
  child: Text('TEST: Go to Profile'),
),
```

If this works but the icon doesn't:
- The route is fine
- The issue is with the icon's `onTap` handler

---

## Route Registry Check

Run this command to see all registered routes:

```bash
grep "name:.*Widget" lib/flutter_flow/nav/nav.dart | head -20
```

You should see:
```dart
name: NewProfile.MyProfileWidget.routeName,  // This should be 'MyProfileScreen'
```

---

## Final Checklist

Before testing:
- [ ] Ran `flutter pub get`
- [ ] Stopped the app completely
- [ ] Restarted with `flutter run` (not hot reload)
- [ ] Verified no errors in console during startup
- [ ] Checked route is registered in nav.dart
- [ ] Confirmed route name is 'MyProfileScreen'

During testing:
- [ ] Can see HomeNew screen
- [ ] Can see profile icon (circle with user icon)
- [ ] Icon is tappable (has ripple effect)
- [ ] Console shows navigation attempt (if debug prints added)

After tap:
- [ ] Screen transitions
- [ ] New profile screen appears
- [ ] No errors in console

---

## Expected Behavior

**Correct Flow:**
1. User taps profile icon in HomeNew
2. App navigates to `/myProfileScreen`
3. MyProfileWidget (new) renders
4. User sees profile with stats
5. Settings icon visible in top-right

**Route Chain:**
```
HomeNew
  → Tap Profile Icon
  → context.pushNamed('MyProfileScreen')
  → GoRouter finds route
  → Calls NewProfile.MyProfileWidget builder
  → Renders new profile screen
```

---

## Alternative: Use MoreOptions Instead

If profile navigation continues to fail, you can access the profile through More Options:

1. Add More Options button to HomeNew
2. Navigate to More Options
3. From there, tap "My Profile"

This route is guaranteed to work since it's part of the main navigation menu.

---

## Need More Help?

If navigation still fails after full restart:

1. Share console output when tapping icon
2. Share any error messages
3. Confirm you did full restart (not hot reload)
4. Try the debug methods above

The routes are configured correctly, so a full restart should fix it! 🚀
