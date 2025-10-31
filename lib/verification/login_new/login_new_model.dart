import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_new_widget.dart' show LoginNewWidget;
import 'package:flutter/material.dart';

class LoginNewModel extends FlutterFlowModel<LoginNewWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for UserNumber widget.
  FocusNode? userNumberFocusNode;
  TextEditingController? userNumberTextController;
  String? Function(BuildContext, String?)? userNumberTextControllerValidator;
  String? _userNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'uvuufyiu' /* Mobile Number is required */,
      );
    }

    if (val.length < 10) {
      return FFLocalizations.of(context).getText(
        '3z7v73w6' /* Enter complete mobile number */,
      );
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    userNumberTextControllerValidator = _userNumberTextControllerValidator;
  }

  @override
  void dispose() {
    userNumberFocusNode?.dispose();
    userNumberTextController?.dispose();
  }
}
