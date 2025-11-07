# 🚀 Chat Room Invite Links - Quick Start

## What This Feature Does

Allows users to invite players to chat rooms via shareable links with configurable expiry and usage limits.

---

## ⚡ Quick Setup (5 Steps)

### 1. Run SQL Migration (2 minutes)
```bash
# Open Supabase Dashboard → SQL Editor
# Copy + paste contents of: chat_room_invites_migration.sql
# Click "Run"
```

### 2. Add Invite Button to Chat Room (1 minute)
```dart
// In your chat room screen AppBar:
import '../widgets/room_invite_sheet.dart';

actions: [
  IconButton(
    icon: const Icon(Icons.person_add),
    onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (context) => RoomInviteSheet(
          roomId: roomId,
          roomName: roomName,
        ),
      );
    },
  ),
],
```

### 3. Add Route (1 minute)
```dart
// In lib/index.dart:
import 'screens/chat/join_room_screen.dart';

GoRoute(
  path: '/room/join/:inviteCode',
  name: 'JoinRoom',
  builder: (context, state) => JoinRoomScreen(
    inviteCode: state.pathParameters['inviteCode'] ?? '',
  ),
),
```

### 4. Add Dependency (1 minute)
```yaml
# In pubspec.yaml:
dependencies:
  uni_links: ^0.5.1  # For deep linking
  share_plus: ^7.2.1  # Already included
```

### 5. Test It!
```
1. Open chat room
2. Tap invite button (👤+)
3. Tap "Create New Invite Link"
4. Configure & create
5. Share link
6. Open link → Should join room
```

---

## 📱 User Experience Flow

### Creating an Invite
```
User → Opens Chat Room
     → Taps Invite Button (AppBar)
     → Bottom Sheet Opens
     → Shows Existing Invites
     → Taps "Create New Invite Link"
     → Dialog Opens:
        • Limit uses? (toggle)
        • Set expiry? (toggle)
        • Share immediately? (checkbox)
     → Taps "Create"
     → Invite Created
     → Share Dialog Opens
     → Shares via WhatsApp/Telegram/etc
```

### Joining via Invite
```
User → Receives Invite Link
     → Clicks Link
     → App Opens
     → Join Room Screen Shows:
        • Room Name
        • Member Count
        • Invite Validity Status
        • Created By Info
     → Taps "Join Room"
     → Joins Room
     → Navigates to Chat Room
     → System Message: "User joined via invite"
```

---

## 🎨 What It Looks Like

### 1. Invite Button in Chat Room
```
┌────────────────────────────────┐
│ ← Chat Room Name          👤+ │  ← Invite Button
├────────────────────────────────┤
│                                │
│  💬 Messages here...           │
│                                │
└────────────────────────────────┘
```

### 2. Invite Management Bottom Sheet
```
┌────────────────────────────────┐
│ Invite Links              ✕    │
├────────────────────────────────┤
│ Share these links to invite    │
│ players to this room            │
│                                │
│ ┌────────────────────────────┐ │
│ │ + Create New Invite Link   │ │
│ └────────────────────────────┘ │
│                                │
│ ┌─ Existing Invites ─────────┐ │
│ │ [Active]      Jan 15, 2025  │ │
│ │ 🔑 ABCD1234                │ │
│ │ 👥 3/10 uses  ⏰ 7 days    │ │
│ │               [Copy] [Share]│ │
│ └────────────────────────────┘ │
│                                │
│ ┌────────────────────────────┐ │
│ │ [Expired]     Jan 10, 2025 │ │
│ │ 🔑 WXYZ5678                │ │
│ │ 👥 5/5 uses   ⏰ Expired   │ │
│ │                        [🚫] │ │
│ └────────────────────────────┘ │
└────────────────────────────────┘
```

### 3. Create Invite Dialog
```
┌────────────────────────────────┐
│ Create Invite Link             │
├────────────────────────────────┤
│                                │
│ ☑ Limit number of uses         │
│   Max uses: 10                 │
│   [────●────────────] 1-100    │
│                                │
│ ☑ Set expiration               │
│   Expires in 7 days            │
│   [──────●──────────] 1-30     │
│                                │
│ ☑ Share immediately            │
│   Open share dialog after      │
│                                │
│       [Cancel]  [Create]       │
└────────────────────────────────┘
```

### 4. Join Room Screen
```
┌────────────────────────────────┐
│ ← Join Chat Room               │
├────────────────────────────────┤
│                                │
│         ╔══════╗               │
│         ║ 👥  ║               │
│         ╚══════╝               │
│                                │
│      Badminton Players         │
│        [BADMINTON]             │
│                                │
│ ┌─ Room Details ─────────────┐ │
│ │ 👥 Members: 15 / 50         │ │
│ │ 👤 Invited by: John         │ │
│ │ 📂 Type: Group Chat         │ │
│ └────────────────────────────┘ │
│                                │
│ ┌────────────────────────────┐ │
│ │ ✓ This invite is valid and │ │
│ │   ready to use!             │ │
│ └────────────────────────────┘ │
│                                │
│ ┌────────────────────────────┐ │
│ │      Join Room             │ │
│ └────────────────────────────┘ │
│                                │
│         Cancel                 │
└────────────────────────────────┘
```

---

## 🔧 Key Features

### For Invite Creators:
- ✅ Create unlimited invites
- ✅ Set max usage limit (1-100 uses)
- ✅ Set expiry (1-30 days or never)
- ✅ View all invites for room
- ✅ See usage statistics
- ✅ Deactivate invites anytime
- ✅ Share via any platform
- ✅ Copy link to clipboard

### For Invite Recipients:
- ✅ Click link to open app
- ✅ See room details before joining
- ✅ Join with one tap
- ✅ Auto-navigate to chat room
- ✅ See validation status

### System Features:
- ✅ Automatic expiry checking
- ✅ Usage tracking
- ✅ System join messages
- ✅ Duplicate join prevention
- ✅ Room full detection
- ✅ Real-time updates

---

## 📊 Database Tables

### `chat.room_invites`
Stores invite links with:
- Invite code (8 chars)
- Invite link
- Max uses limit
- Current usage count
- Expiry date
- Active status

### `chat.room_invite_usage`
Tracks who used invites:
- Invite ID
- User ID
- Used at timestamp

---

## 🎯 Example Invite Links

### Custom Scheme (Recommended):
```
funcircle://room/join/ABCD1234
```
- Works immediately
- No external service needed
- Opens app directly

### Web URL (Future):
```
https://funcircle.app/room/join/ABCD1234
```
- Universal links
- Works on web too
- Requires domain setup

---

## ⚠️ Important Notes

1. **Firebase Dynamic Links is deprecated**
   - Use custom URL scheme instead
   - Or integrate Branch.io/AppsFlyer
   - See implementation guide for details

2. **RLS is enabled**
   - Only room admins/moderators can create invites
   - Only room members can see invites
   - Anyone can use valid invite codes

3. **Invite codes are unique**
   - 8-character alphanumeric
   - Case-sensitive
   - Randomly generated

---

## 🧪 Test Checklist

```
□ Create invite from chat room
□ Set usage limit (10 uses)
□ Set expiry (7 days)
□ Share invite link
□ Copy invite link
□ Join via invite link
□ Verify system message appears
□ Test expired invite (shows error)
□ Test maxed invite (shows error)
□ Test room full (shows error)
□ Deactivate invite
□ View invite usage stats
```

---

## 📁 Files Created

```
✅ chat_room_invites_migration.sql           - Database schema
✅ lib/models/room_invite.dart                - Data models
✅ lib/services/room_invite_service.dart      - Business logic
✅ lib/screens/chat/widgets/room_invite_sheet.dart - Main UI
✅ lib/screens/chat/join_room_screen.dart     - Join flow
✅ lib/utils/room_invite_deep_link_handler.dart - Deep links
✅ ROOM_INVITE_IMPLEMENTATION_GUIDE.md        - Full guide
✅ ROOM_INVITE_QUICK_START.md                 - This file
```

---

## 🆘 Common Issues

### "relation does not exist"
→ Run SQL migration first

### Deep links not working
→ Add URL scheme to AndroidManifest.xml and Info.plist

### Cannot create invite
→ Check user has admin/moderator role in room

### Invite shows invalid
→ Check expiry date and usage count

---

## 📞 Next Steps

1. Run SQL migration
2. Add invite button
3. Add route
4. Test creating invites
5. Test joining via invite
6. Configure deep links
7. Deploy! 🚀

---

**Ready to implement?**
See `ROOM_INVITE_IMPLEMENTATION_GUIDE.md` for detailed instructions.

**Status:** ✅ Complete
**Time to implement:** ~15 minutes
**Difficulty:** Easy

🎉 Happy coding!
