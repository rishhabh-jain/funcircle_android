import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'requests_widget.dart' show RequestsWidget;
import 'package:flutter/material.dart';

class RequestsModel extends FlutterFlowModel<RequestsWidget> {
  ///  Local state fields for this page.

  List<int> requestidslist = [];
  void addToRequestidslist(int item) => requestidslist.add(item);
  void removeFromRequestidslist(int item) => requestidslist.remove(item);
  void removeAtIndexFromRequestidslist(int index) =>
      requestidslist.removeAt(index);
  void insertAtIndexInRequestidslist(int index, int item) =>
      requestidslist.insert(index, item);
  void updateRequestidslistAtIndex(int index, Function(int) updateFn) =>
      requestidslist[index] = updateFn(requestidslist[index]);

  bool updatepagestate = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getinterestedrequests)] action in Requests widget.
  ApiCallResponse? apiResultez3;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
