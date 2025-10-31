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
import 'religion_model.dart';
export 'religion_model.dart';

class ReligionWidget extends StatefulWidget {
  const ReligionWidget({super.key});

  static String routeName = 'Religion';
  static String routePath = '/religion';

  @override
  State<ReligionWidget> createState() => _ReligionWidgetState();
}

class _ReligionWidgetState extends State<ReligionWidget> {
  late ReligionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReligionModel());

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
                LinearPercentIndicator(
                  percent: 0.86,
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  lineHeight: 12.0,
                  animation: false,
                  animateFromLastPercent: true,
                  progressColor: FlutterFlowTheme.of(context).primary,
                  backgroundColor: Color(0xFFDADADA),
                  center: Text(
                    FFLocalizations.of(context).getText(
                      '07yxh01r' /* 86% */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
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
                                  FFIcons.khandsClapping,
                                  color: Color(0xFFF902FF),
                                  size: 30.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 40.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'cfp1uttq' /* Your faith */,
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
                                    'ugo920mm' /* Hindu */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'v3dumpnx' /* Spiritual */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'rsgmj9ti' /* Muslim */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'hoc5l86q' /* Christian */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'j7qa1fxn' /* Atheist */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    '2qzek6ey' /* Agnostic */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'wg0ft2mp' /* Buddhist */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'vki2k5b7' /* Jewish */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'rza5plt9' /* Parsi */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'rqf5sio4' /* Sikh */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'fjhg5u8g' /* Jain */,
                                  )),
                                  ChipData(FFLocalizations.of(context).getText(
                                    'lzjsqfuu' /* Other */,
                                  ))
                                ],
                                onChanged: (val) => safeSetState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull),
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
                                multiselect: false,
                                initialized: _model.choiceChipsValue != null,
                                alignment: WrapAlignment.center,
                                controller:
                                    _model.choiceChipsValueController ??=
                                        FormFieldController<List<String>>(
                                  [
                                    FFLocalizations.of(context).getText(
                                      'cwapsvho' /* Hindu */,
                                    )
                                  ],
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                  logFirebaseEvent('IconButton_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'faith': _model.choiceChipsValue,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  );
                                  logFirebaseEvent('IconButton_backend_call');
                                  await UserprofilecompletionstatusTable()
                                      .update(
                                    data: {
                                      'religion_completed': true,
                                      'current_step': 7,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  );
                                  logFirebaseEvent('IconButton_navigate_to');

                                  context.goNamed(
                                    WorkandeducationWidget.routeName,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.leftToRight,
                                      ),
                                    },
                                  );

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
