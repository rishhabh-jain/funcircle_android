import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'likedusers_widget.dart' show LikedusersWidget;
import 'package:flutter/material.dart';

class LikedusersModel extends FlutterFlowModel<LikedusersWidget> {
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
