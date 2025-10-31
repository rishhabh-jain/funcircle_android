import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'social_widget.dart' show SocialWidget;
import 'package:flutter/material.dart';

class SocialModel extends FlutterFlowModel<SocialWidget> {
  ///  Local state fields for this page.

  String? searchQuery = '';

  String location = '';

  List<String> colors = [];
  void addToColors(String item) => colors.add(item);
  void removeFromColors(String item) => colors.remove(item);
  void removeAtIndexFromColors(int index) => colors.removeAt(index);
  void insertAtIndexInColors(int index, String item) =>
      colors.insert(index, item);
  void updateColorsAtIndex(int index, Function(String) updateFn) =>
      colors[index] = updateFn(colors[index]);

  bool locationremove = false;

  bool onlyexclusive = false;

  /// event, sports, adventure, social
  int currentpage = 1;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Searchbar widget.
  FocusNode? searchbarFocusNode;
  TextEditingController? searchbarTextController;
  String? Function(BuildContext, String?)? searchbarTextControllerValidator;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for premiumcheck widget.
  bool? premiumcheckValue;
  // State field(s) for shownear widget.
  bool? shownearValue;
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
  void dispose() {
    searchbarFocusNode?.dispose();
    searchbarTextController?.dispose();
  }
}
