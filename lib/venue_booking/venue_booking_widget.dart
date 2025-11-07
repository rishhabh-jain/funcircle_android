import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'venue_booking_model.dart';
export 'venue_booking_model.dart';

class VenueBookingWidget extends StatefulWidget {
  const VenueBookingWidget({super.key});

  static String routeName = 'VenueBooking';
  static String routePath = '/venueBooking';

  @override
  State<VenueBookingWidget> createState() => _VenueBookingWidgetState();
}

class _VenueBookingWidgetState extends State<VenueBookingWidget> {
  late VenueBookingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VenueBookingModel());

    // Get user location on init
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _getUserLocation();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    if (_model.isLoadingLocation) return;

    setState(() {
      _model.isLoadingLocation = true;
    });

    try {
      final location = await actions.getCurrentLocation();
      if (location != null && mounted) {
        setState(() {
          _model.userLocation = location;
          _model.locationDisplayText = 'Current Location';
          _model.isLoadingLocation = false;
        });
      } else {
        // Location is null - permission denied or location unavailable
        if (mounted) {
          setState(() {
            _model.isLoadingLocation = false;
          });

          // Show error message and open location selector as fallback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Unable to get current location. Please select manually.'),
              backgroundColor: Colors.yellow.shade700,
              duration: Duration(seconds: 3),
            ),
          );

          // Open location selector dialog as fallback
          _showLocationDialog();
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() {
          _model.isLoadingLocation = false;
        });

        // Show error message and open location selector as fallback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Location permission denied. Please select manually.'),
            backgroundColor: Colors.yellow.shade700,
            duration: Duration(seconds: 3),
          ),
        );

        // Open location selector dialog as fallback
        _showLocationDialog();
      }
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => _LocationSearchDialog(
        currentLocation: _model.locationDisplayText,
        onLocationSelected: (placeId, description, latLng) async {
          setState(() {
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
          });
        },
      ),
    );
  }

  /// Calculate venue distances using Google Distance Matrix API
  ///
  /// IMPORTANT: This API is paid. Multiple safeguards to prevent overuse:
  /// 1. Only calculates once per unique user location
  /// 2. Caches results in _model.venueDistances map
  /// 3. Prevents duplicate requests with isCalculatingDistances flag
  /// 4. Uses calculationRequestId to prevent race conditions
  /// 5. Only called when location changes (checked in caller)
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
      print('✅ Distances already calculated for this location - using cache');
      return;
    }

    // Skip if already calculating to prevent duplicate API calls
    if (_model.isCalculatingDistances) {
      print('⏳ Distance calculation already in progress - skipping');
      return;
    }

    // Increment request ID to track this specific calculation and prevent race conditions
    _model.calculationRequestId++;
    final currentRequestId = _model.calculationRequestId;

    setState(() {
      _model.isCalculatingDistances = true;
      _model.lastCalculatedLocation = _model.userLocation;
    });

    try {
      // 💰 PAID API CALL: Google Distance Matrix API
      print('💰 Calling Distance Matrix API for ${venues.length} venues');
      final result = await actions.calculateDistanceMatrix(
        _model.userLocation!,
        venues,
      );
      print('✅ Distance Matrix API call successful');

      // Check if this is still the latest request
      if (currentRequestId != _model.calculationRequestId) {
        return;
      }

      setState(() {
        _model.venueDistances =
            Map<int, double>.from(result['distances'] as Map);
        _model.venueDurations = Map<int, int>.from(result['durations'] as Map);
        _model.isCalculatingDistances = false;
      });
    } catch (e) {
      print('❌ Error calculating distances: $e');
      setState(() {
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
        return '$hours hr';
      } else {
        return '$hours hr $mins min';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VenuesRow>>(
      future: VenuesTable().queryRows(
        queryFn: (q) => q.inFilter(
          'group_id',
          [90, 104, 105], // Badminton, Pickleball, Padel
        ).order('venue_name', ascending: true),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        List<VenuesRow> allVenues = snapshot.data!;

        // Calculate distances if not already done
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _model.userLocation != null &&
              !_model.isCalculatingDistances) {
            if (_model.venueDistances.isEmpty ||
                _model.lastCalculatedLocation?.latitude !=
                    _model.userLocation?.latitude) {
              _calculateVenueDistances(allVenues);
            }
          }
        });

        // Apply sport filter
        if (_model.selectedSportId != null) {
          allVenues = allVenues
              .where((venue) => venue.groupId == _model.selectedSportId)
              .toList();
        }

        // Apply search filter
        if (_model.searchController != null &&
            _model.searchController!.text.isNotEmpty) {
          final searchText = _model.searchController!.text.toLowerCase();
          allVenues = allVenues.where((venue) {
            final venueName = venue.venueName?.toLowerCase() ?? '';
            final location = venue.location?.toLowerCase() ?? '';
            return venueName.contains(searchText) ||
                location.contains(searchText);
          }).toList();
        }

        // Sort by distance
        allVenues = _sortVenuesByDistance(allVenues);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xFF121212),
            body: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _VenueBookingBackgroundPainter(),
                  ),
                ),
                // Main content
                SafeArea(
                  top: true,
                  child: CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Book Venues',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLargeFamily,
                                            color: Colors.white,
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .headlineLargeIsCustom,
                                          ),
                                    ),
                                    SizedBox(height: 4.0),
                                    InkWell(
                                      onTap: _showLocationDialog,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                _model.locationDisplayText ??
                                                    'Select location',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.7),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 16,
                                              color: Colors.white
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              // GPS location button - gets current location
                              InkWell(
                                onTap: () async {
                                  await _getUserLocation();
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white
                                                .withValues(alpha: 0.15),
                                            Colors.white.withValues(alpha: 0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: _model.isLoadingLocation
                                          ? SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              Icons.my_location_rounded,
                                              size: 22,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 8.0).toSliver(),

                      // Sport Filter Chips
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildSportChip('All', null),
                                SizedBox(width: 8.0),
                                _buildSportChip('Badminton', 90),
                                SizedBox(width: 8.0),
                                _buildSportChip('Pickleball', 104),
                                SizedBox(width: 8.0),
                                _buildSportChip('Padel', 105),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.0).toSliver(),

                      // Search Bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.15),
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.black.withValues(alpha: 0.3),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _model.searchController,
                                  onChanged: (_) => setState(() {}),
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Search venues, location...',
                                    hintStyle: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                    suffixIcon: _model.searchController !=
                                                null &&
                                            _model.searchController!.text
                                                .isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.white
                                                  .withValues(alpha: 0.7),
                                            ),
                                            onPressed: () {
                                              _model.searchController?.clear();
                                              setState(() {});
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0).toSliver(),

                      // Results count
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '${allVenues.length} ${allVenues.length == 1 ? 'venue' : 'venues'} found',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.0).toSliver(),

                      // Venues List
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final venue = allVenues[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: _buildVenueCard(venue),
                              );
                            },
                            childCount: allVenues.length,
                          ),
                        ),
                      ),

                      SizedBox(height: 100.0).toSliver(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSportChip(String label, int? sportId) {
    final isSelected = _model.selectedSportId == sportId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _model.selectedSportId = sportId;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isSelected ? 15 : 10,
            sigmaY: isSelected ? 15 : 10,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFF7931E),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.08),
                      ],
                    ),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.25),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Color(0xFFFF6B35).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 14.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVenueCard(VenuesRow venue) {
    final hasImages = venue.images.isNotEmpty;
    final imageUrl = hasImages ? venue.images.first : null;
    final distance = _model.venueDistances[venue.id];
    final duration = _model.venueDurations[venue.id];

    return InkWell(
      onTap: () {
        // Navigate to single venue page
        context.pushNamed(
          'SingleVenueNew',
          queryParameters: {
            'venueid': venue.id.toString(),
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          // Outer glow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              blurRadius: 30,
              spreadRadius: -5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.25),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Image with distance badge
                  Stack(
                    children: [
                      if (imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: 160.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.withValues(alpha: 0.2),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.withValues(alpha: 0.2),
                              child: Icon(
                                Icons.location_on,
                                size: 60,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 160.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.3),
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.sports_tennis,
                              size: 80,
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      // Distance & Time Badge
                      if (distance != null && duration != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 9.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.75),
                                      Colors.black.withValues(alpha: 0.6),
                                      Colors.black.withValues(alpha: 0.5),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      size: 16,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      _formatDistance(distance),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '• ${_formatDuration(duration)}',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Venue Details
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Venue Name with glow
                        Text(
                          venue.venueName ?? 'Unnamed Venue',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .headlineSmallFamily,
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .headlineSmallIsCustom,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8.0),

                        // Sport badges (show available sports)
                        if (venue.sportType != null)
                          _buildSportBadges(venue.sportType!),

                        SizedBox(height: 10.0),

                        // Location and Price Row
                        Row(
                          children: [
                            // Location
                            if (venue.location != null) ...[
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primary
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  venue.location!,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: Colors.white
                                            .withValues(alpha: 0.85),
                                        fontSize: 14.0,
                                        letterSpacing: 0.2,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            // Price
                            if (venue.pricePerHour != null) ...[
                              SizedBox(width: 12.0),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '₹${venue.pricePerHour!.toStringAsFixed(0)} onwards',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 12.0),

                        // Book Now Button with gradient
                        Container(
                          width: double.infinity,
                          height: 44.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFF7931E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.0),
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14.0),
                              onTap: () {
                                context.pushNamed(
                                  'SingleVenueNew',
                                  queryParameters: {
                                    'venueid': venue.id.toString(),
                                  },
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Book Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSportBadges(String sportType) {
    final sports = _getSportsFromType(sportType);

    if (sports.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sports
          .map((sport) =>
              _buildSingleSportBadge(sport['emoji']!, sport['name']!))
          .toList(),
    );
  }

  List<Map<String, String>> _getSportsFromType(String sportType) {
    final sports = <Map<String, String>>[];
    final lowerType = sportType.toLowerCase();

    if (lowerType == 'both') {
      sports.add({'emoji': '🏸', 'name': 'Badminton'});
      sports.add({'emoji': '🎾', 'name': 'Pickleball'});
    } else if (lowerType.contains('badminton')) {
      sports.add({'emoji': '🏸', 'name': 'Badminton'});
    } else if (lowerType.contains('pickleball')) {
      sports.add({'emoji': '🎾', 'name': 'Pickleball'});
    } else if (lowerType.contains('padel')) {
      sports.add({'emoji': '🏓', 'name': 'Padel'});
    }

    return sports;
  }

  Widget _buildSingleSportBadge(String emoji, String sportName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 6),
          Text(
            sportName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

extension on SizedBox {
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}

// Location Search Dialog Widget
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
    );
  }
}

// Background Painter for Venue Booking Screen
class _VenueBookingBackgroundPainter extends CustomPainter {
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

    // Large decorative circles with orange/blue gradients
    final circlePaint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFFF6B35).withValues(alpha: 0.04); // Orange

    final circlePaint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFF4A90E2).withValues(alpha: 0.03); // Blue

    // Top-right cluster (orange)
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.12), 60, circlePaint1);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12), 80,
        circlePaint1..color = const Color(0xFFFF6B35).withValues(alpha: 0.02));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12), 100,
        circlePaint1..color = const Color(0xFFFF6B35).withValues(alpha: 0.01));

    // Bottom-left cluster (blue)
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.75), 50, circlePaint2);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.75), 70,
        circlePaint2..color = const Color(0xFF4A90E2).withValues(alpha: 0.015));
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.75), 90,
        circlePaint2..color = const Color(0xFF4A90E2).withValues(alpha: 0.01));

    // Middle decorative circles
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 120,
        circlePaint1..color = const Color(0xFFFF6B35).withValues(alpha: 0.015));
    canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.55),
        80,
        circlePaint2
          ..color = const Color(0xFF9B59B6)
              .withValues(alpha: 0.015)); // Purple accent

    // Bottom-right cluster (orange)
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.85), 65, circlePaint1);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.85), 85,
        circlePaint1..color = const Color(0xFFFF6B35).withValues(alpha: 0.02));

    // Draw dots pattern for depth
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.02);

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

    // Subtle radial gradient overlays for depth
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6B35).withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.3),
        radius: size.width * 0.4,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.4,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
