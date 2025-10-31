import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'ticketwebview_model.dart';
export 'ticketwebview_model.dart';

class TicketwebviewWidget extends StatefulWidget {
  const TicketwebviewWidget({super.key});

  static String routeName = 'ticketwebview';
  static String routePath = '/ticketwebview';

  @override
  State<TicketwebviewWidget> createState() => _TicketwebviewWidgetState();
}

class _TicketwebviewWidgetState extends State<TicketwebviewWidget> {
  late TicketwebviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketwebviewModel());

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
      ),
    );
  }
}
