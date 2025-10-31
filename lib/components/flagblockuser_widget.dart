import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'flagblockuser_model.dart';
export 'flagblockuser_model.dart';

class FlagblockuserWidget extends StatefulWidget {
  const FlagblockuserWidget({
    super.key,
    required this.otheruserref,
  });

  final DocumentReference? otheruserref;

  @override
  State<FlagblockuserWidget> createState() => _FlagblockuserWidgetState();
}

class _FlagblockuserWidgetState extends State<FlagblockuserWidget> {
  late FlagblockuserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FlagblockuserModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(
              0.0,
              -3.0,
            ),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FFButtonWidget(
              onPressed: () async {
                if ((currentUserDocument?.userBlocked.toList() ?? [])
                    .contains(widget.otheruserref)) {
                  logFirebaseEvent('Button_alert_dialog');
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return WebViewAware(
                        child: AlertDialog(
                          title: Text('User Blocked'),
                          content: Text('This user is blocked'),
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
                  logFirebaseEvent('Button_backend_call');

                  await currentUserReference!.update({
                    ...mapToFirestore(
                      {
                        'user_blocked':
                            FieldValue.arrayUnion([widget.otheruserref]),
                      },
                    ),
                  });
                  logFirebaseEvent('Button_close_dialog_drawer_etc');
                  Navigator.pop(context);
                  logFirebaseEvent('Button_backend_call');

                  await widget.otheruserref!.update({
                    ...mapToFirestore(
                      {
                        'flaggednumber': FieldValue.increment(1),
                      },
                    ),
                  });
                }
              },
              text: FFLocalizations.of(context).getText(
                '4yfp2q1t' /* Flag as inappropriate */,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).warning,
                textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                      color: FlutterFlowTheme.of(context).secondary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  if ((currentUserDocument?.userBlocked.toList() ?? [])
                      .contains(widget.otheruserref)) {
                    logFirebaseEvent('Button_alert_dialog');
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return WebViewAware(
                          child: AlertDialog(
                            title: Text('User Blocked'),
                            content: Text('This user is blocked'),
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
                    logFirebaseEvent('Button_backend_call');

                    await currentUserReference!.update({
                      ...mapToFirestore(
                        {
                          'user_blocked':
                              FieldValue.arrayUnion([widget.otheruserref]),
                        },
                      ),
                    });
                    logFirebaseEvent('Button_alert_dialog');
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return WebViewAware(
                          child: AlertDialog(
                            title: Text('User Blocked'),
                            content: Text('This user is blocked'),
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
                    logFirebaseEvent('Button_close_dialog_drawer_etc');
                    Navigator.pop(context);
                  }
                },
                text: FFLocalizations.of(context).getText(
                  'sb05c7m5' /* Block user */,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).error,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyLargeFamily,
                        color: FlutterFlowTheme.of(context).tertiary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  logFirebaseEvent('Button_close_dialog_drawer_etc');
                  Navigator.pop(context);
                },
                text: FFLocalizations.of(context).getText(
                  '980i6coj' /* Cancel */,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
