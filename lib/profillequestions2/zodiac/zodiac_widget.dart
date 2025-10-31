import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'zodiac_model.dart';
export 'zodiac_model.dart';

class ZodiacWidget extends StatefulWidget {
  const ZodiacWidget({
    super.key,
    this.uid,
  });

  final String? uid;

  static String routeName = 'Zodiac';
  static String routePath = '/zodiac';

  @override
  State<ZodiacWidget> createState() => _ZodiacWidgetState();
}

class _ZodiacWidgetState extends State<ZodiacWidget> {
  late ZodiacModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZodiacModel());

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
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Stack(
              alignment: AlignmentDirectional(0.0, 1.0),
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (widget.uid == null || widget.uid == '')
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 30.0),
                            child: LinearPercentIndicator(
                              percent: 0.48,
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              lineHeight: 12.0,
                              animation: false,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).primary,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).accent4,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 80.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 10.0),
                                          child: Icon(
                                            FFIcons.kplanet,
                                            color: Color(0xFFF902FF),
                                            size: 30.0,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 40.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              '5jz60mt3' /* What is your zodiac? */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: Color(0xFF323A46),
                                                  fontSize: 24.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Aries';
                                              _model.select1 = true;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '3a5y07gp' /* Aries */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select1 =
                                                                !_model
                                                                    .select1);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Aries';
                                                        _model.select1 = true;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select1,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Taurus';
                                              _model.select1 = false;
                                              _model.select2 = true;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'sromagvr' /* Taurus */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select2 =
                                                                !_model
                                                                    .select2);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Taurus';
                                                        _model.select1 = false;
                                                        _model.select2 = true;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select2,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Gemini';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = true;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'lzibofe2' /* Gemini */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select3 =
                                                                !_model
                                                                    .select3);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Gemini';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = true;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select3,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Cancer';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = true;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'no6xi0q3' /* Cancer */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select4 =
                                                                !_model
                                                                    .select4);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Cancer';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = true;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select4,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Leo';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = true;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'kvzwdwj1' /* Leo */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select5 =
                                                                !_model
                                                                    .select5);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Leo';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = true;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select5,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Virgo';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = true;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'xf2fwsfq' /* Virgo */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select6 =
                                                                !_model
                                                                    .select6);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Virgo';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = true;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select6,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Libra';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = true;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'h6rrwpf1' /* Libra */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select7 =
                                                                !_model
                                                                    .select7);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Libra';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = true;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select7,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Scorpio';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = true;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'rfiwve60' /* Scorpio */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select8 =
                                                                !_model
                                                                    .select8);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Scorpio';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = true;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select8,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue =
                                                  'Sagittarius';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = true;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'za5d3mip' /* Sagittarius */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select9 =
                                                                !_model
                                                                    .select9);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Sagittarius';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = true;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select9,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Capricorn';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = true;
                                              _model.select11 = false;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'zk5x3vt3' /* Capricorn */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select10 =
                                                                !_model
                                                                    .select10);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Capricorn';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = true;
                                                        _model.select11 = false;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select10,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Aquarius';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = true;
                                              _model.select12 = false;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'l2gr414e' /* Aquarius */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select11 =
                                                                !_model
                                                                    .select11);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Aquarius';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = true;
                                                        _model.select12 = false;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select11,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 5.0, 15.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Container_update_page_state');
                                              _model.selectValue = 'Pisces';
                                              _model.select1 = false;
                                              _model.select2 = false;
                                              _model.select3 = false;
                                              _model.select4 = false;
                                              _model.select5 = false;
                                              _model.select6 = false;
                                              _model.select7 = false;
                                              _model.select8 = false;
                                              _model.select9 = false;
                                              _model.select10 = false;
                                              _model.select11 = false;
                                              _model.select12 = true;
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(46.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'f5zl3hz1' /* Pisces */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                15.0, 0.0),
                                                    child: ToggleIcon(
                                                      onPressed: () async {
                                                        safeSetState(() =>
                                                            _model.select12 =
                                                                !_model
                                                                    .select12);
                                                        logFirebaseEvent(
                                                            'ToggleIcon_update_page_state');
                                                        _model.selectValue =
                                                            'Pisces';
                                                        _model.select1 = false;
                                                        _model.select2 = false;
                                                        _model.select3 = false;
                                                        _model.select4 = false;
                                                        _model.select5 = false;
                                                        _model.select6 = false;
                                                        _model.select7 = false;
                                                        _model.select8 = false;
                                                        _model.select9 = false;
                                                        _model.select10 = false;
                                                        _model.select11 = false;
                                                        _model.select12 = true;
                                                        safeSetState(() {});
                                                      },
                                                      value: _model.select12,
                                                      onIcon: Icon(
                                                        Icons
                                                            .check_circle_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 25.0,
                                                      ),
                                                      offIcon: Icon(
                                                        Icons.radio_button_off,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.uid == null || widget.uid == '')
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  logFirebaseEvent('Text_navigate_to');

                                  context.pushNamed(
                                    HeightWidget.routeName,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.topToBottom,
                                      ),
                                    },
                                  );
                                },
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'd9abvi95' /* Skip */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
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
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      await UsersTable().update(
                                        data: {
                                          'zodiac': _model.selectValue,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'user_id',
                                          widget.uid,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_back');
                                      context.safePop();
                                    } else {
                                      logFirebaseEvent(
                                          'IconButton_backend_call');
                                      await UsersTable().update(
                                        data: {
                                          'zodiac': _model.selectValue,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'user_id',
                                          currentUserUid,
                                        ),
                                      );
                                      logFirebaseEvent(
                                          'IconButton_navigate_to');

                                      context.goNamed(
                                        HeightWidget.routeName,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.leftToRight,
                                          ),
                                        },
                                      );
                                    }
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
