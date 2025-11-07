import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../screens/chat/join_room_screen.dart';

/// Handles deep links for room invites
class RoomInviteDeepLinkHandler {
  static final RoomInviteDeepLinkHandler _instance =
      RoomInviteDeepLinkHandler._internal();

  factory RoomInviteDeepLinkHandler() => _instance;

  RoomInviteDeepLinkHandler._internal();

  /// Initialize deep link handling
  /// Call this in main.dart after runApp
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // Handle links when app is in foreground
    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        _handleDynamicLink(dynamicLinkData, navigatorKey);
      },
      onError: (error) {
        print('Dynamic link error: $error');
      },
    );

    // Handle link that opened the app
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _handleDynamicLink(initialLink, navigatorKey);
    }
  }

  /// Handle a dynamic link
  void _handleDynamicLink(
    PendingDynamicLinkData dynamicLinkData,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    final deepLink = dynamicLinkData.link;

    // Check if it's a room invite link
    // Format: https://funcircle.app/room/join/{invite_code}
    if (deepLink.pathSegments.length >= 3 &&
        deepLink.pathSegments[0] == 'room' &&
        deepLink.pathSegments[1] == 'join') {
      final inviteCode = deepLink.pathSegments[2];
      _navigateToJoinRoom(inviteCode, navigatorKey);
    }
  }

  /// Navigate to join room screen
  void _navigateToJoinRoom(
    String inviteCode,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => JoinRoomScreen(inviteCode: inviteCode),
      ),
    );
  }

  /// Handle custom URL scheme links (for iOS universal links)
  /// Format: funcircle://room/join/{invite_code}
  Future<bool> handleCustomSchemeUrl(
    String url,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    try {
      final uri = Uri.parse(url);

      if (uri.scheme == 'funcircle' &&
          uri.pathSegments.length >= 3 &&
          uri.pathSegments[0] == 'room' &&
          uri.pathSegments[1] == 'join') {
        final inviteCode = uri.pathSegments[2];
        _navigateToJoinRoom(inviteCode, navigatorKey);
        return true;
      }

      return false;
    } catch (e) {
      print('Error handling custom URL: $e');
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
