import '/flutter_flow/flutter_flow_model.dart';
import 'referrals_screen_widget.dart' show ReferralsScreenWidget;
import 'package:flutter/material.dart';

class ReferralsScreenModel extends FlutterFlowModel<ReferralsScreenWidget> {
  bool isLoading = false;
  String? referralCode;
  int totalReferrals = 0;
  int pendingReferrals = 0;
  int completedReferrals = 0;
  double totalRewards = 0.0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
