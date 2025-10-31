import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'homepagewebview_model.dart';
export 'homepagewebview_model.dart';

class HomepagewebviewWidget extends StatefulWidget {
  const HomepagewebviewWidget({
    super.key,
    String? url,
  }) : this.url = url ?? 'https://www.funcircleapp.com/play?headhide=true';

  /// webview url
  final String url;

  static String routeName = 'homepagewebview';
  static String routePath = '/homepagewebview';

  @override
  State<HomepagewebviewWidget> createState() => _HomepagewebviewWidgetState();
}

class _HomepagewebviewWidgetState extends State<HomepagewebviewWidget> {
  late HomepagewebviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepagewebviewModel());

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
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
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
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  size: 28.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/logos_(7).png',
                                    width: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            logFirebaseEvent('Container_navigate_to');

                            context.pushNamed(MyProfileWidget.routeName);
                          },
                          child: Container(
                            width: 52.0,
                            height: 52.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1B),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              FFIcons.kuser,
                              color: FlutterFlowTheme.of(context).tertiary,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FlutterFlowWebView(
                  content: widget.url,
                  bypass: false,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  verticalScroll: true,
                  horizontalScroll: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
