import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'lookingfor_model.dart';
export 'lookingfor_model.dart';

class LookingforWidget extends StatefulWidget {
  const LookingforWidget({
    super.key,
    this.uid,
  });

  final String? uid;

  static String routeName = 'Lookingfor';
  static String routePath = '/lookingfor';

  @override
  State<LookingforWidget> createState() => _LookingforWidgetState();
}

class _LookingforWidgetState extends State<LookingforWidget> {
  late LookingforModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LookingforModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
        backgroundColor: Color(0xFFFFF5FB),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.uid == null || widget.uid == '')
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: LinearPercentIndicator(
                      percent: 0.42,
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      lineHeight: 12.0,
                      animation: false,
                      animateFromLastPercent: true,
                      progressColor: FlutterFlowTheme.of(context).primary,
                      backgroundColor: Color(0xFFDADADA),
                      center: Text(
                        FFLocalizations.of(context).getText(
                          'jpe6m706' /* 42% */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: Icon(
                                    FFIcons.kmagnifyingGlass,
                                    color: Color(0xFFF902FF),
                                    size: 30.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 40.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'o8ue12lv' /* What are you looking for? */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFF323A46),
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 5.0, 15.0, 5.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'Container_update_page_state');
                                      _model.selectValue = 'relationship';
                                      _model.select1 = true;
                                      _model.select2 = false;
                                      _model.select3 = false;
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(46.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                '9oquxnwk' /* Relationship */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeFamily,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 15.0, 0.0),
                                            child: ToggleIcon(
                                              onPressed: () async {
                                                safeSetState(() => _model
                                                    .select1 = !_model.select1);
                                                logFirebaseEvent(
                                                    'ToggleIcon_update_page_state');
                                                _model.selectValue =
                                                    'relationship';
                                                _model.select1 = true;
                                                _model.select2 = false;
                                                _model.select3 = false;
                                                safeSetState(() {});
                                              },
                                              value: _model.select1,
                                              onIcon: Icon(
                                                Icons.check_circle_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 25.0,
                                              ),
                                              offIcon: Icon(
                                                Icons.radio_button_off,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 5.0, 15.0, 5.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'Container_update_page_state');
                                      _model.selectValue = 'casual';
                                      _model.select1 = false;
                                      _model.select2 = true;
                                      _model.select3 = false;
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(46.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'd0umo0dl' /* Casual */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeFamily,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 15.0, 0.0),
                                            child: ToggleIcon(
                                              onPressed: () async {
                                                safeSetState(() => _model
                                                    .select2 = !_model.select2);
                                                logFirebaseEvent(
                                                    'ToggleIcon_update_page_state');
                                                _model.selectValue = 'casual';
                                                _model.select1 = false;
                                                _model.select2 = true;
                                                _model.select3 = false;
                                                safeSetState(() {});
                                              },
                                              value: _model.select2,
                                              onIcon: Icon(
                                                Icons.check_circle_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 25.0,
                                              ),
                                              offIcon: Icon(
                                                Icons.radio_button_off,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 5.0, 15.0, 5.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'Container_update_page_state');
                                      _model.selectValue = 'dont know yet';
                                      _model.select1 = false;
                                      _model.select2 = false;
                                      _model.select3 = true;
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(46.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'tujvl17l' /* Don't know yet */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeFamily,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeIsCustom,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 15.0, 0.0),
                                            child: ToggleIcon(
                                              onPressed: () async {
                                                safeSetState(() => _model
                                                    .select3 = !_model.select3);
                                                logFirebaseEvent(
                                                    'ToggleIcon_update_page_state');
                                                _model.selectValue =
                                                    'dont know yet';
                                                _model.select1 = false;
                                                _model.select2 = false;
                                                _model.select3 = true;
                                                safeSetState(() {});
                                              },
                                              value: _model.select3,
                                              onIcon: Icon(
                                                Icons.check_circle_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 25.0,
                                              ),
                                              offIcon: Icon(
                                                Icons.radio_button_off,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 25.0,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                    child: Container(
                      width: 335.0,
                      height: 50.0,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Visibility(
                                  visible:
                                      widget.uid != null && widget.uid != '',
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 20.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      FFIcons.karrowLeft,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 32.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.safePop();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEE6FF),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 20.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  fillColor: Color(0xFFFEE6FF),
                                  icon: Icon(
                                    FFIcons.kcaretRight,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 32.0,
                                  ),
                                  showLoadingIndicator: true,
                                  onPressed: () async {
                                    if (widget.uid != null &&
                                        widget.uid != '') {
                                      if (_model.selectValue == null ||
                                          _model.selectValue == '') {
                                        logFirebaseEvent(
                                            'IconButton_show_snack_bar');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please select one',
                                              style: GoogleFonts.inter(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .tertiary,
                                          ),
                                        );
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_backend_call');
                                        await UsersTable().update(
                                          data: {
                                            'looking_for': _model.selectValue,
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            widget.uid,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'IconButton_navigate_back');
                                        context.safePop();
                                      }
                                    } else {
                                      if (_model.selectValue == null ||
                                          _model.selectValue == '') {
                                        logFirebaseEvent(
                                            'IconButton_show_snack_bar');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please select one',
                                              style: GoogleFonts.inter(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .tertiary,
                                          ),
                                        );
                                      } else {
                                        logFirebaseEvent(
                                            'IconButton_backend_call');
                                        await UsersTable().update(
                                          data: {
                                            'looking_for': _model.selectValue,
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            currentUserUid,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'IconButton_backend_call');
                                        await UserprofilecompletionstatusTable()
                                            .update(
                                          data: {
                                            'looking_for_completed': true,
                                            'current_step': 4,
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            currentUserUid,
                                          ),
                                        );
                                        logFirebaseEvent(
                                            'IconButton_navigate_to');

                                        context.goNamed(
                                          DoyousmokeWidget.routeName,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType: PageTransitionType
                                                  .leftToRight,
                                            ),
                                          },
                                        );
                                      }
                                    }

                                    safeSetState(() {});
                                  },
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
          ),
        ),
      ),
    );
  }
}
