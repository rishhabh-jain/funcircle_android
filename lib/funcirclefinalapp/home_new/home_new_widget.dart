import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/auth/firebase_auth/auth_util.dart';
import '/services/notifications_service.dart';
import '/index.dart';
import '/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:ui';
import 'home_new_model.dart';
export 'home_new_model.dart';

class HomeNewWidget extends StatefulWidget {
  const HomeNewWidget({super.key});

  static String routeName = 'HomeNew';
  static String routePath = '/homeNew';

  @override
  State<HomeNewWidget> createState() => _HomeNewWidgetState();
}

class _HomeNewWidgetState extends State<HomeNewWidget>
    with SingleTickerProviderStateMixin {
  late HomeNewModel _model;
  late TabController _sportTabController;
  late NotificationsService _notificationsService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeNewModel());
    _sportTabController = TabController(length: 2, vsync: this);
    _sportTabController.addListener(_onSportTabChanged);
    _notificationsService = NotificationsService(SupaFlow.client);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    // Get user's current location on initialization
    _fetchUserLocation();
    // Fetch unread notifications count
    _fetchUnreadNotificationsCount();
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    if (currentUserUid.isEmpty) return;

    try {
      final count = await _notificationsService.getUnreadCount(currentUserUid);
      safeSetState(() {
        _model.unreadNotificationsCount = count;
      });
    } catch (e) {
      print('Error fetching unread notifications count: $e');
    }
  }

  void _onSportTabChanged() {
    if (!_sportTabController.indexIsChanging) {
      safeSetState(() {
        if (_sportTabController.index == 0) {
          _model.choiceChipsValue = 'Badminton';
          _model.currentsportid = 90;
        } else {
          _model.choiceChipsValue = 'Pickleball';
          _model.currentsportid = 104;
        }
      });
    }
  }

  @override
  void dispose() {
    _sportTabController.removeListener(_onSportTabChanged);
    _sportTabController.dispose();
    _model.dispose();
    super.dispose();
  }

  /// Fetch user's current location
  /// Set [forceRefresh] to true to bypass cached location and fetch from GPS
  Future<void> _fetchUserLocation({bool forceRefresh = false}) async {
    // First check if we have a persisted location (only if not forcing refresh)
    if (!forceRefresh &&
        FFAppState().locationDisplayText.isNotEmpty &&
        FFAppState().userLocation != null) {
      safeSetState(() {
        _model.userLocation = FFAppState().userLocation;
        _model.locationDisplayText = FFAppState().locationDisplayText;
        _model.isLoadingLocation = false;
      });
      return;
    }

    safeSetState(() {
      _model.isLoadingLocation = true;
    });

    try {
      final location = await actions.getCurrentLocation();
      if (location != null) {
        safeSetState(() {
          _model.userLocation = location;
          _model.locationDisplayText = 'Current Location';
          _model.isLoadingLocation = false;
        });

        // Store in global app state as well
        FFAppState().update(() {
          FFAppState().userLocation = location;
          FFAppState().userLatitude = location.latitude;
          FFAppState().userLongitude = location.longitude;
          FFAppState().locationDisplayText = 'Current Location';
        });
      } else {
        // Location is null - either permission denied or location disabled
        safeSetState(() {
          _model.isLoadingLocation = false;
        });

        if (mounted && forceRefresh) {
          // Only show error if user explicitly tried to refresh
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Unable to get location. Please enable location services and grant permission in Settings.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () async {
                  // Try to open app settings
                  await actions.turnOnGPS();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching location: $e');
      safeSetState(() {
        _model.isLoadingLocation = false;
      });

      if (mounted && forceRefresh) {
        // Only show error if user explicitly tried to refresh
        String errorMessage = 'Unable to get your location.';

        // Try to provide more specific error message
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('permission') || errorStr.contains('denied')) {
          errorMessage = 'Location permission denied. Please grant permission in Settings.';
        } else if (errorStr.contains('disabled') || errorStr.contains('service')) {
          errorMessage = 'Location services disabled. Please enable location in Settings.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () async {
                // Try to open app settings
                await actions.turnOnGPS();
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _calculateVenueDistances(List<VenuesRow> venues) async {
    if (_model.userLocation == null) {
      print('⚠️ No user location available');
      return;
    }

    // Skip if already calculated for this exact location
    if (_model.lastCalculatedLocation != null &&
        _model.lastCalculatedLocation!.latitude ==
            _model.userLocation!.latitude &&
        _model.lastCalculatedLocation!.longitude ==
            _model.userLocation!.longitude &&
        _model.venueDistances.isNotEmpty) {
      print('✓ Distances already calculated for this location - SKIPPING');
      return;
    }

    // Skip if already calculating
    if (_model.isCalculatingDistances) {
      print('⚠️ Distance calculation already in progress - SKIPPING');
      return;
    }

    // Increment request ID to track this specific calculation
    _model.calculationRequestId++;
    final currentRequestId = _model.calculationRequestId;

    print('');
    print('🚀 Starting Distance Matrix API call #$currentRequestId');
    print(
        '   Location: ${_model.userLocation!.latitude}, ${_model.userLocation!.longitude}');
    print('   Venues: ${venues.length}');

    safeSetState(() {
      _model.isCalculatingDistances = true;
      _model.lastCalculatedLocation = _model.userLocation;
    });

    try {
      // Use Google Distance Matrix API to get road distances and durations
      final result = await actions.calculateDistanceMatrix(
        _model.userLocation!,
        venues,
      );

      // Check if this is still the latest request (not superseded by a newer one)
      if (currentRequestId != _model.calculationRequestId) {
        print(
            '⚠️ Request #$currentRequestId superseded by newer request #${_model.calculationRequestId} - DISCARDING results');
        return;
      }

      safeSetState(() {
        _model.venueDistances =
            Map<int, double>.from(result['distances'] as Map);
        _model.venueDurations = Map<int, int>.from(result['durations'] as Map);
        _model.isCalculatingDistances = false;
      });

      print(
          '✅ Distance Matrix API call #$currentRequestId completed successfully');
      print(
          '   Calculated distances for ${_model.venueDistances.length} venues');
      print('');
    } catch (e) {
      print('❌ Error in Distance Matrix API call #$currentRequestId: $e');
      safeSetState(() {
        _model.isCalculatingDistances = false;
      });
    }
  }

  List<VenuesRow> _sortVenuesByDistance(List<VenuesRow> venues) {
    if (_model.userLocation == null || _model.venueDistances.isEmpty) {
      return venues;
    }

    final sortedVenues = List<VenuesRow>.from(venues);
    sortedVenues.sort((a, b) {
      final distanceA = _model.venueDistances[a.id] ?? double.infinity;
      final distanceB = _model.venueDistances[b.id] ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });

    return sortedVenues;
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)} m';
    } else {
      return '${distanceKm.toStringAsFixed(1)} km';
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '${hours}h';
      }
      return '${hours}h ${mins}m';
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => _LocationSearchDialog(
        currentLocation: _model.locationDisplayText,
        onLocationSelected: (placeId, description, latLng) async {
          safeSetState(() {
            _model.userLocation = latLng;
            _model.locationDisplayText = description;
            // Clear previous distances to trigger recalculation
            _model.venueDistances.clear();
            _model.lastCalculatedLocation = null;
          });

          // Update app state
          FFAppState().update(() {
            FFAppState().userLocation = latLng;
            FFAppState().userLatitude = latLng.latitude;
            FFAppState().userLongitude = latLng.longitude;
            FFAppState().locationDisplayText = description;
          });
        },
      ),
    );
  }

  Widget _buildSportsAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: clampedValue,
            child: InkWell(
              onTap: () {
                context.pushNamed('findPlayersNew');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated sports icons
                    // Cricket (top left)
                    Positioned(
                      left: 15 + (value * 8),
                      top: 15,
                      child: Transform.rotate(
                        angle: value * 0.3,
                        child: Icon(
                          Icons.sports_cricket,
                          size: 38,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                    // Badminton (top center-left)
                    Positioned(
                      left: 70,
                      top: 20,
                      child: Transform.rotate(
                        angle: -value * 0.2,
                        child: Icon(
                          Icons
                              .sports_tennis, // Using tennis as badminton placeholder
                          size: 32,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    // Football/Soccer (top right)
                    Positioned(
                      right: 20 - (value * 8),
                      top: 18,
                      child: Transform.rotate(
                        angle: -value * 0.3,
                        child: Icon(
                          Icons.sports_soccer,
                          size: 36,
                          color: Colors.white.withValues(alpha: 0.52),
                        ),
                      ),
                    ),
                    // Pickleball (bottom left) - using basketball as placeholder
                    Positioned(
                      left: 25,
                      bottom: 20,
                      child: Transform.rotate(
                        angle: value * 0.2,
                        child: Icon(
                          Icons.sports_basketball,
                          size: 30,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                    // Tennis (bottom center-right)
                    Positioned(
                      right: 80,
                      bottom: 22,
                      child: Icon(
                        Icons.sports_tennis,
                        size: 34,
                        color: Colors.white.withValues(alpha: 0.48),
                      ),
                    ),
                    // Additional decorative icon (bottom right)
                    Positioned(
                      right: 18,
                      bottom: 25,
                      child: Transform.rotate(
                        angle: -value * 0.15,
                        child: Icon(
                          Icons.sports_volleyball,
                          size: 28,
                          color: Colors.white.withValues(alpha: 0.42),
                        ),
                      ),
                    ),
                    // Center text with features
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Map icon with glow
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.white.withValues(alpha: 0.05),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.explore_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Main title with glow
                          Text(
                            'FIND PLAYERS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Features row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // On Maps
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.25),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.map_outlined,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'On Maps',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Online
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.25),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.greenAccent
                                                .withValues(alpha: 0.6),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Online',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tap indicator
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFF121212),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: _HomeBackgroundPainter(),
                ),
              ),
              // Main content
              SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glass UI Header with Wave Pattern (including notification bar)
                      Stack(
                        children: [
                          // Wave pattern background including status bar
                          CustomPaint(
                            painter: _HeaderWavePainter(),
                            child: Container(
                              height: 80 + MediaQuery.of(context).padding.top,
                              width: double.infinity,
                            ),
                          ),
                          // Header content with top padding
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: MediaQuery.of(context).padding.top + 12.0,
                              bottom: 12.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Menu button
                                InkWell(
                                  onTap: () {
                                    logFirebaseEvent('Menu_navigate_to');
                                    context.pushNamed('ProfileMenuScreen');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white
                                                  .withValues(alpha: 0.15),
                                              Colors.white
                                                  .withValues(alpha: 0.08),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.menu_rounded,
                                          color: Colors.white,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Spacer
                                const Spacer(),

                                // Notifications button
                                InkWell(
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'Notifications_navigate_to');
                                    await context.pushNamed(
                                        NotificationsScreenWidget.routeName);
                                    // Refresh unread count when returning from notifications screen
                                    _fetchUnreadNotificationsCount();
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white
                                                      .withValues(alpha: 0.15),
                                                  Colors.white
                                                      .withValues(alpha: 0.08),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white
                                                    .withValues(alpha: 0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.notifications_outlined,
                                              color: Colors.white,
                                              size: 22.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Unread badge
                                      if (_model.unreadNotificationsCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                _model.unreadNotificationsCount > 9
                                                    ? 4
                                                    : 6),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFF6584),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color(0xFF121212),
                                                width: 2,
                                              ),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 20,
                                              minHeight: 20,
                                            ),
                                            child: Text(
                                              _model.unreadNotificationsCount > 99
                                                  ? '99+'
                                                  : '${_model.unreadNotificationsCount}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Chats button
                                InkWell(
                                  onTap: () {
                                    logFirebaseEvent('Chats_navigate_to');
                                    context.pushNamed('chatsnew');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white
                                                  .withValues(alpha: 0.15),
                                              Colors.white
                                                  .withValues(alpha: 0.08),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.forum_rounded,
                                          color: Colors.white,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Profile button
                                InkWell(
                                  onTap: () {
                                    logFirebaseEvent('Profile_navigate_to');
                                    context.pushNamed('MyProfileScreen');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white
                                                  .withValues(alpha: 0.15),
                                              Colors.white
                                                  .withValues(alpha: 0.08),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Colors.white,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Thick Liquid Glass Location Picker
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _showLocationDialog,
                                child: Stack(
                                  children: [
                                    // Subtle outer shadow
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.15),
                                            blurRadius: 16,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Watery glass container
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 24, sigmaY: 24),
                                        child: Container(
                                          height: 56,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 14.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white
                                                    .withValues(alpha: 0.12),
                                                Colors.white
                                                    .withValues(alpha: 0.06),
                                                Colors.white
                                                    .withValues(alpha: 0.03),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: const [0.0, 0.5, 1.0],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white
                                                  .withValues(alpha: 0.18),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              // Subtle inner highlight
                                              BoxShadow(
                                                color: Colors.white
                                                    .withValues(alpha: 0.1),
                                                blurRadius: 8,
                                                offset: const Offset(-1, -1),
                                                spreadRadius: -1,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Icon with glow
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      const Color(0xFFFF6B35)
                                                          .withValues(
                                                              alpha: 0.2),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(
                                                  FFIcons.kmapPin,
                                                  color:
                                                      const Color(0xFFFF6B35),
                                                  size: 18.0,
                                                  shadows: [
                                                    Shadow(
                                                      color: const Color(
                                                              0xFFFF6B35)
                                                          .withValues(
                                                              alpha: 0.6),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: _model.isLoadingLocation
                                                    ? Text(
                                                        'Getting location...',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.7),
                                                          fontSize: 14,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          shadows: const [
                                                            Shadow(
                                                              color: Colors
                                                                  .black45,
                                                              blurRadius: 6,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Text(
                                                        _model.locationDisplayText ??
                                                            'Tap to set location',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors
                                                                  .black45,
                                                              blurRadius: 6,
                                                            ),
                                                          ],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                              ),
                                              Icon(
                                                Icons.edit_location_alt,
                                                color: Colors.white
                                                    .withValues(alpha: 0.8),
                                                size: 16.0,
                                                shadows: const [
                                                  Shadow(
                                                    color: Colors.black38,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Watery Glass GPS Button
                            InkWell(
                              onTap: () async {
                                safeSetState(() {
                                  _model.venueDistances.clear();
                                  _model.lastCalculatedLocation = null;
                                });

                                // Force refresh location from GPS
                                await _fetchUserLocation(forceRefresh: true);

                                // Show success feedback
                                if (mounted && _model.userLocation != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Location updated: ${_model.locationDisplayText}'),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  // Outer glow
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF6B35)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 20,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Main button
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 16, sigmaY: 16),
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF6B35),
                                              Color(0xFFF7931E),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                            BoxShadow(
                                              color: Colors.white
                                                  .withValues(alpha: 0.15),
                                              blurRadius: 6,
                                              offset: const Offset(-1, -1),
                                            ),
                                          ],
                                        ),
                                        child: _model.isLoadingLocation
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.my_location,
                                                color: Colors.white,
                                                size: 22.0,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Gap
                      const SizedBox(height: 16),
                      // Animated Sports Illustration
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildSportsAnimation(),
                      ),
                      const SizedBox(height: 16),
                      // Enhanced action cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Explore Venues Card
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent('Container_navigate_to');
                                  print('🔍 Explore Venues button tapped!');
                                  // Navigate to VenueBooking tab in main navigation
                                  final navBarState = context.findAncestorStateOfType<NavBarPageState>();
                                  print('🔍 Found navBarState: ${navBarState != null}');
                                  if (navBarState != null) {
                                    print('🔍 Switching to venuesNew tab');
                                    navBarState.switchToTab('venuesNew');
                                  } else {
                                    print('❌ NavBarPageState not found in widget tree');
                                  }
                                },
                                child: Container(
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF1E1E1E),
                                        Color(0xFF2A2A2A),
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: FlutterFlowTheme.of(context)
                                            .primary
                                            .withValues(alpha: 0.2),
                                        blurRadius: 12.0,
                                        offset: Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary
                                                        .withValues(alpha: 0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                FFIcons.kmapPin,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 20.0,
                                              ),
                                            ),
                                            Icon(
                                              FFIcons.kcaretRight,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 18.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'j1mjxljf' /* Explore venues */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'cymorick' /* Explore groups and venues */,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color: Colors.grey[400],
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            // Daily Games Card
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent('Container_navigate_to');
                                  context.pushNamed(PlaynewWidget.routeName);
                                },
                                child: Container(
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        FlutterFlowTheme.of(context)
                                            .primary
                                            .withValues(alpha: 0.3),
                                        FlutterFlowTheme.of(context)
                                            .warning
                                            .withValues(alpha: 0.3),
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).warning,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: FlutterFlowTheme.of(context)
                                            .warning
                                            .withValues(alpha: 0.2),
                                        blurRadius: 12.0,
                                        offset: Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .warning
                                                        .withValues(alpha: 0.3),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                FFIcons
                                                    .kbadmintonPlayerSvgrepoCom,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .warning,
                                                size: 22.0,
                                              ),
                                            ),
                                            Icon(
                                              FFIcons.kcaretRight,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .warning,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'wp4krhz6' /* Daily Games */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'dlluqiix' /* Go to daily games happening ne... */,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color: Colors.grey[300],
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Game Requests and My Bookings Cards - Same Height
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            // Game Requests Card
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed('GameRequestsScreen');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      height: 70,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white
                                                .withValues(alpha: 0.03),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.sports_tennis,
                                            color: const Color(0xFFFF6B35),
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'My Games',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'View all requests',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                    fontSize: 10,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // My Bookings Card - Same height
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed('MyBookingsScreen');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      height: 70,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white
                                                .withValues(alpha: 0.03),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.book_online_outlined,
                                            color: const Color(0xFF64B5F6),
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'My Bookings',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'View your bookings',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                    fontSize: 10,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.0),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GradientText(
                                FFLocalizations.of(context).getText(
                                  'e1aagha6' /* Venues Near You */,
                                ),
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                colors: [
                                  FlutterFlowTheme.of(context).primary,
                                  FlutterFlowTheme.of(context).tertiary
                                ],
                                gradientDirection: GradientDirection.ltr,
                                gradientType: GradientType.linear,
                              ),
                            ),
                            if (_model.isCalculatingDistances)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 16.0,
                                  height: 16.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Sport Filter (matching My Bookings style)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1.5,
                                ),
                              ),
                              child: TabBar(
                                controller: _sportTabController,
                                labelColor: Colors.white,
                                unselectedLabelColor:
                                    Colors.white.withValues(alpha: 0.6),
                                indicator: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B35),
                                      Color(0xFFF7931E)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.orange.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorPadding: const EdgeInsets.all(5),
                                dividerColor: Colors.transparent,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                labelStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                                tabs: [
                                  Tab(
                                      text: FFLocalizations.of(context)
                                          .getText('vf7sv3s3' /* Badminton */)),
                                  Tab(
                                      text: FFLocalizations.of(context).getText(
                                          'jjgj6gy1' /* Pickleball */)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Carousel showing 3 venues per slide
                      FutureBuilder<List<VenuesRow>>(
                        future: VenuesTable().queryRows(
                          queryFn: (q) => q.eqOrNull(
                            'group_id',
                            _model.currentsportid,
                          ),
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: SpinKitRing(
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 50.0,
                                ),
                              ),
                            );
                          }
                          List<VenuesRow> venues = snapshot.data!;

                          if (venues.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Text(
                                  'No venues available',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.grey[400],
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            );
                          }

                          // Calculate distances after build is complete to avoid setState during build
                          // Only schedule if not already calculating or calculated
                          if (!_model.isCalculatingDistances &&
                              (_model.lastCalculatedLocation == null ||
                                  _model.lastCalculatedLocation!.latitude !=
                                      _model.userLocation?.latitude ||
                                  _model.lastCalculatedLocation!.longitude !=
                                      _model.userLocation?.longitude ||
                                  _model.venueDistances.isEmpty)) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted &&
                                  _model.userLocation != null &&
                                  !_model.isCalculatingDistances) {
                                _calculateVenueDistances(venues);
                              }
                            });
                          }

                          // Sort venues by distance if location is available
                          final sortedVenues = _sortVenuesByDistance(venues);

                          // Group venues into chunks of 3
                          final List<List<VenuesRow>> groupedVenues = [];
                          for (int i = 0; i < sortedVenues.length; i += 3) {
                            groupedVenues.add(
                              sortedVenues.sublist(
                                i,
                                i + 3 > sortedVenues.length
                                    ? sortedVenues.length
                                    : i + 3,
                              ),
                            );
                          }

                          return Column(
                            children: [
                              // Carousel
                              Container(
                                height: 600.0,
                                child: PageView.builder(
                                  controller: _model.venueCarouselController,
                                  onPageChanged: (index) {
                                    safeSetState(() {
                                      _model.currentCarouselPage = index;
                                    });
                                  },
                                  itemCount: groupedVenues.length,
                                  itemBuilder: (context, pageIndex) {
                                    final venuesInPage =
                                        groupedVenues[pageIndex];
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        children: venuesInPage.map((venue) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_navigate_to');
                                                context.pushNamed(
                                                  SingleVenueNewWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'venueid': serializeParam(
                                                      venue.id,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 180.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF1E1E1E),
                                                      Color(0xFF2A2A2A),
                                                    ],
                                                    stops: [0.0, 1.0],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                              .withValues(
                                                                  alpha: 0.15),
                                                      blurRadius: 16.0,
                                                      offset: Offset(0, 6),
                                                    )
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    // Enhanced image with overlay
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0.0),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            imageUrl: venue
                                                                .images
                                                                .firstOrNull!,
                                                            width: 140.0,
                                                            height: 180.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        // Gradient overlay
                                                        Container(
                                                          width: 140.0,
                                                          height: 180.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .transparent,
                                                                Colors.black
                                                                    .withValues(
                                                                        alpha:
                                                                            0.3),
                                                              ],
                                                              stops: [0.6, 1.0],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                            ),
                                                          ),
                                                        ),
                                                        // Distance & Duration badges
                                                        if (_model
                                                            .venueDistances
                                                            .containsKey(
                                                                venue.id))
                                                          Positioned(
                                                            top: 8.0,
                                                            right: 8.0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                // Distance badge
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        FlutterFlowTheme.of(context)
                                                                            .warning,
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withValues(alpha: 0.4),
                                                                        blurRadius:
                                                                            4.0,
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .near_me,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            11.0,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              3.0),
                                                                      Text(
                                                                        _formatDistance(
                                                                            _model.venueDistances[venue.id]!),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                              color: Colors.white,
                                                                              fontSize: 10.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // Duration badge
                                                                if (_model
                                                                    .venueDurations
                                                                    .containsKey(
                                                                        venue
                                                                            .id))
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8.0,
                                                                          vertical:
                                                                              4.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black
                                                                            .withValues(alpha: 0.7),
                                                                        borderRadius:
                                                                            BorderRadius.circular(12.0),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black.withValues(alpha: 0.4),
                                                                            blurRadius:
                                                                                4.0,
                                                                            offset:
                                                                                Offset(0, 2),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                11.0,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 3.0),
                                                                          Text(
                                                                            _formatDuration(_model.venueDurations[venue.id]!),
                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                  color: Colors.white,
                                                                                  fontSize: 10.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    // Content section
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    venue
                                                                        .venueName,
                                                                    'Venue name',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        6.0),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    venue
                                                                        .description,
                                                                    'Description',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Colors
                                                                            .grey[400],
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 12.0),
                                                            // Book now button
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 42.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .warning,
                                                                  ],
                                                                  stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ],
                                                                  begin: Alignment
                                                                      .centerLeft,
                                                                  end: Alignment
                                                                      .centerRight,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            SingleVenueNewWidget(
                                                                          venueid: venue.id,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Book now',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Page indicators
                              if (groupedVenues.length > 1)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      groupedVenues.length,
                                      (index) => AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width:
                                            index == _model.currentCarouselPage
                                                ? 24.0
                                                : 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          gradient: index ==
                                                  _model.currentCarouselPage
                                              ? LinearGradient(
                                                  colors: [
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                    FlutterFlowTheme.of(context)
                                                        .warning,
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                )
                                              : null,
                                          color: index ==
                                                  _model.currentCarouselPage
                                              ? null
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/images/WhatsApp_Image_2025-09-12_at_10.45.19_PM.jpeg',
                            width: double.infinity,
                            height: 167.7,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Footer Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 32),
                        child: Column(
                          children: [
                            // Decorative divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withValues(alpha: 0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // India flag emoji and text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '🇮🇳',
                                  style: TextStyle(fontSize: 28),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red.withValues(alpha: 0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Main text
                            Text(
                              'Made by sport lovers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'for sport lovers',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: const Color(0xFFFF6B35),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'India',
                                  style: TextStyle(
                                    color: const Color(0xFFFF6B35),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Small tagline
                            Text(
                              'Connecting sports enthusiasts nationwide',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wave pattern painter for header (including notification bar)
class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Smooth wave curves
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.orange.withValues(alpha: 0.1);

    // Top wave
    final wave1 = Path();
    wave1.moveTo(0, size.height * 0.3);
    for (double i = 0; i <= size.width; i += 40) {
      wave1.quadraticBezierTo(
        i + 20,
        size.height * 0.3 + (i % 80 == 0 ? -12 : 12),
        i + 40,
        size.height * 0.3,
      );
    }
    canvas.drawPath(wave1, wavePaint);

    // Middle wave
    final wave2 = Path();
    wave2.moveTo(0, size.height * 0.5);
    for (double i = 0; i <= size.width; i += 50) {
      wave2.quadraticBezierTo(
        i + 25,
        size.height * 0.5 + (i % 100 == 0 ? 10 : -10),
        i + 50,
        size.height * 0.5,
      );
    }
    canvas.drawPath(
        wave2, wavePaint..color = Colors.blue.withValues(alpha: 0.08));

    // Bottom wave
    final wave3 = Path();
    wave3.moveTo(0, size.height * 0.75);
    for (double i = 0; i <= size.width; i += 35) {
      wave3.quadraticBezierTo(
        i + 17.5,
        size.height * 0.75 + (i % 70 == 0 ? -8 : 8),
        i + 35,
        size.height * 0.75,
      );
    }
    canvas.drawPath(
        wave3, wavePaint..color = Colors.purple.withValues(alpha: 0.06));

    // Floating circles
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.06);

    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.25), 25, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.45), 30, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.65), 20,
        circlePaint..color = Colors.blue.withValues(alpha: 0.05));

    // Subtle gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.orange.withValues(alpha: 0.02),
          Colors.transparent,
          Colors.blue.withValues(alpha: 0.015),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Enhanced Background painter for home screen
class _HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Diagonal grid pattern
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = Colors.white.withValues(alpha: 0.01);

    // Draw diagonal lines from top-left to bottom-right
    for (int i = -10; i < 20; i++) {
      final startX = i * size.width * 0.15;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 1.2, size.height),
        gridPaint,
      );
    }

    // Draw diagonal lines from top-right to bottom-left
    for (int i = 0; i < 30; i++) {
      final startX = i * size.width * 0.15;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX - size.height * 1.2, size.height),
        gridPaint,
      );
    }

    // Large decorative circles with gradients
    final circlePaint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.03);

    final circlePaint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.blue.withValues(alpha: 0.02);

    // Top-right cluster
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.12), 60, circlePaint1);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12), 80,
        circlePaint1..color = Colors.orange.withValues(alpha: 0.015));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12), 100,
        circlePaint1..color = Colors.orange.withValues(alpha: 0.01));

    // Bottom-left cluster
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.75), 50, circlePaint2);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.75), 70,
        circlePaint2..color = Colors.blue.withValues(alpha: 0.01));
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.75), 90,
        circlePaint2..color = Colors.blue.withValues(alpha: 0.005));

    // Middle decorative circles
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 120,
        circlePaint1..color = Colors.orange.withValues(alpha: 0.01));
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.5), 80,
        circlePaint2..color = Colors.purple.withValues(alpha: 0.01));

    // Draw dots pattern
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.015);

    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 30; j++) {
        if ((i + j) % 3 == 0) {
          canvas.drawCircle(
            Offset(i * size.width * 0.08, j * size.height * 0.05),
            1.5,
            dotPaint,
          );
        }
      }
    }

    // Radial gradient top
    final radialPaint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange.withValues(alpha: 0.04),
          Colors.orange.withValues(alpha: 0.01),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.12),
        radius: size.width * 0.4,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.12),
      size.width * 0.4,
      radialPaint1,
    );

    // Radial gradient bottom
    final radialPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.03),
          Colors.blue.withValues(alpha: 0.01),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.15, size.height * 0.75),
        radius: size.width * 0.35,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.75),
      size.width * 0.35,
      radialPaint2,
    );

    // Animated wave effect
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.02);

    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.3);

    for (double i = 0; i <= size.width; i += 20) {
      wavePath.quadraticBezierTo(
        i + 10,
        size.height * 0.3 + (i % 40 == 0 ? -15 : 15),
        i + 20,
        size.height * 0.3,
      );
    }
    canvas.drawPath(wavePath, wavePaint);

    // Second wave
    final wavePath2 = Path();
    wavePath2.moveTo(0, size.height * 0.6);

    for (double i = 0; i <= size.width; i += 20) {
      wavePath2.quadraticBezierTo(
        i + 10,
        size.height * 0.6 + (i % 40 == 0 ? 15 : -15),
        i + 20,
        size.height * 0.6,
      );
    }
    canvas.drawPath(
        wavePath2, wavePaint..color = Colors.blue.withValues(alpha: 0.02));

    // Overall gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.orange.withValues(alpha: 0.015),
          Colors.transparent,
          Colors.blue.withValues(alpha: 0.01),
          Colors.purple.withValues(alpha: 0.01),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Location Search Dialog with Google Places Autocomplete
class _LocationSearchDialog extends StatefulWidget {
  final String? currentLocation;
  final Function(String placeId, String description, LatLng latLng)
      onLocationSelected;

  const _LocationSearchDialog({
    this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<_LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<_LocationSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Debounce search
    Future.delayed(Duration(milliseconds: 500), () {
      if (_searchController.text.trim() == query) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final results = await actions.searchPlaces(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error searching: $e');
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final latLng = await actions.geocodePlace(placeId);
      if (latLng != null) {
        widget.onLocationSelected(placeId, description, latLng);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to get coordinates for this location'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error selecting place: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Search Location',
        style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
              color: Colors.white,
              letterSpacing: 0.0,
              useGoogleFonts:
                  !FlutterFlowTheme.of(context).headlineSmallIsCustom,
            ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search field
              TextField(
                controller: _searchController,
                autofocus: true,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: Colors.white,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
                decoration: InputDecoration(
                  hintText: 'Search for sector, city, or area',
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Colors.grey[600],
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                  filled: true,
                  fillColor: Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16.0),

              // Search results
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : _isSearching
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          )
                        : _searchResults.isEmpty
                            ? Center(
                                child: Text(
                                  _searchController.text.isEmpty
                                      ? 'Start typing to search...'
                                      : 'No results found',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.grey[400],
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final place = _searchResults[index];
                                  final description =
                                      place['description'] as String;
                                  final placeId = place['place_id'] as String;

                                  return InkWell(
                                    onTap: () =>
                                        _selectPlace(placeId, description),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFF2C2C2E),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 20.0,
                                          ),
                                          SizedBox(width: 12.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  description,
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey[600],
                                            size: 16.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: Colors.grey[400],
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ),
      ],
    );
  }
}
