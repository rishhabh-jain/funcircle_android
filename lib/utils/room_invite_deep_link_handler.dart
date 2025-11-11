import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../screens/chat/join_room_screen.dart';

/// Handles deep links for room invites
/// Supports custom URL scheme: funcircle://room/join/{invite_code}
class RoomInviteDeepLinkHandler {
  static final RoomInviteDeepLinkHandler _instance =
      RoomInviteDeepLinkHandler._internal();

  factory RoomInviteDeepLinkHandler() => _instance;

  RoomInviteDeepLinkHandler._internal();

  final _appLinks = AppLinks();
  bool _initialized = false;

  /// Initialize deep link handling
  /// Call this in main.dart after app initialization
  Future<void> initialize(BuildContext context) async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Handle initial link if app was launched via deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri, context);
      }

      // Listen to incoming links while app is running
      _appLinks.uriLinkStream.listen(
        (uri) {
          _handleDeepLink(uri, context);
        },
        onError: (err) {
          print('Room invite deep link error: $err');
        },
      );
    } catch (e) {
      print('Error initializing room invite deep links: $e');
    }
  }

  /// Handle a deep link URI
  void _handleDeepLink(Uri uri, BuildContext context) {
    print('Received room invite deep link: $uri');

    // Check if it's a room invite link
    // Format: funcircle://room/join/{invite_code}
    if (uri.scheme == 'funcircle' && uri.host == 'room') {
      final pathSegments = uri.pathSegments;

      // Check for join action with invite code
      if (pathSegments.length >= 2 && pathSegments[0] == 'join') {
        final inviteCode = pathSegments[1];
        _navigateToJoinRoom(inviteCode, context);
      } else {
        print('Invalid room invite link format');
      }
    } else {
      print('Not a room invite deep link: ${uri.scheme}://${uri.host}${uri.path}');
    }
  }

  /// Navigate to join room screen
  void _navigateToJoinRoom(String inviteCode, BuildContext context) {
    print('Navigating to join room with code: $inviteCode');

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JoinRoomScreen(inviteCode: inviteCode),
        ),
      );
    } catch (e) {
      print('Error navigating to join room: $e');
    }
  }

  /// Manually handle a deep link URL (for testing or custom handling)
  Future<bool> handleUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      _handleDeepLink(uri, context);
      return true;
    } catch (e) {
      print('Error handling room invite URL: $e');
      return false;
    }
  }
}

/// Extension to add deep link handling to your main app
///
/// Usage in main.dart:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   final navigatorKey = GlobalKey<NavigatorState>();
///
///   runApp(MyApp(navigatorKey: navigatorKey));
///
///   // Initialize deep link handler
///   RoomInviteDeepLinkHandler().initialize(navigatorKey);
/// }
/// ```
