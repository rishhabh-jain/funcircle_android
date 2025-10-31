import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'prompts_model.dart';
export 'prompts_model.dart';

class PromptsWidget extends StatefulWidget {
  const PromptsWidget({
    super.key,
    bool? fromeditprofile,
  }) : this.fromeditprofile = fromeditprofile ?? false;

  final bool fromeditprofile;

  static String routeName = 'Prompts';
  static String routePath = '/prompts';

  @override
  State<PromptsWidget> createState() => _PromptsWidgetState();
}

class _PromptsWidgetState extends State<PromptsWidget> {
  late PromptsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PromptsModel());

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
        backgroundColor: FlutterFlowTheme.of(context).tertiary,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.fromeditprofile == false)
                  LinearPercentIndicator(
                    percent: 0.75,
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    lineHeight: 12.0,
                    animation: false,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    padding: EdgeInsets.zero,
                  ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      '3paysxzr' /* Add Prompts */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF323A46),
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 15.0, 10.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'ce5us1zb' /* Help potential matched underst... */,
                    ),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF64748B),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 520.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: FutureBuilder<List<PromptsRow>>(
                      future: PromptsTable().queryRows(
                        queryFn: (q) => q,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitRing(
                                color: FlutterFlowTheme.of(context).primary,
                                size: 50.0,
                              ),
                            ),
                          );
                        }
                        List<PromptsRow> listViewPromptsRowList =
                            snapshot.data!;

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewPromptsRowList.length,
                          itemBuilder: (context, listViewIndex) {
                            final listViewPromptsRow =
                                listViewPromptsRowList[listViewIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 10.0),
                              child: FutureBuilder<List<UserpromptsRow>>(
                                future: UserpromptsTable().querySingleRow(
                                  queryFn: (q) => q
                                      .eqOrNull(
                                        'user_id',
                                        valueOrDefault<String>(
                                          currentUserUid,
                                          'JiK4SkNUWsT3S1kgYUETPbOFsuH3',
                                        ),
                                      )
                                      .eqOrNull(
                                        'prompt_id',
                                        listViewPromptsRow.promptId,
                                      ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: SpinKitRing(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 50.0,
                                        ),
                                      ),
                                    );
                                  }
                                  List<UserpromptsRow>
                                      listTileUserpromptsRowList =
                                      snapshot.data!;

                                  final listTileUserpromptsRow =
                                      listTileUserpromptsRowList.isNotEmpty
                                          ? listTileUserpromptsRowList.first
                                          : null;

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (listTileUserpromptsRow?.answerText !=
                                              null &&
                                          listTileUserpromptsRow?.answerText !=
                                              '') {
                                        logFirebaseEvent(
                                            'ListTile_navigate_to');

                                        context.pushNamed(
                                          AnswerpromptWidget.routeName,
                                          queryParameters: {
                                            'promptid': serializeParam(
                                              listViewPromptsRow.promptId,
                                              ParamType.int,
                                            ),
                                            'questionText': serializeParam(
                                              listViewPromptsRow.questionText,
                                              ParamType.String,
                                            ),
                                            'questionisset': serializeParam(
                                              true,
                                              ParamType.bool,
                                            ),
                                            'fromeditProfile': serializeParam(
                                              false,
                                              ParamType.bool,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                            ),
                                          },
                                        );
                                      } else {
                                        logFirebaseEvent(
                                            'ListTile_navigate_to');

                                        context.pushNamed(
                                          AnswerpromptWidget.routeName,
                                          queryParameters: {
                                            'promptid': serializeParam(
                                              listViewPromptsRow.promptId,
                                              ParamType.int,
                                            ),
                                            'questionText': serializeParam(
                                              listViewPromptsRow.questionText,
                                              ParamType.String,
                                            ),
                                            'questionisset': serializeParam(
                                              false,
                                              ParamType.bool,
                                            ),
                                            'fromeditProfile': serializeParam(
                                              false,
                                              ParamType.bool,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                            ),
                                          },
                                        );
                                      }
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        title: Text(
                                          listViewPromptsRow.questionText!,
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLargeFamily,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleLargeIsCustom,
                                              ),
                                        ),
                                        subtitle: Text(
                                          valueOrDefault<String>(
                                            listTileUserpromptsRow?.answerText,
                                            'Add ',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 20.0,
                                        ),
                                        tileColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        dense: false,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                15.0, 5.0, 15.0, 5.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
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
                          if (widget.fromeditprofile == false)
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent('Text_navigate_to');

                                context.pushNamed(
                                  PoliticalLeaningsWidget.routeName,
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
                                  'oo9rjejm' /* Skip */,
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
                          if (widget.fromeditprofile == true)
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
                                  fillColor: Color(0x82DADADA),
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
                          if (widget.fromeditprofile == false)
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
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.pushNamed(
                                      PoliticalLeaningsWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
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
