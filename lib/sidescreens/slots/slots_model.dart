import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'slots_widget.dart' show SlotsWidget;
import 'package:flutter/material.dart';

class SlotsModel extends FlutterFlowModel<SlotsWidget> {
  ///  Local state fields for this page.
  /// tickets supabase row
  List<TicketsRow> tickets = [];
  void addToTickets(TicketsRow item) => tickets.add(item);
  void removeFromTickets(TicketsRow item) => tickets.remove(item);
  void removeAtIndexFromTickets(int index) => tickets.removeAt(index);
  void insertAtIndexInTickets(int index, TicketsRow item) =>
      tickets.insert(index, item);
  void updateTicketsAtIndex(int index, Function(TicketsRow) updateFn) =>
      tickets[index] = updateFn(tickets[index]);

  /// will it be am or pm
  String? time;

  /// current date tickets
  List<dynamic> currenttickets = [];
  void addToCurrenttickets(dynamic item) => currenttickets.add(item);
  void removeFromCurrenttickets(dynamic item) => currenttickets.remove(item);
  void removeAtIndexFromCurrenttickets(int index) =>
      currenttickets.removeAt(index);
  void insertAtIndexInCurrenttickets(int index, dynamic item) =>
      currenttickets.insert(index, item);
  void updateCurrentticketsAtIndex(int index, Function(dynamic) updateFn) =>
      currenttickets[index] = updateFn(currenttickets[index]);

  /// 0,1,2,3
  int? currentindex;

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
