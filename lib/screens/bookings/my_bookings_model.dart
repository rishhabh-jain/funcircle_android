import '/flutter_flow/flutter_flow_util.dart';
import 'my_bookings_widget.dart' show MyBookingsWidget;
import 'package:flutter/material.dart';
import '../../models/booking.dart';

class MyBookingsModel extends FlutterFlowModel<MyBookingsWidget> {
  ///  Local state fields for this page.

  String currentFilter = 'all';
  List<Booking> bookings = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
