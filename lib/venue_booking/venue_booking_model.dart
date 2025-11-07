import '/flutter_flow/flutter_flow_util.dart';
import 'venue_booking_widget.dart' show VenueBookingWidget;
import 'package:flutter/material.dart';

class VenueBookingModel extends FlutterFlowModel<VenueBookingWidget> {
  ///  Local state fields for this page.

  // Selected sport filter
  int? selectedSportId;

  // Search text
  String searchQuery = '';

  // Selected date for booking
  DateTime? selectedDate;

  // Selected venue
  int? selectedVenueId;

  // Text controller for search
  TextEditingController? searchController;

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

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController?.dispose();
  }
}
