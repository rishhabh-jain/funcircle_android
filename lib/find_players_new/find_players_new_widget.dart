import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'dart:ui';
import 'find_players_new_model.dart';
import 'widgets/player_info_sheet.dart';
import 'widgets/venue_info_sheet.dart';
import 'widgets/request_info_sheet.dart';
import 'widgets/session_info_sheet.dart';
import 'widgets/create_request_sheet.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/quick_match_sheet.dart';
import 'services/location_service.dart';
export 'find_players_new_model.dart';

class FindPlayersNewWidget extends StatefulWidget {
  const FindPlayersNewWidget({super.key});

  static String routeName = 'findPlayersNew';
  static String routePath = '/findPlayersNew';

  @override
  State<FindPlayersNewWidget> createState() => _FindPlayersNewWidgetState();
}

class _FindPlayersNewWidgetState extends State<FindPlayersNewWidget> {
  late FindPlayersNewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FindPlayersNewModel());

    // Set up marker tap callbacks
    _model.onPlayerMarkerTapped = _showPlayerInfo;
    _model.onVenueMarkerTapped = _showVenueInfo;
    _model.onRequestMarkerTapped = _showRequestInfo;
    _model.onSessionMarkerTapped = _showSessionInfo;

    // Initialize map data and location on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _model.getUserLocation();
      await _model.loadMapData();
      _model.subscribeToUpdates();
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // Google Map with custom markers
              gmaps.GoogleMap(
                onMapCreated: (controller) async {
                  if (!_model.googleMapsController.isCompleted) {
                    _model.googleMapsController.complete(controller);
                    // Hide all POI, businesses, and places - show only pure map
                    controller.setMapStyle('''
                    [
                      {
                        "featureType": "poi",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.business",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.park",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.attraction",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.government",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.medical",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.place_of_worship",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.school",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "poi.sports_complex",
                        "stylers": [{"visibility": "off"}]
                      },
                      {
                        "featureType": "transit",
                        "stylers": [{"visibility": "off"}]
                      }
                    ]
                    ''');
                  }
                },
                initialCameraPosition: gmaps.CameraPosition(
                  target: _model.googleMapsCenter != null
                      ? gmaps.LatLng(
                          _model.googleMapsCenter!.latitude,
                          _model.googleMapsCenter!.longitude,
                        )
                      : const gmaps.LatLng(28.7041, 77.1025),
                  zoom: 14.0,
                ),
                markers: _model.isHeatMapMode ? {} : _model.markers,
                circles: _model.isHeatMapMode ? _model.heatMapCircles : {},
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: gmaps.MapType.normal,
              ),

              // Top bar with sport toggle
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildTopBar(),
              ),

              // Filter, Quick Match, and Heat Map buttons
              Positioned(
                top: 80,
                right: 16,
                child: Column(
                  children: [
                    _buildFilterButton(),
                    const SizedBox(height: 8),
                    _buildQuickMatchButton(),
                    const SizedBox(height: 8),
                    _buildHeatMapToggleButton(),
                  ],
                ),
              ),

              // Loading indicator
              if (_model.isLoadingMarkers || _model.isLoadingLocation)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: FlutterFlowTheme.of(context).primary,
                        size: 50.0,
                      ),
                    ),
                  ),
                ),

              // Legend
              Positioned(
                bottom: 100,
                left: 16,
                child: _buildLegend(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateRequest,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Create Request',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Build top bar with sport toggle
  Widget _buildTopBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildSportButton('Badminton', Icons.sports_tennis),
              ),
              Expanded(
                child: _buildSportButton('Pickleball', Icons.sports_baseball),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build sport toggle button
  Widget _buildSportButton(String sport, IconData icon) {
    final isSelected = _model.currentSport == sport;
    return GestureDetector(
      onTap: () async {
        if (!isSelected) {
          await _model.switchSport(sport);
          safeSetState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFFFF6B35),
                    const Color(0xFFF7931E),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              sport,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build filter button
  Widget _buildFilterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilters,
          ),
        ),
      ),
    );
  }

  /// Build Quick Match button
  Widget _buildQuickMatchButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B35).withValues(alpha: 0.8),
                const Color(0xFFF7931E).withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.bolt, color: Colors.white),
            onPressed: _showQuickMatch,
            tooltip: 'Quick Match',
          ),
        ),
      ),
    );
  }

  /// Build Heat Map toggle button
  Widget _buildHeatMapToggleButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _model.isHeatMapMode
                  ? [
                      Colors.orange.withValues(alpha: 0.8),
                      Colors.deepOrange.withValues(alpha: 0.7),
                    ]
                  : [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.85),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _model.isHeatMapMode
                    ? Colors.orange.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.thermostat,
              color: Colors.white,
            ),
            onPressed: _toggleHeatMap,
            tooltip: _model.isHeatMapMode ? 'Show Markers' : 'Show Heat Map',
          ),
        ),
      ),
    );
  }

  /// Build map legend
  Widget _buildLegend() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Legend',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              _buildLegendItem(Icons.location_on, 'Venues', Colors.blue),
              _buildLegendItem(Icons.person_pin, 'Players', Colors.green),
              _buildLegendItem(Icons.people, 'Requests', Colors.orange),
              _buildLegendItem(Icons.sports, 'Sessions', Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

  /// Build legend item
  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  // Bottom sheet handlers

  void _showPlayerInfo(player) {
    // Calculate distance if user location is available
    double? distance;
    if (_model.userLocation != null) {
      distance = LocationService.calculateDistance(
        startLatitude: _model.userLocation!.latitude,
        startLongitude: _model.userLocation!.longitude,
        endLatitude: player.latitude,
        endLongitude: player.longitude,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlayerInfoSheet(
        player: player,
        distanceKm: distance,
      ),
    );
  }

  void _showVenueInfo(venue) {
    // Calculate distance if user location is available
    double? distance;
    if (_model.userLocation != null) {
      distance = LocationService.calculateDistance(
        startLatitude: _model.userLocation!.latitude,
        startLongitude: _model.userLocation!.longitude,
        endLatitude: venue.latitude,
        endLongitude: venue.longitude,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VenueInfoSheet(
        venue: venue,
        distanceKm: distance,
      ),
    );
  }

  void _showRequestInfo(request) {
    // Calculate distance if user location is available
    double? distance;
    if (_model.userLocation != null && request.latLng != null) {
      distance = LocationService.calculateDistance(
        startLatitude: _model.userLocation!.latitude,
        startLongitude: _model.userLocation!.longitude,
        endLatitude: request.latitude,
        endLongitude: request.longitude,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RequestInfoSheet(
        request: request,
        distanceKm: distance,
        currentUserId: currentUserUid ?? '',
      ),
    );
  }

  void _showSessionInfo(session) {
    // Calculate distance if user location is available
    double? distance;
    if (_model.userLocation != null && session.latLng != null) {
      distance = LocationService.calculateDistance(
        startLatitude: _model.userLocation!.latitude,
        startLongitude: _model.userLocation!.longitude,
        endLatitude: session.latitude,
        endLongitude: session.longitude,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SessionInfoSheet(
        session: session,
        distanceKm: distance,
        currentUserId: currentUserUid ?? '',
      ),
    );
  }

  Future<void> _showCreateRequest() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRequestSheet(
        currentUserId: currentUserUid ?? '',
        currentSport: _model.currentSport,
        venues: _model.venues,
      ),
    );

    // Reload data if request was created
    if (result == true) {
      await _model.loadMapData();
      safeSetState(() {});
    }
  }

  Future<void> _showFilters() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        currentSkillLevel: _model.selectedSkillLevel,
        currentMaxDistance: _model.maxDistanceKm,
        currentTimeFilter: _model.timeFilter,
      ),
    );

    // Apply filters if returned
    if (result != null) {
      await _model.applyFilters(
        skillLevel: result['skillLevel'] as int?,
        distance: result['maxDistance'] as double?,
        timeFilter: result['timeFilter'] as String?,
      );
      safeSetState(() {});
    }
  }

  /// Show Quick Match sheet for AI-powered matching
  void _showQuickMatch() {
    if (_model.userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location to use Quick Match'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickMatchSheet(
        sportType: _model.currentSport,
        userLatitude: _model.userLocation!.latitude,
        userLongitude: _model.userLocation!.longitude,
        userSkillLevel: null, // TODO: Get from user profile if needed
      ),
    );
  }

  /// Toggle heat map visualization
  Future<void> _toggleHeatMap() async {
    await _model.toggleHeatMap();
    safeSetState(() {});
  }
}
