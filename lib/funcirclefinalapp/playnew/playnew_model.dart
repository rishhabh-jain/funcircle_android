import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'playnew_widget.dart' show PlaynewWidget;
import 'package:flutter/material.dart';

class PlaynewModel extends FlutterFlowModel<PlaynewWidget> {
  ///  Local state fields for this page.

  int currentsportid = 90;

  String currentAmOrPm = 'pm';

  int? currentVenueId;

  String? currentDate;

  bool showAllVenues = false;

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

  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
