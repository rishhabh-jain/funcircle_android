import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'player_new_widget.dart' show PlayerNewWidget;
import 'package:flutter/material.dart';

class PlayerNewModel extends FlutterFlowModel<PlayerNewWidget> {
  ///  Local state fields for this page.

  bool editprofile = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for UserName widget.
  FocusNode? userNameFocusNode;
  TextEditingController? userNameTextController;
  String? Function(BuildContext, String?)? userNameTextControllerValidator;
  // State field(s) for UserEmail widget.
  FocusNode? userEmailFocusNode;
  TextEditingController? userEmailTextController;
  String? Function(BuildContext, String?)? userEmailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    userNameFocusNode?.dispose();
    userNameTextController?.dispose();

    userEmailFocusNode?.dispose();
    userEmailTextController?.dispose();
  }
}
