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

/// Searches for places using Google Places Autocomplete API
/// Returns a list of place predictions with their place_id and description
Future<List<dynamic>> searchPlaces(String input) async {
  if (input.isEmpty) {
    return [];
  }

  const apiKey = 'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s';
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:in',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['predictions'] as List<dynamic>;
      } else {
        print('Places API error: ${data['status']}');
        return [];
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error searching places: $e');
    return [];
  }
}
