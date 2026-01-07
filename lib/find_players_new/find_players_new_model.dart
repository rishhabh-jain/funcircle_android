import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'find_players_new_widget.dart' show FindPlayersNewWidget;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'dart:async';
import 'models/player_request_model.dart';
import 'models/user_location_model.dart';
import 'models/venue_marker_model.dart';
import 'models/game_session_model.dart';
import 'services/map_service.dart';
import 'services/location_service.dart';
import 'services/heat_map_service.dart';
import 'widgets/map_marker_builder.dart';

class FindPlayersNewModel extends FlutterFlowModel<FindPlayersNewWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  // Current sport type (badminton or pickleball)
  String currentSport = 'badminton';

  // Loading states
  bool isLoadingMarkers = false;
  bool isLoadingLocation = false;

  // User location
  LatLng? userLocation;

  // Map data
  List<VenueMarkerModel> venues = [];
  List<PlayerRequestModel> playerRequests = [];
  List<UserLocationModel> availablePlayers = [];
  List<GameSessionModel> gameSessions = [];
  List<Map<String, dynamic>> playNowGames = [];

  // Map markers
  Set<gmaps.Marker> markers = {};

  // Heat map
  bool isHeatMapMode = false;
  bool isLoadingHeatMap = false;
  Set<gmaps.Circle> heatMapCircles = {};

  // User visibility on map
  bool isUserVisibleOnMap = false;

  // Filters
  int? selectedSkillLevel;
  double maxDistanceKm = 10.0;
  String timeFilter = 'all'; // 'all', 'today', 'this_week'

  // Real-time subscriptions
  StreamSubscription? _requestsSubscription;
  StreamSubscription? _playersSubscription;
  StreamSubscription? _sessionsSubscription;

  @override
  void initState(BuildContext context) {
    // Initialize with default location (will be updated with user location)
    googleMapsCenter = const LatLng(28.7041, 77.1025); // Delhi, India
  }

  @override
  void dispose() {
    _requestsSubscription?.cancel();
    _playersSubscription?.cancel();
    _sessionsSubscription?.cancel();
  }

  /// Load all map data for current sport
  Future<void> loadMapData() async {
    isLoadingMarkers = true;

    try {
      // Load all data in parallel
      final results = await Future.wait([
        MapService.getVenues(),
        MapService.getActiveRequestsBySport(currentSport),
        MapService.getAvailablePlayersBySport(currentSport),
        MapService.getGameSessionsBySport(currentSport),
        MapService.getPlayNowGamesBySport(currentSport),
      ]);

      venues = results[0] as List<VenueMarkerModel>;
      playerRequests = results[1] as List<PlayerRequestModel>;
      availablePlayers = results[2] as List<UserLocationModel>;
      gameSessions = results[3] as List<GameSessionModel>;
      playNowGames = results[4] as List<Map<String, dynamic>>;

      // Generate markers after loading data
      await generateMarkers();
    } catch (e) {
      print('Error loading map data: $e');
    } finally {
      isLoadingMarkers = false;
    }
  }

  /// Get user's current location
  Future<void> getUserLocation() async {
    isLoadingLocation = true;

    try {
      final location = await LocationService.getCurrentLatLng();
      if (location != null) {
        userLocation = LatLng(location.latitude, location.longitude);
        googleMapsCenter = userLocation;

        // Move camera to user location
        final controller = await googleMapsController.future;
        controller.animateCamera(
          gmaps.CameraUpdate.newLatLngZoom(
            gmaps.LatLng(location.latitude, location.longitude),
            14.0,
          ),
        );
      }
    } catch (e) {
      print('Error getting user location: $e');
    } finally {
      isLoadingLocation = false;
    }
  }

  /// Switch sport type and reload data
  Future<void> switchSport(String newSport) async {
    if (currentSport != newSport) {
      currentSport = newSport;
      // Cancel existing subscriptions
      _requestsSubscription?.cancel();
      _playersSubscription?.cancel();
      _sessionsSubscription?.cancel();
      // Reload data and restart subscriptions
      await loadMapData();
      subscribeToUpdates();
    }
  }

  /// Subscribe to real-time updates
  void subscribeToUpdates() {
    // Cancel existing subscriptions first to prevent duplicates
    _requestsSubscription?.cancel();
    _playersSubscription?.cancel();
    _sessionsSubscription?.cancel();

    // Subscribe to player requests with better error handling
    _requestsSubscription = MapService.subscribeToRequests(currentSport).listen(
      (requests) {
        playerRequests = requests;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        // Silently handle subscription errors - likely RLS or Realtime config issue
        // Only log once to avoid spam
      },
      cancelOnError: false, // Keep subscription alive even on errors
    );

    // Subscribe to available players with better error handling
    _playersSubscription =
        MapService.subscribeToPlayerLocations(currentSport).listen(
      (players) {
        availablePlayers = players;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        // Silently handle errors
      },
      cancelOnError: false,
    );

    // Subscribe to game sessions with better error handling
    _sessionsSubscription =
        MapService.subscribeToGameSessions(currentSport).listen(
      (sessions) {
        gameSessions = sessions;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        // Silently handle errors
      },
      cancelOnError: false,
    );
  }

  /// Apply filters to data
  List<PlayerRequestModel> get filteredRequests {
    final now = DateTime.now();

    return playerRequests.where((request) {
      // CRITICAL FIX: Always filter out past requests regardless of timeFilter
      // This ensures old dates never appear even after button clicks
      if (request.scheduledTime.isBefore(now)) {
        return false;
      }

      // Skill level filter
      if (selectedSkillLevel != null &&
          request.skillLevel != null &&
          request.skillLevel != selectedSkillLevel) {
        return false;
      }

      // Distance filter
      if (userLocation != null && request.latLng != null) {
        final distance = LocationService.calculateDistance(
          startLatitude: userLocation!.latitude,
          startLongitude: userLocation!.longitude,
          endLatitude: request.latLng!.latitude,
          endLongitude: request.latLng!.longitude,
        );
        if (distance > maxDistanceKm) {
          return false;
        }
      }

      // Additional time filter (optional - for further narrowing)
      if (timeFilter == 'today') {
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        if (request.scheduledTime.isBefore(today) ||
            request.scheduledTime.isAfter(tomorrow)) {
          return false;
        }
      } else if (timeFilter == 'this_week') {
        final weekFromNow = now.add(const Duration(days: 7));
        if (request.scheduledTime.isAfter(weekFromNow)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get filtered players
  List<UserLocationModel> get filteredPlayers {
    return availablePlayers.where((player) {
      // Skill level filter
      if (selectedSkillLevel != null &&
          player.skillLevel != null &&
          player.skillLevel != selectedSkillLevel) {
        return false;
      }

      // Distance filter
      if (userLocation != null) {
        final distance = LocationService.calculateDistance(
          startLatitude: userLocation!.latitude,
          startLongitude: userLocation!.longitude,
          endLatitude: player.latLng.latitude,
          endLongitude: player.latLng.longitude,
        );
        if (distance > maxDistanceKm) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get filtered game sessions
  List<GameSessionModel> get filteredSessions {
    final now = DateTime.now();
    return gameSessions.where((session) {
      // Only show open sessions
      if (!session.isOpen) return false;

      // CRITICAL FIX: Filter out past sessions (scheduled_time must be in future)
      if (session.scheduledTime.isBefore(now)) {
        return false;
      }

      // Skill level filter
      if (selectedSkillLevel != null &&
          session.skillLevelRequired != null &&
          session.skillLevelRequired != selectedSkillLevel) {
        return false;
      }

      // Distance filter
      if (userLocation != null && session.latLng != null) {
        final distance = LocationService.calculateDistance(
          startLatitude: userLocation!.latitude,
          startLongitude: userLocation!.longitude,
          endLatitude: session.latLng!.latitude,
          endLongitude: session.latLng!.longitude,
        );
        if (distance > maxDistanceKm) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get filtered venues based on current sport
  List<VenueMarkerModel> get filteredVenues {
    return venues.where((venue) {
      // Filter by sport type - show if venue supports current sport or both sports
      if (venue.sportType == null)
        return true; // Show venues without sport type
      if (venue.sportType == 'both')
        return true; // Show venues that support both sports
      if (venue.sportType == currentSport)
        return true; // Show venues for current sport
      return false;
    }).toList();
  }

  /// Get filtered playnow games
  List<Map<String, dynamic>> get filteredPlayNowGames {
    final now = DateTime.now();

    return playNowGames.where((game) {
      // Only show open games
      if (game['status'] != 'open') return false;

      // CRITICAL FIX: Filter out past games by combining game_date AND start_time
      final gameDateStr = game['game_date'] as String?;
      final startTimeStr = game['start_time'] as String?;

      if (gameDateStr != null && startTimeStr != null) {
        try {
          // Parse date (YYYY-MM-DD format)
          final gameDate = DateTime.parse(gameDateStr);

          // Parse time (HH:MM:SS format)
          final timeParts = startTimeStr.split(':');
          if (timeParts.length >= 2) {
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);

            // Combine date and time into full DateTime
            final gameDateTime = DateTime(
              gameDate.year,
              gameDate.month,
              gameDate.day,
              hour,
              minute,
            );

            // Game must be in the future (not just today, but future time)
            if (gameDateTime.isBefore(now)) {
              return false;  // Exclude past games
            }
          } else {
            // If time format is invalid, fall back to date-only comparison
            final today = DateTime(now.year, now.month, now.day);
            if (gameDate.isBefore(today)) {
              return false;
            }
          }
        } catch (e) {
          print('Error parsing game datetime: $e');
          // If parsing fails, exclude the game to be safe
          return false;
        }
      } else if (gameDateStr != null) {
        // Fallback: If no start_time, just check date
        try {
          final gameDate = DateTime.parse(gameDateStr);
          final today = DateTime(now.year, now.month, now.day);
          if (gameDate.isBefore(today)) {
            return false;
          }
        } catch (e) {
          print('Error parsing game_date: $e');
          return false;
        }
      }

      // Skill level filter
      if (selectedSkillLevel != null &&
          game['skill_level'] != null &&
          game['skill_level'] != selectedSkillLevel) {
        return false;
      }

      // Distance filter - playnow games don't have lat/lng yet in the fetch
      // So we'll skip distance filtering for now
      // TODO: Add venue lat/lng to games query if needed

      return true;
    }).toList();
  }

  /// Generate map markers from filtered data
  Future<void> generateMarkers() async {
    final newMarkers = <gmaps.Marker>{};

    try {
      // Generate venue markers (filtered by sport)
      for (final venue in filteredVenues) {
        final icon = await MapMarkerBuilder.createVenueMarker(
          venueName: venue.name,
          sportType: venue.sportType,
        );
        newMarkers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('venue_${venue.id}'),
            position: gmaps.LatLng(venue.latitude, venue.longitude),
            icon: icon,
            anchor: const Offset(0.5, 0.5), // Center anchor for circular marker - prevents moving
            infoWindow: gmaps.InfoWindow(title: venue.name),
            onTap: () => onVenueMarkerTapped?.call(venue),
          ),
        );
      }

      // Generate player markers (filtered)
      for (final player in filteredPlayers) {
        final icon = await MapMarkerBuilder.createPlayerMarker(
          profilePictureUrl: player.userProfilePicture,
          skillLevel: player.skillLevel,
          userName: player.userName ?? 'Unknown',
          sportType: currentSport, // Pass current sport type
        );
        newMarkers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('player_${player.id}'),
            position: gmaps.LatLng(player.latitude, player.longitude),
            icon: icon,
            anchor: const Offset(0.5, 0.5), // Center anchor for circular marker
            infoWindow: gmaps.InfoWindow(
              title: player.userName ?? 'Player',
            ),
            onTap: () => onPlayerMarkerTapped?.call(player),
          ),
        );
      }

      markers = newMarkers;
    } catch (e) {
      print('Error generating markers: $e');
    }
  }

  /// Apply filter changes and regenerate markers
  Future<void> applyFilters({
    int? skillLevel,
    double? distance,
    String? timeFilter,
  }) async {
    if (skillLevel != null) selectedSkillLevel = skillLevel;
    if (distance != null) maxDistanceKm = distance;
    if (timeFilter != null) this.timeFilter = timeFilter;

    await generateMarkers();
  }

  // Marker tap callbacks (to be set by widget)
  void Function(VenueMarkerModel)? onVenueMarkerTapped;
  void Function(UserLocationModel)? onPlayerMarkerTapped;
  void Function(PlayerRequestModel)? onRequestMarkerTapped;
  void Function(GameSessionModel)? onSessionMarkerTapped;

  /// Toggle heat map mode
  Future<void> toggleHeatMap() async {
    isHeatMapMode = !isHeatMapMode;

    if (isHeatMapMode) {
      // Load heat map data
      await generateHeatMap();
    } else {
      // Clear heat map circles
      heatMapCircles = {};
    }
  }

  /// Generate heat map circles from activity data
  Future<void> generateHeatMap({
    HeatMapTimeFilter timeFilter = HeatMapTimeFilter.all,
  }) async {
    isLoadingHeatMap = true;

    try {
      // Get heat map data points
      final heatMapPoints = await HeatMapService.getHeatMapData(
        sportType: currentSport,
        timeFilter: timeFilter,
        daysBack: 30,
      );

      // Convert to map circles
      heatMapCircles = HeatMapService.generateHeatMapCircles(heatMapPoints);
    } catch (e) {
      print('Error generating heat map: $e');
      heatMapCircles = {};
    } finally {
      isLoadingHeatMap = false;
    }
  }

  /// Toggle user visibility on map
  Future<void> toggleUserVisibility(String userId) async {
    isUserVisibleOnMap = !isUserVisibleOnMap;

    try {
      // Update user location availability in database
      await MapService.updateUserVisibility(
        userId: userId,
        isAvailable: isUserVisibleOnMap,
        sportType: currentSport,
        latitude: userLocation?.latitude,
        longitude: userLocation?.longitude,
      );

      // IMPORTANT: Reload data to sync map with visibility change
      // This ensures the user marker appears/disappears immediately
      await loadMapData();
    } catch (e) {
      print('Error updating user visibility: $e');
      // Revert on error
      isUserVisibleOnMap = !isUserVisibleOnMap;
    }
  }
}
