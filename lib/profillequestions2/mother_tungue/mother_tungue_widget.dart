import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'mother_tungue_model.dart';
export 'mother_tungue_model.dart';

class MotherTungueWidget extends StatefulWidget {
  const MotherTungueWidget({
    super.key,
    this.uid,
  });

  final String? uid;

  static String routeName = 'MotherTungue';
  static String routePath = '/motherrungue';

  @override
  State<MotherTungueWidget> createState() => _MotherTungueWidgetState();
}

class _MotherTungueWidgetState extends State<MotherTungueWidget> {
  late MotherTungueModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MotherTungueModel());

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
              children: [
                if (widget.uid == null || widget.uid == '')
                  LinearPercentIndicator(
                    percent: 0.36,
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    lineHeight: 12.0,
                    animation: false,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    padding: EdgeInsets.zero,
                  ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 565.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Icon(
                                  FFIcons.kbird,
                                  color: Color(0xFFF902FF),
                                  size: 30.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 40.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'ilug6fi8' /* Your mother tungue */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: FlutterFlowChoiceChips(
                                options: [
                                  ChipData(FFLocalizations.of(context).getText(
                                    '4c80mpji' /* Hindi */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'kzwvuwuc' /* English */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'u9e1vvxx' /* Marathi */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'vbvryjc4' /* Telegu */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '49e6tdes' /* Tamil */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'rpafsah4' /* Bengali */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'pjptb199' /* Gujrati */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '93ibrmmm' /* Malyalam */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '3u4oetsm' /* Urdu */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'jnyixfeb' /* Oriya */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'dyxu0pbl' /* Other */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'luuscf5k' /* Kannada */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'ddpi9hxe' /* Punjabi */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'ao9juuas' /* Assamese */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'gxxtsonu' /* Maithili */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'fwyl23pk' /* Konkani */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '2vc5vvgi' /* Sindhi */,
                                  ))
                                ],
                                onChanged: (val) => safeSetState(
                                    () => _model.choiceChipsValues = val),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor: Colors.white,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFFF902FF),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor: Color(0xFFF902FF),
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderColor: Color(0xFFF902FF),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF323A46),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  iconColor: Color(0xFF323A46),
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderColor: Color(0xFFE7EAEE),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                chipSpacing: 10.0,
                                rowSpacing: 15.0,
                                multiselect: true,
                                initialized: _model.choiceChipsValues != null,
                                alignment: WrapAlignment.center,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [],
                                ),
                                wrapped: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                  child: Container(
                    width: 335.0,
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
                                  ZodiacWidget.routeName,
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
                                  'szcrea84' /* Skip */,
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
                          if (widget.uid != null && widget.uid != '')
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  if (widget.uid != null &&
                                      widget.uid != '') {
                                    logFirebaseEvent('IconButton_backend_call');
                                    await UsersTable().update(
                                      data: {
                                        'mother_tongue':
                                            _model.choiceChipsValues,
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
                                    logFirebaseEvent('IconButton_backend_call');
                                    await UsersTable().update(
                                      data: {
                                        'mother_tongue':
                                            _model.choiceChipsValues,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                    );
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.goNamed(
                                      ZodiacWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
