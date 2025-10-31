import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'sales_model.dart';
export 'sales_model.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({
    super.key,
    required this.ticketid,
  });

  /// tickets associated with that group
  final List<int>? ticketid;

  static String routeName = 'Sales';
  static String routePath = '/sales';

  @override
  State<SalesWidget> createState() => _SalesWidgetState();
}

class _SalesWidgetState extends State<SalesWidget> {
  late SalesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalesModel());

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
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
