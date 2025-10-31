import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'search_profile_widget.dart' show SearchProfileWidget;
import 'package:flutter/material.dart';

class SearchProfileModel extends FlutterFlowModel<SearchProfileWidget> {
  ///  Local state fields for this page.

  double? age;

  double? height;

  List<String> languages = [];
  void addToLanguages(String item) => languages.add(item);
  void removeFromLanguages(String item) => languages.remove(item);
  void removeAtIndexFromLanguages(int index) => languages.removeAt(index);
  void insertAtIndexInLanguages(int index, String item) =>
      languages.insert(index, item);
  void updateLanguagesAtIndex(int index, Function(String) updateFn) =>
      languages[index] = updateFn(languages[index]);

  String? religion;

  String? exercise;

  String? drink;

  String? smoke;

  String? lookingfor;

  String? political;

  String? zodiac;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Slider widget.
  double? sliderValue1;
  // State field(s) for Slider widget.
  double? sliderValue2;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  List<String>? get choiceChipsValues1 => choiceChipsValueController1?.value;
  set choiceChipsValues1(List<String>? val) =>
      choiceChipsValueController1?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];
  // State field(s) for exerciseradio widget.
  FormFieldController<String>? exerciseradioValueController;
  // State field(s) for drinkradio widget.
  FormFieldController<String>? drinkradioValueController;
  // State field(s) for smokeradio widget.
  FormFieldController<String>? smokeradioValueController;
  // State field(s) for lookforradio widget.
  FormFieldController<String>? lookforradioValueController;
  // State field(s) for polradio widget.
  FormFieldController<String>? polradioValueController;
  // State field(s) for zodiacradio widget.
  FormFieldController<String>? zodiacradioValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  String? get exerciseradioValue => exerciseradioValueController?.value;
  String? get drinkradioValue => drinkradioValueController?.value;
  String? get smokeradioValue => smokeradioValueController?.value;
  String? get lookforradioValue => lookforradioValueController?.value;
  String? get polradioValue => polradioValueController?.value;
  String? get zodiacradioValue => zodiacradioValueController?.value;
}
