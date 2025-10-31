import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'addtocartcontroller_model.dart';
export 'addtocartcontroller_model.dart';

class AddtocartcontrollerWidget extends StatefulWidget {
  const AddtocartcontrollerWidget({
    super.key,
    required this.ticketid,
    required this.ticketname,
    required this.ticketprice,
  });

  final int? ticketid;
  final String? ticketname;
  final String? ticketprice;

  @override
  State<AddtocartcontrollerWidget> createState() =>
      _AddtocartcontrollerWidgetState();
}

class _AddtocartcontrollerWidgetState extends State<AddtocartcontrollerWidget> {
  late AddtocartcontrollerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddtocartcontrollerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 120.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 0.0,
          ),
        ),
        child: FlutterFlowCountController(
          decrementIconBuilder: (enabled) => FaIcon(
            FontAwesomeIcons.minus,
            color: enabled
                ? FlutterFlowTheme.of(context).secondaryText
                : FlutterFlowTheme.of(context).alternate,
            size: 20.0,
          ),
          incrementIconBuilder: (enabled) => FaIcon(
            FontAwesomeIcons.plus,
            color: enabled
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            size: 20.0,
          ),
          countBuilder: (count) => Text(
            count.toString(),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleLargeIsCustom,
                ),
          ),
          count: _model.countControllerValue ??= 0,
          updateCount: (count) async {
            safeSetState(() => _model.countControllerValue = count);
            if (_model.countControllerValue! > 0) {
              logFirebaseEvent('CountController_update_app_state');
              FFAppState().addToTicketsaddtocart(TicketsaddtocartStruct(
                ticketid: widget.ticketid,
                quantity: _model.countControllerValue,
                ticketname: widget.ticketname,
                ticketprice: widget.ticketprice,
              ));
              safeSetState(() {});
            } else {
              logFirebaseEvent('CountController_update_app_state');
              FFAppState().removeFromTicketsaddtocart(TicketsaddtocartStruct(
                ticketid: widget.ticketid,
                quantity: 1,
              ));
              safeSetState(() {});
            }
          },
          stepSize: 1,
          minimum: 0,
          maximum: 10,
        ),
      ),
    );
  }
}
