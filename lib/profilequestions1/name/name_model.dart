import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'name_widget.dart' show NameWidget;
import 'package:flutter/material.dart';

class NameModel extends FlutterFlowModel<NameWidget> {
  ///  Local state fields for this page.

  String? genderValue;

  bool maleState = false;

  bool femaleState = false;

  String location = 'location';

  bool showplacepicker = false;

  bool showlocationbutton = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (geocodingreverse)] action in Name widget.
  ApiCallResponse? geocodingreverse34;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'a8wvzyll' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  DateTime? datePicked;
  // Stores action output result for [Backend Call - API (geocodingreverse)] action in Button widget.
  ApiCallResponse? geocodingreverse4Copy;
  // Stores action output result for [Backend Call - API (geocodingreverse)] action in Button widget.
  ApiCallResponse? geocodingreverse3Copy;
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'hgfp6vl8' /* Field is required */,
      );
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    emailTextControllerValidator = _emailTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
