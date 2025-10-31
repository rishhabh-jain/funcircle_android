import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'dart:async';
import 'view_group_widget.dart' show ViewGroupWidget;
import 'package:flutter/material.dart';

class ViewGroupModel extends FlutterFlowModel<ViewGroupWidget> {
  ///  Local state fields for this page.

  bool groupJoined = false;

  String invitationstatus = 'invited';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (checkjoinedgroups)] action in viewGroup widget.
  ApiCallResponse? apiResultmw4;
  String currentPageLink = '';
  Completer<List<GroupsRow>>? requestCompleter;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  Stream<List<TicketsRow>>? containerSupabaseStream;
  // Stores action output result for [Backend Call - API (get tickets)] action in Container widget.
  ApiCallResponse? getticketsresult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
