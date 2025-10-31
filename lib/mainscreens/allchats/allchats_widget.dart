import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'allchats_model.dart';
export 'allchats_model.dart';

class AllchatsWidget extends StatefulWidget {
  const AllchatsWidget({super.key});

  static String routeName = 'allchats';
  static String routePath = '/allchats';

  @override
  State<AllchatsWidget> createState() => _AllchatsWidgetState();
}

class _AllchatsWidgetState extends State<AllchatsWidget> {
  late AllchatsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllchatsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).secondary),
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Container(
                    width: 70.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'io9l5znu' /* Chats */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
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
          actions: [],
          centerTitle: true,
          toolbarHeight: MediaQuery.sizeOf(context).height * 1.0,
          elevation: 1.0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 70.0),
          child:
              PagedListView<DocumentSnapshot<Object?>?, ChatsRecord>.separated(
            pagingController: _model.setListViewController(
              ChatsRecord.collection
                  .where(
                    'users',
                    arrayContains: currentUserReference,
                  )
                  .orderBy('last_message_time', descending: true),
            ),
            padding: EdgeInsets.zero,
            reverse: false,
            scrollDirection: Axis.vertical,
            separatorBuilder: (_, __) => SizedBox(height: 2.0),
            builderDelegate: PagedChildBuilderDelegate<ChatsRecord>(
              // Customize what your widget looks like when it's loading the first page.
              firstPageProgressIndicatorBuilder: (_) => Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: SpinKitRing(
                    color: FlutterFlowTheme.of(context).primary,
                    size: 50.0,
                  ),
                ),
              ),
              // Customize what your widget looks like when it's loading another page.
              newPageProgressIndicatorBuilder: (_) => Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: SpinKitRing(
                    color: FlutterFlowTheme.of(context).primary,
                    size: 50.0,
                  ),
                ),
              ),
              noItemsFoundIndicatorBuilder: (_) => Center(
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  imageUrl:
                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/no_chats__1_.jpg',
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                ),
              ),
              itemBuilder: (context, _, listViewIndex) {
                final listViewChatsRecord =
                    _model.listViewPagingController!.itemList![listViewIndex];
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: StreamBuilder<FFChatInfo>(
                    stream: FFChatManager.instance
                        .getChatInfo(chatRecord: listViewChatsRecord),
                    builder: (context, snapshot) {
                      final chatInfo =
                          snapshot.data ?? FFChatInfo(listViewChatsRecord);
                      return FFChatPreview(
                        onTap: () => context.pushNamed(
                          ChatWidget.routeName,
                          queryParameters: {
                            'chatUser': serializeParam(
                              chatInfo.otherUsers.length == 1
                                  ? chatInfo.otherUsersList.first
                                  : null,
                              ParamType.Document,
                            ),
                            'chatRef': serializeParam(
                              chatInfo.chatRecord.reference,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            'chatUser': chatInfo.otherUsers.length == 1
                                ? chatInfo.otherUsersList.first
                                : null,
                          },
                        ),
                        lastChatText: chatInfo.chatPreviewMessage(),
                        lastChatTime: listViewChatsRecord.lastMessageTime,
                        seen: listViewChatsRecord.lastMessageSeenBy
                            .contains(currentUserReference),
                        title: chatInfo.chatPreviewTitle(),
                        userProfilePic: chatInfo.chatPreviewPic(),
                        color: Color(0xFFEEF0F5),
                        unreadColor: FlutterFlowTheme.of(context).primary,
                        titleTextStyle: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        dateTextStyle: GoogleFonts.inter(
                          color: Color(0x73000000),
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        previewTextStyle: GoogleFonts.inter(
                          color: Color(0x73000000),
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        contentPadding: EdgeInsets.all(3.0),
                        borderRadius: BorderRadius.circular(0.0),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
