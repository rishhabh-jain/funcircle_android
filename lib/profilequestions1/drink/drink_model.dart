import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'drink_widget.dart' show DrinkWidget;
import 'package:flutter/material.dart';

class DrinkModel extends FlutterFlowModel<DrinkWidget> {
  ///  Local state fields for this page.

  String? selectValue;

  bool select1 = false;

  bool select2 = false;

  bool select3 = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? drinkOutput2;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? drinkOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
