import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import '/playnow/widgets/create_game_sheet.dart';
import '/playnow/widgets/game_card.dart';
import '/playnow/widgets/game_details_sheet.dart';
import '/playnow/services/game_service.dart';
import '/playnow/models/game_model.dart';
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaynewModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('playnew_update_page_state');
      _model.currentDate = dateTimeFormat(
        "d",
        getCurrentTimestamp,
        locale: FFLocalizations.of(context).languageCode,
      );
      safeSetState(() {});

      // Get user's current location
      _fetchUserLocation();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _fetchUserLocation() async {
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
        });
      } else {
        safeSetState(() {
          _model.isLoadingLocation = false;
          _model.locationDisplayText = 'Gurugram'; // Fallback
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      safeSetState(() {
        _model.isLoadingLocation = false;
        _model.locationDisplayText = 'Gurugram'; // Fallback
      });
    }
  }

  Future<void> _calculateVenueDistances(List<VenuesRow> venues) async {
    if (_model.userLocation == null) {
      print('⚠️ No user location available for distance calculation');
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

    _model.calculationRequestId++;
    final currentRequestId = _model.calculationRequestId;

    print(
        '🚀 Starting Distance Matrix API call #$currentRequestId (playnew screen)');

    safeSetState(() {
      _model.isCalculatingDistances = true;
      _model.lastCalculatedLocation = _model.userLocation;
    });

    try {
      final result = await actions.calculateDistanceMatrix(
        _model.userLocation!,
        venues,
      );

      if (currentRequestId != _model.calculationRequestId) {
        print('⚠️ Request superseded - DISCARDING results');
        return;
      }

      safeSetState(() {
        _model.venueDistances =
            Map<int, double>.from(result['distances'] as Map);
        _model.venueDurations = Map<int, int>.from(result['durations'] as Map);
        _model.isCalculatingDistances = false;
      });

      print(
          '✅ Distance calculation completed for ${_model.venueDistances.length} venues');
    } catch (e) {
      print('❌ Error calculating distances: $e');
      safeSetState(() {
        _model.isCalculatingDistances = false;
      });
    }
  }

  int? _getNearestVenueId(List<dynamic> venueOptions) {
    if (_model.venueDistances.isEmpty || venueOptions.isEmpty) {
      return null;
    }

    int? nearestVenueId;
    double shortestDistance = double.infinity;

    for (final venue in venueOptions) {
      final venueId = getJsonField(venue, r'''$.venueid''');
      final distance = _model.venueDistances[venueId];

      if (distance != null && distance < shortestDistance) {
        shortestDistance = distance;
        nearestVenueId = venueId;
      }
    }

    return nearestVenueId;
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
            _model.venueDistances.clear();
            _model.venueDurations.clear();
            _model.lastCalculatedLocation = null;
          });

          FFAppState().update(() {
            FFAppState().userLocation = latLng;
            FFAppState().userLatitude = latLng.latitude;
            FFAppState().userLongitude = latLng.longitude;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TicketsRow>>(
      future: TicketsTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'ticketstatus',
          'live',
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<TicketsRow> playnewTicketsRowList = snapshot.data!;

        // Set default date to first available date if not already set
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              (_model.currentDate == null ||
                  _model.currentDate ==
                      dateTimeFormat("d", getCurrentTimestamp,
                          locale: FFLocalizations.of(context).languageCode))) {
            final availableDates = functions.getAvailableDates(
              playnewTicketsRowList.toList(),
              _model.currentAmOrPm,
              _model.currentsportid,
              _model.currentVenueId != null
                  ? _model.currentVenueId
                  : functions.getMostPopularVenue(
                      playnewTicketsRowList.toList(),
                      _model.currentAmOrPm,
                      _model.currentsportid),
            );

            if (availableDates != null && availableDates.isNotEmpty) {
              final firstDate = getJsonField(
                availableDates.first,
                r'''$.date''',
              ).toString();

              if (_model.currentDate != firstDate) {
                safeSetState(() {
                  _model.currentDate = firstDate;
                });
              }
            }
          }
        });

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent('Icon_navigate_back');
                                        context.safePop();
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        _showLocationDialog();
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 6.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black
                                                      .withValues(alpha: 0.7),
                                                  Colors.black
                                                      .withValues(alpha: 0.85),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  FFIcons.kmapPin,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 16.0,
                                                ),
                                                SizedBox(width: 6.0),
                                                Flexible(
                                                  child: Text(
                                                    _model.isLoadingLocation
                                                        ? 'Getting location...'
                                                        : (_model
                                                                .locationDisplayText ??
                                                            'Gurugram'),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(
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
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 4.0),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.6),
                                                  size: 18.0,
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
                            // Refresh location button
                            InkWell(
                              onTap: () {
                                safeSetState(() {
                                  _model.venueDistances.clear();
                                  _model.venueDurations.clear();
                                  _model.lastCalculatedLocation = null;
                                });
                                _fetchUserLocation();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context).primary,
                                          FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: FlutterFlowChoiceChips(
                                options: [
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'd9rhkeq9' /* Badminton */,
                                      ),
                                      FFIcons.kbadmintonPlayerSvgrepoCom),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'wkqc3l5e' /* Pickleball */,
                                      ),
                                      Icons.call_made),
                                  ChipData(
                                      FFLocalizations.of(context).getText(
                                        'luzu9ah7' /* Padel */,
                                      ),
                                      Icons.sports_tennis)
                                ],
                                onChanged: (val) async {
                                  safeSetState(() => _model.choiceChipsValue =
                                      val?.firstOrNull);
                                  logFirebaseEvent(
                                      'ChoiceChips_update_page_state');
                                  _model.currentsportid = valueOrDefault<int>(
                                    () {
                                      if (_model.choiceChipsValue ==
                                          'Badminton') {
                                        return 90;
                                      } else if (_model.choiceChipsValue ==
                                          'Pickleball') {
                                        return 104;
                                      } else if (_model.choiceChipsValue ==
                                          'Padel') {
                                        return 105;
                                      } else {
                                        return 90;
                                      }
                                    }(),
                                    90,
                                  );
                                  _model.currentVenueId = null;
                                  safeSetState(() {});
                                },
                                selectedChipStyle: ChipStyle(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor: Colors.white,
                                  iconSize: 16.0,
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor:
                                      Colors.black.withValues(alpha: 0.6),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor:
                                      Colors.white.withValues(alpha: 0.7),
                                  iconSize: 16.0,
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                chipSpacing: 8.0,
                                rowSpacing: 8.0,
                                multiselect: false,
                                initialized: _model.choiceChipsValue != null,
                                alignment: WrapAlignment.start,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [
                                    FFLocalizations.of(context).getText(
                                      'tj81zx5p' /* Badminton */,
                                    )
                                  ],
                                ),
                                wrapped: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Games Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: FutureBuilder<List<Game>>(
                        future: GameService.getOpenGames(
                          sportType: _model.choiceChipsValue?.toLowerCase() ==
                                  'badminton'
                              ? 'badminton'
                              : _model.choiceChipsValue?.toLowerCase() ==
                                      'pickleball'
                                  ? 'pickleball'
                                  : 'badminton',
                          limit: 10,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final games = snapshot.data!;

                          if (games.isEmpty) {
                            return SizedBox.shrink();
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: games.map((game) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  margin: EdgeInsets.only(right: 12.0),
                                  child: GameCard(
                                    game: game,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => GameDetailsSheet(
                                          game: game,
                                          onGameUpdated: () {
                                            safeSetState(() {});
                                          },
                                        ),
                                      );
                                    },
                                    showJoinButton: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    // Venues for booking continue below
                    FutureBuilder<List<VenuesRow>>(
                      future: VenuesTable().queryRows(
                        queryFn: (q) => q.inFilter(
                          'group_id',
                          [90, 104, 105], // Badminton, Pickleball, Padel
                        ),
                      ),
                      builder: (context, allVenuesSnapshot) {
                        if (!allVenuesSnapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: SpinKitRing(
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          );
                        }

                        final allVenues = allVenuesSnapshot.data!;

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

                        // Determine which venue to show
                        final venueOptions = functions
                                .getAllVenueOptions(
                                    playnewTicketsRowList.toList(),
                                    _model.currentsportid)
                                ?.toList() ??
                            [];

                        int? displayVenueId;
                        if (_model.currentVenueId != null) {
                          displayVenueId = _model.currentVenueId;
                        } else if (_model.venueDistances.isNotEmpty) {
                          // Use nearest venue
                          displayVenueId = _getNearestVenueId(venueOptions);
                        }

                        // Fallback to most popular if no distances yet
                        displayVenueId ??= functions.getMostPopularVenue(
                          playnewTicketsRowList.toList(),
                          _model.currentAmOrPm,
                          _model.currentsportid,
                        );

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 0),
                          child: FutureBuilder<List<VenuesRow>>(
                            future: VenuesTable().querySingleRow(
                              queryFn: (q) => q.eqOrNull('id', displayVenueId),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: SpinKitRing(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 50.0,
                                    ),
                                  ),
                                );
                              }

                              final containerVenuesRow =
                                  snapshot.data!.isNotEmpty
                                      ? snapshot.data!.first
                                      : null;

                              final venueId = containerVenuesRow?.id;
                              final hasDistance = venueId != null &&
                                  _model.venueDistances.containsKey(venueId);

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withValues(alpha: 0.7),
                                          Colors.black.withValues(alpha: 0.85),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    containerVenuesRow
                                                        ?.venueName,
                                                    'Venue name',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ),
                                              if (hasDistance)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.near_me,
                                                        color: Colors.white,
                                                        size: 12.0,
                                                      ),
                                                      SizedBox(width: 4.0),
                                                      Text(
                                                        _formatDistance(_model
                                                                .venueDistances[
                                                            venueId]!),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallFamily,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallIsCustom,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    _model.venueDistances
                                                            .isNotEmpty
                                                        ? 'Nearest Venue'
                                                        : 'Popular Venue',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color:
                                                              Color(0xFF0C85FF),
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  if (hasDistance &&
                                                      _model.venueDurations
                                                          .containsKey(venueId))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.access_time,
                                                            color: Colors
                                                                .grey[400],
                                                            size: 14.0,
                                                          ),
                                                          SizedBox(width: 4.0),
                                                          Text(
                                                            _formatDuration(
                                                                _model.venueDurations[
                                                                    venueId]!),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallFamily,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmallIsCustom,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  logFirebaseEvent(
                                                      'Button_update_page_state');
                                                  _model.showAllVenues =
                                                      !_model.showAllVenues;
                                                  safeSetState(() {});
                                                },
                                                text: _model.showAllVenues
                                                    ? 'Hide Venues'
                                                    : 'All Venues',
                                                icon: Icon(
                                                  _model.showAllVenues
                                                      ? Icons.expand_less
                                                      : Icons.expand_more,
                                                  size: 16.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 32.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.showAllVenues
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                          .withValues(
                                                              alpha: 0.2)
                                                      : Color(0xFF1C1C1E),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmallFamily,
                                                            color: _model
                                                                    .showAllVenues
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary
                                                                : Colors.white,
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmallIsCustom,
                                                          ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.showAllVenues
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primary
                                                        : Color(0xFF3A3A3C),
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    if (_model.showAllVenues)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF0A0A0A),
                        ),
                        child: Builder(
                          builder: (context) {
                            var allVenues = functions
                                    .getAllVenueOptions(
                                        playnewTicketsRowList.toList(),
                                        _model.currentsportid)
                                    ?.toList() ??
                                [];

                            // Sort venues by distance (nearest first)
                            if (_model.venueDistances.isNotEmpty) {
                              allVenues.sort((a, b) {
                                final venueIdA =
                                    getJsonField(a, r'''$.venueid''');
                                final venueIdB =
                                    getJsonField(b, r'''$.venueid''');
                                final distanceA =
                                    _model.venueDistances[venueIdA] ??
                                        double.maxFinite;
                                final distanceB =
                                    _model.venueDistances[venueIdB] ??
                                        double.maxFinite;
                                return distanceA.compareTo(distanceB);
                              });
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'All Venues',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMediumFamily,
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleMediumIsCustom,
                                            ),
                                      ),
                                      if (_model.venueDistances.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.sort,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 14.0,
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                'Sorted by distance',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      fontSize: 11.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Venues list
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(allVenues.length,
                                        (allVenuesIndex) {
                                      final allVenuesItem =
                                          allVenues[allVenuesIndex];
                                      return Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: FutureBuilder<List<VenuesRow>>(
                                          future: VenuesTable().querySingleRow(
                                            queryFn: (q) => q.eqOrNull(
                                              'id',
                                              getJsonField(
                                                allVenuesItem,
                                                r'''$.venueid''',
                                              ),
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 50.0,
                                                  ),
                                                ),
                                              );
                                            }
                                            List<VenuesRow>
                                                containerVenuesRowList =
                                                snapshot.data!;

                                            final containerVenuesRow =
                                                containerVenuesRowList
                                                        .isNotEmpty
                                                    ? containerVenuesRowList
                                                        .first
                                                    : null;

                                            final venueId =
                                                containerVenuesRow?.id;
                                            final hasDistance =
                                                venueId != null &&
                                                    _model.venueDistances
                                                        .containsKey(venueId);

                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model.currentVenueId =
                                                    getJsonField(
                                                  allVenuesItem,
                                                  r'''$.venueid''',
                                                );
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model.showAllVenues = false;
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  border: Border.all(
                                                    color: Color(0xFF5B5B5B),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            containerVenuesRow
                                                                ?.venueName,
                                                            'Venue Name',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                      if (hasDistance)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          6.0,
                                                                      vertical:
                                                                          3.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.0),
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
                                                                    size: 10.0,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          3.0),
                                                                  Text(
                                                                    _formatDistance(
                                                                        _model.venueDistances[
                                                                            venueId]!),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            if (_model
                                                                .venueDurations
                                                                .containsKey(
                                                                    venueId))
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .access_time,
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      size:
                                                                          11.0,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            3.0),
                                                                    Text(
                                                                      _formatDuration(
                                                                          _model
                                                                              .venueDurations[venueId]!),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            color:
                                                                                Colors.grey[400],
                                                                            fontSize:
                                                                                10.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodySmallIsCustom,
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
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    Builder(
                      builder: (context) {
                        final availableDates = functions
                                .getAvailableDates(
                                    playnewTicketsRowList.toList(),
                                    _model.currentAmOrPm,
                                    _model.currentsportid,
                                    _model.currentVenueId != null
                                        ? _model.currentVenueId
                                        : functions.getMostPopularVenue(
                                            playnewTicketsRowList.toList(),
                                            _model.currentAmOrPm,
                                            _model.currentsportid))
                                ?.toList() ??
                            [];

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(availableDates.length,
                                (availableDatesIndex) {
                              final availableDatesItem =
                                  availableDates[availableDatesIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 12.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'Container_update_page_state');
                                    _model.currentDate = getJsonField(
                                      availableDatesItem,
                                      r'''$.date''',
                                    ).toString();
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: _model.currentDate ==
                                                        getJsonField(
                                                          availableDatesItem,
                                                          r'''$.date''',
                                                        ).toString()
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary
                                                    : Color(0xFF3A3A3A),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    getJsonField(
                                                      availableDatesItem,
                                                      r'''$.date''',
                                                    ).toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  Text(
                                                    getJsonField(
                                                      availableDatesItem,
                                                      r'''$.day''',
                                                    ).toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                            .divide(SizedBox(width: 12.0))
                                            .addToStart(SizedBox(width: 12.0))
                                            .addToEnd(SizedBox(width: 12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                logFirebaseEvent('CREATE_GAME_BTN_show_bottom_sheet');
                                await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => CreateGameSheet(
                                    initialSportType: _model.choiceChipsValue
                                                ?.toLowerCase() ==
                                            'badminton'
                                        ? 'badminton'
                                        : _model.choiceChipsValue
                                                    ?.toLowerCase() ==
                                                'pickleball'
                                            ? 'pickleball'
                                            : 'badminton',
                                    onGameCreated: () {
                                      safeSetState(() {});
                                    },
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context).primary,
                                          FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: FlutterFlowTheme.of(context)
                                              .primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        SizedBox(width: 6.0),
                                        Text(
                                          'Create Game',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
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
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 140.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.7),
                                        Colors.black.withValues(alpha: 0.85),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Container_update_page_state');
                                            _model.currentAmOrPm = 'pm';
                                            safeSetState(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _model.currentAmOrPm ==
                                                      'pm'
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.dark_mode,
                                                  color: _model.currentAmOrPm ==
                                                          'pm'
                                                      ? Colors.white
                                                      : Color(0xFF7A7A7A),
                                                  size: 16.0,
                                                ),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  'PM',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            _model.currentAmOrPm ==
                                                                    'pm'
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF7A7A7A),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            _model.currentAmOrPm ==
                                                                    'pm'
                                                                ? FontWeight
                                                                    .w600
                                                                : FontWeight
                                                                    .normal,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Container_update_page_state');
                                            _model.currentAmOrPm = 'am';
                                            safeSetState(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _model.currentAmOrPm == 'am'
                                                      ? Color(0xFF5D9CEC)
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.wb_sunny,
                                                  color: _model.currentAmOrPm ==
                                                          'am'
                                                      ? Colors.white
                                                      : Color(0xFF7A7A7A),
                                                  size: 16.0,
                                                ),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  'AM',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            _model.currentAmOrPm ==
                                                                    'am'
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF7A7A7A),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            _model.currentAmOrPm ==
                                                                    'am'
                                                                ? FontWeight
                                                                    .w600
                                                                : FontWeight
                                                                    .normal,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Color(0x557E859D),
                    ),
                    Builder(
                      builder: (context) {
                        final getTickets = functions
                                .getTicketsForDate(
                                    playnewTicketsRowList.toList(),
                                    _model.currentAmOrPm,
                                    _model.currentsportid,
                                    _model.currentVenueId != null
                                        ? _model.currentVenueId
                                        : functions.getMostPopularVenue(
                                            playnewTicketsRowList.toList(),
                                            _model.currentAmOrPm,
                                            _model.currentsportid),
                                    _model.currentDate != null &&
                                            _model.currentDate != ''
                                        ? _model.currentDate
                                        : dateTimeFormat(
                                            "d",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ))
                                ?.toList() ??
                            [];

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(getTickets.length,
                                (getTicketsIndex) {
                              final getTicketsItem =
                                  getTickets[getTicketsIndex];
                              return Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getJsonField(
                                              getTicketsItem,
                                              r'''$.startTime''',
                                            ).toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Container_navigate_to');

                                                    context.pushNamed(
                                                      BookticketsWidget
                                                          .routeName,
                                                      queryParameters: {
                                                        'groupid':
                                                            serializeParam(
                                                          _model.currentsportid,
                                                          ParamType.int,
                                                        ),
                                                        'ticketid':
                                                            serializeParam(
                                                          getJsonField(
                                                            getTicketsItem,
                                                            r'''$.ticketid''',
                                                          ),
                                                          ParamType.int,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.6,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x1FFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Text(
                                                        getJsonField(
                                                          getTicketsItem,
                                                          r'''$.ticketName''',
                                                        ).toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
      },
    );
  }
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
                                            child: Text(
                                              description,
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
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
