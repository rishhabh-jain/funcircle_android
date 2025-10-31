import '/flutter_flow/flutter_flow_util.dart';
import 'game_requests_widget.dart' show GameRequestsWidget;
import 'package:flutter/material.dart';
import '../../models/game_request.dart';

class GameRequestsModel extends FlutterFlowModel<GameRequestsWidget> {
  ///  Local state fields for this page.

  List<GameRequest> receivedRequests = [];
  List<GameRequest> sentRequests = [];
  bool isLoadingReceived = true;
  bool isLoadingSent = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
