import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'createtickets_widget.dart' show CreateticketsWidget;
import 'package:flutter/material.dart';

class CreateticketsModel extends FlutterFlowModel<CreateticketsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Backend Call - Delete Row(s)] action in Button widget.
  List<TicketsRow>? deleteticket;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Button widget.
  List<TicketsRow>? deleteticketCopy;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
