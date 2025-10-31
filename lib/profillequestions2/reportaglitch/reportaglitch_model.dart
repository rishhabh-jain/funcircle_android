import '/flutter_flow/flutter_flow_util.dart';
import 'reportaglitch_widget.dart' show ReportaglitchWidget;
import 'package:flutter/material.dart';

class ReportaglitchModel extends FlutterFlowModel<ReportaglitchWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_glitchimages = false;
  List<FFUploadedFile> uploadedLocalFiles_glitchimages = [];
  List<String> uploadedFileUrls_glitchimages = [];

  // State field(s) for glitchtext widget.
  FocusNode? glitchtextFocusNode;
  TextEditingController? glitchtextTextController;
  String? Function(BuildContext, String?)? glitchtextTextControllerValidator;
  String? _glitchtextTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        's332x6px' /* Field is required */,
      );
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    glitchtextTextControllerValidator = _glitchtextTextControllerValidator;
  }

  @override
  void dispose() {
    glitchtextFocusNode?.dispose();
    glitchtextTextController?.dispose();
  }
}
