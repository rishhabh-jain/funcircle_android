import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'answerprompt_widget.dart' show AnswerpromptWidget;
import 'package:flutter/material.dart';

class AnswerpromptModel extends FlutterFlowModel<AnswerpromptWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '1zfwi6za' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UserpromptsRow>? promptAnswerOutput3;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UserpromptsRow>? promptAnswerOutput2;
  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  UserpromptsRow? promptAnswerOutput;

  @override
  void initState(BuildContext context) {
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
