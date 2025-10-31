# 🎮 CLAUDE CODE IMPLEMENTATION PROMPT

## TASK: Implement 6 Additional User Account Screens

Hi Claude Code! Please implement 6 new screens for our sports app based on the comprehensive documentation provided.

---

## 📁 CONTEXT FILES

Please read these files in order:

1. **additional_screens_migration.sql** - Database schema (already run)
2. **additional_screens_guide_part1.md** - Screens 1-3 implementation
3. **additional_screens_guide_part2.md** - Screens 4-6 implementation
4. **ADDITIONAL_SCREENS_SUMMARY.md** - Complete reference

---

## 🎯 YOUR TASK

Implement these 6 screens with complete Flutter code:

### SCREEN 1: More Options Screen (Hub)
**File:** `lib/screens/more_options/more_options_screen.dart`

**Requirements:**
- User header with profile picture and name
- Quick stats cards (bookings, friends, games)
- Navigation menu items with icons
- Badge for pending game requests
- Service: Use `get_user_booking_stats()` and `get_play_friend_stats()` functions

**Models needed:**
- `UserQuickStats` class

**Providers needed:**
- `userQuickStatsProvider`
- `pendingGameRequestsCountProvider`

---

### SCREEN 2: My Bookings Screen
**File:** `lib/screens/bookings/my_bookings_screen.dart`

**Requirements:**
- Filter tabs: All, Upcoming, Past, Cancelled
- Booking cards with full details
- View booking details (bottom sheet)
- Cancel booking with confirmation
- Rate completed games button
- Use `user_bookings_view` for data

**Models needed:**
- `Booking` class with all fields

**Services needed:**
- `BookingsService` with methods:
  - `getUserBookings(userId, filter)`
  - `cancelBooking(orderId)`
  - `getBookingDetails(orderId)`

**Widgets needed:**
- `BookingCard` - Display booking info
- `BookingDetailsSheet` - Bottom sheet with details

---

### SCREEN 3: Game Requests Screen
**File:** `lib/screens/game_requests/game_requests_screen.dart`

**Requirements:**
- Two tabs: Received and Sent
- Received tab: Accept/Reject buttons
- Sent tab: Cancel request button
- Show request status with color-coded chips
- Display user info (name, image, level)
- Use `game_requests_view` for data

**Models needed:**
- `GameRequest` class

**Services needed:**
- `GameRequestsService` with methods:
  - `getReceivedRequests(userId)`
  - `getSentRequests(userId)`
  - `acceptRequest(requestId)`
  - `rejectRequest(requestId)`
  - `cancelRequest(requestId)`

**Widgets needed:**
- `ReceivedRequestCard`
- `SentRequestCard`
- `RequestHistoryCard`

---

### SCREEN 4: My Play Friends Screen
**File:** `lib/screens/play_friends/my_play_friends_screen.dart`

**Requirements:**
- Search bar for filtering
- Filter chips: All, Favorites, Badminton, Pickleball
- Friend cards with profile picture
- Games played together count
- Toggle favorite (star icon)
- View profile button
- Send message button
- Use `play_friends_view` for data

**Models needed:**
- `PlayFriend` class

**Services needed:**
- `PlayFriendsService` with methods:
  - `getPlayFriends(userId, {favoritesOnly, sportType})`
  - `toggleFavorite(friendshipId, isFavorite)`
  - `addPlayFriend(userId, friendId)`
  - `removePlayFriend(friendshipId)`
  - `updateNickname(friendshipId, nickname)`

**Widgets needed:**
- `PlayFriendCard`
- `AddFriendDialog`
- `EditFriendDialog`

---

### SCREEN 5: My Profile Screen
**File:** `lib/screens/profile/my_profile_screen.dart`

**Requirements:**
- Profile picture with edit button
- User name, level, location
- Rating display (stars)
- Statistics cards (total games, win rate, streak)
- Skill levels section (badminton/pickleball)
- Achievements badges
- Bio section
- Location, email, phone display
- Edit profile button (navigates to edit screen)
- Use existing `users` table

**Models needed:**
- `UserStats` class

**Services needed:**
- `ProfileService` with methods:
  - `getUserProfile(userId)`
  - `getUserStats(userId)`
  - `updateProfile(userId, data)`

---

### SCREEN 6: Settings Screen
**File:** `lib/screens/settings/settings_screen.dart`

**Requirements:**
- Notification settings section with toggles
- Appearance section (theme, language)
- Privacy settings section with toggles
- Support section (contact, report, FAQ)
- Legal section (policies)
- Account section (logout, delete)
- Use `user_settings` table

**Models needed:**
- `UserSettings` class
- `SupportTicket` class
- `AppPolicy` class

**Services needed:**
- `SettingsService` with methods:
  - `getUserSettings(userId)`
  - `updateSetting(field, value)`
  - `submitSupportTicket(ticket)`
  - `getPolicies(policyType)`

**Additional Screens:**
- `ContactSupportScreen` - Form to submit tickets
- `PolicyScreen` - Display policy content

---

## 🏗️ PROJECT STRUCTURE

Create this folder structure:

```
lib/
├── models/
│   ├── booking.dart
│   ├── game_request.dart
│   ├── play_friend.dart
│   ├── user_settings.dart
│   ├── support_ticket.dart
│   └── app_policy.dart
│
├── services/
│   ├── more_options_service.dart
│   ├── bookings_service.dart
│   ├── game_requests_service.dart
│   ├── play_friends_service.dart
│   ├── profile_service.dart
│   └── settings_service.dart
│
├── providers/
│   ├── more_options_providers.dart
│   ├── bookings_providers.dart
│   ├── game_requests_providers.dart
│   ├── play_friends_providers.dart
│   ├── profile_providers.dart
│   └── settings_providers.dart
│
├── screens/
│   ├── more_options/
│   │   └── more_options_screen.dart
│   ├── bookings/
│   │   ├── my_bookings_screen.dart
│   │   └── widgets/
│   │       ├── booking_card.dart
│   │       └── booking_details_sheet.dart
│   ├── game_requests/
│   │   ├── game_requests_screen.dart
│   │   └── widgets/
│   │       ├── received_request_card.dart
│   │       └── sent_request_card.dart
│   ├── play_friends/
│   │   ├── my_play_friends_screen.dart
│   │   └── widgets/
│   │       ├── play_friend_card.dart
│   │       └── add_friend_dialog.dart
│   ├── profile/
│   │   ├── my_profile_screen.dart
│   │   └── edit_profile_screen.dart
│   └── settings/
│       ├── settings_screen.dart
│       ├── contact_support_screen.dart
│       └── policy_screen.dart
│
└── utils/
    └── date_formatters.dart
```

---

## 📋 IMPLEMENTATION CHECKLIST

For each screen, ensure you:

### Models:
- [ ] Create model class with all fields
- [ ] Add `fromJson` factory constructor
- [ ] Add computed properties (e.g., `isUpcoming`, `formattedDate`)
- [ ] Add helper methods as needed

### Services:
- [ ] Create service class with SupabaseClient
- [ ] Implement all required methods
- [ ] Add error handling (try-catch)
- [ ] Use proper queries (filters, ordering)
- [ ] Use views where specified

### Providers:
- [ ] Create Riverpod providers
- [ ] Use `StreamProvider` for real-time data
- [ ] Use `FutureProvider` for one-time fetches
- [ ] Use `StateNotifierProvider` for complex state
- [ ] Implement proper error handling

### Screens:
- [ ] Implement full UI as specified
- [ ] Add loading states (CircularProgressIndicator)
- [ ] Add empty states with helpful messages
- [ ] Add error handling with SnackBars
- [ ] Implement navigation
- [ ] Add confirmation dialogs for destructive actions
- [ ] Use Material Design 3 components

### Widgets:
- [ ] Create reusable card components
- [ ] Add proper spacing (8px grid)
- [ ] Use consistent styling
- [ ] Add tap handlers
- [ ] Implement animations where appropriate

---

## 🎨 UI GUIDELINES

### Colors:
```dart
// Use these throughout
- Primary: Theme.of(context).primaryColor
- Success: Colors.green
- Warning: Colors.amber
- Error: Colors.red
- Grey text: Colors.grey[600]
```

### Spacing:
```dart
// Use 8px grid
- XSmall: 4
- Small: 8
- Medium: 16
- Large: 24
- XLarge: 32
```

### Typography:
```dart
- Heading: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
- Subheading: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
- Body: TextStyle(fontSize: 14)
- Caption: TextStyle(fontSize: 12, color: Colors.grey[600])
```

### Components:
- Use `Card` for list items
- Use `ListTile` for menu items
- Use `FilterChip` for filters
- Use `BottomSheet` for details
- Use `AlertDialog` for confirmations
- Use `SnackBar` for feedback

---

## 💾 DATABASE QUERIES

### Key Queries to Use:

**User Bookings:**
```dart
await supabase
  .from('user_bookings_view')
  .select()
  .eq('user_id', userId)
  .order('booked_at', ascending: false);
```

**Game Requests:**
```dart
await supabase
  .from('game_requests_view')
  .select()
  .eq('reciever', userId)
  .eq('status', 'pending');
```

**Play Friends:**
```dart
await supabase
  .from('play_friends_view')
  .select()
  .eq('user_id', userId)
  .order('games_played_together', ascending: false);
```

**User Stats:**
```dart
await supabase
  .rpc('get_user_booking_stats', params: {'p_user_id': userId});
```

**User Settings:**
```dart
await supabase
  .from('user_settings')
  .select()
  .eq('user_id', userId)
  .single();
```

---

## 🔐 IMPORTANT NOTES

1. **Use Existing Supabase Client**
   - Don't create a new client
   - Use: `ref.read(supabaseClientProvider)` or similar

2. **Use Existing Navigation**
   - Follow existing navigation patterns
   - Use `Navigator.push` or your routing solution

3. **Use Existing User Provider**
   - Access current user via existing provider
   - Don't re-fetch user data unnecessarily

4. **Error Handling**
   - Always wrap Supabase calls in try-catch
   - Show user-friendly error messages
   - Log errors for debugging

5. **RLS is Enabled**
   - All queries are secured by Row Level Security
   - Users can only access their own data
   - No need to manually filter by user_id in most cases

---

## 🧪 TESTING REQUIREMENTS

After implementation, test:

### Functionality:
- [ ] All screens load without errors
- [ ] Filters work correctly
- [ ] Search functionality works
- [ ] Buttons perform correct actions
- [ ] Dialogs show and close properly
- [ ] Navigation works smoothly

### Data:
- [ ] Correct data displays for each user
- [ ] Real-time updates work (if using StreamProvider)
- [ ] Stats calculate correctly
- [ ] Empty states show when no data

### Edge Cases:
- [ ] No bookings - show empty state
- [ ] No friends - show empty state
- [ ] No game requests - show empty state
- [ ] Network errors - show error message
- [ ] Loading states - show indicators

### UX:
- [ ] Loading states visible during API calls
- [ ] Success messages after actions
- [ ] Confirmation before destructive actions
- [ ] Back button works correctly
- [ ] Smooth animations

---

## 📱 EXAMPLE CODE STRUCTURE

Here's an example of how to structure one screen:

```dart
// models/booking.dart
class Booking {
  final String orderId;
  final String gameTitle;
  // ... other fields
  
  Booking({required this.orderId, required this.gameTitle});
  
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      orderId: json['order_id'],
      gameTitle: json['game_title'] ?? 'Game',
      // ... other fields
    );
  }
  
  bool get isUpcoming => startDateTime.isAfter(DateTime.now());
}

// services/bookings_service.dart
class BookingsService {
  final SupabaseClient _supabase;
  
  BookingsService(this._supabase);
  
  Future<List<Booking>> getUserBookings(String userId, {String? filter}) async {
    try {
      var query = _supabase.from('user_bookings_view').select();
      // ... apply filters
      final results = await query;
      return results.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }
}

// providers/bookings_providers.dart
final bookingsServiceProvider = Provider((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BookingsService(supabase);
});

final userBookingsProvider = FutureProvider.family<List<Booking>, String>((ref, filter) async {
  final service = ref.watch(bookingsServiceProvider);
  final user = ref.watch(currentUserProvider);
  return service.getUserBookings(user.userId, filter: filter);
});

// screens/bookings/my_bookings_screen.dart
class MyBookingsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  String _filter = 'all';
  
  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(userBookingsProvider(_filter));
    
    return Scaffold(
      appBar: AppBar(title: Text('My Bookings')),
      body: bookings.when(
        data: (list) => ListView.builder(...),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
```

---

## ✅ COMPLETION CRITERIA

The implementation is complete when:

1. **All 6 screens implemented** with full functionality
2. **All models created** with proper parsing
3. **All services created** with all methods
4. **All providers setup** with proper state management
5. **Navigation works** between all screens
6. **No compilation errors**
7. **All screens tested** with real data
8. **UI matches specifications** from guides
9. **Error handling implemented** throughout
10. **Code is clean** and well-organized

---

## 🚀 START IMPLEMENTATION

**Step 1:** Read all 3 implementation guide files
**Step 2:** Start with More Options screen (it's the hub)
**Step 3:** Implement screens in this order:
  1. More Options (hub first)
  2. Settings (easiest)
  3. My Profile (mostly read-only)
  4. My Bookings (uses view)
  5. Game Requests (two tabs)
  6. Play Friends (most complex)

**Step 4:** Test each screen as you complete it
**Step 5:** Polish UI and test all flows

---

## 💡 TIPS FOR SUCCESS

1. **Read the full guides** before starting
2. **Use the views** - they simplify complex queries
3. **Follow the existing code style** in the project
4. **Test with real data** as you go
5. **Ask questions** if anything is unclear
6. **Focus on one screen at a time**
7. **Reuse widgets** between screens where possible
8. **Keep code DRY** (Don't Repeat Yourself)

---

## 📞 REFERENCE MATERIALS

- **Complete specs:** additional_screens_guide_part1.md & part2.md
- **Database schema:** additional_screens_migration.sql
- **Overview:** ADDITIONAL_SCREENS_SUMMARY.md
- **Quick reference:** QUICK_REFERENCE_CARD.md

---

**Ready to start? Let's build these 6 screens! 🚀**

Please confirm you've read the guide files and are ready to begin implementation.