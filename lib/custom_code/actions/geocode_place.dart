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

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Geocodes a place ID to get its latitude and longitude
/// Returns LatLng or null if geocoding fails
Future<LatLng?> geocodePlace(String placeId) async {
  if (placeId.isEmpty) {
    return null;
  }

  const apiKey = 'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s';
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final lat = location['lat'] as double;
        final lng = location['lng'] as double;

        print('Geocoded location: $lat, $lng');
        return LatLng(lat, lng);
      } else {
        print('Geocoding error: ${data['status']}');
        return null;
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error geocoding place: $e');
    return null;
  }
}
