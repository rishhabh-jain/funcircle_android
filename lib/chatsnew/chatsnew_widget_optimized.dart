import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

    for (final keyword in levelKeywords) {
      if (lowerName.contains(keyword)) {
        final regex = RegExp(keyword, caseSensitive: false);
        final match = regex.firstMatch(roomName);
        if (match != null) {
          final level = match.group(0)!;
          return level.split(' ').map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()
          ).join(' ');
        }
      }
    }

    return null;
  }

  /// OPTIMIZED: Fetch chat rooms with minimal queries
  Future<void> _fetchChatRooms() async {
    try {
      print('DEBUG: Starting optimized fetch...');

      // QUERY 1: Get all room data in ONE query using joins
      // This replaces 100+ queries with a single query
      final roomsQuery = '''
        SELECT
          r.*,
          rm.user_id as member_user_id,
          v.images as venue_images,
          v.group_id as venue_group_id,
          (
            SELECT json_build_object(
              'content', m.content,
              'created_at', m.created_at,
              'message_type', m.message_type,
              'sender_id', m.sender_id
            )
            FROM chat.messages m
            WHERE m.room_id = r.id
              AND m.is_deleted = false
            ORDER BY m.created_at DESC
            LIMIT 1
          ) as last_message,
          (
            SELECT COUNT(*)::int
            FROM chat.messages m
            WHERE m.room_id = r.id
              AND m.sender_id != '${currentUserUid}'
              AND m.is_deleted = false
              AND NOT EXISTS (
                SELECT 1
                FROM chat.message_read_status mrs
                WHERE mrs.message_id = m.id
                  AND mrs.user_id = '${currentUserUid}'
              )
          ) as unread_count,
          (
            SELECT EXISTS (
              SELECT 1
              FROM chat.messages m
              WHERE m.room_id = r.id
                AND m.sender_id = '${currentUserUid}'
                AND m.is_deleted = false
            )
          ) as user_has_messaged
        FROM chat.rooms r
        INNER JOIN chat.room_members rm ON r.id = rm.room_id
        LEFT JOIN public.venues v ON r.venue_id = v.id
        WHERE rm.user_id = '${currentUserUid}'
          AND rm.is_banned = false
          AND r.is_active = true
        ORDER BY r.updated_at DESC
      ''';

      final roomsResponse = await SupaFlow.client.rpc('execute_sql',
        params: {'query': roomsQuery}
      ).catchError((error) async {
        // Fallback: Use regular query if RPC doesn't exist
        print('DEBUG: RPC not available, using standard query');
        return await _fetchChatRoomsFallback();
      });

      if (roomsResponse == null || (roomsResponse is List && roomsResponse.isEmpty)) {
        print('DEBUG: No rooms found');
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return;
      }

      // QUERY 2: Get user details for single chats in ONE batch query
      final roomsList = roomsResponse as List;
      final singleChatRoomIds = roomsList
          .where((r) => r['type'] == 'single')
          .map((r) => r['id'] as String)
          .toList();

      Map<String, Map<String, dynamic>> otherUsersMap = {};

      if (singleChatRoomIds.isNotEmpty) {
        // Get all members and their user details in one query
        final membersResponse = await SupaFlow.client
            .schema('chat')
            .from('room_members')
            .select('room_id, user_id')
            .inFilter('room_id', singleChatRoomIds)
            .neq('user_id', currentUserUid);

        final otherUserIds = (membersResponse as List)
            .map((m) => m['user_id'] as String)
            .toSet()
            .toList();

        if (otherUserIds.isNotEmpty) {
          final usersResponse = await SupaFlow.client
              .from('users')
              .select('user_id, first_name, profile_picture')
              .inFilter('user_id', otherUserIds);

          // Create map for quick lookup
          for (final user in (usersResponse as List)) {
            final userId = user['user_id'] as String;
            otherUsersMap[userId] = {
              'first_name': user['first_name'],
              'profile_picture': user['profile_picture'],
            };
          }

          // Map users to rooms
          for (final member in (membersResponse as List)) {
            final roomId = member['room_id'] as String;
            final userId = member['user_id'] as String;
            if (otherUsersMap.containsKey(userId)) {
              otherUsersMap['room_$roomId'] = otherUsersMap[userId]!;
            }
          }
        }
      }

      // Parse rooms and build details
      final rooms = <ChatRoomsRow>[];
      final roomDetailsMap = <String, dynamic>{};

      for (final roomData in roomsList) {
        final room = ChatRoomsRow(roomData);
        rooms.add(room);

        final lastMessage = roomData['last_message'];
        String? lastMessageText;
        DateTime? lastMessageTime;

        if (lastMessage != null && lastMessage is Map) {
          final messageType = lastMessage['message_type'] as String?;
          if (messageType == 'text') {
            lastMessageText = lastMessage['content'] as String?;
          } else if (messageType == 'image') {
            lastMessageText = '📷 Photo';
          } else if (messageType == 'video') {
            lastMessageText = '🎥 Video';
          } else if (messageType == 'file') {
            lastMessageText = '📎 File';
          } else {
            lastMessageText = lastMessage['content'] as String?;
          }

          final createdAtStr = lastMessage['created_at'];
          if (createdAtStr != null) {
            lastMessageTime = DateTime.parse(createdAtStr as String);
          }
        }

        final venueImagesRaw = roomData['venue_images'];
        List<String>? venueImages;
        if (venueImagesRaw is List) {
          venueImages = venueImagesRaw.cast<String>();
        }

        String? otherUserName;
        String? otherUserProfilePicture;
        if (room.type == 'single') {
          final otherUser = otherUsersMap['room_${room.id}'];
          otherUserName = otherUser?['first_name'];
          otherUserProfilePicture = otherUser?['profile_picture'];
        }

        roomDetailsMap[room.id] = {
          'venueImages': venueImages,
          'groupId': roomData['venue_group_id'],
          'lastMessage': lastMessageText,
          'lastMessageTime': lastMessageTime,
          'userHasMessaged': roomData['user_has_messaged'] ?? false,
          'otherUserName': otherUserName,
          'otherUserProfilePicture': otherUserProfilePicture,
          'unreadCount': roomData['unread_count'] ?? 0,
        };
      }

      print('DEBUG: Successfully loaded ${rooms.length} rooms with optimized query');

      safeSetState(() {
        _model.chatRooms = rooms;
        _model.filteredChatRooms = rooms;
        _model.chatRoomDetails = roomDetailsMap;
        _model.isLoadingRooms = false;
      });

    } catch (e, stackTrace) {
      print('ERROR fetching chat rooms: $e');
      print('Stack trace: $stackTrace');

      // Fallback to original method if optimization fails
      await _fetchChatRoomsFallback();
    }
  }

  /// Fallback method using original approach but with parallel queries
  Future<dynamic> _fetchChatRoomsFallback() async {
    try {
      print('DEBUG: Using fallback method with parallel queries');

      // Get room IDs where current user is a member
      final membershipResponse = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select('room_id')
          .eq('user_id', currentUserUid)
          .eq('is_banned', false);

      if ((membershipResponse as List).isEmpty) {
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return [];
      }

      final roomIds = (membershipResponse as List)
          .map((item) => item['room_id'] as String)
          .toList();

      // Fetch room details
      final roomsResponse = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select('*')
          .inFilter('id', roomIds)
          .eq('is_active', true)
          .order('updated_at', ascending: false);

      if ((roomsResponse as List).isEmpty) {
        safeSetState(() {
          _model.chatRooms = [];
          _model.filteredChatRooms = [];
          _model.chatRoomDetails = {};
          _model.isLoadingRooms = false;
        });
        return [];
      }

      final rooms = (roomsResponse as List)
          .map((data) => ChatRoomsRow(data))
          .toList();

      // Fetch all additional data in PARALLEL instead of sequentially
      final roomDetailsMap = <String, dynamic>{};

      await Future.wait(
        (roomsResponse as List).map((roomData) async {
          final roomId = roomData['id'] as String;
          final venueId = roomData['venue_id'] as int?;
          final roomType = roomData['type'] as String?;

          // Execute all queries for this room in parallel
          final results = await Future.wait<dynamic>([
            // Venue data
            venueId != null
                ? SupaFlow.client
                    .from('venues')
                    .select('images, group_id')
                    .eq('id', venueId)
                    .maybeSingle()
                    .then((value) => value)
                : Future.value(null),
            // Last message
            SupaFlow.client
                .schema('chat')
                .from('messages')
                .select('content, created_at, sender_id, message_type')
                .eq('room_id', roomId)
                .eq('is_deleted', false)
                .order('created_at', ascending: false)
                .limit(1)
                .then((value) => value),
            // User has messaged check
            SupaFlow.client
                .schema('chat')
                .from('messages')
                .select('id')
                .eq('room_id', roomId)
                .eq('sender_id', currentUserUid)
                .eq('is_deleted', false)
                .limit(1)
                .then((value) => value),
            // Members for single chats
            roomType == 'single'
                ? SupaFlow.client
                    .schema('chat')
                    .from('room_members')
                    .select('user_id')
                    .eq('room_id', roomId)
                    .then((value) => value)
                : Future.value([]),
            // Unread messages
            SupaFlow.client
                .schema('chat')
                .from('messages')
                .select('id')
                .eq('room_id', roomId)
                .neq('sender_id', currentUserUid)
                .eq('is_deleted', false)
                .then((value) => value),
          ]);

          // Parse results
          final venueResponse = results[0];
          final lastMessageResponse = results[1] as List;
          final userMessageResponse = results[2] as List;
          final membersResponse = results[3];
          final unreadResponse = results[4] as List;

          // Process venue data
          List<String>? venueImages;
          int? groupId;
          if (venueResponse != null) {
            final imagesRaw = venueResponse['images'];
            if (imagesRaw is List) {
              venueImages = imagesRaw.cast<String>();
            }
            groupId = venueResponse['group_id'] as int?;
          }

          // Process last message
          String? lastMessage;
          DateTime? lastMessageTime;
          if (lastMessageResponse.isNotEmpty) {
            final msgData = lastMessageResponse.first;
            final messageType = msgData['message_type'] as String?;
            if (messageType == 'text') {
              lastMessage = msgData['content'] as String?;
            } else if (messageType == 'image') {
              lastMessage = '📷 Photo';
            } else if (messageType == 'video') {
              lastMessage = '🎥 Video';
            } else if (messageType == 'file') {
              lastMessage = '📎 File';
            }
            final createdAtStr = msgData['created_at'];
            if (createdAtStr != null) {
              lastMessageTime = DateTime.parse(createdAtStr as String);
            }
          }

          // User has messaged
          bool userHasMessaged = userMessageResponse.isNotEmpty;

          // Get other user for single chats
          String? otherUserName;
          String? otherUserProfilePicture;
          if (roomType == 'single' && membersResponse is List && membersResponse.isNotEmpty) {
            String? otherUserId;
            for (final member in membersResponse) {
              final userId = member['user_id'];
              if (userId != currentUserUid) {
                otherUserId = userId;
                break;
              }
            }
            if (otherUserId != null) {
              final userResponse = await SupaFlow.client
                  .from('users')
                  .select('first_name, profile_picture')
                  .eq('user_id', otherUserId)
                  .maybeSingle();
              if (userResponse != null) {
                otherUserName = userResponse['first_name'];
                otherUserProfilePicture = userResponse['profile_picture'];
              }
            }
          }

          // Calculate unread count
          int unreadCount = 0;
          final messageIds = unreadResponse.map((m) => m['id'] as String).toList();
          if (messageIds.isNotEmpty) {
            final readStatusResponse = await SupaFlow.client
                .schema('chat')
                .from('message_read_status')
                .select('message_id')
                .inFilter('message_id', messageIds)
                .eq('user_id', currentUserUid);
            final readMessageIds = (readStatusResponse as List)
                .map((r) => r['message_id'] as String)
                .toSet();
            unreadCount = messageIds.where((id) => !readMessageIds.contains(id)).length;
          }

          roomDetailsMap[roomId] = {
            'venueImages': venueImages,
            'groupId': groupId,
            'lastMessage': lastMessage,
            'lastMessageTime': lastMessageTime,
            'userHasMessaged': userHasMessaged,
            'otherUserName': otherUserName,
            'otherUserProfilePicture': otherUserProfilePicture,
            'unreadCount': unreadCount,
          };
        }),
      );

      safeSetState(() {
        _model.chatRooms = rooms;
        _model.filteredChatRooms = rooms;
        _model.chatRoomDetails = roomDetailsMap;
        _model.isLoadingRooms = false;
      });

      return roomsResponse;
    } catch (e) {
      print('ERROR in fallback: $e');
      safeSetState(() {
        _model.chatRooms = [];
        _model.filteredChatRooms = [];
        _model.chatRoomDetails = {};
        _model.isLoadingRooms = false;
      });
      return [];
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

                                // Always show single type rooms (1-on-1 chats) regardless of filter
                                final isSingleChat = room.type == 'single';

                                if (!isSingleChat) {
                                  // PlayTime filter
                                  if (selectedFilter == 'playtime') {
                                    final metaData = room.metaData;
                                    final hasGameId = metaData is Map &&
                                        metaData.containsKey('game_id') &&
                                        metaData['game_id'] != null;
                                    final userHasMessaged = roomDetails?['userHasMessaged'] as bool? ?? false;
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
                              }

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    final result = await context.pushNamed(
                                      'ChatRoom',
                                      queryParameters: {
                                        'roomId': serializeParam(
                                          room.id,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    // Refresh if room was left
                                    if (result == 'room_left' && mounted) {
                                      await _fetchChatRooms();
                                    }
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
                                        // Avatar
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
                                            if (room.type == 'single') {
                                              final roomInfo = _model.chatRoomDetails?[room.id] as Map<String, dynamic>?;
                                              final otherUserProfilePic = roomInfo?['otherUserProfilePicture'];
                                              if (otherUserProfilePic != null && otherUserProfilePic is String && otherUserProfilePic.isNotEmpty) {
                                                return ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: otherUserProfilePic,
                                                    width: 56.0,
                                                    height: 56.0,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) {
                                                      return Icon(
                                                        Icons.person_rounded,
                                                        color: Colors.white,
                                                        size: 28.0,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Icon(
                                                  Icons.person_rounded,
                                                  color: Colors.white,
                                                  size: 28.0,
                                                );
                                              }
                                            }

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
                                                      Icons.groups_rounded,
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
                                                Icons.groups_rounded,
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
                                                      room.type == 'single'
                                                          ? (roomDetails?['otherUserName'] ?? room.name ?? 'Chat')
                                                          : (room.name ?? 'Chat Room'),
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
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
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
                                                      // Unread indicator
                                                      if ((roomDetails?['unreadCount'] as int? ?? 0) > 0) ...[
                                                        SizedBox(width: 6.0),
                                                        Container(
                                                          padding: EdgeInsets.all(6.0),
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Text(
                                                            '${roomDetails!['unreadCount']}',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
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
