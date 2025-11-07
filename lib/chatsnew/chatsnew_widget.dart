import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'chatsnew_model.dart';
export 'chatsnew_model.dart';

class ChatsnewWidget extends StatefulWidget {
  const ChatsnewWidget({super.key});

  static String routeName = 'chatsnew';
  static String routePath = '/chatsnew';

  @override
  State<ChatsnewWidget> createState() => _ChatsnewWidgetState();
}

class _ChatsnewWidgetState extends State<ChatsnewWidget> {
  late ChatsnewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatsnewModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Add listener for search
    _model.textController?.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    // Fetch chat rooms
    _fetchChatRooms();
  }

  void _onSearchChanged() {
    final query = _model.textController?.text.toLowerCase() ?? '';
    safeSetState(() {
      _model.searchQuery = query;
      if (query.isEmpty) {
        _model.filteredChatRooms = _model.chatRooms;
      } else {
        _model.filteredChatRooms = _model.chatRooms?.where((room) {
          final name = room.name?.toLowerCase() ?? '';
          final sportType = room.sportType?.toLowerCase() ?? '';
          final description = room.description?.toLowerCase() ?? '';
          return name.contains(query) ||
              sportType.contains(query) ||
              description.contains(query);
        }).toList();
      }
    });
  }

  /// Extracts the skill level from the room name
  /// Returns the level string if found, null otherwise
  String? _extractLevelFromName(String? roomName) {
    if (roomName == null || roomName.isEmpty) return null;

    final lowerName = roomName.toLowerCase();
    final levelKeywords = [
      'beginner-intermediate',
      'beginner intermediate',
      'upper-intermediate',
      'upper intermediate',
      'beginner',
      'intermediate',
      'advanced',
      'pro',
      'professional',
      'expert',
      'novice',
    ];

    // Try to find level keywords in the room name
    for (final keyword in levelKeywords) {
      if (lowerName.contains(keyword)) {
        // Extract the keyword with proper capitalization
        final regex = RegExp(keyword, caseSensitive: false);
        final match = regex.firstMatch(roomName);
        if (match != null) {
          // Capitalize first letter of each word
          final level = match.group(0)!;
          return level.split(' ').map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()
          ).join(' ');
        }
      }
    }

    return null;
  }

  Future<void> _fetchChatRooms() async {
    try {
      print('DEBUG: Starting to fetch chat rooms...');

      // Get room IDs where current user is a member
      final membershipResponse = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select('room_id')
          .eq('user_id', currentUserUid)
          .eq('is_banned', false);

      print('DEBUG: Membership response: $membershipResponse');

      if ((membershipResponse as List).isEmpty) {
        print('DEBUG: No memberships found');
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return;
      }

      final roomIds = (membershipResponse as List)
          .map((item) => item['room_id'] as String)
          .toList();

      print('DEBUG: Room IDs: $roomIds');

      if (roomIds.isEmpty) {
        print('DEBUG: Room IDs list is empty');
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return;
      }

      // Fetch room details first without join
      final roomsResponse = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select('*')
          .inFilter('id', roomIds)
          .eq('is_active', true)
          .order('updated_at', ascending: false);

      print('DEBUG: Rooms response: $roomsResponse');

      if ((roomsResponse as List).isEmpty) {
        print('DEBUG: No active rooms found');
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return;
      }

      final rooms = (roomsResponse as List)
          .map((data) => ChatRoomsRow(data))
          .toList();

      print('DEBUG: Parsed ${rooms.length} rooms');

      // Fetch additional details for each room
      final roomDetailsMap = <String, dynamic>{};
      for (final roomData in (roomsResponse as List)) {
        try {
          final roomId = roomData['id'] as String;
          final venueId = roomData['venue_id'] as int?;

          print('DEBUG: Processing room $roomId with venue_id: $venueId');

          // Get venue data if venue_id exists
          List<String>? venueImages;
          int? groupId;

          if (venueId != null) {
            try {
              final venueResponse = await SupaFlow.client
                  .from('venues')
                  .select('images, group_id')
                  .eq('id', venueId)
                  .single();

              print('DEBUG: Venue response for $venueId: $venueResponse');

              final imagesRaw = venueResponse['images'];
              if (imagesRaw is List) {
                venueImages = imagesRaw.cast<String>();
              }
              groupId = venueResponse['group_id'] as int?;
            } catch (venueError) {
              print('DEBUG: Error fetching venue $venueId: $venueError');
            }
          }

          // Get last message for this room
          String? lastMessage;
          DateTime? lastMessageTime;

          try {
            final lastMessageResponse = await SupaFlow.client
                .schema('chat')
                .from('messages')
                .select('content, created_at, sender_id, message_type')
                .eq('room_id', roomId)
                .eq('is_deleted', false)
                .order('created_at', ascending: false)
                .limit(1);

            print('DEBUG: Last message response for room $roomId: $lastMessageResponse');

            if ((lastMessageResponse as List).isNotEmpty) {
              final msgData = (lastMessageResponse as List).first;
              final messageType = msgData['message_type'] as String?;

              if (messageType == 'text') {
                lastMessage = msgData['content'] as String?;
              } else if (messageType == 'image') {
                lastMessage = '📷 Photo';
              } else if (messageType == 'video') {
                lastMessage = '🎥 Video';
              } else if (messageType == 'file') {
                lastMessage = '📎 File';
              } else {
                lastMessage = msgData['content'] as String?;
              }

              final createdAtStr = msgData['created_at'];
              if (createdAtStr != null) {
                lastMessageTime = DateTime.parse(createdAtStr as String);
              }
            }
          } catch (messageError) {
            print('DEBUG: Error fetching last message for room $roomId: $messageError');
          }

          // Check if current user has sent any messages in this room
          bool userHasMessaged = false;
          try {
            final userMessageResponse = await SupaFlow.client
                .schema('chat')
                .from('messages')
                .select('id')
                .eq('room_id', roomId)
                .eq('sender_id', currentUserUid)
                .eq('is_deleted', false)
                .limit(1);

            userHasMessaged = (userMessageResponse as List).isNotEmpty;
          } catch (messageError) {
            print('DEBUG: Error checking user messages for room $roomId: $messageError');
          }

          roomDetailsMap[roomId] = {
            'venueImages': venueImages,
            'groupId': groupId,
            'lastMessage': lastMessage,
            'lastMessageTime': lastMessageTime,
            'userHasMessaged': userHasMessaged,
          };
        } catch (roomError) {
          print('DEBUG: Error processing room: $roomError');
        }
      }

      print('DEBUG: Room details map: $roomDetailsMap');

      safeSetState(() {
        _model.chatRooms = rooms;
        _model.filteredChatRooms = rooms;
        _model.chatRoomDetails = roomDetailsMap;
        _model.isLoadingRooms = false;
      });

      print('DEBUG: Successfully loaded ${rooms.length} rooms');
    } catch (e, stackTrace) {
      print('ERROR fetching chat rooms: $e');
      print('Stack trace: $stackTrace');
      safeSetState(() {
        _model.chatRooms = [];
        _model.filteredChatRooms = [];
        _model.chatRoomDetails = {};
        _model.isLoadingRooms = false;
      });
    }
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
        backgroundColor: Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: Color(0xFF1C1C1E),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 46.0,
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
          title: Text(
            FFLocalizations.of(context).getText(
              '9tkforqk' /* Chats */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: Colors.white,
                  fontSize: 28.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Search Field
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C1E),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF8E8E93),
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Search',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: Color(0xFF8E8E93),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context)
                                          .labelMediumIsCustom,
                                    ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily:
                                        FlutterFlowTheme.of(context).bodyMediumFamily,
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context)
                                        .bodyMediumIsCustom,
                                  ),
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              enableInteractiveSelection: true,
                              validator:
                                  _model.textControllerValidator.asValidator(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: FlutterFlowChoiceChips(
                    options: [
                      ChipData(FFLocalizations.of(context).getText(
                        'arazdo5g' /* Badminton */,
                      )),
                      ChipData(FFLocalizations.of(context).getText(
                        'vc02kv5u' /* Pickleball */,
                      )),
                      ChipData(FFLocalizations.of(context).getText(
                        '8u99q7v2' /* Padel */,
                      )),
                      ChipData('PlayTime')
                    ],
                    onChanged: (val) => safeSetState(
                        () => _model.choiceChipsValue = val?.firstOrNull),
                    selectedChipStyle: ChipStyle(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).info,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      iconColor: FlutterFlowTheme.of(context).info,
                      iconSize: 16.0,
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    unselectedChipStyle: ChipStyle(
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      iconColor: FlutterFlowTheme.of(context).secondaryText,
                      iconSize: 16.0,
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    chipSpacing: 8.0,
                    rowSpacing: 8.0,
                    multiselect: false,
                    initialized: _model.choiceChipsValue != null,
                    alignment: WrapAlignment.start,
                    controller: _model.choiceChipsValueController ??=
                        FormFieldController<List<String>>(
                      [
                        FFLocalizations.of(context).getText(
                          'a583krnu' /* Badminton */,
                        )
                      ],
                    ),
                    wrapped: false,
                  ),
                ),
              ),
              Expanded(
                child: _model.isLoadingRooms
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : _model.filteredChatRooms == null ||
                            _model.filteredChatRooms!.isEmpty
                        ? Center(
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'no_chats' /* No chats yet */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context)
                                        .bodyMediumIsCustom,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _model.filteredChatRooms!.length,
                            itemBuilder: (context, index) {
                              final room = _model.filteredChatRooms![index];
                              final roomDetails = _model.chatRoomDetails?[room.id] as Map<String, dynamic>?;
                              final groupId = roomDetails?['groupId'] as int?;

                              // Filter by sport type using group IDs or PlayTime
                              if (_model.choiceChipsValue != null &&
                                  _model.choiceChipsValue!.isNotEmpty) {
                                final selectedFilter = _model.choiceChipsValue!.toLowerCase();

                                // PlayTime filter - show only game chat rooms where user has messaged
                                if (selectedFilter == 'playtime') {
                                  final metaData = room.metaData;
                                  final hasGameId = metaData is Map &&
                                      metaData.containsKey('game_id') &&
                                      metaData['game_id'] != null;

                                  final userHasMessaged = roomDetails?['userHasMessaged'] as bool? ?? false;

                                  // Only show if it's a game chat AND user has sent messages
                                  if (!hasGameId || !userHasMessaged) {
                                    return SizedBox.shrink();
                                  }
                                } else {
                                  // Sport type filters
                                  int? expectedGroupId;

                                  if (selectedFilter.contains('badminton')) {
                                    expectedGroupId = 90;
                                  } else if (selectedFilter.contains('pickleball')) {
                                    expectedGroupId = 104;
                                  } else if (selectedFilter.contains('padel')) {
                                    expectedGroupId = 105;
                                  }

                                  if (expectedGroupId != null && groupId != expectedGroupId) {
                                    return SizedBox.shrink();
                                  }
                                }
                              }

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    context.pushNamed(
                                      'ChatRoom',
                                      queryParameters: {
                                        'roomId': serializeParam(
                                          room.id,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 12.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A0A0A),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFF2C2C2E),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar - prioritize venue image
                                        Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            gradient: (() {
                                              final venueImages = roomDetails?['venueImages'] as List?;
                                              final hasVenueImage = venueImages != null && venueImages.isNotEmpty;
                                              final hasAvatarUrl = room.avatarUrl != null && room.avatarUrl!.isNotEmpty;

                                              return (!hasVenueImage && !hasAvatarUrl)
                                                  ? LinearGradient(
                                                      colors: [
                                                        FlutterFlowTheme.of(context).primary,
                                                        FlutterFlowTheme.of(context).secondary,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    )
                                                  : null;
                                            })(),
                                            shape: BoxShape.circle,
                                          ),
                                          child: (() {
                                            final venueImages = roomDetails?['venueImages'] as List?;
                                            final hasVenueImage = venueImages != null && venueImages.isNotEmpty;

                                            if (hasVenueImage) {
                                              return ClipOval(
                                                child: Image.network(
                                                  venueImages.first as String,
                                                  width: 56.0,
                                                  height: 56.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      room.type == 'single'
                                                          ? Icons.person_rounded
                                                          : Icons.groups_rounded,
                                                      color: Colors.white,
                                                      size: 28.0,
                                                    );
                                                  },
                                                ),
                                              );
                                            } else if (room.avatarUrl != null && room.avatarUrl!.isNotEmpty) {
                                              return ClipOval(
                                                child: Image.network(
                                                  room.avatarUrl!,
                                                  width: 56.0,
                                                  height: 56.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            } else {
                                              return Icon(
                                                room.type == 'single'
                                                    ? Icons.person_rounded
                                                    : Icons.groups_rounded,
                                                color: Colors.white,
                                                size: 28.0,
                                              );
                                            }
                                          })(),
                                        ),
                                        SizedBox(width: 14.0),
                                        // Chat info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      room.name ?? 'Chat Room',
                                                      style: FlutterFlowTheme.of(context)
                                                          .titleMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(context)
                                                                    .titleMediumFamily,
                                                            color: Colors.white,
                                                            fontSize: 17.0,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context)
                                                                    .titleMediumIsCustom,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (roomDetails?['lastMessageTime'] != null)
                                                    Text(
                                                      (() {
                                                        final lastMsgTime = roomDetails!['lastMessageTime'] as DateTime;
                                                        return lastMsgTime.hour.toString() +
                                                            ':' +
                                                            lastMsgTime.minute
                                                                .toString()
                                                                .padLeft(2, '0');
                                                      })(),
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodySmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(context)
                                                                    .bodySmallFamily,
                                                            color: Color(0xFF8E8E93),
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context)
                                                                    .bodySmallIsCustom,
                                                          ),
                                                    ),
                                                ],
                                              ),
                                              // Display level if available
                                              if (_extractLevelFromName(room.name) != null) ...[
                                                SizedBox(height: 3.0),
                                                Text(
                                                  _extractLevelFromName(room.name)!,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(context)
                                                                .bodySmallFamily,
                                                        color: FlutterFlowTheme.of(context)
                                                            .primary,
                                                        fontSize: 13.0,
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context)
                                                                .bodySmallIsCustom,
                                                      ),
                                                ),
                                              ],
                                              SizedBox(height: 4.0),
                                              Row(
                                                children: [
                                                  if (room.sportType != null)
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 8.0, vertical: 3.0),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            FlutterFlowTheme.of(context)
                                                                .primary
                                                                .withValues(alpha: 0.3),
                                                            FlutterFlowTheme.of(context)
                                                                .secondary
                                                                .withValues(alpha: 0.3),
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(6.0),
                                                      ),
                                                      child: Text(
                                                        room.sportType!,
                                                        style: FlutterFlowTheme.of(context)
                                                            .bodySmall
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(context)
                                                                      .bodySmallFamily,
                                                              color: FlutterFlowTheme.of(context)
                                                                  .primary,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(context)
                                                                      .bodySmallIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                  SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                      roomDetails?['lastMessage'] as String? ?? 'Tap to view chat',
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodySmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(context)
                                                                    .bodySmallFamily,
                                                            color: Color(0xFF8E8E93),
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context)
                                                                    .bodySmallIsCustom,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
        ),
      ),
    );
  }
}
