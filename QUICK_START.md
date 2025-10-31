# Quick Start Guide - Additional Screens

## 🚀 Get Started in 3 Steps

### Step 1: Add Routes (Required)
Open `lib/index.dart` and add:

```dart
// At the top with other imports
import 'screens/more_options/more_options_widget.dart';
import 'screens/settings/settings_widget.dart';
import 'screens/settings/contact_support_widget.dart';
import 'screens/settings/policy_widget.dart';
import 'screens/profile/my_profile_widget.dart';
import 'screens/bookings/my_bookings_widget.dart';
import 'screens/game_requests/game_requests_widget.dart';
import 'screens/play_friends/my_play_friends_widget.dart';

// In your routes list
GoRoute(
  path: '/MoreOptionsScreen',
  name: 'MoreOptionsScreen',
  builder: (context, state) => const MoreOptionsWidget(),
),
// ... add all 8 routes (see ROUTING_SETUP.md for complete list)
```

### Step 2: Test Navigation
Add a button anywhere to test:

```dart
ElevatedButton(
  onPressed: () => context.pushNamed('MoreOptionsScreen'),
  child: const Text('Open More Options'),
)
```

### Step 3: Create RPC Functions in Supabase
Run these SQL commands in your Supabase SQL editor:

```sql
-- Function 1: Get user booking stats
CREATE OR REPLACE FUNCTION get_user_booking_stats(p_user_id UUID)
RETURNS JSON AS $$
BEGIN
  RETURN json_build_object(
    'total_bookings', (SELECT COUNT(*) FROM orders WHERE user_id = p_user_id),
    'upcoming_bookings', (SELECT COUNT(*) FROM orders
      WHERE user_id = p_user_id
      AND booking_status = 'confirmed'
      AND start_date_time > NOW())
  );
END;
$$ LANGUAGE plpgsql;

-- Function 2: Get play friend stats
CREATE OR REPLACE FUNCTION get_play_friend_stats(p_user_id UUID)
RETURNS JSON AS $$
BEGIN
  RETURN json_build_object(
    'total_friends', (SELECT COUNT(*) FROM play_friends WHERE user_id = p_user_id),
    'total_games_played', (SELECT COALESCE(SUM(games_played_together), 0) FROM play_friends WHERE user_id = p_user_id)
  );
END;
$$ LANGUAGE plpgsql;

-- Function 3: Get user stats
CREATE OR REPLACE FUNCTION get_user_stats(p_user_id UUID)
RETURNS JSON AS $$
BEGIN
  RETURN json_build_object(
    'user_id', p_user_id,
    'total_games', 0,
    'games_won', 0,
    'current_streak', 0,
    'rating', 0.0,
    'total_friends', (SELECT COUNT(*) FROM play_friends WHERE user_id = p_user_id),
    'total_bookings', (SELECT COUNT(*) FROM orders WHERE user_id = p_user_id),
    'sport_stats', '{}'::jsonb
  );
END;
$$ LANGUAGE plpgsql;
```

---

## ✅ That's It!

Your new screens are ready to use. Navigate to the More Options screen to access all new features.

---

## 📱 Screen Overview

| Screen | Route Name | Purpose |
|--------|-----------|---------|
| More Options | `MoreOptionsScreen` | Hub with navigation to all features |
| My Bookings | `MyBookingsScreen` | View and manage ticket bookings |
| Game Requests | `GameRequestsScreen` | Manage game invitations |
| Play Friends | `PlayFriendsScreen` | View and search play friends |
| My Profile | `MyProfileScreen` | View user profile and stats |
| Settings | `SettingsScreen` | App settings and preferences |
| Contact Support | `ContactSupportScreen` | Submit support tickets |
| Policy Viewer | `PolicyScreen` | View policies and terms |

---

## 🎯 Key Features

- ✅ **Material Design 3** UI throughout
- ✅ **Pull-to-refresh** on all list screens
- ✅ **Search & Filter** capabilities
- ✅ **Empty states** with helpful messages
- ✅ **Loading states** for all async operations
- ✅ **Error handling** with user-friendly messages
- ✅ **Confirmation dialogs** for destructive actions
- ✅ **Real-time data** from Supabase
- ✅ **Optimized performance** with ListView.builder

---

## 📖 Full Documentation

For detailed information, see:
- `ADDITIONAL_SCREENS_IMPLEMENTATION.md` - Complete implementation details
- `ROUTING_SETUP.md` - Detailed routing setup
- `IMPLEMENTATION_STATS.md` - Statistics and metrics

---

## 🆘 Need Help?

1. **Navigation not working?**
   - Check routes are added to index.dart
   - Verify route names match exactly

2. **Data not loading?**
   - Verify RPC functions are created in Supabase
   - Check database views exist
   - Verify user is authenticated

3. **Compilation errors?**
   - Run `flutter pub get`
   - Run `flutter analyze`
   - Check imports are correct

---

**Ready to go! 🎉**
