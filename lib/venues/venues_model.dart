import '/components/navbarnew_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'venues_widget.dart' show VenuesWidget;
import 'package:flutter/material.dart';

class VenuesModel extends FlutterFlowModel<VenuesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for navbarnew component.
  late NavbarnewModel navbarnewModel;

  @override
  void initState(BuildContext context) {
    navbarnewModel = createModel(context, () => NavbarnewModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    navbarnewModel.dispose();
  }
}
