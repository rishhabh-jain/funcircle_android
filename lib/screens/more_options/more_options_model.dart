import '/flutter_flow/flutter_flow_util.dart';
import 'more_options_widget.dart' show MoreOptionsWidget;
import 'package:flutter/material.dart';
import '../../models/booking.dart';

class MoreOptionsModel extends FlutterFlowModel<MoreOptionsWidget> {
  ///  Local state fields for this page.

  UserQuickStats? userStats;
  int pendingRequestsCount = 0;
  bool isLoadingStats = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
