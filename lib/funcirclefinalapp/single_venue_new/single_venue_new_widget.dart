import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/chatsnew/chatsnew_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'single_venue_new_model.dart';
export 'single_venue_new_model.dart';

class SingleVenueNewWidget extends StatefulWidget {
  const SingleVenueNewWidget({
    super.key,
    int? venueid,
  }) : this.venueid = venueid ?? 9;

  final int venueid;

  static String routeName = 'SingleVenueNew';
  static String routePath = '/singleVenueNew';

  @override
  State<SingleVenueNewWidget> createState() => _SingleVenueNewWidgetState();
}

class _SingleVenueNewWidgetState extends State<SingleVenueNewWidget> {
  late SingleVenueNewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SingleVenueNewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<ChatRoomsRow>> _fetchVenueRooms() async {
    try {
      final response = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select('*')
          .eq('venue_id', widget.venueid)
          .eq('is_active', true)
          .order('name');

      return (response as List).map((data) => ChatRoomsRow(data)).toList();
    } catch (e) {
      print('Error fetching venue rooms: $e');
      return [];
    }
  }

  Future<int> _fetchTotalMembers() async {
    try {
      // Get all room IDs for this venue
      final roomsResponse = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select('id')
          .eq('venue_id', widget.venueid)
          .eq('is_active', true);

      if ((roomsResponse as List).isEmpty) {
        return 0;
      }

      final roomIds = (roomsResponse as List)
          .map((item) => item['id'] as String)
          .toList();

      // Count unique members across all rooms
      final membersResponse = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select('user_id')
          .inFilter('room_id', roomIds)
          .eq('is_banned', false);

      if ((membersResponse as List).isEmpty) {
        return 0;
      }

      // Get unique user IDs
      final uniqueUsers = <String>{};
      for (final member in (membersResponse as List)) {
        uniqueUsers.add(member['user_id'] as String);
      }

      return uniqueUsers.length;
    } catch (e) {
      print('Error fetching total members: $e');
      return 0;
    }
  }

  String _getRoomLevelFromName(String? roomName) {
    if (roomName == null) return '';
    final lower = roomName.toLowerCase();
    if (lower.contains('beginner-intermediate') || lower.contains('beginner intermediate')) {
      return 'Beginner-Intermediate';
    } else if (lower.contains('upper-intermediate') || lower.contains('upper intermediate')) {
      return 'Upper Intermediate';
    } else if (lower.contains('intermediate')) {
      return 'Intermediate';
    } else if (lower.contains('beginner')) {
      return 'Beginner';
    }
    return '';
  }

  Future<void> _joinRoom(String roomId) async {
    try {
      // Check if user is already a member
      final existingMember = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select()
          .eq('room_id', roomId)
          .eq('user_id', currentUserUid)
          .maybeSingle();

      if (existingMember != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are already a member of this group!'),
            backgroundColor: FlutterFlowTheme.of(context).warning,
          ),
        );

        // Still navigate to chatsnew
        await Future.delayed(Duration(milliseconds: 500));
        context.pushNamed(ChatsnewWidget.routeName);
        return;
      }

      // Add user to room
      await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .insert({
        'room_id': roomId,
        'user_id': currentUserUid,
        'role': 'member',
        'joined_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined the group!'),
          backgroundColor: FlutterFlowTheme.of(context).success,
        ),
      );

      safeSetState(() {
        _model.showlevelcomponent = false;
      });

      // Navigate to chatsnew screen after brief delay
      await Future.delayed(Duration(milliseconds: 800));
      context.pushNamed(ChatsnewWidget.routeName);
    } catch (e) {
      print('Error joining room: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join group. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VenuesRow>>(
      future: VenuesTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.venueid,
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
        List<VenuesRow> singleVenueNewVenuesRowList = snapshot.data!;

        final singleVenueNewVenuesRow = singleVenueNewVenuesRowList.isNotEmpty
            ? singleVenueNewVenuesRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            body: SizedBox.expand(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      // Enhanced hero image with overlay
                      Stack(
                        children: [
                          CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 500),
                            imageUrl: singleVenueNewVenuesRow!.images.firstOrNull!,
                            width: double.infinity,
                            height: 320.0,
                            fit: BoxFit.cover,
                          ),
                          // Gradient overlay
                          Container(
                            width: double.infinity,
                            height: 320.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                stops: [0.3, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          // Back button
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: FlutterFlowIconButton(
                                borderRadius: 24.0,
                                buttonSize: 48.0,
                                fillColor: Colors.black.withValues(alpha: 0.5),
                                icon: Icon(
                                  FFIcons.karrowLeft,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  logFirebaseEvent('IconButton_navigate_back');
                                  context.safePop();
                                },
                              ),
                            ),
                          ),
                          // Venue name at bottom of image
                          Positioned(
                            bottom: 20.0,
                            left: 20.0,
                            right: 20.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    singleVenueNewVenuesRow.venueName,
                                    'Venue name',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: Colors.white,
                                        fontSize: 28.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 18.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        valueOrDefault<String>(
                                          singleVenueNewVenuesRow.location,
                                          'Location',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Quick Actions
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Maps button
                            InkWell(
                              onTap: () async {
                                logFirebaseEvent('Button_launch_url');
                                await launchURL(singleVenueNewVenuesRow.mapsLink!);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      FlutterFlowTheme.of(context).primary,
                                      FlutterFlowTheme.of(context).secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                                      blurRadius: 12.0,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.map, color: Colors.white, size: 20.0),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Get Directions',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Description Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                color: Colors.white,
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              valueOrDefault<String>(
                                singleVenueNewVenuesRow.description,
                                'No description available',
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                color: Colors.grey[400],
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 140.0), // Extra space for bottom button
                    ],
                  ),
                ),
                // Floating Join Button with Member Count
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).secondary.withValues(alpha: 0.0),
                          FlutterFlowTheme.of(context).secondary.withValues(alpha: 0.95),
                          FlutterFlowTheme.of(context).secondary,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: FutureBuilder<int>(
                        future: _fetchTotalMembers(),
                        builder: (context, memberSnapshot) {
                          final memberCount = memberSnapshot.data ?? 0;

                          return Container(
                            width: double.infinity,
                            height: 56.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  FlutterFlowTheme.of(context).primary,
                                  FlutterFlowTheme.of(context).warning,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.4),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  logFirebaseEvent('Button_update_page_state');
                                  _model.showlevelcomponent = true;
                                  safeSetState(() {});
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.group,
                                            color: Colors.white,
                                            size: 24.0,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            '$memberCount ${memberCount == 1 ? 'Member' : 'Members'}',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          'nhemn2k7' /* Join group */,
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Enhanced Level Selection Popup
                if (_model.showlevelcomponent)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: FutureBuilder<List<ChatRoomsRow>>(
                            future: _fetchVenueRooms(),
                            builder: (context, roomSnapshot) {
                              if (!roomSnapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.all(40.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: SpinKitRing(
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 50.0,
                                  ),
                                );
                              }

                              final rooms = roomSnapshot.data!;
                              final roomsByLevel = <String, ChatRoomsRow>{};

                              for (final room in rooms) {
                                final level = _getRoomLevelFromName(room.name);
                                if (level.isNotEmpty) {
                                  roomsByLevel[level] = room;
                                }
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E1E1E),
                                      Color(0xFF2A2A2A),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                                      blurRadius: 30.0,
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header
                                    Padding(
                                      padding: EdgeInsets.all(24.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  FlutterFlowTheme.of(context).primary,
                                                  FlutterFlowTheme.of(context).warning,
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              FFIcons.kbadmintonPlayerSvgrepoCom,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Choose Your Level',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Select your playing level',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    color: Colors.grey[400],
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Level Buttons
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                                      child: Column(
                                        children: [
                                          ...[
                                            'Beginner',
                                            'Beginner-Intermediate',
                                            'Intermediate',
                                            'Upper Intermediate',
                                          ].map((level) {
                                            final room = roomsByLevel[level];
                                            final isAvailable = room != null;

                                            return Padding(
                                              padding: EdgeInsets.only(bottom: 12.0),
                                              child: InkWell(
                                                onTap: isAvailable
                                                    ? () async {
                                                        await _joinRoom(room.id);
                                                      }
                                                    : null,
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(20.0),
                                                  decoration: BoxDecoration(
                                                    gradient: isAvailable
                                                        ? LinearGradient(
                                                            colors: [
                                                              FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                                                              FlutterFlowTheme.of(context).warning.withValues(alpha: 0.2),
                                                            ],
                                                          )
                                                        : null,
                                                    color: !isAvailable ? Colors.grey[800] : null,
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    border: Border.all(
                                                      color: isAvailable
                                                          ? FlutterFlowTheme.of(context).primary
                                                          : Colors.grey[700]!,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        level,
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          color: isAvailable ? Colors.white : Colors.grey[600],
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                        ),
                                                      ),
                                                      Icon(
                                                        isAvailable ? Icons.arrow_forward : Icons.lock,
                                                        color: isAvailable
                                                            ? FlutterFlowTheme.of(context).primary
                                                            : Colors.grey[600],
                                                        size: 20.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    // Cancel Button
                                    Padding(
                                      padding: EdgeInsets.all(24.0),
                                      child: InkWell(
                                        onTap: () {
                                          safeSetState(() {
                                            _model.showlevelcomponent = false;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).error,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                color: FlutterFlowTheme.of(context).error,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
