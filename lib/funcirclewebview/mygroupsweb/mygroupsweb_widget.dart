import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'mygroupsweb_model.dart';
export 'mygroupsweb_model.dart';

/// Homepage
///
class MygroupswebWidget extends StatefulWidget {
  const MygroupswebWidget({super.key});

  static String routeName = 'Mygroupsweb';
  static String routePath = '/mygroupsweb';

  @override
  State<MygroupswebWidget> createState() => _MygroupswebWidgetState();
}

class _MygroupswebWidgetState extends State<MygroupswebWidget> {
  late MygroupswebModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MygroupswebModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('Mygroupsweb_request_permissions');
      await requestPermission(locationPermission);
      if (await getPermissionStatus(locationPermission)) {
        if (currentUserDocument?.latlong != null) {
          logFirebaseEvent('Mygroupsweb_update_app_state');
          FFAppState().userLocation = currentUserDocument?.latlong;
          safeSetState(() {});
        } else {
          logFirebaseEvent('Mygroupsweb_update_app_state');
          FFAppState().userLocation = functions.getDefaultLatLng();
          safeSetState(() {});
        }
      } else {
        logFirebaseEvent('Mygroupsweb_update_app_state');
        FFAppState().userLocation = functions.getDefaultLatLng();
        safeSetState(() {});
      }
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
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (_model.url ==
                                        'https://www.funcircleapp.com/chat?headhide=true&lcnbtn=hide')
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'Icon_navigate_back');
                                          context.safePop();
                                        },
                                        child: Icon(
                                          FFIcons.karrowLeft,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          size: 28.0,
                                        ),
                                      ),
                                    if (_model.url !=
                                        'https://www.funcircleapp.com/chat?headhide=true&lcnbtn=hide')
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'Icon_update_page_state');
                                          _model.webviewGoBack =
                                              !_model.webviewGoBack;
                                          safeSetState(() {});
                                        },
                                        child: Icon(
                                          FFIcons.karrowLeft,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          size: 28.0,
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'cnq2z77d' /* My groups */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                custom_widgets.WebViewWithUrlTracking(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  initialUrl:
                      'https://funcircleapp.com/chat?headhide=true&lcnbtn=hide',
                  triggerBack: _model.webviewGoBack,
                  triggerForward: _model.webviewGoForward,
                  triggerRefresh: _model.webviewRefresh,
                  onUrlChanged: (url) async {
                    logFirebaseEvent(
                        'WebViewWithUrlTracking_update_page_state');
                    _model.url = url;
                    safeSetState(() {});
                    if (_model.url ==
                        'https://www.funcircleapp.com/events/90') {
                      logFirebaseEvent('WebViewWithUrlTracking_navigate_to');

                      context.pushNamed(PlayWidget.routeName);
                    }
                    if (_model.url == 'https://www.funcircleapp.com/venues') {
                      logFirebaseEvent('WebViewWithUrlTracking_navigate_to');

                      context.pushNamed(VenuesWidget.routeName);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
