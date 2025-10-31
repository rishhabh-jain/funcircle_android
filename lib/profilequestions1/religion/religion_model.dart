import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'religion_widget.dart' show ReligionWidget;
import 'package:flutter/material.dart';

class ReligionModel extends FlutterFlowModel<ReligionWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? lookingForOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
