import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'others_profile_widget.dart' show OthersProfileWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OthersProfileModel extends FlutterFlowModel<OthersProfileWidget> {
  ///  Local state fields for this page.

  bool likedvalue = true;

  bool connectionvalue = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (checkConnection)] action in othersProfile widget.
  ApiCallResponse? apiResulte7u;
  // Stores action output result for [Backend Call - API (checkuserlikestatus)] action in othersProfile widget.
  ApiCallResponse? apiResultmzh;
  // Stores action output result for [Backend Call - API (checkuserlikestatus)] action in Button widget.
  ApiCallResponse? likecheck;
  // Stores action output result for [Backend Call - API (checkConnection)] action in Button widget.
  ApiCallResponse? connectioncall;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // Stores action output result for [Backend Call - API (checkuserlikestatus)] action in Button widget.
  ApiCallResponse? likecheck2;
  // Stores action output result for [Backend Call - API (checkConnection)] action in Button widget.
  ApiCallResponse? connectioncall2;
  String currentPageLink = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
