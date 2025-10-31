import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    this.chatUser,
    this.chatRef,
  });

  final UsersRecord? chatUser;
  final DocumentReference? chatRef;

  static String routeName = 'chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  FFChatInfo? _chatInfo;
  bool isGroupChat() {
    if (widget.chatUser == null) {
      return true;
    }
    if (widget.chatRef == null) {
      return false;
    }
    return _chatInfo?.isGroupChat ?? false;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    FFChatManager.instance
        .getChatInfo(
      otherUserRecord: widget.chatUser,
      chatReference: widget.chatRef,
    )
        .listen((info) {
      safeSetState(() => _chatInfo = info);
    });

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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 46.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 24.0,
            ),
            onPressed: () async {
              logFirebaseEvent('IconButton_navigate_back');
              context.pop();
            },
          ),
          title: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (!isGroupChat()) {
                logFirebaseEvent('Text_navigate_to');

                context.pushNamed(
                  OthersProfileWidget.routeName,
                  pathParameters: {
                    'uid': serializeParam(
                      widget.chatUser?.uid,
                      ParamType.String,
                    ),
                  }.withoutNulls,
                );
              }
            },
            child: Text(
              valueOrDefault<String>(
                () {
                  if (isGroupChat()) {
                    return valueOrDefault<String>(
                      _chatInfo!.chatRecord.groupName,
                      'Group name',
                    );
                  } else if (!isGroupChat()) {
                    return valueOrDefault<String>(
                      widget.chatUser?.displayName,
                      'name',
                    );
                  } else {
                    return 'Name';
                  }
                }(),
                'name',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isGroupChat())
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 35.0,
                    icon: Icon(
                      Icons.block,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      logFirebaseEvent('IconButton_alert_dialog');
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return WebViewAware(
                                child: AlertDialog(
                                  title: Text('Alert'),
                                  content: Text(
                                      'Are you sure you want to block the user. This can\'t be undone. Chat will be deleted.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          alertDialogContext, false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          alertDialogContext, true),
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ) ??
                          false;
                      if (confirmDialogResponse) {
                        if ((currentUserDocument?.userBlocked.toList() ?? [])
                            .contains(widget.chatUser?.reference)) {
                          logFirebaseEvent('IconButton_alert_dialog');
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return WebViewAware(
                                child: AlertDialog(
                                  title: Text('Already Blocked'),
                                  content: Text('User already blocked'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          logFirebaseEvent('IconButton_backend_call');

                          await currentUserReference!.update({
                            ...mapToFirestore(
                              {
                                'user_blocked': FieldValue.arrayUnion(
                                    [widget.chatUser?.reference]),
                              },
                            ),
                          });
                          logFirebaseEvent('IconButton_backend_call');
                          await widget.chatRef!.delete();
                          logFirebaseEvent('IconButton_navigate_to');

                          context.goNamed(AllchatsWidget.routeName);
                        }
                      }
                    },
                  ),
                if (isGroupChat())
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 35.0,
                      icon: Icon(
                        Icons.add,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        logFirebaseEvent('IconButton_navigate_to');

                        context.pushNamed(
                          MyProfileWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                            ),
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
          centerTitle: false,
          elevation: 1.0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: StreamBuilder<FFChatInfo>(
          stream: FFChatManager.instance.getChatInfo(
            otherUserRecord: widget.chatUser,
            chatReference: widget.chatRef,
          ),
          builder: (context, snapshot) => snapshot.hasData
              ? FFChatPage(
                  chatInfo: snapshot.data!,
                  allowImages: true,
                  backgroundColor: Color(0x0AC702CC),
                  timeDisplaySetting: TimeDisplaySetting.alwaysVisible,
                  currentUserBoxDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  otherUsersBoxDecoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  currentUserTextStyle: GoogleFonts.inter(
                    color: Color(0xFF1E2429),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    fontStyle: FontStyle.normal,
                  ),
                  otherUsersTextStyle: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                  inputHintTextStyle: GoogleFonts.inter(
                    color: Color(0xFF95A1AC),
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  inputTextStyle: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  emptyChatWidget: Image.asset(
                    'assets/images/Date.png',
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: SpinKitRing(
                      color: FlutterFlowTheme.of(context).primary,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
