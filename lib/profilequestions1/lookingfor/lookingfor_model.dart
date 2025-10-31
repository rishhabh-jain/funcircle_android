import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'lookingfor_widget.dart' show LookingforWidget;
import 'package:flutter/material.dart';

class LookingforModel extends FlutterFlowModel<LookingforWidget> {
  ///  Local state fields for this page.

  String? selectValue;

  bool select1 = false;

  bool select2 = false;

  bool select3 = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? lookingForOutput2;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? lookingForOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
