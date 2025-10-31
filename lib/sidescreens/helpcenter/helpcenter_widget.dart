import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'helpcenter_model.dart';
export 'helpcenter_model.dart';

class HelpcenterWidget extends StatefulWidget {
  const HelpcenterWidget({super.key});

  static String routeName = 'helpcenter';
  static String routePath = '/helpcenter';

  @override
  State<HelpcenterWidget> createState() => _HelpcenterWidgetState();
}

class _HelpcenterWidgetState extends State<HelpcenterWidget> {
  late HelpcenterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpcenterModel());

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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).secondary),
          automaticallyImplyLeading: true,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              logFirebaseEvent('Icon_navigate_back');
              context.safePop();
            },
            child: Icon(
              FFIcons.karrowLeft,
              color: FlutterFlowTheme.of(context).secondary,
              size: 24.0,
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 135.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          '3shrzu0a' /* Help Center */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ],
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('Container_navigate_to');

                        context.pushNamed(
                          WebviewWidget.routeName,
                          queryParameters: {
                            'url': serializeParam(
                              'https://www.funcircleapp.com/contactUs',
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        width: 388.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                Icons.support_agent_sharp,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'ppwt4l68' /* Contact us */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                FFIcons.kcaretRight,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent('IconButton_navigate_to');

                                context.pushNamed(
                                  WebviewWidget.routeName,
                                  queryParameters: {
                                    'url': serializeParam(
                                      'https://www.funcircleapp.com/contactUs',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('Container_navigate_to');

                        context.pushNamed(
                          WebviewWidget.routeName,
                          queryParameters: {
                            'url': serializeParam(
                              'https://www.funcircleapp.com/contactUs',
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        width: 388.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                FFIcons.kquestion,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'k0ajyr2l' /* FAQs */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                FFIcons.kcaretRight,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent('IconButton_navigate_to');

                                context.pushNamed(
                                  WebviewWidget.routeName,
                                  queryParameters: {
                                    'url': serializeParam(
                                      'https://www.funcircleapp.com/contactUs',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        logFirebaseEvent('Container_navigate_to');

                        context.pushNamed(
                          WebviewWidget.routeName,
                          queryParameters: {
                            'url': serializeParam(
                              'https://www.funcircleapp.com/about',
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        width: 388.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                FFIcons.kcheckCircle,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'ofriece7' /* Safety Tips */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                FFIcons.kcaretRight,
                                color: Color(0xFFA0ABBB),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent('IconButton_navigate_to');

                                context.pushNamed(
                                  WebviewWidget.routeName,
                                  queryParameters: {
                                    'url': serializeParam(
                                      'https://www.funcircleapp.com/about',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
            child: Text(
              FFLocalizations.of(context).getText(
                'i25b9pcv' /* Contact us Via */,
              ),
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).labelMediumIsCustom,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderRadius: 12.0,
                  borderWidth: 1.0,
                  buttonSize: 48.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: FaIcon(
                    FontAwesomeIcons.instagram,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    logFirebaseEvent('IconButton_launch_u_r_l');
                    await launchURL('https://instagram.com/funcircleapp');
                  },
                ),
                FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderRadius: 12.0,
                  borderWidth: 1.0,
                  buttonSize: 48.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    logFirebaseEvent('IconButton_launch_u_r_l');
                    await launchURL('https://wa.me/919561079271');
                  },
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
          ),
          Spacer(),
        ].addToEnd(SizedBox(height: 64.0)),
      ),
    );
  }
}
