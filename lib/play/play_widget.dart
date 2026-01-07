import '/components/navbarnew_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'play_model.dart';
export 'play_model.dart';

class PlayWidget extends StatefulWidget {
  const PlayWidget({super.key});

  static String routeName = 'Play';
  static String routePath = '/play';

  @override
  State<PlayWidget> createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  late PlayModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlayModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (functions.isLocationZero(currentUserLocationValue) == true) {
        logFirebaseEvent('Play_alert_dialog');
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return WebViewAware(
              child: AlertDialog(
                title: Text('Location not received'),
                content: Text(
                    'Your device location is either off or permission not granted, Fix that to view nearest venues and games.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
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
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: SpinKitRing(
              color: FlutterFlowTheme.of(context).primary,
              size: 50.0,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        extendBody: true,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
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
                      if (!((_model.url ==
                              'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}') ||
                          (_model.url ==
                              'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}')))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 8.0),
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
                                      if ((_model.url ==
                                              'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}') ||
                                          (_model.url ==
                                              'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}'))
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
                                      if ((_model.url !=
                                              'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}') ||
                                          (_model.url !=
                                              'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}'))
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
                                            'fbtt3xej' /* Games */,
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                      if ((_model.url ==
                              'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}') ||
                          (_model.url ==
                              'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}'))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent('Button_page_view');
                                  await _model.pageViewController
                                      ?.animateToPage(
                                    0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                text: FFLocalizations.of(context).getText(
                                  'i9hmbi25' /* Badminton */,
                                ),
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF247CE7),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent('Button_page_view');
                                  await _model.pageViewController
                                      ?.animateToPage(
                                    1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                text: FFLocalizations.of(context).getText(
                                  '2x2p6i0i' /* Pickleball */,
                                ),
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF247CE7),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ]
                                .divide(SizedBox(width: 12.0))
                                .addToStart(SizedBox(width: 18.0)),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _model.pageViewController ??=
                        PageController(initialPage: 0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            child: custom_widgets.WebViewWithUrlTracking(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              initialUrl:
                                  'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(currentUserLocationValue).toString()}&lng=${functions.getLongitude(currentUserLocationValue).toString()}',
                              triggerBack: _model.webviewGoBack,
                              triggerForward: true,
                              triggerRefresh: true,
                              onUrlChanged: (url) async {
                                logFirebaseEvent(
                                    'WebViewWithUrlTracking_update_page_state');
                                _model.url = url;
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            child: custom_widgets.WebViewWithUrlTracking(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              initialUrl:
                                  'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(currentUserLocationValue).toString()}&lng=${functions.getLongitude(currentUserLocationValue).toString()}',
                              triggerBack: _model.webviewGoBack,
                              triggerForward: true,
                              triggerRefresh: true,
                              onUrlChanged: (url) async {
                                logFirebaseEvent(
                                    'WebViewWithUrlTracking_update_page_state');
                                _model.url = url;
                                safeSetState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              ),
              // Floating navigation bar
              if ((_model.url ==
                      'https://www.funcircleapp.com/events/90?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}') ||
                  (_model.url ==
                      'https://www.funcircleapp.com/events/104?headhide=true&lat=${functions.getLatitude(FFAppState().userLocation).toString()}&lng=${functions.getLongitude(FFAppState().userLocation).toString()}'))
                wrapWithModel(
                  model: _model.navbarnewModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarnewWidget(
                    number: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
