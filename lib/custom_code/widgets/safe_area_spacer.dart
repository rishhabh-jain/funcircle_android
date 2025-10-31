// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
class SafeAreaSpacer extends StatelessWidget {
  const SafeAreaSpacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the SafeArea padding from MediaQuery
    double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity, // Takes full width
      height: topPadding > 0 ? topPadding : 24, // Ensures a minimum height
    );
  }
}
