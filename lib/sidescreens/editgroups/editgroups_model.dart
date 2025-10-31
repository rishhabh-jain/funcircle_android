import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'editgroups_widget.dart' show EditgroupsWidget;
import 'package:flutter/material.dart';

class EditgroupsModel extends FlutterFlowModel<EditgroupsWidget> {
  ///  Local state fields for this page.

  List<String> imagesupdates = ['false'];
  void addToImagesupdates(String item) => imagesupdates.add(item);
  void removeFromImagesupdates(String item) => imagesupdates.remove(item);
  void removeAtIndexFromImagesupdates(int index) =>
      imagesupdates.removeAt(index);
  void insertAtIndexInImagesupdates(int index, String item) =>
      imagesupdates.insert(index, item);
  void updateImagesupdatesAtIndex(int index, Function(String) updateFn) =>
      imagesupdates[index] = updateFn(imagesupdates[index]);

  bool rebuildpagestate = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_groupimages = false;
  List<FFUploadedFile> uploadedLocalFiles_groupimages = [];
  List<String> uploadedFileUrls_groupimages = [];

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'ul0i0loz' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'j168rjq2' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<GroupsRow>? groupupdate;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
