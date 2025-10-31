import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'createvenue_widget.dart' show CreatevenueWidget;
import 'package:flutter/material.dart';

class CreatevenueModel extends FlutterFlowModel<CreatevenueWidget> {
  ///  Local state fields for this page.

  List<String> imagesupdates = [];
  void addToImagesupdates(String item) => imagesupdates.add(item);
  void removeFromImagesupdates(String item) => imagesupdates.remove(item);
  void removeAtIndexFromImagesupdates(int index) =>
      imagesupdates.removeAt(index);
  void insertAtIndexInImagesupdates(int index, String item) =>
      imagesupdates.insert(index, item);
  void updateImagesupdatesAtIndex(int index, Function(String) updateFn) =>
      imagesupdates[index] = updateFn(imagesupdates[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Venuename widget.
  FocusNode? venuenameFocusNode;
  TextEditingController? venuenameTextController;
  String? Function(BuildContext, String?)? venuenameTextControllerValidator;
  String? _venuenameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        's39nxkh1' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // State field(s) for Venuemapslink widget.
  FocusNode? venuemapslinkFocusNode;
  TextEditingController? venuemapslinkTextController;
  String? Function(BuildContext, String?)? venuemapslinkTextControllerValidator;
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // State field(s) for Venuedescription widget.
  FocusNode? venuedescriptionFocusNode;
  TextEditingController? venuedescriptionTextController;
  String? Function(BuildContext, String?)?
      venuedescriptionTextControllerValidator;
  String? _venuedescriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'rrnprnvu' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  bool isDataUploading_venueImages = false;
  List<FFUploadedFile> uploadedLocalFiles_venueImages = [];
  List<String> uploadedFileUrls_venueImages = [];

  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  VenuesRow? venueoutput;

  @override
  void initState(BuildContext context) {
    venuenameTextControllerValidator = _venuenameTextControllerValidator;
    venuedescriptionTextControllerValidator =
        _venuedescriptionTextControllerValidator;
  }

  @override
  void dispose() {
    venuenameFocusNode?.dispose();
    venuenameTextController?.dispose();

    venuemapslinkFocusNode?.dispose();
    venuemapslinkTextController?.dispose();

    venuedescriptionFocusNode?.dispose();
    venuedescriptionTextController?.dispose();
  }
}
