import '/flutter_flow/flutter_flow_util.dart';
import 'single_venue_new_widget.dart' show SingleVenueNewWidget;
import 'package:flutter/material.dart';

class SingleVenueNewModel extends FlutterFlowModel<SingleVenueNewWidget> {
  ///  Local state fields for this page.

  int currentsportid = 90;

  bool showlevelcomponent = false;

  /// Image gallery state
  PageController? imagePageController;
  int currentImageIndex = 0;

  @override
  void initState(BuildContext context) {
    imagePageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    imagePageController?.dispose();
  }
}
