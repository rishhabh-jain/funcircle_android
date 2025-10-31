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

import 'dart:math' show cos, sqrt, asin;

/// Calculates the distance between two coordinates using the Haversine formula
/// Returns distance in kilometers
double calculateVenueDistance(
  LatLng origin,
  double venueLat,
  double venueLng,
) {
  // Haversine formula to calculate distance between two points
  const double earthRadiusKm = 6371.0;

  double lat1 = origin.latitude;
  double lon1 = origin.longitude;
  double lat2 = venueLat;
  double lon2 = venueLng;

  // Convert degrees to radians
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  lat1 = _degreesToRadians(lat1);
  lat2 = _degreesToRadians(lat2);

  // Haversine formula
  double a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  double c = 2 * asin(sqrt(a));

  return earthRadiusKm * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180.0;
}

double sin(double radians) {
  return radians - (radians * radians * radians) / 6 +
         (radians * radians * radians * radians * radians) / 120;
}

const double pi = 3.14159265359;
