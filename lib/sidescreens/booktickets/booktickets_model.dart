import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'booktickets_widget.dart' show BookticketsWidget;
import 'package:flutter/material.dart';

class BookticketsModel extends FlutterFlowModel<BookticketsWidget> {
  ///  Local state fields for this page.

  String ticketusername = '';

  String ticketnumber = '';

  int? chosenticketidindex = 0;

  int? cartValue;

  bool isProcessingPayment = false;

  List<int> addedtocartticketIDs = [];
  void addToAddedtocartticketIDs(int item) => addedtocartticketIDs.add(item);
  void removeFromAddedtocartticketIDs(int item) =>
      addedtocartticketIDs.remove(item);
  void removeAtIndexFromAddedtocartticketIDs(int index) =>
      addedtocartticketIDs.removeAt(index);
  void insertAtIndexInAddedtocartticketIDs(int index, int item) =>
      addedtocartticketIDs.insert(index, item);
  void updateAddedtocartticketIDsAtIndex(int index, Function(int) updateFn) =>
      addedtocartticketIDs[index] = updateFn(addedtocartticketIDs[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateCart] action in IconButton widget.
  List<TicketsaddtocartStruct>? outputUpdateCart2;
  // Stores action output result for [Custom Action - updateCart] action in IconButton widget.
  List<TicketsaddtocartStruct>? outputUpdateCart;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  OrdersRow? orderoutput98;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  OrderitemsRow? orderitemsoutput2;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  OrdersRow? orderoutput99;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  OrderitemsRow? orderitemsoutput;
  // Stores action output result for [Razorpay Payment] action in Button widget.
  String? razorpayPaymentId;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
