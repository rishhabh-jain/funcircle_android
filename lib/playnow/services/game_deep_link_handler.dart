import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/playnow/pages/game_details_page.dart';

/// Handles deep links for game invites
/// Supports custom URL scheme: funcircle://game/{gameId}
class GameDeepLinkHandler {
  static final GameDeepLinkHandler _instance =
      GameDeepLinkHandler._internal();

  factory GameDeepLinkHandler() => _instance;

  GameDeepLinkHandler._internal();

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
          print('Deep link error: $err');
        },
      );
    } catch (e) {
      print('Error initializing game deep links: $e');
    }
  }

  /// Handle a deep link URI
  void _handleDeepLink(Uri uri, BuildContext context) {
    print('Received deep link: $uri');

    // Check if it's a game link
    // Format: funcircle://game/{gameId}
    if (uri.scheme == 'funcircle' && uri.host == 'game') {
      final pathSegments = uri.pathSegments;

      // Get game ID from path
      String? gameId;
      if (pathSegments.isNotEmpty) {
        gameId = pathSegments[0];
      } else if (uri.path.isNotEmpty) {
        // Handle case where gameId might be directly in path
        gameId = uri.path.replaceAll('/', '');
      }

      if (gameId != null && gameId.isNotEmpty) {
        _navigateToGame(gameId, context);
      } else {
        print('Invalid game deep link - no game ID found');
      }
    } else {
      print('Not a game deep link: ${uri.scheme}://${uri.host}${uri.path}');
    }
  }

  /// Navigate to game details page
  void _navigateToGame(String gameId, BuildContext context) {
    print('Navigating to game: $gameId');

    try {
      // Use Navigator to push the game details page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: gameId),
        ),
      );
    } catch (e) {
      print('Error navigating to game: $e');

      // Fallback: try using GoRouter if available
      try {
        context.go('/gameDetails', extra: gameId);
      } catch (goError) {
        print('GoRouter navigation also failed: $goError');
      }
    }
  }

  /// Manually handle a deep link URL (for testing or custom handling)
  Future<bool> handleUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      _handleDeepLink(uri, context);
      return true;
    } catch (e) {
      print('Error handling URL: $e');
      return false;
    }
  }
}
