import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'navbarnew_model.dart';
export 'navbarnew_model.dart';

class NavbarnewWidget extends StatefulWidget {
  const NavbarnewWidget({
    super.key,
    int? number,
  }) : this.number = number ?? 0;

  final int number;

  @override
  State<NavbarnewWidget> createState() => _NavbarnewWidgetState();
}

class _NavbarnewWidgetState extends State<NavbarnewWidget> {
  late NavbarnewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarnewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondary,
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              color: Color(0x0F000000),
              offset: Offset(
                0.0,
                4.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 14.0, 5.0, 14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Column_update_component_state');
                    _model.number = 0;
                    safeSetState(() {});
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FFIcons.khouseSimple,
                        color: widget.number == 0
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 23.0,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '1hq3c6xy' /* Home */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                color: widget.number == 0
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Column_update_component_state');
                    _model.number = 1;
                    safeSetState(() {});
                    logFirebaseEvent('Column_navigate_to');

                    context.goNamed(VenuesWidget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FFIcons.kmapPin,
                        color: widget.number == 1
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 23.0,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            's3tvmbjo' /* Venues */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                color: widget.number == 1
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Column_update_component_state');
                    _model.number = 2;
                    safeSetState(() {});
                    logFirebaseEvent('Column_navigate_to');

                    context.goNamed(PlayWidget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FFIcons.kbadmintonPlayerSvgrepoCom,
                        color: widget.number == 2
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 23.0,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'tnff4dct' /* Games */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                color: widget.number == 2
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Column_update_component_state');
                    _model.number = 3;
                    safeSetState(() {});
                    logFirebaseEvent('Column_navigate_to');

                    context.pushNamed(MyProfileWidget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FFIcons.klist,
                        color: widget.number == 3
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 23.0,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'lf9fz21z' /* More */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                color: widget.number == 3
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                        ),
                      ),
                    ],
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
