import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../single_venue_new/single_venue_new_widget.dart';

/// Handles deep links for venue sharing
/// Supports custom URL scheme: funcircle://venue/{venueId}
class VenueDeepLinkHandler {
  static final VenueDeepLinkHandler _instance =
      VenueDeepLinkHandler._internal();

  factory VenueDeepLinkHandler() => _instance;

  VenueDeepLinkHandler._internal();

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
          print('Venue deep link error: $err');
        },
      );
    } catch (e) {
      print('Error initializing venue deep links: $e');
    }
  }

  /// Handle a deep link URI
  void _handleDeepLink(Uri uri, BuildContext context) {
    print('Received venue deep link: $uri');

    // Check if it's a venue link
    // Format: funcircle://venue/{venueId}
    if (uri.scheme == 'funcircle' && uri.host == 'venue') {
      final pathSegments = uri.pathSegments;

      // Get venue ID from path
      String? venueId;
      if (pathSegments.isNotEmpty) {
        venueId = pathSegments[0];
      } else if (uri.path.isNotEmpty) {
        // Handle case where venueId might be directly in path
        venueId = uri.path.replaceAll('/', '');
      }

      if (venueId != null && venueId.isNotEmpty) {
        _navigateToVenue(venueId, context);
      } else {
        print('Invalid venue deep link - no venue ID found');
      }
    } else {
      print('Not a venue deep link: ${uri.scheme}://${uri.host}${uri.path}');
    }
  }

  /// Navigate to venue details page
  void _navigateToVenue(String venueId, BuildContext context) {
    print('Navigating to venue: $venueId');

    try {
      // Parse venue ID to int
      final venueIdInt = int.tryParse(venueId);
      if (venueIdInt == null) {
        print('Invalid venue ID format: $venueId');
        return;
      }

      // Use Navigator to push the venue details page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleVenueNewWidget(venueid: venueIdInt),
        ),
      );
    } catch (e) {
      print('Error navigating to venue: $e');

      // Fallback: try using GoRouter if available
      try {
        context.go('/venueDetails', extra: venueId);
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
      print('Error handling venue URL: $e');
      return false;
    }
  }
}
