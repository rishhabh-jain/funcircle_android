import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'send_notification_widget.dart' show SendNotificationWidget;
import 'package:flutter/material.dart';

class SendNotificationModel extends FlutterFlowModel<SendNotificationWidget> {
  ///  State fields for stateful widgets in this page.

  String currentPageLink = '';
  // State field(s) for Title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  // State field(s) for Text widget.
  FocusNode? textFocusNode;
  TextEditingController? textTextController;
  String? Function(BuildContext, String?)? textTextControllerValidator;
  // State field(s) for GroupID widget.
  FocusNode? groupIDFocusNode;
  TextEditingController? groupIDTextController;
  String? Function(BuildContext, String?)? groupIDTextControllerValidator;
  // State field(s) for GroupName widget.
  FocusNode? groupNameFocusNode;
  TextEditingController? groupNameTextController;
  String? Function(BuildContext, String?)? groupNameTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<UsersRecord>? firestorequery;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    textFocusNode?.dispose();
    textTextController?.dispose();

    groupIDFocusNode?.dispose();
    groupIDTextController?.dispose();

    groupNameFocusNode?.dispose();
    groupNameTextController?.dispose();
  }
}
