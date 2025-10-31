# Routing Setup for Additional Screens

## Quick Setup Guide

Add these imports and routes to your `lib/index.dart` file to enable navigation to the new screens.

---

## 1. Add Imports

Add these imports at the top of your `lib/index.dart` file:

```dart
// Additional Screens
import 'screens/more_options/more_options_widget.dart';
import 'screens/settings/settings_widget.dart';
import 'screens/settings/contact_support_widget.dart';
import 'screens/settings/policy_widget.dart';
import 'screens/profile/my_profile_widget.dart';
import 'screens/bookings/my_bookings_widget.dart';
import 'screens/game_requests/game_requests_widget.dart';
import 'screens/play_friends/my_play_friends_widget.dart';
```

---

## 2. Add Routes to GoRouter

If you're using GoRouter (which you are), add these routes to your routes list:

```dart
GoRoute(
  path: '/MoreOptionsScreen',
  name: 'MoreOptionsScreen',
  builder: (context, state) => const MoreOptionsWidget(),
),
GoRoute(
  path: '/MyBookingsScreen',
  name: 'MyBookingsScreen',
  builder: (context, state) => const MyBookingsWidget(),
),
GoRoute(
  path: '/GameRequestsScreen',
  name: 'GameRequestsScreen',
  builder: (context, state) => const GameRequestsWidget(),
),
GoRoute(
  path: '/PlayFriendsScreen',
  name: 'PlayFriendsScreen',
  builder: (context, state) => const MyPlayFriendsWidget(),
),
GoRoute(
  path: '/MyProfileScreen',
  name: 'MyProfileScreen',
  builder: (context, state) => const MyProfileWidget(),
),
GoRoute(
  path: '/SettingsScreen',
  name: 'SettingsScreen',
  builder: (context, state) => const SettingsWidget(),
),
GoRoute(
  path: '/ContactSupportScreen',
  name: 'ContactSupportScreen',
  builder: (context, state) => const ContactSupportWidget(),
),
GoRoute(
  path: '/PolicyScreen',
  name: 'PolicyScreen',
  builder: (context, state) {
    final policyType = state.uri.queryParameters['policyType'] ?? 'privacy';
    return PolicyWidget(policyType: policyType);
  },
),
```

---

## 3. Navigation Examples

### From anywhere in your app:

```dart
// Navigate to More Options (hub)
context.pushNamed('MoreOptionsScreen');

// Navigate to My Bookings
context.pushNamed('MyBookingsScreen');

// Navigate to Game Requests
context.pushNamed('GameRequestsScreen');

// Navigate to Play Friends
context.pushNamed('PlayFriendsScreen');

// Navigate to My Profile
context.pushNamed('MyProfileScreen');

// Navigate to Settings
context.pushNamed('SettingsScreen');

// Navigate to Contact Support
context.pushNamed('ContactSupportScreen');

// Navigate to Privacy Policy
context.pushNamed('PolicyScreen', queryParameters: {
  'policyType': 'privacy',
});

// Navigate to Terms of Service
context.pushNamed('PolicyScreen', queryParameters: {
  'policyType': 'terms',
});

// Navigate to Community Guidelines
context.pushNamed('PolicyScreen', queryParameters: {
  'policyType': 'community',
});
```

---

## 4. Add to Bottom Navigation (Optional)

If you want to add "More Options" to your bottom navigation bar, modify your bottom nav widget:

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.more_horiz),
  label: 'More',
),
```

And in the navigation handler:

```dart
case 4: // More tab
  return const MoreOptionsWidget();
```

---

## 5. Add to Drawer/Menu (Optional)

If you have a side drawer, you can add menu items:

```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text('My Profile'),
  onTap: () {
    Navigator.pop(context); // Close drawer
    context.pushNamed('MyProfileScreen');
  },
),
ListTile(
  leading: Icon(Icons.book_online),
  title: Text('My Bookings'),
  onTap: () {
    Navigator.pop(context);
    context.pushNamed('MyBookingsScreen');
  },
),
ListTile(
  leading: Icon(Icons.settings),
  title: Text('Settings'),
  onTap: () {
    Navigator.pop(context);
    context.pushNamed('SettingsScreen');
  },
),
```

---

## 6. Test Navigation

After adding routes, test by navigating from your app:

```dart
// Example: Add a button somewhere in your app
ElevatedButton(
  onPressed: () => context.pushNamed('MoreOptionsScreen'),
  child: Text('Open More Options'),
)
```

---

## Complete Example Integration

Here's how you might integrate the More Options screen into your existing bottom navigation:

```dart
// In your main navigation widget
class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeNewWidget(),
    FindPlayersNewWidget(),
    PlayNewWidget(),
    VenuesNewWidget(),
    MoreOptionsWidget(), // Add this as 5th tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Play'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Venues'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
```

---

## Troubleshooting

### Route not found error?
- Make sure you've added the import at the top of index.dart
- Verify the route name matches exactly (case-sensitive)
- Check that GoRouter is properly configured

### Screen shows but data doesn't load?
- Verify database migration is complete
- Check Supabase RPC functions exist
- Verify user authentication is working
- Check Supabase logs for errors

### Navigation doesn't work?
- Use `context.pushNamed()` not `context.push()`
- Make sure route name matches the `name` parameter in GoRoute
- Check for typos in route names

---

## Next Steps

1. ✅ Add imports to index.dart
2. ✅ Add routes to GoRouter configuration
3. ✅ Test navigation to each screen
4. ✅ Verify data loads correctly
5. ✅ Add to your main navigation if desired

That's it! Your new screens are ready to use.
