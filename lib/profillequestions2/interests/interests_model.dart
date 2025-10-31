import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'interests_widget.dart' show InterestsWidget;
import 'package:flutter/material.dart';

class InterestsModel extends FlutterFlowModel<InterestsWidget> {
  ///  Local state fields for this page.

  List<String> interests = [];
  void addToInterests(String item) => interests.add(item);
  void removeFromInterests(String item) => interests.remove(item);
  void removeAtIndexFromInterests(int index) => interests.removeAt(index);
  void insertAtIndexInInterests(int index, String item) =>
      interests.insert(index, item);
  void updateInterestsAtIndex(int index, Function(String) updateFn) =>
      interests[index] = updateFn(interests[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for selfcare widget.
  FormFieldController<List<String>>? selfcareValueController;
  String? get selfcareValue => selfcareValueController?.value?.firstOrNull;
  set selfcareValue(String? val) =>
      selfcareValueController?.value = val != null ? [val] : [];
  // State field(s) for sports widget.
  FormFieldController<List<String>>? sportsValueController;
  String? get sportsValue => sportsValueController?.value?.firstOrNull;
  set sportsValue(String? val) =>
      sportsValueController?.value = val != null ? [val] : [];
  // State field(s) for music widget.
  FormFieldController<List<String>>? musicValueController;
  String? get musicValue => musicValueController?.value?.firstOrNull;
  set musicValue(String? val) =>
      musicValueController?.value = val != null ? [val] : [];
  // State field(s) for art widget.
  FormFieldController<List<String>>? artValueController;
  String? get artValue => artValueController?.value?.firstOrNull;
  set artValue(String? val) =>
      artValueController?.value = val != null ? [val] : [];
  // State field(s) for pets widget.
  FormFieldController<List<String>>? petsValueController;
  String? get petsValue => petsValueController?.value?.firstOrNull;
  set petsValue(String? val) =>
      petsValueController?.value = val != null ? [val] : [];
  // State field(s) for outdoor widget.
  FormFieldController<List<String>>? outdoorValueController;
  String? get outdoorValue => outdoorValueController?.value?.firstOrNull;
  set outdoorValue(String? val) =>
      outdoorValueController?.value = val != null ? [val] : [];
  // State field(s) for sprituality widget.
  FormFieldController<List<String>>? spritualityValueController;
  String? get spritualityValue =>
      spritualityValueController?.value?.firstOrNull;
  set spritualityValue(String? val) =>
      spritualityValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
