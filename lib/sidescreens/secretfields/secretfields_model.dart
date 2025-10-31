import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'secretfields_widget.dart' show SecretfieldsWidget;
import 'package:flutter/material.dart';

class SecretfieldsModel extends FlutterFlowModel<SecretfieldsWidget> {
  ///  Local state fields for this page.

  List<String> secrets = ['anser1', ' answer2', ' answer3'];
  void addToSecrets(String item) => secrets.add(item);
  void removeFromSecrets(String item) => secrets.remove(item);
  void removeAtIndexFromSecrets(int index) => secrets.removeAt(index);
  void insertAtIndexInSecrets(int index, String item) =>
      secrets.insert(index, item);
  void updateSecretsAtIndex(int index, Function(String) updateFn) =>
      secrets[index] = updateFn(secrets[index]);

  int questionnumber = 0;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (get secret fields of user)] action in secretfields widget.
  ApiCallResponse? apiResultnc6;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'k9q566c0' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

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
