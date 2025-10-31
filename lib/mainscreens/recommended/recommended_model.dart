import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'recommended_widget.dart' show RecommendedWidget;
import 'package:flutter/material.dart';

class RecommendedModel extends FlutterFlowModel<RecommendedWidget> {
  ///  Local state fields for this page.

  String updatingstate = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (recommendationalgo)] action in Button widget.
  ApiCallResponse? recommendations;
  // Stores action output result for [Backend Call - API (recommendationalgo)] action in Button widget.
  ApiCallResponse? recommendationsCopy;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
