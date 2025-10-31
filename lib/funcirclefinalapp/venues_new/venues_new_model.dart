import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'venues_new_widget.dart' show VenuesNewWidget;
import 'package:flutter/material.dart';

class VenuesNewModel extends FlutterFlowModel<VenuesNewWidget> {
  ///  Local state fields for this page.

  String searchquery = '';

  int currentsportid = 90;

  List<VenuesRow> venuesdata = [];
  void addToVenuesdata(VenuesRow item) => venuesdata.add(item);
  void removeFromVenuesdata(VenuesRow item) => venuesdata.remove(item);
  void removeAtIndexFromVenuesdata(int index) => venuesdata.removeAt(index);
  void insertAtIndexInVenuesdata(int index, VenuesRow item) =>
      venuesdata.insert(index, item);
  void updateVenuesdataAtIndex(int index, Function(VenuesRow) updateFn) =>
      venuesdata[index] = updateFn(venuesdata[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in VenuesNew widget.
  List<VenuesRow>? venuesoutput;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<String> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
