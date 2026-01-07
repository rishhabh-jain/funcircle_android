import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/playnow/widgets/create_game_sheet.dart';
import '/playnow/widgets/game_card.dart';
import '/playnow/pages/game_details_page.dart';
import '/playnow/services/game_service.dart';
import '/playnow/services/new_user_offer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'playnew_model.dart';
export 'playnew_model.dart';

class PlaynewWidget extends StatefulWidget {
  const PlaynewWidget({super.key});

  static String routeName = 'playnew';
  static String routePath = '/playnew';

  @override
  State<PlaynewWidget> createState() => _PlaynewWidgetState();
}

class _PlaynewWidgetState extends State<PlaynewWidget> {
  late PlaynewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<VenuesRow> _allVenues = [];
  bool _isLoadingVenues = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaynewModel());

    // Initialize on page load - PROGRESSIVE LOADING (non-blocking)
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Run independent operations in PARALLEL
      await Future.wait([
        // 1. Check new user offer (non-critical, runs in background)
        if (currentUserUid.isNotEmpty)
          NewUserOfferService.checkAndCreateNewUserOffer(currentUserUid)
              .catchError((e) => print('Offer check error: $e')),

        // 2. Fetch user location
        _fetchUserLocation(),

        // 3. Load venues
        _loadVenues(),
      ]);

      // After venues are loaded, load games with optimized query
      await _loadGamesOptimized();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
      if (location != null && mounted) {
        safeSetState(() {
          _model.userLocation = location;
          _model.locationDisplayText = 'Current Location';
          _model.isLoadingLocation = false;
        });

        // Store in global app state
        FFAppState().update(() {
          FFAppState().userLocation = location;
          FFAppState().userLatitude = location.latitude;
          FFAppState().userLongitude = location.longitude;
          FFAppState().locationDisplayText = 'Current Location';
        });
      } else {
        // Default to Gurugram coordinates
        if (mounted) {
          final gurugram = LatLng(28.4595, 77.0266);
          safeSetState(() {
            _model.userLocation = gurugram;
            _model.isLoadingLocation = false;
            _model.locationDisplayText = 'Gurugram';
          });

          // Store in global app state
          FFAppState().update(() {
            FFAppState().userLocation = gurugram;
            FFAppState().userLatitude = gurugram.latitude;
            FFAppState().userLongitude = gurugram.longitude;
            FFAppState().locationDisplayText = 'Gurugram';
          });

          // Show error if user explicitly tried to refresh
          if (forceRefresh) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Unable to get location. Please enable location services and grant permission in Settings. Using Gurugram as default.',
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
                    await actions.turnOnGPS();
                  },
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching location: $e');
      if (mounted) {
        // Default to Gurugram coordinates
        final gurugram = LatLng(28.4595, 77.0266);
        safeSetState(() {
          _model.userLocation = gurugram;
          _model.isLoadingLocation = false;
          _model.locationDisplayText = 'Gurugram';
        });

        // Store in global app state
        FFAppState().update(() {
          FFAppState().userLocation = gurugram;
          FFAppState().userLatitude = gurugram.latitude;
          FFAppState().userLongitude = gurugram.longitude;
          FFAppState().locationDisplayText = 'Gurugram';
        });

        // Show error if user explicitly tried to refresh
        if (forceRefresh) {
          String errorMessage = 'Unable to get your location. Using Gurugram as default.';

          // Try to provide more specific error message
          final errorStr = e.toString().toLowerCase();
          if (errorStr.contains('permission') || errorStr.contains('denied')) {
            errorMessage =
                'Location permission denied. Please grant permission in Settings. Using Gurugram as default.';
          } else if (errorStr.contains('disabled') ||
              errorStr.contains('service')) {
            errorMessage =
                'Location services disabled. Please enable location in Settings. Using Gurugram as default.';
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
                  await actions.turnOnGPS();
                },
              ),
            ),
          );
        }
      }
    }
  }

  /// Load venues from database
  Future<void> _loadVenues() async {
    try {
      safeSetState(() => _isLoadingVenues = true);

      // Fetch all venues
      final venuesData = await VenuesTable().queryRows(
        queryFn: (q) => q.inFilter('group_id', [90, 104, 105]),
      );

      if (mounted) {
        _allVenues = venuesData;

        // INSTANT: Calculate straight-line distances first (no API call)
        if (_model.userLocation != null) {
          _calculateStraightLineDistances();
        }

        // BACKGROUND: Calculate accurate road distances via Google API (non-blocking)
        // This will update the distances when ready
        if (_model.userLocation != null) {
          _calculateVenueDistances(); // No await!
        }

        // First check if there's a saved venue in app state
        if (FFAppState().selectedVenueId != null) {
          // Try to find the saved venue in current venues list
          final savedVenueId = FFAppState().selectedVenueId!;
          final sortedVenues = _getSortedVenuesBySport();
          final savedVenueExists = sortedVenues.any((v) => v.id == savedVenueId);

          if (savedVenueExists) {
            // Restore saved venue
            safeSetState(() {
              _model.selectedVenueId = FFAppState().selectedVenueId;
              _model.selectedVenueName = FFAppState().selectedVenueName;
            });
          } else {
            // Saved venue doesn't match current sport, select nearest
            if (sortedVenues.isNotEmpty) {
              final nearestVenue = sortedVenues.first;
              safeSetState(() {
                _model.selectedVenueId = nearestVenue.id;
                _model.selectedVenueName = nearestVenue.venueName;
              });
              // Save to app state
              FFAppState().update(() {
                FFAppState().selectedVenueId = nearestVenue.id;
                FFAppState().selectedVenueName = nearestVenue.venueName ?? '';
              });
            } else {
              safeSetState(() {
                _model.selectedVenueId = null;
                _model.selectedVenueName = null;
              });
            }
          }
        } else {
          // No saved venue, select nearest venue by default
          if (_allVenues.isNotEmpty) {
            final sortedVenues = _getSortedVenuesBySport();
            if (sortedVenues.isNotEmpty) {
              final nearestVenue = sortedVenues.first;
              safeSetState(() {
                _model.selectedVenueId = nearestVenue.id;
                _model.selectedVenueName = nearestVenue.venueName;
              });
              // Save to app state
              FFAppState().update(() {
                FFAppState().selectedVenueId = nearestVenue.id;
                FFAppState().selectedVenueName = nearestVenue.venueName ?? '';
              });
            } else {
              // No venues match the selected sport
              safeSetState(() {
                _model.selectedVenueId = null;
                _model.selectedVenueName = null;
              });
            }
          }
        }

        safeSetState(() => _isLoadingVenues = false);
      }
    } catch (e) {
      print('Error loading venues: $e');
      if (mounted) {
        safeSetState(() => _isLoadingVenues = false);
      }
    }
  }

  /// INSTANT: Calculate straight-line distances using Haversine formula
  /// This runs synchronously (no API call) and provides immediate approximate distances
  void _calculateStraightLineDistances() {
    if (_model.userLocation == null) return;

    print('📏 Calculating straight-line distances (instant)...');

    _model.venueDistances.clear();

    for (final venue in _allVenues) {
      if (venue.lat != null && venue.lng != null) {
        final distance = _calculateHaversineDistance(
          _model.userLocation!.latitude,
          _model.userLocation!.longitude,
          venue.lat!,
          venue.lng!,
        );
        _model.venueDistances[venue.id] = distance;
      }
    }

    print('✅ Straight-line distances ready for ${_model.venueDistances.length} venues');

    // Trigger UI update to show venues sorted by approximate distance
    if (mounted) {
      safeSetState(() {});
    }
  }

  /// Haversine formula to calculate straight-line distance between two points
  /// Returns distance in kilometers
  double _calculateHaversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    // Convert degrees to radians
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final radLat1 = _degreesToRadians(lat1);
    final radLat2 = _degreesToRadians(lat2);

    // Haversine formula
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(radLat1) * _cos(radLat2) * _sin(dLon / 2) * _sin(dLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * 3.14159265359 / 180.0;

  double _sin(double x) => x - (x * x * x) / 6 + (x * x * x * x * x) / 120;

  double _cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;

  double _sqrt(double x) {
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _atan2(double y, double x) {
    if (x > 0) {
      return _atan(y / x);
    } else if (x < 0 && y >= 0) {
      return _atan(y / x) + 3.14159265359;
    } else if (x < 0 && y < 0) {
      return _atan(y / x) - 3.14159265359;
    } else if (x == 0 && y > 0) {
      return 3.14159265359 / 2;
    } else if (x == 0 && y < 0) {
      return -3.14159265359 / 2;
    }
    return 0;
  }

  double _atan(double x) {
    return x - (x * x * x) / 3 + (x * x * x * x * x) / 5 -
           (x * x * x * x * x * x * x) / 7;
  }

  /// Calculate distances to venues (runs in BACKGROUND, non-blocking)
  /// When distances are ready, updates UI and re-sorts venues by distance
  Future<void> _calculateVenueDistances() async {
    if (_model.userLocation == null) return;
    if (_model.isCalculatingDistances) return;

    try {
      safeSetState(() => _model.isCalculatingDistances = true);

      print('🚀 Starting distance calculation in background...');

      final result = await actions.calculateDistanceMatrix(
        _model.userLocation!,
        _allVenues,
      );

      if (mounted) {
        safeSetState(() {
          _model.venueDistances.clear();
          _model.venueDurations.clear();

          // Result structure: {'distances': {venueId: distance}, 'durations': {venueId: duration}}
          final distances = result['distances'];
          final durations = result['durations'];

          if (distances != null) {
            distances.forEach((venueId, distance) {
              _model.venueDistances[venueId] = distance.toDouble();
            });
          }

          if (durations != null) {
            durations.forEach((venueId, duration) {
              _model.venueDurations[venueId] = duration.toInt();
            });
          }

          _model.lastCalculatedLocation = _model.userLocation;
        });

        print('✅ Distances calculated! Updating UI with distance info...');

        // Trigger UI update to show distances in venue selector
        safeSetState(() {});
      }
    } catch (e) {
      print('Error calculating distances: $e');
    } finally {
      if (mounted) {
        safeSetState(() => _model.isCalculatingDistances = false);
      }
    }
  }

  /// Get venues sorted by distance for selected sport
  List<VenuesRow> _getSortedVenuesBySport() {
    final sportType = _model.selectedSportType;

    // Filter venues by sport type
    var filtered = _allVenues.where((venue) {
      if (venue.sportType == null) return false;
      final venueSport = venue.sportType!.toLowerCase();
      return venueSport == sportType || venueSport == 'both';
    }).toList();

    // Sort by distance if available
    if (_model.venueDistances.isNotEmpty) {
      filtered.sort((a, b) {
        final distA = _model.venueDistances[a.id] ?? double.infinity;
        final distB = _model.venueDistances[b.id] ?? double.infinity;
        return distA.compareTo(distB);
      });
    }

    return filtered;
  }

  /// Load games from database
  Future<void> _loadGames() async {
    if (_model.selectedVenueId == null) return;

    safeSetState(() => _model.isLoadingGames = true);

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_model.selectedDate);

      final games = await GameService.getGamesForVenueAndDate(
        sportType: _model.selectedSportType,
        venueId: _model.selectedVenueId,
        date: dateStr,
        timeOfDay: _model.currentAmOrPm,
      );

      if (mounted) {
        safeSetState(() {
          _model.games = games;
          _model.isLoadingGames = false;
        });
      }
    } catch (e) {
      print('Error loading games: $e');
      if (mounted) {
        safeSetState(() {
          _model.games = [];
          _model.isLoadingGames = false;
        });
      }
    }
  }

  /// OPTIMIZED: Load games and auto-select best time (AM/PM) in one operation
  /// Reduces 3 queries to 2 parallel queries
  Future<void> _loadGamesOptimized() async {
    if (_model.selectedVenueId == null) {
      print('Cannot load games: No venue selected');
      return;
    }

    safeSetState(() => _model.isLoadingGames = true);

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_model.selectedDate);
      print('Loading games for date: $dateStr, venue: ${_model.selectedVenueId}, sport: ${_model.selectedSportType}');

      // Query AM and PM games in PARALLEL (not sequential)
      final results = await Future.wait([
        GameService.getGamesForVenueAndDate(
          sportType: _model.selectedSportType,
          venueId: _model.selectedVenueId,
          date: dateStr,
          timeOfDay: 'am',
        ),
        GameService.getGamesForVenueAndDate(
          sportType: _model.selectedSportType,
          venueId: _model.selectedVenueId,
          date: dateStr,
          timeOfDay: 'pm',
        ),
      ]);

      final amGames = results[0];
      final pmGames = results[1];

      print('Loaded: ${amGames.length} AM games, ${pmGames.length} PM games');

      if (mounted) {
        safeSetState(() {
          // Auto-select time period with more games, default to PM if equal
          if (amGames.isEmpty && pmGames.isEmpty) {
            // No games at all, keep current selection or default to PM
            _model.currentAmOrPm = _model.currentAmOrPm;
          } else {
            _model.currentAmOrPm = amGames.length > pmGames.length ? 'am' : 'pm';
          }

          // Set the games for the selected time
          _model.games = _model.currentAmOrPm == 'am' ? amGames : pmGames;
          _model.isLoadingGames = false;

          print('Selected: ${_model.currentAmOrPm} with ${_model.games.length} games');
        });
      }
    } catch (e) {
      print('Error loading games optimized: $e');
      if (mounted) {
        safeSetState(() {
          _model.games = [];
          _model.isLoadingGames = false;
        });
      }
    }
  }

  /// Show location selector dialog
  Future<void> _showLocationDialog() async {
    return showDialog(
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

          // Recalculate distances
          if (_allVenues.isNotEmpty) {
            await _calculateVenueDistances();

            // Select nearest venue after recalculating distances
            final sortedVenues = _getSortedVenuesBySport();
            if (sortedVenues.isNotEmpty) {
              safeSetState(() {
                _model.selectedVenueId = sortedVenues.first.id;
                _model.selectedVenueName = sortedVenues.first.venueName;
              });
              // Save to app state
              FFAppState().update(() {
                FFAppState().selectedVenueId = sortedVenues.first.id;
                FFAppState().selectedVenueName = sortedVenues.first.venueName ?? '';
              });

              // Reload games with optimized query
              await _loadGamesOptimized();
            }
          }
        },
      ),
    );
  }

  /// Show venue selector dialog
  Future<void> _showVenueSelector() async {
    final venues = _getSortedVenuesBySport();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Venue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Venues list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    final venue = venues[index];
                    final distance = _model.venueDistances[venue.id];
                    final isSelected = venue.id == _model.selectedVenueId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          safeSetState(() {
                            _model.selectedVenueId = venue.id;
                            _model.selectedVenueName = venue.venueName;
                          });
                          // Save to app state
                          FFAppState().update(() {
                            FFAppState().selectedVenueId = venue.id;
                            FFAppState().selectedVenueName = venue.venueName ?? '';
                          });
                          // Load games with optimized query
                          _loadGamesOptimized();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: isSelected
                                    ? FlutterFlowTheme.of(context).primary
                                    : Colors.white.withValues(alpha: 0.7),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      venue.venueName ?? 'Venue ${venue.id}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        if (distance != null) ...[
                                          Text(
                                            '${distance.toStringAsFixed(1)} km',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.6),
                                              fontSize: 13,
                                            ),
                                          ),
                                          if (_model.venueDurations[venue.id] != null) ...[
                                            Text(
                                              ' • ',
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.4),
                                                fontSize: 13,
                                              ),
                                            ),
                                            Icon(
                                              Icons.access_time,
                                              size: 12,
                                              color: Colors.white.withValues(alpha: 0.6),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${_model.venueDurations[venue.id]} min',
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.6),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // REMOVED BLOCKING LOADING SCREEN - Show UI immediately with progressive loading
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0A0A0A),
                const Color(0xFF1A1A1A),
                const Color(0xFF0A0A0A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header with location
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Sport selector
                SliverToBoxAdapter(
                  child: _buildSportSelector(),
                ),

                // Venue selector
                SliverToBoxAdapter(
                  child: _buildVenueSelector(),
                ),

                // Dates row
                SliverToBoxAdapter(
                  child: _buildDatesRow(),
                ),

                // Create Game + AM/PM row
                SliverToBoxAdapter(
                  child: _buildActionRow(),
                ),

                // Games list
                _buildGamesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with location
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Location selector
          Expanded(
            child: InkWell(
              onTap: _showLocationDialog,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _model.isLoadingLocation
                                ? 'Getting location...'
                                : (_model.locationDisplayText ?? 'Select Location'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Refresh location button
          InkWell(
            onTap: () async {
              safeSetState(() {
                _model.venueDistances.clear();
                _model.venueDurations.clear();
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

              // After fetching location, recalculate and update nearest venue
              if (_allVenues.isNotEmpty && _model.userLocation != null) {
                await _calculateVenueDistances();

                // Select nearest venue after recalculating distances
                final sortedVenues = _getSortedVenuesBySport();
                if (sortedVenues.isNotEmpty) {
                  safeSetState(() {
                    _model.selectedVenueId = sortedVenues.first.id;
                    _model.selectedVenueName = sortedVenues.first.venueName;
                  });
                  // Save to app state
                  FFAppState().update(() {
                    FFAppState().selectedVenueId = sortedVenues.first.id;
                    FFAppState().selectedVenueName = sortedVenues.first.venueName ?? '';
                  });

                  // Reload games with optimized query
                  await _loadGamesOptimized();
                }
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _model.isLoadingLocation
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build sport selector toggle
  Widget _buildSportSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(child: _buildSportOption('badminton', '🏸 Badminton')),
          const SizedBox(width: 8),
          Expanded(child: _buildSportOption('pickleball', '🎾 Pickleball')),
          const SizedBox(width: 8),
          Expanded(child: _buildSportOption('padel', '🎾 Padel')),
        ],
      ),
    );
  }

  Widget _buildSportOption(String sportType, String label) {
    final isSelected = _model.selectedSportType == sportType;

    return InkWell(
      onTap: () {
        safeSetState(() {
          _model.selectedSportType = sportType;

          // Reset venue selection and reload
          final sortedVenues = _getSortedVenuesBySport();
          if (sortedVenues.isNotEmpty) {
            _model.selectedVenueId = sortedVenues.first.id;
            _model.selectedVenueName = sortedVenues.first.venueName;
            // Save to app state
            FFAppState().update(() {
              FFAppState().selectedVenueId = sortedVenues.first.id;
              FFAppState().selectedVenueName = sortedVenues.first.venueName ?? '';
            });
          } else {
            // No venues available for this sport
            _model.selectedVenueId = null;
            _model.selectedVenueName = null;
          }
        });
        _loadGames();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build venue selector
  Widget _buildVenueSelector() {
    // Get sport-specific icon
    IconData getSportIcon() {
      switch (_model.selectedSportType) {
        case 'badminton':
          return Icons.sports_tennis; // Badminton racket
        case 'pickleball':
          return Icons.sports_baseball; // Pickleball paddle
        case 'padel':
          return Icons.sports_tennis; // Padel racket
        default:
          return Icons.location_city;
      }
    }

    // SKELETON STATE: Show loading placeholder while venues are loading
    if (_isLoadingVenues) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    getSportIcon(),
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 14,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 11,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final hasVenues = _getSortedVenuesBySport().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: hasVenues ? _showVenueSelector : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    getSportIcon(),
                    color: Colors.white.withValues(alpha: hasVenues ? 0.7 : 0.4),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hasVenues
                              ? (_model.selectedVenueName ?? 'Select Venue')
                              : 'No venues available for this sport',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: hasVenues ? 1.0 : 0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (hasVenues && _getVenueDistanceText() != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Text(
                                  _getVenueDistanceText()!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (_model.isCalculatingDistances) ...[
                                  const SizedBox(width: 6),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        else if (hasVenues && _model.isCalculatingDistances)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Text(
                                  'Calculating distances...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (hasVenues)
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build dates row
  Widget _buildDatesRow() {
    final today = DateTime.now();
    final dates = List.generate(14, (index) => today.add(Duration(days: index)));

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(_model.selectedDate);

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildDateOption(date, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildDateOption(DateTime date, bool isSelected) {
    final dayName = DateFormat('EEE').format(date);
    final dayNumber = DateFormat('d').format(date);

    return InkWell(
      onTap: () async {
        safeSetState(() {
          _model.selectedDate = date;
        });
        // Load games with optimized query
        _loadGamesOptimized();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 55,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isSelected ? 0.9 : 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build action row with Create Game button and AM/PM toggle
  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Create Game button
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: CreateGameSheet(
                      initialSportType: _model.selectedSportType,
                      initialVenueId: _model.selectedVenueId,
                      onGameCreated: () {
                        _loadGames();
                      },
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Create Game',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // AM/PM toggle
          Expanded(
            flex: 1,
            child: _buildTimeToggle(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggle() {
    // Check if selected date is today AND it's past noon (disable AM only for today)
    final now = DateTime.now();
    final isToday = DateFormat('yyyy-MM-dd').format(_model.selectedDate) ==
        DateFormat('yyyy-MM-dd').format(now);
    final isAfternoon = now.hour >= 12;
    final shouldDisableAM = isToday && isAfternoon;

    // If it's afternoon on today and AM is selected, auto-switch to PM
    if (shouldDisableAM && _model.currentAmOrPm == 'am') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          safeSetState(() {
            _model.currentAmOrPm = 'pm';
          });
          _loadGames();
        }
      });
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTimeOption('am', 'AM', disabled: shouldDisableAM)),
          Expanded(child: _buildTimeOption('pm', 'PM')),
        ],
      ),
    );
  }

  Widget _buildTimeOption(String value, String label, {bool disabled = false}) {
    final isSelected = _model.currentAmOrPm == value;
    // Use orange for AM (day/sun), dark purple for PM (night sky)
    final selectedColor = value == 'am'
        ? Colors.orange
        : const Color(0xFF4A148C); // Deep purple/night sky

    return InkWell(
      onTap: disabled ? null : () {
        safeSetState(() {
          _model.currentAmOrPm = value;
        });
        _loadGames();
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.white.withValues(alpha: 0.05)
              : (isSelected ? selectedColor : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: disabled
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              decoration: disabled ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Build games list
  Widget _buildGamesList() {
    if (_model.isLoadingGames) {
      return SliverFillRemaining(
        child: Center(
          child: SpinKitRing(
            color: FlutterFlowTheme.of(context).primary,
            size: 50.0,
          ),
        ),
      );
    }

    if (_model.games.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_tennis,
                size: 64,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No games available',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to create one!',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final game = _model.games[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GameCard(
                game: game,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailsPage(gameId: game.id),
                    ),
                  );
                  // Refresh games after viewing details (in case user joined)
                  _loadGames();
                },
              ),
            );
          },
          childCount: _model.games.length,
        ),
      ),
    );
  }

  /// Get formatted distance and time text for selected venue
  String? _getVenueDistanceText() {
    if (_model.selectedVenueId == null) return null;

    final venueId = _model.selectedVenueId!;
    final distance = _model.venueDistances[venueId];
    final duration = _model.venueDurations[venueId];

    if (distance == null && duration == null) return null;

    final parts = <String>[];

    if (distance != null) {
      parts.add('${distance.toStringAsFixed(1)} km');
    }

    if (duration != null) {
      parts.add('${duration} min');
    }

    return parts.join(' • ');
  }
}

/// Location Search Dialog
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
  List<dynamic> _predictions = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final predictions = await actions.searchPlaces(input);
      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching places: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    try {
      final coordinates = await actions.geocodePlace(placeId);
      if (coordinates != null && mounted) {
        widget.onLocationSelected(placeId, description, coordinates);
        Navigator.of(context).pop();
      } else {
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
        'Select Location',
        style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
              color: Colors.white,
              letterSpacing: 0.0,
              useGoogleFonts:
                  !FlutterFlowTheme.of(context).headlineSmallIsCustom,
            ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                onChanged: _searchPlaces,
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
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.white.withValues(alpha: 0.7)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                )
              else if (_predictions.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      final prediction = _predictions[index];
                      final description = prediction['description'] ?? '';
                      final placeId = prediction['place_id'] ?? '';

                      return InkWell(
                        onTap: () => _selectPlace(placeId, description),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  description,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
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
    );
  }
}
