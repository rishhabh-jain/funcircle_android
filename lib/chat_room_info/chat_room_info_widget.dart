import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/screens/chat/widgets/room_invite_sheet.dart';
import 'package:flutter/material.dart';
import 'chat_room_info_model.dart';
export 'chat_room_info_model.dart';

class ChatRoomInfoWidget extends StatefulWidget {
  const ChatRoomInfoWidget({
    super.key,
    this.roomId,
  });

  final String? roomId;

  static const String routeName = 'ChatRoomInfo';
  static const String routePath = '/chatRoomInfo';

  @override
  State<ChatRoomInfoWidget> createState() => _ChatRoomInfoWidgetState();
}

class _ChatRoomInfoWidgetState extends State<ChatRoomInfoWidget> {
  late ChatRoomInfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatRoomInfoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    // Load room and members
    if (widget.roomId != null && widget.roomId!.isNotEmpty) {
      _loadRoomInfo();
      _loadRoomMembers();
    }
  }

  Future<void> _loadRoomInfo() async {
    if (widget.roomId == null) return;

    try {
      final response = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select()
          .eq('id', widget.roomId!)
          .single();

      safeSetState(() {
        _model.chatRoom = ChatRoomsRow(response);
        _model.isLoadingRoom = false;
      });
    } catch (e) {
      print('Error loading room: $e');
      safeSetState(() {
        _model.isLoadingRoom = false;
      });
    }
  }

  Future<void> _loadRoomMembers() async {
    if (widget.roomId == null) return;

    try {
      // Get room members with user details
      final response = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select('user_id, role, joined_at, is_muted, is_banned')
          .eq('room_id', widget.roomId!)
          .eq('is_banned', false);

      final members = response as List;

      // Fetch user details for each member
      List<Map<String, dynamic>> membersWithDetails = [];
      for (var member in members) {
        try {
          final userResponse = await SupaFlow.client
              .from('users')
              .select('user_id, first_name, images')
              .eq('user_id', member['user_id'])
              .single();

          membersWithDetails.add({
            ...member,
            'user_details': userResponse,
          });
        } catch (e) {
          print('Error fetching user ${member['user_id']}: $e');
        }
      }

      safeSetState(() {
        _model.roomMembers = membersWithDetails;
        _model.isLoadingMembers = false;
      });
    } catch (e) {
      print('Error loading members: $e');
      safeSetState(() {
        _model.isLoadingMembers = false;
      });
    }
  }

  Future<void> _leaveRoom() async {
    if (widget.roomId == null || currentUserUid.isEmpty) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Leave Room',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                  color: FlutterFlowTheme.of(context).info,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                ),
          ),
          content: Text(
            'Are you sure you want to leave this room? You can be re-invited later.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Leave',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).error,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      );

      // Get user's name for the system message
      String userName = 'A user';
      try {
        final userResponse = await SupaFlow.client
            .from('users')
            .select('first_name')
            .eq('user_id', currentUserUid)
            .single();
        userName = userResponse['first_name'] ?? 'A user';
      } catch (e) {
        print('Could not fetch user name: $e');
      }

      // Create system message before leaving
      try {
        await SupaFlow.client
            .schema('chat')
            .from('messages')
            .insert({
              'room_id': widget.roomId!,
              'sender_id': currentUserUid,
              'content': '$userName has left the chat',
              'message_type': 'system',
              'created_at': DateTime.now().toUtc().toIso8601String(),
            });
      } catch (e) {
        print('Could not create system message: $e');
        // Continue with leaving even if system message fails
      }

      // Delete the user from room_members
      await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .delete()
          .eq('room_id', widget.roomId!)
          .eq('user_id', currentUserUid);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have left the room'),
            backgroundColor: FlutterFlowTheme.of(context).success,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back with result to trigger refresh
        Navigator.of(context).pop('room_left');
      }
    } catch (e) {
      print('Error leaving room: $e');

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to leave room: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondary,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          buttonSize: 46.0,
          icon: Icon(
            FFIcons.karrowLeft,
            color: FlutterFlowTheme.of(context).info,
            size: 24.0,
          ),
          onPressed: () async {
            context.safePop();
          },
        ),
        title: Text(
          'Room Info',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                color: FlutterFlowTheme.of(context).info,
                fontSize: 18.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).headlineMediumIsCustom,
              ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: _model.isLoadingRoom
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room Avatar
                    if (_model.chatRoom?.avatarUrl != null &&
                        _model.chatRoom!.avatarUrl!.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: Image.network(
                              _model.chatRoom!.avatarUrl!,
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                    // Room Name
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                      child: Text(
                        'Room Name',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).labelMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .labelMediumIsCustom,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                      child: Text(
                        _model.chatRoom?.name ?? 'Unknown',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineSmallFamily,
                              color: FlutterFlowTheme.of(context).info,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineSmallIsCustom,
                            ),
                      ),
                    ),

                    // Description
                    if (_model.chatRoom?.description != null &&
                        _model.chatRoom!.description!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 8.0),
                            child: Text(
                              'Description',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 16.0),
                            child: Text(
                              _model.chatRoom!.description!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),

                    // Room Type & Sport
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              _model.chatRoom?.type ?? '',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodySmallFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodySmallIsCustom,
                                  ),
                            ),
                          ),
                          if (_model.chatRoom?.sportType != null)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2F2F2F),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  _model.chatRoom!.sportType!,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Created Date
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                      child: Text(
                        'Created',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).labelMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .labelMediumIsCustom,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                      child: Text(
                        _model.chatRoom?.createdAt != null
                            ? dateTimeFormat(
                                'MMMMEEEEd', _model.chatRoom!.createdAt)
                            : 'Unknown',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).info,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),

                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).secondaryText
                          .withValues(alpha: 0.2),
                    ),

                    // Invite Players Button
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => RoomInviteSheet(
                              roomId: widget.roomId ?? '',
                              roomName: _model.chatRoom?.name ?? 'Chat Room',
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: FlutterFlowTheme.of(context).info,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                'Invite Players',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleMediumFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: !FlutterFlowTheme.of(context)
                                          .titleMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Members Section
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Members',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineSmallFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineSmallIsCustom,
                                ),
                          ),
                          Text(
                            '${_model.roomMembers.length}',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    // Members List
                    _model.isLoadingMembers
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _model.roomMembers.length,
                            itemBuilder: (context, index) {
                              final member = _model.roomMembers[index];
                              final userDetails =
                                  member['user_details'] as Map<String, dynamic>?;
                              final firstName = userDetails?['first_name'] ?? 'Unknown';
                              final images = userDetails?['images'] as List?;
                              final avatarUrl = images != null && images.isNotEmpty
                                  ? images.first
                                  : null;
                              final role = member['role'] ?? 'member';

                              return ListTile(
                                leading: avatarUrl != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          avatarUrl,
                                          width: 40.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 20.0,
                                        ),
                                      ),
                                title: Text(
                                  firstName,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyLargeIsCustom,
                                      ),
                                ),
                                trailing: role != 'member'
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: role == 'admin'
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : Color(0xFF2F2F2F),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          role,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmallFamily,
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .info,
                                                fontSize: 10.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmallIsCustom,
                                              ),
                                        ),
                                      )
                                    : null,
                                dense: false,
                              );
                            },
                          ),

                    // Divider before leave button
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Divider(
                        thickness: 1.0,
                        color: FlutterFlowTheme.of(context).secondaryText
                            .withValues(alpha: 0.2),
                      ),
                    ),

                    // Leave Room Button
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 32.0),
                      child: InkWell(
                        onTap: _leaveRoom,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).error
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: FlutterFlowTheme.of(context).error,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                'Leave Room',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleMediumFamily,
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: !FlutterFlowTheme.of(context)
                                          .titleMediumIsCustom,
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
    );
  }
}
