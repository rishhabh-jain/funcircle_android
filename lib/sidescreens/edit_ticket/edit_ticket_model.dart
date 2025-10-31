import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_ticket_widget.dart' show EditTicketWidget;
import 'package:flutter/material.dart';

class EditTicketModel extends FlutterFlowModel<EditTicketWidget> {
  ///  Local state fields for this page.

  List<SelectedusersStruct> selectedusers = [];
  void addToSelectedusers(SelectedusersStruct item) => selectedusers.add(item);
  void removeFromSelectedusers(SelectedusersStruct item) =>
      selectedusers.remove(item);
  void removeAtIndexFromSelectedusers(int index) =>
      selectedusers.removeAt(index);
  void insertAtIndexInSelectedusers(int index, SelectedusersStruct item) =>
      selectedusers.insert(index, item);
  void updateSelectedusersAtIndex(
          int index, Function(SelectedusersStruct) updateFn) =>
      selectedusers[index] = updateFn(selectedusers[index]);

  int initialindex = 0;

  List<String> imageupdates = [];
  void addToImageupdates(String item) => imageupdates.add(item);
  void removeFromImageupdates(String item) => imageupdates.remove(item);
  void removeAtIndexFromImageupdates(int index) => imageupdates.removeAt(index);
  void insertAtIndexInImageupdates(int index, String item) =>
      imageupdates.insert(index, item);
  void updateImageupdatesAtIndex(int index, Function(String) updateFn) =>
      imageupdates[index] = updateFn(imageupdates[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool isDataUploading_firebaseImages4 = false;
  List<FFUploadedFile> uploadedLocalFiles_firebaseImages4 = [];
  List<String> uploadedFileUrls_firebaseImages4 = [];

  // State field(s) for CheckboxListTile widget.
  Map<OrderitemsRow, bool> checkboxListTileValueMap = {};
  List<OrderitemsRow> get checkboxListTileCheckedItems =>
      checkboxListTileValueMap.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
