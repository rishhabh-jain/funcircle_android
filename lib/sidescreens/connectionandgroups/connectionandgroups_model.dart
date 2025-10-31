import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'connectionandgroups_widget.dart' show ConnectionandgroupsWidget;
import 'package:flutter/material.dart';

class ConnectionandgroupsModel
    extends FlutterFlowModel<ConnectionandgroupsWidget> {
  ///  Local state fields for this page.

  String pagestate = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
