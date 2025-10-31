import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'signup_new_widget.dart' show SignupNewWidget;
import 'package:flutter/material.dart';

class SignupNewModel extends FlutterFlowModel<SignupNewWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for UserName widget.
  FocusNode? userNameFocusNode;
  TextEditingController? userNameTextController;
  String? Function(BuildContext, String?)? userNameTextControllerValidator;
  String? _userNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '33ba2uw5' /* Name is required */,
      );
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }

    return null;
  }

  // State field(s) for UserEmail widget.
  FocusNode? userEmailFocusNode;
  TextEditingController? userEmailTextController;
  String? Function(BuildContext, String?)? userEmailTextControllerValidator;
  String? _userEmailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '7ketliqc' /* Email is required */,
      );
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for UserNumber widget.
  FocusNode? userNumberFocusNode;
  TextEditingController? userNumberTextController;
  String? Function(BuildContext, String?)? userNumberTextControllerValidator;
  String? _userNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'teouyvt3' /* Mobile Number is required */,
      );
    }

    if (val.length < 10) {
      return FFLocalizations.of(context).getText(
        '0jjp9y7r' /* Enter complete mobile number */,
      );
    }

    if (!RegExp('/^\\\\d{10}\$/').hasMatch(val)) {
      return FFLocalizations.of(context).getText(
        'hqaloq9a' /* Enter correct mobile number */,
      );
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    userNameTextControllerValidator = _userNameTextControllerValidator;
    userEmailTextControllerValidator = _userEmailTextControllerValidator;
    userNumberTextControllerValidator = _userNumberTextControllerValidator;
  }

  @override
  void dispose() {
    userNameFocusNode?.dispose();
    userNameTextController?.dispose();

    userEmailFocusNode?.dispose();
    userEmailTextController?.dispose();

    userNumberFocusNode?.dispose();
    userNumberTextController?.dispose();
  }
}
