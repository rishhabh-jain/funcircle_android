import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
                  ],
                ),
              ),
      ),
    );
  }
}
