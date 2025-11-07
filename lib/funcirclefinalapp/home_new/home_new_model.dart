import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'home_new_widget.dart' show HomeNewWidget;
import 'package:flutter/material.dart';

class HomeNewModel extends FlutterFlowModel<HomeNewWidget> {
  ///  Local state fields for this page.

  int currentsportid = 90;
  int currentCarouselPage = 0;

  // Location state
  LatLng? userLocation;
  String? locationDisplayText;
  bool isLoadingLocation = false;

  // Venue distances map (venue ID -> distance in km)
  Map<int, double> venueDistances = {};

  // Venue durations map (venue ID -> duration in minutes)
  Map<int, int> venueDurations = {};

  bool isCalculatingDistances = false;

  // Track last calculated location to avoid duplicate calculations
  LatLng? lastCalculatedLocation;

  // Track calculation request ID to prevent race conditions
  int calculationRequestId = 0;

  // Notifications unread count
  int unreadNotificationsCount = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  // State field(s) for venue carousel PageController
  PageController? venueCarouselController;

  // State field(s) for location search TextField
  FocusNode? locationFieldFocusNode;
  TextEditingController? locationTextController;

  @override
  void initState(BuildContext context) {
    venueCarouselController = PageController(viewportFraction: 0.95);
    locationTextController = TextEditingController();
    locationFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    venueCarouselController?.dispose();
    locationFieldFocusNode?.dispose();
    locationTextController?.dispose();
  }
}
