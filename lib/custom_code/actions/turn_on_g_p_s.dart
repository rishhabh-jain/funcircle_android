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

import 'package:geolocator/geolocator.dart';

Future<void> turnOnGPS() async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationServiceEnabled) {
    bool serviceStatusResult = await Geolocator.openLocationSettings();
    print("Service status opened: $serviceStatusResult");
  }
}
