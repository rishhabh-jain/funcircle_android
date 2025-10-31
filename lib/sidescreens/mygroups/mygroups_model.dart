import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mygroups_widget.dart' show MygroupsWidget;
import 'package:flutter/material.dart';

class MygroupsModel extends FlutterFlowModel<MygroupsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchgroup widget.
  FocusNode? searchgroupFocusNode;
  TextEditingController? searchgroupTextController;
  String? Function(BuildContext, String?)? searchgroupTextControllerValidator;
  List<String> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchgroupFocusNode?.dispose();
    searchgroupTextController?.dispose();
  }
}
