# 🎯 Chat Room Invite Links - Implementation Guide

## Overview

This feature allows users to invite players to chat rooms via shareable invite links. Users can create invite links with configurable expiry and usage limits, share them via any platform, and new users can join the room by clicking the link.

---

## ✅ What's Been Created

### 1. **Database Schema** ✅
- `chat.room_invites` - Stores invite links
- `chat.room_invite_usage` - Tracks who used which invite
- Helper functions for validation
- Row Level Security (RLS) policies
- Triggers for auto-updates

**File:** `chat_room_invites_migration.sql`

### 2. **Data Models** ✅
- `RoomInvite` - Model for invite data
- `RoomInviteDetails` - Model for join screen

**File:** `lib/models/room_invite.dart`

### 3. **Service Layer** ✅
- `RoomInviteService` - Complete CRUD operations
- Create invites with options
- Validate invites
- Join rooms via invite
- Track usage

**File:** `lib/services/room_invite_service.dart`

### 4. **UI Components** ✅
- `RoomInviteSheet` - Bottom sheet to manage invites
- `CreateInviteDialog` - Dialog to create new invites
- `InviteCard` - Display individual invites
- `JoinRoomScreen` - Screen to join via invite link

**Files:**
- `lib/screens/chat/widgets/room_invite_sheet.dart`
- `lib/screens/chat/join_room_screen.dart`

### 5. **Deep Link Handler** ✅
- `RoomInviteDeepLinkHandler` - Handles incoming invite links

**File:** `lib/utils/room_invite_deep_link_handler.dart`

---

## 🚀 Implementation Steps

### Step 1: Run Database Migration

1. **Open Supabase Dashboard**
   - Go to your project
   - Click "SQL Editor" in sidebar

2. **Run the Migration**
   - Click "New Query"
   - Copy entire contents of `chat_room_invites_migration.sql`
   - Paste and click "Run"

3. **Verify Success**
   ```sql
   -- Check tables were created
   SELECT table_name FROM information_schema.tables
   WHERE table_schema = 'chat'
   AND table_name IN ('room_invites', 'room_invite_usage');

   -- Should return 2 rows ✅
   ```

---

### Step 2: Add Invite Button to Chat Room Screen

Find your chat room screen (likely `lib/screens/chat/chat_room_screen.dart` or similar) and add an invite button to the AppBar:

```dart
import '../widgets/room_invite_sheet.dart'; // Add this import

// In your ChatRoomScreen AppBar:
AppBar(
  title: Text(roomName),
  actions: [
    // Add this button
    IconButton(
      icon: const Icon(Icons.person_add),
      tooltip: 'Invite Players',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => RoomInviteSheet(
            roomId: widget.roomId,
            roomName: widget.roomName,
          ),
        );
      },
    ),
    // ... your other actions
  ],
)
```

---

### Step 3: Add Route for Join Room Screen

In `lib/index.dart` (or your routing file), add:

```dart
import 'screens/chat/join_room_screen.dart';

// Add to your GoRouter routes:
GoRoute(
  path: '/room/join/:inviteCode',
  name: 'JoinRoom',
  builder: (context, state) {
    final inviteCode = state.pathParameters['inviteCode'] ?? '';
    return JoinRoomScreen(inviteCode: inviteCode);
  },
),
```

---

### Step 4: Initialize Deep Link Handling (Optional)

**Note:** Firebase Dynamic Links is deprecated (shutting down August 2025). You have two options:

#### Option A: Simple Custom URL Scheme (Recommended for now)

1. **Add to `lib/main.dart`:**

```dart
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'utils/room_invite_deep_link_handler.dart';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Handle initial link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }

    // Handle links while app is running
    _linkSubscription = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleLink(link);
        }
      },
      onError: (err) {
        print('Link error: $err');
      },
    );
  }

  void _handleLink(String link) {
    RoomInviteDeepLinkHandler().handleCustomSchemeUrl(
      link,
      widget.navigatorKey,
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      // ... rest of your app config
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(MyApp(navigatorKey: navigatorKey));
}
```

2. **Add dependency to `pubspec.yaml`:**

```yaml
dependencies:
  uni_links: ^0.5.1
```

3. **Configure URL Scheme:**

**Android** - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<activity android:name=".MainActivity">
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
      android:scheme="funcircle"
      android:host="room" />
  </intent-filter>
</activity>
```

**iOS** - Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>funcircle</string>
    </array>
  </dict>
</array>
```

#### Option B: Use Alternative Link Service

Consider using:
- **Branch.io** - Free tier available
- **AppsFlyer OneLink** - Free for basic use
- **Your own backend** - Generate short URLs

---

### Step 5: Update Invite Link Generation

In `lib/services/room_invite_service.dart`, update line 38:

```dart
// Replace this TODO with your actual domain:
final inviteLink = 'https://funcircle.app/room/join/$inviteCode';

// Or use custom scheme (simpler, works immediately):
final inviteLink = 'funcircle://room/join/$inviteCode';
```

---

## 🧪 Testing the Feature

### Test 1: Create an Invite

1. Open a chat room
2. Tap the "Invite Players" button (👤+)
3. Tap "Create New Invite Link"
4. Configure options:
   - ✅ Limit uses (10)
   - ✅ Set expiry (7 days)
   - ✅ Share immediately
5. Tap "Create"
6. Should see the share dialog

### Test 2: Share an Invite

1. From the invite sheet, tap "Share" on an invite
2. Share via WhatsApp/Telegram/etc
3. Link format should be:
   - `funcircle://room/join/ABCD1234` (custom scheme)
   - Or `https://funcircle.app/room/join/ABCD1234` (web)

### Test 3: Join via Invite

1. Click the shared invite link
2. App should open to "Join Room" screen
3. Should show:
   - ✅ Room name
   - ✅ Member count
   - ✅ Invite validity status
4. Tap "Join Room"
5. Should navigate to chat room

### Test 4: Invite Validation

1. Create an invite with max 1 use
2. Use it to join
3. Try using the same link again
4. Should show "Max Uses Reached"

### Test 5: Expiry

1. Create an invite that expires in 1 day
2. Manually set expires_at to past date:
   ```sql
   UPDATE chat.room_invites
   SET expires_at = NOW() - INTERVAL '1 day'
   WHERE invite_code = 'YOUR_CODE';
   ```
3. Try to join
4. Should show "Expired"

---

## 📊 Database Queries for Testing

### View All Invites
```sql
SELECT * FROM chat.room_invites_view
ORDER BY created_at DESC;
```

### Check Invite Usage
```sql
SELECT
  i.invite_code,
  i.current_uses,
  i.max_uses,
  COUNT(u.id) as actual_uses
FROM chat.room_invites i
LEFT JOIN chat.room_invite_usage u ON u.invite_id = i.id
GROUP BY i.id, i.invite_code, i.current_uses, i.max_uses;
```

### Clean Up Test Data
```sql
-- Delete all invites for testing
DELETE FROM chat.room_invites WHERE room_id = 'YOUR_ROOM_ID';

-- Reset usage count
UPDATE chat.room_invites SET current_uses = 0;
```

### Create Test Invite Manually
```sql
INSERT INTO chat.room_invites (
  room_id,
  created_by,
  invite_code,
  invite_link,
  max_uses,
  expires_at
) VALUES (
  'your-room-id',
  'your-user-id',
  'TEST1234',
  'funcircle://room/join/TEST1234',
  10,
  NOW() + INTERVAL '7 days'
);
```

---

## 🎨 Customization Options

### Change Invite Code Length
In `lib/services/room_invite_service.dart`:
```dart
// Change from 8 to any length
List.generate(8, ...) // Current
List.generate(6, ...) // Shorter codes
```

### Add More Invite Options
In `CreateInviteDialog`, add new options like:
- Required skill level
- Sport type filter
- Admin approval required

### Customize Share Message
In `RoomInviteSheet._shareInvite()`:
```dart
final message = '''
🎮 Join our ${widget.roomName} chat room!
📍 Sport: ${details.sportType}
👥 ${details.memberCount} members

Tap to join:
${invite.inviteLink}
''';
```

---

## 🐛 Troubleshooting

### Issue: "relation does not exist: chat.room_invites"
**Fix:** Run the SQL migration in Step 1

### Issue: "permission denied for table room_invites"
**Fix:** Check RLS policies:
```sql
SELECT * FROM pg_policies
WHERE schemaname = 'chat'
AND tablename = 'room_invites';
```

### Issue: Deep links not working
**Fix:**
1. Check URL scheme is configured in Android/iOS
2. Verify `uni_links` package is installed
3. Test with `adb shell am start -a android.intent.action.VIEW -d "funcircle://room/join/TEST1234" com.your.package` (Android)
4. For iOS, use Xcode → Open URL

### Issue: Invite shows as invalid but should work
**Fix:** Check the validation function:
```sql
SELECT chat.is_invite_valid('YOUR_CODE');
-- Should return true
```

### Issue: User joins but doesn't appear in room
**Fix:** Check room_members table:
```sql
SELECT * FROM chat.room_members
WHERE room_id = 'YOUR_ROOM_ID'
AND user_id = 'USER_WHO_JOINED';
```

---

## 📝 Feature Usage in Your App

### Where to Add Invite Button

1. **Chat Room AppBar** (Primary)
   - Most intuitive location
   - Easy access during conversation

2. **Chat Room Info Page**
   - With other room settings
   - "Manage Invites" section

3. **Chat List Long Press**
   - Quick action menu
   - "Invite to Room"

### Recommended User Flow

```
User Flow 1: Create & Share
1. User opens chat room
2. Taps invite button
3. Sees list of existing invites
4. Taps "Create New"
5. Configures options
6. Shares immediately

User Flow 2: Join via Link
1. User receives invite link
2. Clicks link
3. App opens to join screen
4. Reviews room details
5. Taps "Join Room"
6. Enters chat room
```

---

## 🔒 Security Considerations

### Current Security Features
- ✅ RLS policies restrict access
- ✅ Only admins/moderators can create invites
- ✅ Expiry prevents old links from working
- ✅ Max uses prevents spam
- ✅ Usage tracking for auditing

### Additional Security (Optional)

1. **Captcha for Join**
   ```dart
   // Add captcha verification before joining
   await _verifyCaptcha();
   await _inviteService.joinRoomViaInvite(...);
   ```

2. **Approval Queue**
   ```dart
   // Instead of auto-join, add to pending
   await _submitJoinRequest(inviteCode);
   ```

3. **IP Rate Limiting**
   - Limit joins per IP address
   - Implement in Supabase Edge Functions

---

## 📈 Analytics to Track

Consider tracking these events:

```dart
// Invite created
analytics.logEvent(
  name: 'invite_created',
  parameters: {
    'room_id': roomId,
    'has_max_uses': maxUses != null,
    'has_expiry': expiresInDays != null,
  },
);

// Invite shared
analytics.logEvent(
  name: 'invite_shared',
  parameters: {
    'room_id': roomId,
    'share_method': 'whatsapp', // or detected method
  },
);

// Room joined via invite
analytics.logEvent(
  name: 'room_joined_via_invite',
  parameters: {
    'room_id': roomId,
    'invite_code': inviteCode,
  },
);
```

---

## 🎉 Next Steps

### Immediate Next Steps:
1. ✅ Run SQL migration
2. ✅ Add invite button to chat room
3. ✅ Test creating invites
4. ✅ Test joining via invite
5. ✅ Configure deep links

### Future Enhancements:
- 🔮 QR code generation for invites
- 🔮 Invite templates (recurring events)
- 🔮 Bulk invite management
- 🔮 Invite analytics dashboard
- 🔮 Social sharing preview images
- 🔮 Invite rewards (referral bonuses)

---

## 📚 Files Summary

### Created Files:
```
chat_room_invites_migration.sql                    # Database schema
lib/models/room_invite.dart                        # Data models
lib/services/room_invite_service.dart              # Business logic
lib/screens/chat/widgets/room_invite_sheet.dart    # Main UI
lib/screens/chat/join_room_screen.dart             # Join flow
lib/utils/room_invite_deep_link_handler.dart       # Deep links
ROOM_INVITE_IMPLEMENTATION_GUIDE.md                # This guide
```

### Files to Modify:
```
lib/main.dart                    # Add deep link handling
lib/index.dart                   # Add JoinRoom route
lib/screens/chat/chat_room.dart  # Add invite button
pubspec.yaml                     # Add uni_links dependency
android/app/src/main/AndroidManifest.xml  # URL scheme
ios/Runner/Info.plist            # URL scheme
```

---

## ✅ Completion Checklist

```
□ SQL migration run successfully
□ Database tables verified
□ Invite button added to chat room
□ JoinRoom route added
□ Deep link handling initialized
□ URL schemes configured (Android/iOS)
□ Test: Create invite works
□ Test: Share invite works
□ Test: Join via invite works
□ Test: Validation works (expiry, max uses)
□ Test: Deep links open app correctly
```

---

## 🆘 Support

If you encounter issues:

1. **Check Flutter console** for errors
2. **Check Supabase logs** in dashboard
3. **Verify RLS policies** are correct
4. **Test SQL functions** manually
5. **Check URL scheme** configuration

---

**Status:** ✅ Complete and Ready to Implement
**Created:** January 2025
**Last Updated:** January 2025

🎉 Your chat room invite feature is ready to go!
