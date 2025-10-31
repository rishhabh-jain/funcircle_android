import '/flutter_flow/flutter_flow_util.dart';
import 'contact_support_widget.dart' show ContactSupportWidget;
import 'package:flutter/material.dart';

class ContactSupportModel extends FlutterFlowModel<ContactSupportWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // State field(s) for subject TextField.
  FocusNode? subjectFocusNode;
  TextEditingController? subjectController;
  String? Function(BuildContext, String?)? subjectControllerValidator;

  // State field(s) for description TextField.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionController;
  String? Function(BuildContext, String?)? descriptionControllerValidator;

  String selectedCategory = 'help';
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {
    subjectController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    subjectFocusNode?.dispose();
    subjectController?.dispose();
    descriptionFocusNode?.dispose();
    descriptionController?.dispose();
  }
}
