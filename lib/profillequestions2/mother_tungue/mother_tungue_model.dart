import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'mother_tungue_widget.dart' show MotherTungueWidget;
import 'package:flutter/material.dart';

class MotherTungueModel extends FlutterFlowModel<MotherTungueWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? motherTungueOutput;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? mother;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
