import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'createticketgroups_widget.dart' show CreateticketgroupsWidget;
import 'package:flutter/material.dart';

class CreateticketgroupsModel
    extends FlutterFlowModel<CreateticketgroupsWidget> {
  ///  Local state fields for this page.

  int? selectedVenueid;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'f7lqs1l8' /* Field is required */,
      );
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for Venueseelect widget.
  int? venueseelectValue;
  FormFieldController<int>? venueseelectValueController;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '78yl9kfm' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'v2kvl4sv' /* Field is required */,
      );
    }

    return null;
  }

  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  TicketsRow? rsvpoutput;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  TicketsRow? notrsvpoutput;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
