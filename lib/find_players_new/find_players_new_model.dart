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
  String currentSport = 'Badminton';

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

  // Map markers
  Set<gmaps.Marker> markers = {};

  // Heat map
  bool isHeatMapMode = false;
  bool isLoadingHeatMap = false;
  Set<gmaps.Circle> heatMapCircles = {};

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
      ]);

      venues = results[0] as List<VenueMarkerModel>;
      playerRequests = results[1] as List<PlayerRequestModel>;
      availablePlayers = results[2] as List<UserLocationModel>;
      gameSessions = results[3] as List<GameSessionModel>;

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
    // Subscribe to player requests
    _requestsSubscription = MapService.subscribeToRequests(currentSport).listen(
      (requests) {
        playerRequests = requests;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        print('Error in requests subscription: $error');
      },
    );

    // Subscribe to available players
    _playersSubscription =
        MapService.subscribeToPlayerLocations(currentSport).listen(
      (players) {
        availablePlayers = players;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        print('Error in players subscription: $error');
      },
    );

    // Subscribe to game sessions
    _sessionsSubscription =
        MapService.subscribeToGameSessions(currentSport).listen(
      (sessions) {
        gameSessions = sessions;
        generateMarkers(); // Regenerate markers on update
      },
      onError: (error) {
        print('Error in sessions subscription: $error');
      },
    );
  }

  /// Apply filters to data
  List<PlayerRequestModel> get filteredRequests {
    return playerRequests.where((request) {
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

      // Time filter
      if (timeFilter == 'today') {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        if (request.scheduledTime.isBefore(today) ||
            request.scheduledTime.isAfter(tomorrow)) {
          return false;
        }
      } else if (timeFilter == 'this_week') {
        final now = DateTime.now();
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
    return gameSessions.where((session) {
      // Only show open sessions
      if (!session.isOpen) return false;

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

  /// Generate map markers from filtered data
  Future<void> generateMarkers() async {
    final newMarkers = <gmaps.Marker>{};

    try {
      // Generate venue markers
      for (final venue in venues) {
        final icon = await MapMarkerBuilder.createVenueMarker();
        newMarkers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('venue_${venue.id}'),
            position: gmaps.LatLng(venue.latitude, venue.longitude),
            icon: icon,
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
        );
        newMarkers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('player_${player.id}'),
            position: gmaps.LatLng(player.latitude, player.longitude),
            icon: icon,
            infoWindow: gmaps.InfoWindow(
              title: player.userName ?? 'Player',
            ),
            onTap: () => onPlayerMarkerTapped?.call(player),
          ),
        );
      }

      // Generate request markers (filtered)
      for (final request in filteredRequests) {
        if (request.latLng != null) {
          final icon = await MapMarkerBuilder.createRequestMarker(
            playersNeeded: request.playersNeeded,
            skillLevel: request.skillLevel,
          );
          newMarkers.add(
            gmaps.Marker(
              markerId: gmaps.MarkerId('request_${request.id}'),
              position: gmaps.LatLng(request.latitude!, request.longitude!),
              icon: icon,
              infoWindow: gmaps.InfoWindow(
                title:
                    'Need ${request.playersNeeded} player${request.playersNeeded > 1 ? 's' : ''}',
              ),
              onTap: () => onRequestMarkerTapped?.call(request),
            ),
          );
        }
      }

      // Generate session markers (filtered)
      for (final session in filteredSessions) {
        if (session.latLng != null) {
          final icon = await MapMarkerBuilder.createSessionMarker(
            currentPlayers: session.joinedPlayersCount,
            maxPlayers: session.maxPlayers,
            playerPictures: [],
          );
          newMarkers.add(
            gmaps.Marker(
              markerId: gmaps.MarkerId('session_${session.id}'),
              position: gmaps.LatLng(session.latitude!, session.longitude!),
              icon: icon,
              infoWindow: gmaps.InfoWindow(
                title:
                    'Game Session ${session.joinedPlayersCount}/${session.maxPlayers}',
              ),
              onTap: () => onSessionMarkerTapped?.call(session),
            ),
          );
        }
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
}
