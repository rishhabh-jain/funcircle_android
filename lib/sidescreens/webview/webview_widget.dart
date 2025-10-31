import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'webview_model.dart';
export 'webview_model.dart';

class WebviewWidget extends StatefulWidget {
  const WebviewWidget({
    super.key,
    required this.url,
  });

  final String? url;

  static String routeName = 'webview';
  static String routePath = '/webview';

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  late WebviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebviewModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
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
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      size: 28.0,
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
              FlutterFlowWebView(
                content: widget.url!,
                bypass: false,
                height: MediaQuery.sizeOf(context).height * 0.8,
                verticalScroll: true,
                horizontalScroll: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
