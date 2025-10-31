// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
List<TicketsaddtocartStruct> updateCart(
    int ticketid,
    String ticketname,
    String ticketprice,
    int maxcapacity,
    bool reduceticket,
    List<TicketsaddtocartStruct> ticketsaddtocart) {
  int index =
      ticketsaddtocart.indexWhere((ticket) => ticket.ticketid == ticketid);

  if (index != -1) {
    if (reduceticket) {
      if (ticketsaddtocart[index].quantity > 1) {
        ticketsaddtocart[index].quantity -= 1;
      } else {
        ticketsaddtocart.removeAt(index);
      }
    } else {
      if (ticketsaddtocart[index].quantity < maxcapacity) {
        ticketsaddtocart[index].quantity += 1;
      }
    }
  } else {
    if (!reduceticket) {
      if (1 <= maxcapacity) {
        ticketsaddtocart.add(TicketsaddtocartStruct(
          ticketid: ticketid,
          quantity: 1,
          ticketname: ticketname,
          ticketprice: ticketprice,
        ));
      }
    }
    // If reduceticket is true and the ticketid is not in the list, we do nothing and return the list as is.
  }

  return ticketsaddtocart;
}
