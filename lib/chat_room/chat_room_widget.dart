import '/auth/firebase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_room_model.dart';
export 'chat_room_model.dart';

class ChatRoomWidget extends StatefulWidget {
  const ChatRoomWidget({
    super.key,
    this.roomId,
  });

  final String? roomId;

  static const String routeName = 'ChatRoom';
  static const String routePath = '/chatRoom';

  @override
  State<ChatRoomWidget> createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  late ChatRoomModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatRoomModel());

    _model.messageController ??= TextEditingController();
    _model.messageFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    // Load room and messages only if roomId is provided
    if (widget.roomId != null && widget.roomId!.isNotEmpty) {
      _loadRoom();
      _loadMessages();
      _subscribeToMessages();
    }
  }

  Future<void> _loadRoom() async {
    if (widget.roomId == null) return;

    try {
      final response = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select()
          .eq('id', widget.roomId!)
          .single();

      final room = ChatRoomsRow(response);

      // If it's a single chat, fetch the other user's details
      if (room.type == 'single') {
        try {
          // Get all members of this room
          final membersResponse = await SupaFlow.client
              .schema('chat')
              .from('room_members')
              .select('user_id')
              .eq('room_id', widget.roomId!);

          // Find the other user (not current user)
          final members = (membersResponse as List);
          String? otherUserId;
          for (final member in members) {
            final userId = member['user_id'];
            if (userId != currentUserUid) {
              otherUserId = userId;
              break;
            }
          }

          if (otherUserId != null) {
            // Fetch other user's details
            final userResponse = await SupaFlow.client
                .from('users')
                .select('first_name, profile_picture')
                .eq('user_id', otherUserId)
                .maybeSingle();

            if (userResponse != null) {
              _model.otherUserName = userResponse['first_name'];
              _model.otherUserProfilePicture = userResponse['profile_picture'];
            }
          }
        } catch (e) {
          print('Error fetching other user details: $e');
        }
      }

      safeSetState(() {
        _model.chatRoom = room;
        _model.isLoadingRoom = false;
      });
    } catch (e) {
      print('Error loading room: $e');
      safeSetState(() {
        _model.isLoadingRoom = false;
      });
    }
  }

  Future<void> _loadMessages() async {
    if (widget.roomId == null) return;

    try {
      final response = await SupaFlow.client
          .schema('chat')
          .from('messages')
          .select()
          .eq('room_id', widget.roomId!)
          .eq('is_deleted', false)
          .order('created_at', ascending: true);

      // Fetch profile pictures for all unique senders
      final messages = response as List;
      final senderIds = messages
          .map((m) => m['sender_id'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      Map<String, String?> profilePictures = {};
      if (senderIds.isNotEmpty) {
        try {
          final usersResponse = await SupaFlow.client
              .from('users')
              .select('user_id, profile_picture, first_name')
              .inFilter('user_id', senderIds);

          for (final user in usersResponse as List) {
            final userId = user['user_id'] as String;
            profilePictures[userId] = user['profile_picture'] as String?;

            // Also update sender name if not present
            for (var msg in messages) {
              if (msg['sender_id'] == userId && msg['sender_name'] == null) {
                msg['sender_name'] = user['first_name'];
              }
            }
          }
        } catch (e) {
          print('Error fetching user profile pictures: $e');
        }
      }

      // Add profile pictures to message data
      for (var msg in messages) {
        final senderId = msg['sender_id'] as String?;
        if (senderId != null) {
          msg['sender_profile_picture'] = profilePictures[senderId];
        }
      }

      safeSetState(() {
        _model.messages = messages.map((data) => ChatMessagesRow(data)).toList();
        _model.isLoadingMessages = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error loading messages: $e');
      safeSetState(() {
        _model.isLoadingMessages = false;
      });
    }
  }

  void _subscribeToMessages() {
    if (widget.roomId == null) return;

    // Set up real-time subscription for new messages
    _model.messageSubscription = SupaFlow.client
        .channel('messages:${widget.roomId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'chat',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: widget.roomId!,
          ),
          callback: (payload) async {
            final newMessageData = payload.newRecord;
            // Only add if it's not from the current user (to avoid duplicates)
            final senderId = newMessageData['sender_id'] as String?;
            if (senderId != null && senderId != currentUserUid) {
              // Fetch sender's profile picture
              try {
                final userResponse = await SupaFlow.client
                    .from('users')
                    .select('profile_picture, first_name')
                    .eq('user_id', senderId)
                    .maybeSingle();

                if (userResponse != null) {
                  newMessageData['sender_profile_picture'] =
                      userResponse['profile_picture'];
                  if (newMessageData['sender_name'] == null) {
                    newMessageData['sender_name'] = userResponse['first_name'];
                  }
                }
              } catch (e) {
                print('Error fetching sender profile: $e');
              }

              final newMessage = ChatMessagesRow(newMessageData);
              safeSetState(() {
                _model.messages.add(newMessage);
              });

              // Scroll to bottom
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          },
        )
        .subscribe();
  }

  void _scrollToBottom() {
    if (_model.scrollController != null &&
        _model.scrollController!.hasClients) {
      _model.scrollController!.animateTo(
        _model.scrollController!.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    // Validate message
    final messageText = _model.messageController?.text.trim();
    if (messageText == null || messageText.isEmpty) {
      return;
    }

    if (widget.roomId == null) {
      print('Error: roomId is null');
      return;
    }

    if (currentUserUid.isEmpty) {
      print('Error: currentUserUid is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    safeSetState(() {
      _model.isSendingMessage = true;
    });

    try {
      final payload = {
        'room_id': widget.roomId!,
        'sender_id': currentUserUid,
        'content': messageText,
        'message_type': 'text',
      };

      print('=== SENDING MESSAGE ===');
      print('roomId: ${widget.roomId}');
      print('senderId: $currentUserUid');
      print('content: $messageText');
      print('Payload: $payload');

      // Insert message into database
      final response = await SupaFlow.client
          .schema('chat')
          .from('messages')
          .insert(payload)
          .select();

      print('=== MESSAGE SENT SUCCESSFULLY ===');
      print('Response: $response');

      if (response.isNotEmpty) {
        // Add message to local list
        final newMessage = ChatMessagesRow(response.first);
        safeSetState(() {
          _model.messages.add(newMessage);
        });

        // Clear input
        _model.messageController?.clear();

        // Note: room's updated_at should be updated via database trigger
        // to avoid RLS permission issues

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e, stackTrace) {
      print('=== ERROR SENDING MESSAGE ===');
      print('Error type: ${e.runtimeType}');
      print('Error: $e');
      print('Stack trace: $stackTrace');

      String errorMessage = 'Failed to send message';

      // Try to extract more specific error information
      if (e.toString().contains('violates row-level security policy')) {
        errorMessage = 'Permission denied. Check RLS policies.';
      } else if (e.toString().contains('foreign key constraint')) {
        errorMessage = 'Invalid room or user reference';
      } else if (e.toString().contains('null value')) {
        errorMessage = 'Missing required field';
      } else {
        errorMessage = 'Failed to send: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      safeSetState(() {
        _model.isSendingMessage = false;
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
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            buttonSize: 46.0,
            icon: Icon(
              FFIcons.karrowLeft,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: _model.isLoadingRoom
              ? SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    if (widget.roomId != null) {
                      final result = await context.pushNamed(
                        'ChatRoomInfo',
                        queryParameters: {
                          'roomId': serializeParam(
                            widget.roomId,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );

                      // If user left room, pop this screen too with the same result
                      if (result == 'room_left' && mounted) {
                        Navigator.of(context).pop('room_left');
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Room Avatar
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          gradient: _model.chatRoom?.type == 'single'
                              ? null
                              : LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).primary,
                                    FlutterFlowTheme.of(context).secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: _model.chatRoom?.type == 'single'
                              ? Colors.grey.shade800
                              : null,
                          shape: BoxShape.circle,
                        ),
                        child: _model.chatRoom?.type == 'single' &&
                                _model.otherUserProfilePicture != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _model.otherUserProfilePicture!,
                                  fit: BoxFit.cover,
                                  width: 40.0,
                                  height: 40.0,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            : Icon(
                                _model.chatRoom?.type == 'single'
                                    ? Icons.person
                                    : Icons.groups_rounded,
                                color: Colors.white,
                                size: 20.0,
                              ),
                      ),
                      SizedBox(width: 12.0),
                      // Room Name & Type
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _model.chatRoom?.type == 'single'
                                  ? (_model.otherUserName ?? 'Chat')
                                  : (_model.chatRoom?.name ?? 'Chat'),
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineMediumFamily,
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts: !FlutterFlowTheme.of(context)
                                        .headlineMediumIsCustom,
                                  ),
                            ),
                            if (_model.chatRoom?.sportType != null)
                              Text(
                                '${_model.chatRoom?.sportType} • ${_model.chatRoom?.type ?? 'group'}',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context)
                                          .bodySmallIsCustom,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Messages List
              Expanded(
                child: _model.isLoadingMessages
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : _model.messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Color(0xFF3A3A3C),
                                  size: 64.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'No messages yet',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8E8E93),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Send a message to get started!',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: Color(0xFF636366),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context)
                                            .bodySmallIsCustom,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _model.scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            itemCount: _model.messages.length,
                            itemBuilder: (context, index) {
                              final message = _model.messages[index];
                              final isMe = message.senderId == currentUserUid;
                              final isSystemMessage =
                                  message.messageType == 'system';

                              // System message (centered)
                              if (isSystemMessage) {
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 12.0),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2C2C2E),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        message.content ?? '',
                                        textAlign: TextAlign.center,
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
                                    ),
                                  ),
                                );
                              }

                              // Regular message
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 3.0, 0.0, 3.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!isMe)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 8.0, 0.0),
                                        child: message.senderProfilePicture != null &&
                                               message.senderProfilePicture!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: message.senderProfilePicture!,
                                                  width: 32.0,
                                                  height: 32.0,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    width: 32.0,
                                                    height: 32.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF00C9FF),
                                                          Color(0xFF0084FF),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        (message.senderName ?? 'U')[0].toUpperCase(),
                                                        style: FlutterFlowTheme.of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily: FlutterFlowTheme.of(context)
                                                                  .bodyMediumFamily,
                                                              color: Colors.white,
                                                              fontSize: 14.0,
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                                                  .bodyMediumIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    width: 32.0,
                                                    height: 32.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF00C9FF),
                                                          Color(0xFF0084FF),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        (message.senderName ?? 'U')[0].toUpperCase(),
                                                        style: FlutterFlowTheme.of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily: FlutterFlowTheme.of(context)
                                                                  .bodyMediumFamily,
                                                              color: Colors.white,
                                                              fontSize: 14.0,
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                                                  .bodyMediumIsCustom,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 32.0,
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF00C9FF),
                                                      Color(0xFF0084FF),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (message.senderName ?? 'U')[0].toUpperCase(),
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: FlutterFlowTheme.of(context)
                                                              .bodyMediumFamily,
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: !FlutterFlowTheme.of(context)
                                                              .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          // Sender name (only for other users)
                                          if (!isMe && message.senderName != null)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12.0, 0.0, 0.0, 2.0),
                                              child: Text(
                                                message.senderName!,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallFamily,
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w500,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmallIsCustom,
                                                    ),
                                              ),
                                            ),
                                          // Message bubble
                                          GestureDetector(
                                            onLongPress: !isMe ? () {
                                              // Show report dialog for other users' messages
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) => AlertDialog(
                                                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                  title: Text(
                                                    'Report Message',
                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                      fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                      color: FlutterFlowTheme.of(context).tertiary,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Report this message as inappropriate?',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(dialogContext),
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        try {
                                                          // Add report to database (chat schema)
                                                          await SupaFlow.client
                                                              .schema('chat')
                                                              .from('message_reports')
                                                              .insert({
                                                            'message_id': message.id,
                                                            'room_id': widget.roomId,
                                                            'reporter_id': currentUserUid,
                                                            'reported_user_id': message.senderId,
                                                            'created_at': DateTime.now().toIso8601String(),
                                                          });

                                                          Navigator.pop(dialogContext);

                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Message reported successfully'),
                                                              backgroundColor: FlutterFlowTheme.of(context).success,
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          print('Error reporting message: $e');
                                                          Navigator.pop(dialogContext);

                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Failed to report message'),
                                                              backgroundColor: FlutterFlowTheme.of(context).error,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'Report',
                                                        style: TextStyle(color: FlutterFlowTheme.of(context).error),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } : null,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.sizeOf(context)
                                                        .width *
                                                    0.7,
                                              ),
                                              decoration: BoxDecoration(
                                              gradient: isMe
                                                  ? LinearGradient(
                                                      colors: [
                                                        FlutterFlowTheme.of(context).primary,
                                                        FlutterFlowTheme.of(context).secondary,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    )
                                                  : null,
                                              color: isMe ? null : Color(0xFF1C1C1E),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomLeft: Radius.circular(
                                                    isMe ? 20.0 : 4.0),
                                                bottomRight: Radius.circular(
                                                    isMe ? 4.0 : 20.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.15),
                                                  blurRadius: 8.0,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14.0, vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    message.content ?? '',
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
                                                          useGoogleFonts: !FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        message.createdAt != null
                                                            ? timeago.format(
                                                                message.createdAt!)
                                                            : '',
                                                        style: FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmallFamily,
                                                              color: Colors.white
                                                                  .withValues(alpha: 0.6),
                                                              fontSize: 11.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmallIsCustom,
                                                            ),
                                                      ),
                                                      if (isMe) ...[
                                                        SizedBox(width: 4.0),
                                                        Icon(
                                                          Icons.done_all_rounded,
                                                          color: Colors.white.withValues(alpha: 0.6),
                                                          size: 14.0,
                                                        ),
                                                      ],
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
                                  ],
                                ),
                              );
                            },
                          ),
              ),
              // Message Input
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Attach button
                      Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 22.0,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      // Message input
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 36.0,
                            maxHeight: 100.0,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: TextFormField(
                              controller: _model.messageController,
                              focusNode: _model.messageFieldFocusNode,
                              autofocus: true,
                              obscureText: false,
                              textInputAction: TextInputAction.send,
                              onFieldSubmitted: (value) async {
                                if (!_model.isSendingMessage && value.trim().isNotEmpty) {
                                  await _sendMessage();
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Message',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF8E8E93),
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(
                                              context)
                                          .bodyMediumIsCustom,
                                    ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(
                                            context)
                                        .bodyMediumIsCustom,
                                  ),
                              maxLines: 5,
                              minLines: 1,
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              validator: _model.messageControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      // Send button with gradient
                      Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          gradient: _model.isSendingMessage
                              ? null
                              : LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).primary,
                                    FlutterFlowTheme.of(context).secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: _model.isSendingMessage ? Color(0xFF3A3A3C) : null,
                          shape: BoxShape.circle,
                          boxShadow: _model.isSendingMessage
                              ? []
                              : [
                                  BoxShadow(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18.0),
                            onTap: _model.isSendingMessage
                                ? null
                                : () async {
                                    await _sendMessage();
                                  },
                            child: Center(
                              child: _model.isSendingMessage
                                  ? SizedBox(
                                      width: 16.0,
                                      height: 16.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF8E8E93),
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Colors.white,
                                      size: 20.0,
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
  }
}
