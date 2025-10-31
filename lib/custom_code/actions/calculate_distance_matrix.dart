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

/// Calculates road distances and durations using Google Distance Matrix API
/// Returns a map with two keys: 'distances' and 'durations'
/// distances: Map of venue IDs to their distances in kilometers
/// durations: Map of venue IDs to their travel times in minutes
/// Handles multiple destinations in batches to optimize API calls
Future<Map<String, Map<int, num>>> calculateDistanceMatrix(
  LatLng origin,
  List<VenuesRow> venues,
) async {
  final Map<int, double> distances = {};
  final Map<int, int> durations = {};

  if (venues.isEmpty) {
    return {
      'distances': distances,
      'durations': durations,
    };
  }

  const apiKey = 'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s';

  // Filter venues that have valid coordinates
  final validVenues = venues.where((v) => v.lat != null && v.lng != null).toList();

  print('');
  print('═══════════════════════════════════════════════════════');
  print('📍 DISTANCE MATRIX API REQUEST');
  print('═══════════════════════════════════════════════════════');
  print('Origin (User Location): ${origin.latitude}, ${origin.longitude}');
  print('Total venues to calculate: ${validVenues.length}');
  print('Estimated API requests: ${(validVenues.length / 25).ceil()}');
  print('═══════════════════════════════════════════════════════');

  if (validVenues.isEmpty) {
    print('No venues with valid coordinates');
    return {
      'distances': distances,
      'durations': durations,
    };
  }

  // Google Distance Matrix API allows up to 25 destinations per request
  // We'll batch them in groups of 25
  const batchSize = 25;

  for (int i = 0; i < validVenues.length; i += batchSize) {
    final end = (i + batchSize < validVenues.length) ? i + batchSize : validVenues.length;
    final batch = validVenues.sublist(i, end);

    try {
      // Build destinations string
      final destinationsString = batch
          .map((venue) => '${venue.lat},${venue.lng}')
          .join('|');

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?'
        'origins=${origin.latitude},${origin.longitude}&'
        'destinations=$destinationsString&'
        'mode=driving&'
        'key=$apiKey',
      );

      print('');
      print('📡 API Request ${(i ~/ batchSize) + 1}/${(validVenues.length / batchSize).ceil()}');
      print('   Batch size: ${batch.length} venues');
      print('   URL: $url');

      final response = await http.get(url);

      print('   Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('   API Status: ${data['status']}');

        if (data['status'] == 'OK') {
          final rows = data['rows'] as List;
          if (rows.isNotEmpty) {
            final elements = rows[0]['elements'] as List;

            print('   Received ${elements.length} distance calculations');

            for (int j = 0; j < elements.length && j < batch.length; j++) {
              final element = elements[j];
              final venue = batch[j];

              if (element['status'] == 'OK') {
                // Distance is in meters, convert to kilometers
                final distanceMeters = element['distance']['value'] as int;
                final distanceText = element['distance']['text'] as String;
                final distanceKm = distanceMeters / 1000.0;

                // Duration is in seconds, convert to minutes
                final durationSeconds = element['duration']['value'] as int;
                final durationText = element['duration']['text'] as String;
                final durationMinutes = (durationSeconds / 60).round();

                distances[venue.id] = distanceKm;
                durations[venue.id] = durationMinutes;

                // Only log first few venues to avoid clutter
                if (j < 3 || j == elements.length - 1) {
                  print('     ${venue.venueName}: $distanceText, $durationText');
                } else if (j == 3) {
                  print('     ... (${elements.length - 4} more venues) ...');
                }
              } else {
                // If distance unavailable, calculate straight-line as fallback
                final distanceKm = _calculateHaversineDistance(
                  origin,
                  venue.lat!,
                  venue.lng!,
                );
                distances[venue.id] = distanceKm;
                print('     ⚠️ ${venue.venueName}: ${element['status']} - using fallback ${distanceKm.toStringAsFixed(2)} km');
              }
            }
          }
        } else {
          print('Distance Matrix API error: ${data['status']}');
          if (data['error_message'] != null) {
            print('Error message: ${data['error_message']}');
          }
          // Fallback to Haversine for this batch
          _addHaversineDistances(origin, batch, distances);
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Fallback to Haversine for this batch
        _addHaversineDistances(origin, batch, distances);
      }
    } catch (e) {
      print('Error calculating distances for batch: $e');
      // Fallback to Haversine for this batch
      _addHaversineDistances(origin, batch, distances);
    }

    // Small delay between batches to avoid rate limiting
    if (end < validVenues.length) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  return {
    'distances': distances,
    'durations': durations,
  };
}

/// Fallback: Calculate straight-line distances using Haversine formula
void _addHaversineDistances(
  LatLng origin,
  List<VenuesRow> venues,
  Map<int, double> distances,
) {
  for (final venue in venues) {
    if (venue.lat != null && venue.lng != null) {
      final distance = _calculateHaversineDistance(
        origin,
        venue.lat!,
        venue.lng!,
      );
      distances[venue.id] = distance;
      print('Venue ${venue.venueName}: ${distance.toStringAsFixed(2)} km (Haversine fallback)');
    }
  }
}

/// Haversine formula for straight-line distance
double _calculateHaversineDistance(
  LatLng origin,
  double venueLat,
  double venueLng,
) {
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
  double a = _sin(dLat / 2) * _sin(dLat / 2) +
      _sin(dLon / 2) * _sin(dLon / 2) * _cos(lat1) * _cos(lat2);
  double c = 2 * _asin(_sqrt(a));

  return earthRadiusKm * c;
}

double _degreesToRadians(double degrees) {
  return degrees * 3.14159265359 / 180.0;
}

double _sin(double radians) {
  return radians - (radians * radians * radians) / 6 +
         (radians * radians * radians * radians * radians) / 120;
}

double _cos(double radians) {
  return 1 - (radians * radians) / 2 + (radians * radians * radians * radians) / 24;
}

double _sqrt(double x) {
  if (x == 0) return 0;
  double guess = x / 2;
  for (int i = 0; i < 10; i++) {
    guess = (guess + x / guess) / 2;
  }
  return guess;
}

double _asin(double x) {
  return x + (x * x * x) / 6 + (3 * x * x * x * x * x) / 40;
}
