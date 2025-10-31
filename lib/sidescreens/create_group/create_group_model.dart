import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'create_group_widget.dart' show CreateGroupWidget;
import 'package:flutter/material.dart';

class CreateGroupModel extends FlutterFlowModel<CreateGroupWidget> {
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
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'is8uod3h' /* Field is required */,
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
        '77r8m0t4' /* Field is required */,
      );
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  DateTime? datePicked1;
  DateTime? datePicked2;
  bool isDataUploading_firebaseImages3 = false;
  List<FFUploadedFile> uploadedLocalFiles_firebaseImages3 = [];
  List<String> uploadedFileUrls_firebaseImages3 = [];

  // State field(s) for selfcare widget.
  FormFieldController<List<String>>? selfcareValueController;
  List<String>? get selfcareValues => selfcareValueController?.value;
  set selfcareValues(List<String>? val) => selfcareValueController?.value = val;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  GroupsRow? groupoutput2;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  GroupsRow? groupoutput;

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
