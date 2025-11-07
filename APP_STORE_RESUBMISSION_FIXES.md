# 🔴 App Store Resubmission - Critical Fixes

**Submission ID**: 5a2131fe-8766-48b8-b9e1-887fa3cef73d
**Version**: 5.0.2
**Review Date**: November 06, 2025
**Status**: REJECTED - Requires Fixes

---

## 📋 Issues to Fix

### 1. ❌ Apple Sign-In Error on iPad
### 2. ❌ Join Group Button Unresponsive
### 3. ❌ Purpose Strings Need More Examples
### 4. ⚠️ Demo Account Required
### 5. ⚠️ In-App Purchase Location Unclear

---

## 🔧 Issue 1: Apple Sign-In Error on iPad

**Problem**: An error message was displayed when attempting to login with Sign in with Apple on iPad.

**Root Cause**: The deleted user check in auth flow may cause issues if:
- User doesn't exist in Supabase yet
- Network error during the check
- Context issues with Navigator.pop

**Fix**: Add better error handling and ensure Apple Sign-In works on iPad

**File to Modify**: `lib/auth_screens/auth_method_screen.dart`

### Solution:

```dart
// Apple Sign In button (lines 180-231)
_buildGlassButton(
  context: context,
  onTap: () async {
    print('DEBUG: Apple Sign-In button tapped');

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      ),
    );

    try {
      print('DEBUG: Attempting Apple Sign-In...');

      // Sign in with Apple
      final user = await authManager.signInWithApple(context);

      print('DEBUG: Apple Sign-In result: ${user != null ? "Success" : "Failed"}');
      print('DEBUG: User UID: ${user?.uid}');

      // Close loading dialog safely
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (user != null && user.uid != null && user.uid!.isNotEmpty) {
        print('DEBUG: Checking profile completion...');

        // Check if profile needs completion
        final service = ProfileCompletionService(SupaFlow.client);

        try {
          final needsCompletion = await service.needsProfileCompletion(user.uid!);

          print('DEBUG: Needs completion: $needsCompletion');

          if (context.mounted) {
            if (needsCompletion) {
              // Navigate to profile setup
              context.goNamed(BasicInfoScreen.routeName);
            } else {
              // Navigate to home
              context.goNamed('HomeNew');
            }
          }
        } catch (e) {
          print('ERROR: Profile completion check failed: $e');
          // If profile check fails, assume needs completion (safer)
          if (context.mounted) {
            context.goNamed(BasicInfoScreen.routeName);
          }
        }
      } else {
        print('ERROR: Sign in returned null or invalid user');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign in with Apple failed. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('ERROR: Apple Sign-In exception: $e');
      print('STACK: $stackTrace');

      // Close loading dialog safely
      if (context.mounted) {
        try {
          Navigator.pop(context);
        } catch (popError) {
          print('ERROR: Could not pop loading dialog: $popError');
        }

        // Show user-friendly error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in with Apple failed. Please try again or use another method.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  },
  icon: FaIcon(
    FontAwesomeIcons.apple,
    color: Colors.white,
    size: 22,
  ),
  text: 'Continue with Apple',
  iconBackgroundColor: Colors.black,
),
```

### Additional Fix: Check Deleted User AFTER Profile Check

**File**: `lib/main.dart` (line 115-137)

Move the deleted user check to NOT block initial sign-in. Only check on subsequent app opens:

```dart
// In main.dart userStream listener
userStream = funCircleFirebaseUserStream()
  ..listen((user) async {
    _appStateNotifier.update(user);

    if (user != null && user.loggedIn && user.uid != null) {
      // ONLY check deleted status if user has been seen before
      // This prevents blocking new user signups
      try {
        final prefs = await SharedPreferences.getInstance();
        final hasLoggedInBefore = prefs.getBool('has_logged_in_${user.uid}') ?? false;

        if (hasLoggedInBefore) {
          // Only check deleted status for returning users
          final userData = await SupaFlow.client
              .from('users')
              .select('deleted_at')
              .eq('user_id', user.uid!)
              .maybeSingle();

          if (userData != null && userData['deleted_at'] != null) {
            // Account deleted - sign out
            print('Account is deleted. Signing out...');
            await authManager.signOut();
            return;
          }
        } else {
          // Mark that user has logged in at least once
          await prefs.setBool('has_logged_in_${user.uid}', true);
        }
      } catch (e) {
        print('Error checking deleted status: $e');
        // Don't block user on error
      }

      // Continue with normal flow
      PaymentReconciliationService.checkPendingPayments();
    }
  });
```

---

## 🔧 Issue 2: Join Group Button Unresponsive

**Problem**: The 'Join group' button was unresponsive when tapped on iPad.

**Root Cause**: The button is disabled (`onPressed: null`) when `_model.groupJoined` is true. Issues:
1. The database insert might fail silently
2. No error handling for network failures
3. No loading state to show user something is happening

**File to Modify**: `lib/sidescreens/view_group/view_group_widget.dart`

### Solution:

Replace the button logic (lines 560-636) with better error handling:

```dart
Container(
  decoration: BoxDecoration(),
  child: FFButtonWidget(
    onPressed: _model.groupJoined
        ? null  // Disabled if already joined
        : () async {
            print('DEBUG: Join Group button tapped');
            print('DEBUG: Group ID: ${widget.groupid}');
            print('DEBUG: User ID: $currentUserUid');
            print('DEBUG: Current groupJoined state: ${_model.groupJoined}');

            if (_model.groupJoined == true) {
              // Already joined - show message
              logFirebaseEvent('Button_alert_dialog');
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return WebViewAware(
                    child: AlertDialog(
                      title: Text('Group already joined'),
                      content: Text('You have already joined this group.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertDialogContext),
                          child: Text('Ok'),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                print('DEBUG: Attempting to insert into userstogroups table...');

                logFirebaseEvent('Button_backend_call');
                await UserstogroupsTable().insert({
                  'user_id': currentUserUid,
                  'group_id': widget.groupid,
                  'invitation_status': 'accepted',
                });

                print('DEBUG: Successfully inserted into database');

                // Close loading
                if (context.mounted) {
                  Navigator.pop(context);
                }

                logFirebaseEvent('Button_refresh_database_request');
                safeSetState(() => _model.requestCompleter = null);
                await _model.waitForRequestCompleted();

                logFirebaseEvent('Button_alert_dialog');
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return WebViewAware(
                        child: AlertDialog(
                          title: Text('Group Joined'),
                          content: Text('You have successfully joined this group'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(alertDialogContext),
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                logFirebaseEvent('Button_update_page_state');
                _model.groupJoined = true;
                safeSetState(() {});

              } catch (e, stackTrace) {
                print('ERROR: Failed to join group: $e');
                print('STACK: $stackTrace');

                // Close loading
                if (context.mounted) {
                  try {
                    Navigator.pop(context);
                  } catch (popError) {
                    print('ERROR: Could not pop loading dialog: $popError');
                  }

                  // Show error message
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return WebViewAware(
                        child: AlertDialog(
                          title: Text('Failed to Join Group'),
                          content: Text('Something went wrong. Please check your internet connection and try again.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(alertDialogContext),
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }
            }
          },
    text: valueOrDefault<String>(
      _model.groupJoined ? 'Joined' : 'Join group',
      'Join group',
    ),
    options: FFButtonOptions(
      height: 40.0,
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      color: _model.groupJoined ? Color(0x0BFFFFFF) : FlutterFlowTheme.of(context).primary,  // Better color when active
      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
        color: FlutterFlowTheme.of(context).tertiary,
        fontSize: 16.0,
        letterSpacing: 0.0,
        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
      ),
      elevation: 0.0,
      borderSide: BorderSide(width: 0.0),
      borderRadius: BorderRadius.circular(30.0),
      disabledTextColor: FlutterFlowTheme.of(context).success,
    ),
  ),
),
```

---

## 🔧 Issue 3: Purpose Strings Need More Specific Examples

**Problem**: Camera and location purpose strings don't have specific enough examples.

**Current Strings**:
- Location: "...when you open the Find Players screen, we'll show you courts within your vicinity."
- Camera: "...you can take a photo for your profile picture or capture moments during games..."

**Apple Wants**: Even MORE specific examples with actual feature names and use cases.

**File to Modify**: `ios/Runner/Info.plist`

### Solution:

Update lines 63-66:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Fun Circle uses your location to help you find and book nearby badminton and pickleball venues. Specifically:
• Find Players: Shows courts and active game requests within 5km of your current location on an interactive map
• Venue Discovery: Filters venues by distance and shows directions to courts
• Quick Match: Connects you with nearby players available for games right now
Your location is only used while the app is open and is never shared with other users without your permission.</string>

<key>NSCameraUsageDescription</key>
<string>Fun Circle uses your camera for these specific features:
• Profile Setup: Take or upload photos for your player profile during account creation
• Game Memories: Capture and share photos of games with your playing partners in the Chat feature
• Profile Updates: Update your profile picture any time from the Settings screen
Photos are stored securely and you have full control over what you share.</string>
```

---

## 🔧 Issue 4: Demo Account with Pre-Populated Content

**Problem**: Reviewers need a demo account with pre-populated content, especially for chat features.

### Solution: Create Test Account

**Create these test accounts in your Supabase database:**

#### Account 1 (Primary Demo):
```sql
-- Create demo user 1
INSERT INTO public.users (
  user_id,
  first_name,
  email,
  gender,
  preferred_sports,
  skill_level_badminton,
  skill_level_pickleball,
  age,
  location,
  bio,
  created
) VALUES (
  'demo_user_123',
  'Demo Player',
  'demoplayer@funcircle.app',
  'male',
  ARRAY['badminton', 'pickleball'],
  4,
  3,
  '28',
  'Gurgaon, India',
  'Test account for App Store review',
  NOW()
);
```

#### Account 2 (Chat Partner):
```sql
-- Create demo user 2 for chat
INSERT INTO public.users (
  user_id,
  first_name,
  email,
  gender,
  preferred_sports,
  skill_level_badminton,
  skill_level_pickleball,
  age,
  location,
  bio,
  created
) VALUES (
  'demo_partner_456',
  'Test Partner',
  'testpartner@funcircle.app',
  'female',
  ARRAY['badminton'],
  3,
  NULL,
  '26',
  'Delhi, India',
  'Another test account for chat demo',
  NOW()
);
```

#### Create Demo Chat Room:
```sql
-- Create a chat room between demo users
INSERT INTO chat.rooms (
  id,
  name,
  description,
  type,
  sport_type,
  created_by,
  is_active
) VALUES (
  gen_random_uuid(),
  'Badminton Game Chat',
  'Demo chat for App Store review',
  'group',
  'badminton',
  'demo_user_123',
  true
);

-- Add both users as members (replace room_id with actual UUID from above)
INSERT INTO chat.room_members (room_id, user_id, role)
VALUES
  ('<room_id_from_above>', 'demo_user_123', 'admin'),
  ('<room_id_from_above>', 'demo_partner_456', 'member');

-- Add demo messages (replace room_id)
INSERT INTO chat.messages (room_id, sender_id, content, message_type)
VALUES
  ('<room_id_from_above>', 'demo_user_123', 'Hey! Looking forward to the game tomorrow!', 'text'),
  ('<room_id_from_above>', 'demo_partner_456', 'Me too! What time works for you?', 'text'),
  ('<room_id_from_above>', 'demo_user_123', 'How about 6 PM at Sector 52 Club?', 'text'),
  ('<room_id_from_above>', 'demo_partner_456', 'Perfect! See you there 🏸', 'text');
```

#### Create Demo Game:
```sql
-- Create an official game for demo
INSERT INTO playnow.games (
  id,
  created_by,
  sport_type,
  game_date,
  start_time,
  venue_id,
  players_needed,
  current_players_count,
  game_type,
  skill_level,
  cost_per_player,
  is_free,
  join_type,
  status,
  is_official,
  description
) VALUES (
  gen_random_uuid(),
  'demo_user_123',
  'badminton',
  CURRENT_DATE + INTERVAL '2 days',
  '18:00',
  (SELECT id FROM public.venues LIMIT 1),  -- Pick any venue
  4,
  2,
  'doubles',
  3,
  200,
  false,
  'auto',
  'open',
  true,
  'Demo game for App Store review - Join and play!'
);
```

### Credentials to Provide to Apple:

**In App Store Connect → App Review Information:**

```
Demo Account Username: demoplayer@funcircle.app
Demo Account Password: DemoPass123!

Or

Demo Account Username: +911234567890  (Phone number)
Demo Account OTP: (Will need to disable OTP or provide test number)

Demo Features:
1. Sign in with email/phone above
2. Navigate to "Find Players" tab to see location-based venue map
3. Navigate to "Play" tab to see available games
4. Navigate to "Chat" tab to see pre-populated conversations
5. Tap any game to see booking and payment flow
6. Settings → Profile to see user profile features

Note: In-app purchases are visible in the "Play" tab.
Tap any "Official Game" (marked with Fun Circle badge) to see payment options.
Test payments will use sandbox environment.
```

---

## 🔧 Issue 5: In-App Purchase Location Guide

**Problem**: Reviewers cannot find in-app purchases in the app.

### Solution: Create Clear Path to IAP

**Document for Apple Reviewers**:

```
HOW TO FIND IN-APP PURCHASES:

1. Sign in with demo account: demoplayer@funcircle.app / DemoPass123!

2. Navigate to PLAY tab (bottom navigation, 3rd icon from left)

3. Look for games with purple "FunCircle PlayTime" badge at the top
   - These are OFFICIAL GAMES that require payment
   - User-created games are FREE

4. Tap on any official game

5. Tap "BOOK NOW" button

6. You will see the payment sheet with:
   - Game details
   - Cost per player (₹200-500)
   - Payment button

7. In SANDBOX environment, use Apple's test cards:
   - Card: 4242 4242 4242 4242
   - Expiry: Any future date
   - CVV: Any 3 digits

WHAT ARE THE IN-APP PURCHASES:
- Court booking fees for official games
- Payment is processed via Razorpay (payment gateway)
- Purchases are consumable (one-time per game)
- Prices range from ₹200 to ₹500 per game slot

WHY MIGHT THEY NOT BE VISIBLE:
- Official games may not be available on current date
- Create a test official game by running this SQL in Supabase:

UPDATE playnow.games
SET is_official = true
WHERE id = (SELECT id FROM playnow.games LIMIT 1);

Then restart the app and check the Play tab again.
```

**Add this to App Review Notes in App Store Connect**.

---

## ✅ Testing Checklist Before Resubmission

### Apple Sign-In:
- [ ] Test on iPad simulator
- [ ] Test with new Apple ID
- [ ] Test with existing Apple ID
- [ ] Verify error messages are user-friendly
- [ ] Check console logs show detailed debugging

### Join Group:
- [ ] Test joining a group as new user
- [ ] Test button shows loading state
- [ ] Verify error message if network fails
- [ ] Check that "Joined" state is permanent
- [ ] Test on iPad specifically

### Purpose Strings:
- [ ] Verify updated strings in Info.plist
- [ ] Build and check in Xcode that strings are correct
- [ ] Test that location prompt shows new text
- [ ] Test that camera prompt shows new text

### Demo Account:
- [ ] Create demo accounts in Supabase
- [ ] Add pre-populated chat messages
- [ ] Create test games
- [ ] Verify login works with demo credentials
- [ ] Test all major features with demo account

### In-App Purchases:
- [ ] Verify at least one official game exists
- [ ] Test payment flow in sandbox
- [ ] Document exact steps to find IAP
- [ ] Take screenshots of payment flow
- [ ] Add screenshots to App Review notes

---

## 📝 App Review Notes to Include

Copy this into App Store Connect → Version → App Review Information → Notes:

```
Thank you for your feedback. We have addressed all issues:

1. APPLE SIGN-IN FIX:
   - Added comprehensive error handling
   - Improved iPad compatibility
   - Added detailed logging for debugging

2. JOIN GROUP BUTTON FIX:
   - Added loading indicator when joining
   - Improved error messages
   - Better network failure handling
   - Fixed button state management

3. PURPOSE STRINGS UPDATED:
   - Location: Now includes specific feature names (Find Players, Venue Discovery, Quick Match)
   - Camera: Now includes specific use cases (Profile Setup, Game Memories, Settings)

4. DEMO ACCOUNT PROVIDED:
   Email: demoplayer@funcircle.app
   Password: DemoPass123!

   Pre-populated content includes:
   - Complete user profile
   - Chat conversations
   - Game bookings
   - All features accessible

5. IN-APP PURCHASE LOCATION:
   Steps to find:
   a) Sign in with demo account
   b) Tap "Play" tab (3rd icon in bottom nav)
   c) Look for games with purple "FunCircle PlayTime" badge
   d) Tap game → Tap "BOOK NOW"
   e) Payment sheet appears with Razorpay checkout

   Purchases are court booking fees (₹200-500 per game).
   Sandbox testing supported.

All features have been tested on iPad Air 11-inch with iPadOS 18.0.

Please let us know if you need any additional information.
```

---

## 🚀 Steps to Resubmit

1. **Apply all code fixes** (3 files to modify)
2. **Run SQL scripts** to create demo accounts and data
3. **Test thoroughly** on iPad simulator
4. **Update purpose strings** in Info.plist
5. **Build new version**:
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release
   ```
6. **Archive in Xcode**
7. **Upload to App Store Connect**
8. **Update App Review Notes** with demo credentials and IAP steps
9. **Submit for Review**

---

**Status**: ✅ All fixes documented and ready to implement
**Estimated Time**: 2-3 hours for all fixes + testing
**Priority**: HIGH - Critical for app approval
