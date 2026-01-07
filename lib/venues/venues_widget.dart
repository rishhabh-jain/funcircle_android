import '/components/navbarnew_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'venues_model.dart';
export 'venues_model.dart';

class VenuesWidget extends StatefulWidget {
  const VenuesWidget({super.key});

  static String routeName = 'Venues';
  static String routePath = '/venues';

  @override
  State<VenuesWidget> createState() => _VenuesWidgetState();
}

class _VenuesWidgetState extends State<VenuesWidget>
    with TickerProviderStateMixin {
  late VenuesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VenuesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (functions.isLocationZero(currentUserLocationValue) == true) {
        logFirebaseEvent('Venues_alert_dialog');
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
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        extendBody: true,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0.0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).tertiary,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                        unselectedLabelStyle: TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: EdgeInsets.all(12.0),
                        tabs: [
                          Tab(
                            text: FFLocalizations.of(context).getText(
                              'l3cdsf66' /* Badminton */,
                            ),
                          ),
                          Tab(
                            text: FFLocalizations.of(context).getText(
                              'nqj4n908' /* Pickleball */,
                            ),
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          KeepAliveWidgetWrapper(
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowWebView(
                                  content:
                                      'https://www.funcircleapp.com/venues?group_id=90&headhide=true&hidelocbtn=true&lat=${functions.getLatitude(currentUserLocationValue).toString()}&lng=${functions.getLongitude(currentUserLocationValue).toString()}',
                                  bypass: false,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.7,
                                  verticalScroll: false,
                                  horizontalScroll: false,
                                ),
                              ],
                            ),
                          ),
                          KeepAliveWidgetWrapper(
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowWebView(
                                  content:
                                      'https://www.funcircleapp.com/venues?group_id=104&headhide=true&hidelocbtn=true&lat=${functions.getLatitude(currentUserLocationValue).toString()}&lng=${functions.getLongitude(currentUserLocationValue).toString()}',
                                  bypass: false,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.7,
                                  verticalScroll: false,
                                  horizontalScroll: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ],
            ),
            // Floating navigation bar
            wrapWithModel(
              model: _model.navbarnewModel,
              updateCallback: () => safeSetState(() {}),
              child: NavbarnewWidget(
                number: 1,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
