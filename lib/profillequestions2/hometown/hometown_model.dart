import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'hometown_widget.dart' show HometownWidget;
import 'package:flutter/material.dart';

class HometownModel extends FlutterFlowModel<HometownWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? outputHometown2;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? outputHometown;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
