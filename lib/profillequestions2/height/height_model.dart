import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'height_widget.dart' show HeightWidget;
import 'package:flutter/material.dart';

class HeightModel extends FlutterFlowModel<HeightWidget> {
  ///  Local state fields for this page.

  String pageHeight = '5\'4';

  ///  State fields for stateful widgets in this page.

  // State field(s) for Slider widget.
  double? sliderValue;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? height;
  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? heightOutputCopy;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
