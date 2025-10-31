# Screen Connections & Navigation Map

## ✅ Complete Navigation Setup

All screens are now fully connected with bidirectional navigation!

---

## 🔄 Navigation Flow Diagram

```
┌─────────────────────┐
│   More Options      │ ◄── Hub (Entry Point)
│   (Main Hub)        │
└──────┬──────────────┘
       │
       ├──► My Profile ────────┐
       │                       │
       ├──► My Bookings        │
       │                       │
       ├──► Game Requests      ├──► Settings ◄─┐
       │                       │              │
       ├──► My Play Friends ───┘              │
       │                                      │
       └──► Settings ─────────────────────────┘
              │
              ├──► Contact Support
              │
              └──► Policy Viewer
                     (Privacy/Terms/Community)
```

---

## 📱 Screen-by-Screen Navigation

### 1. **More Options Screen** (Hub)
**Location:** `lib/screens/more_options/more_options_widget.dart`

**Navigation TO:**
- ✅ My Bookings Screen
- ✅ Game Requests Screen
- ✅ My Play Friends Screen
- ✅ My Profile Screen
- ✅ Settings Screen
- ✅ Help & Support

**Navigation FROM:**
- Settings Screen → Quick Access section
- App's main navigation (bottom nav or drawer)

**AppBar Actions:**
- Settings icon (top-right) → Settings Screen

---

### 2. **My Profile Screen**
**Location:** `lib/screens/profile/my_profile_widget.dart`

**Navigation TO:**
- ✅ Edit Profile (existing screen)
- ✅ Settings Screen

**Navigation FROM:**
- More Options Screen
- Settings Screen → Quick Access
- User profile taps throughout app

**AppBar Actions:**
- Edit icon → Edit Profile
- Settings icon (top-right) → Settings Screen

---

### 3. **My Bookings Screen**
**Location:** `lib/screens/bookings/my_bookings_widget.dart`

**Navigation TO:**
- ✅ Settings Screen
- Booking Details (Bottom Sheet)

**Navigation FROM:**
- More Options Screen
- Settings Screen → Quick Access

**AppBar Actions:**
- Settings icon (top-right) → Settings Screen

**Features:**
- 4 Filter Tabs (All, Upcoming, Past, Cancelled)
- Bottom sheet for booking details

---

### 4. **Game Requests Screen**
**Location:** `lib/screens/game_requests/game_requests_widget.dart`

**Navigation TO:**
- ✅ Settings Screen

**Navigation FROM:**
- More Options Screen
- Settings Screen → Quick Access

**AppBar Actions:**
- Settings icon (top-right) → Settings Screen

**Features:**
- 2 Tabs (Received, Sent)
- Accept/Reject/Cancel actions

---

### 5. **My Play Friends Screen**
**Location:** `lib/screens/play_friends/my_play_friends_widget.dart`

**Navigation TO:**
- ✅ Settings Screen
- Friend Profile (placeholder)
- Chat (placeholder)

**Navigation FROM:**
- More Options Screen
- Settings Screen → Quick Access

**AppBar Actions:**
- Settings icon (top-right) → Settings Screen

**Features:**
- Search bar
- Filter chips (Favorites, Sports)

---

### 6. **Settings Screen** ⭐
**Location:** `lib/screens/settings/settings_widget.dart`

**Navigation TO (Quick Access Section):**
- ✅ My Profile
- ✅ My Bookings
- ✅ Game Requests
- ✅ My Play Friends
- ✅ More Options

**Navigation TO (Other):**
- ✅ Contact Support Screen
- ✅ Policy Screen (Privacy, Terms, Community)
- Logout action
- Delete Account action

**Navigation FROM:**
- All main screens (via Settings icon in AppBar)
- More Options Screen

**Sections:**
1. **Quick Access** - Links to all main screens
2. **Notifications** - Toggle settings
3. **Privacy** - Privacy controls
4. **Support** - Help and contact
5. **Legal** - Policies and terms
6. **Account** - Logout/Delete

---

### 7. **Contact Support Screen**
**Location:** `lib/screens/settings/contact_support_widget.dart`

**Navigation TO:**
- None (leaf screen)

**Navigation FROM:**
- Settings Screen → Support section
- More Options Screen → Help & Support

**Features:**
- Category selection
- Subject and description fields
- Submit ticket action

---

### 8. **Policy Screen**
**Location:** `lib/screens/settings/policy_widget.dart`

**Navigation TO:**
- None (leaf screen)

**Navigation FROM:**
- Settings Screen → Legal section

**Parameters:**
- `policyType`: 'privacy', 'terms', or 'community'

**Features:**
- Display policy content
- Version and effective date

---

## 🎯 Quick Access Points

### From Any Screen:
All main screens have a **Settings icon** in the AppBar (top-right corner) that navigates directly to Settings.

```dart
// Standard in all main screens
IconButton(
  icon: const Icon(Icons.settings, color: Colors.white),
  onPressed: () {
    context.pushNamed('SettingsScreen');
  },
),
```

---

## 🔗 Navigation Code Examples

### Navigate to Settings:
```dart
context.pushNamed('SettingsScreen');
```

### Navigate from Settings to other screens:
```dart
// Quick Access section in Settings
context.pushNamed('MyProfileScreen');
context.pushNamed('MyBookingsScreen');
context.pushNamed('GameRequestsScreen');
context.pushNamed('PlayFriendsScreen');
context.pushNamed('MoreOptionsScreen');
```

### Navigate to Policy with parameter:
```dart
context.pushNamed('PolicyScreen', queryParameters: {
  'policyType': 'privacy',  // or 'terms' or 'community'
});
```

---

## ✨ User Experience Flow

### Common User Journeys:

**1. View Profile & Settings:**
```
More Options → My Profile → (Settings icon) → Settings
```

**2. Manage Bookings:**
```
More Options → My Bookings → View Details → Cancel/Rate
               ↓ (Settings icon)
            Settings
```

**3. Handle Game Requests:**
```
More Options → Game Requests → Accept/Reject
               ↓ (Settings icon)
            Settings
```

**4. Manage Friends:**
```
More Options → My Play Friends → Search/Filter → Favorite
               ↓ (Settings icon)
            Settings
```

**5. Get Help:**
```
More Options → Help & Support → Contact Support
       or
Settings → Support → Contact Support
```

**6. Access Everything from Settings:**
```
Settings → Quick Access → Any Screen
```

---

## 🎨 UI Consistency

All navigation follows these patterns:

### AppBar Structure:
```dart
AppBar(
  title: Text('Screen Name'),
  actions: [
    // Optional edit/other icons
    IconButton(icon: Icon(Icons.settings)),  // Settings always last
  ],
)
```

### Navigation Menu Items:
```dart
ListTile(
  leading: Icon(...),
  title: Text(...),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () => context.pushNamed(...),
)
```

### Dividers Between Items:
```dart
Divider(
  height: 1,
  thickness: 1,
  indent: 16,
  endIndent: 16,
)
```

---

## 📊 Navigation Statistics

- **Total Screens:** 8
- **Interconnected Screens:** 6 main + 2 support
- **Settings Access Points:** 5 screens
- **Hub Screen:** More Options
- **Central Hub:** Settings (links to all screens)

---

## 🔍 Navigation Testing Checklist

### From More Options:
- [ ] Navigate to My Profile
- [ ] Navigate to My Bookings
- [ ] Navigate to Game Requests
- [ ] Navigate to My Play Friends
- [ ] Navigate to Settings
- [ ] Navigate to Help & Support

### From Settings:
- [ ] Quick Access → My Profile
- [ ] Quick Access → My Bookings
- [ ] Quick Access → Game Requests
- [ ] Quick Access → My Play Friends
- [ ] Quick Access → More Options
- [ ] Support → Contact Support
- [ ] Legal → Privacy Policy
- [ ] Legal → Terms of Service
- [ ] Legal → Community Guidelines

### AppBar Settings Icon:
- [ ] From My Profile
- [ ] From My Bookings
- [ ] From Game Requests
- [ ] From My Play Friends
- [ ] From More Options

### Back Navigation:
- [ ] All screens return to previous screen
- [ ] Bottom sheets dismiss properly
- [ ] Dialogs cancel correctly

---

## 💡 Implementation Details

### Route Names Required:
```dart
'MoreOptionsScreen'
'MyProfileScreen'
'MyBookingsScreen'
'GameRequestsScreen'
'PlayFriendsScreen'
'SettingsScreen'
'ContactSupportScreen'
'PolicyScreen' (with policyType parameter)
```

### Navigation Method:
All screens use:
```dart
context.pushNamed('ScreenName')
```

For policy screen with parameter:
```dart
context.pushNamed('PolicyScreen', queryParameters: {
  'policyType': 'privacy',
});
```

---

## 🎯 Summary

✅ **All screens fully connected**
✅ **Bidirectional navigation implemented**
✅ **Settings accessible from all main screens**
✅ **Hub screens (More Options & Settings) link to everything**
✅ **Consistent UI/UX patterns**
✅ **Clean navigation architecture**

**Users can now:**
- Access any screen from More Options or Settings
- Jump to Settings from any main screen
- Navigate back easily
- Access help and support from multiple entry points

---

**Navigation implementation complete!** 🎉

All screens are interconnected, providing seamless user experience and easy access to all features.
