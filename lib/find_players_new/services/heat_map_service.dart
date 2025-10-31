import 'dart:math' as math;
import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

/// Heat map data point
class HeatMapPoint {
  final double latitude;
  final double longitude;
  final int intensity; // Number of activities at this point

  HeatMapPoint({
    required this.latitude,
    required this.longitude,
    required this.intensity,
  });
}

/// Time filter options for heat map
enum HeatMapTimeFilter {
  all,
  morning, // 6am - 12pm
  afternoon, // 12pm - 6pm
  evening, // 6pm - 12am
}

/// Service for generating heat map data from player activity
class HeatMapService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Get heat map data points for a sport type
  static Future<List<HeatMapPoint>> getHeatMapData({
    required String sportType,
    HeatMapTimeFilter timeFilter = HeatMapTimeFilter.all,
    int daysBack = 30,
  }) async {
    try {
      final cutoffDate =
          DateTime.now().subtract(Duration(days: daysBack)).toIso8601String();

      // Fetch player requests
      final requestsQuery = _client
          .from('findplayers.player_requests')
          .select('latitude, longitude, scheduled_time')
          .eq('sport_type', sportType)
          .gt('created_at', cutoffDate)
          .not('latitude', 'is', null)
          .not('longitude', 'is', null);

      // Fetch game sessions
      final sessionsQuery = _client
          .from('findplayers.game_sessions')
          .select('latitude, longitude, scheduled_time')
          .eq('sport_type', sportType)
          .gt('created_at', cutoffDate)
          .not('latitude', 'is', null)
          .not('longitude', 'is', null);

      final results = await Future.wait([requestsQuery, sessionsQuery]);

      // Combine all activity points
      final allPoints = <Map<String, dynamic>>[];
      for (final result in results) {
        allPoints.addAll((result as List).cast<Map<String, dynamic>>());
      }

      // Filter by time of day if specified
      final filteredPoints = _filterByTimeOfDay(allPoints, timeFilter);

      // Group points by location (with clustering)
      final heatMapPoints = _clusterPoints(filteredPoints);

      return heatMapPoints;
    } catch (e) {
      print('Error getting heat map data: $e');
      return [];
    }
  }

  /// Filter points by time of day
  static List<Map<String, dynamic>> _filterByTimeOfDay(
    List<Map<String, dynamic>> points,
    HeatMapTimeFilter timeFilter,
  ) {
    if (timeFilter == HeatMapTimeFilter.all) return points;

    return points.where((point) {
      final scheduledTime = point['scheduled_time'] as String?;
      if (scheduledTime == null) return false;

      final time = DateTime.parse(scheduledTime);
      final hour = time.hour;

      switch (timeFilter) {
        case HeatMapTimeFilter.morning:
          return hour >= 6 && hour < 12;
        case HeatMapTimeFilter.afternoon:
          return hour >= 12 && hour < 18;
        case HeatMapTimeFilter.evening:
          return hour >= 18 || hour < 6;
        case HeatMapTimeFilter.all:
          return true;
      }
    }).toList();
  }

  /// Cluster nearby points and count intensity
  static List<HeatMapPoint> _clusterPoints(
    List<Map<String, dynamic>> points,
  ) {
    final clusters = <HeatMapPoint>[];
    final clusterRadius = 0.005; // ~500 meters in degrees

    for (final point in points) {
      final lat = (point['latitude'] as num).toDouble();
      final lng = (point['longitude'] as num).toDouble();

      // Find existing cluster nearby
      var foundCluster = false;
      for (var i = 0; i < clusters.length; i++) {
        final cluster = clusters[i];
        final distance = _calculateDistance(
          lat,
          lng,
          cluster.latitude,
          cluster.longitude,
        );

        if (distance < clusterRadius) {
          // Add to existing cluster
          clusters[i] = HeatMapPoint(
            latitude: (cluster.latitude * cluster.intensity + lat) /
                (cluster.intensity + 1),
            longitude: (cluster.longitude * cluster.intensity + lng) /
                (cluster.intensity + 1),
            intensity: cluster.intensity + 1,
          );
          foundCluster = true;
          break;
        }
      }

      // Create new cluster if no nearby cluster found
      if (!foundCluster) {
        clusters.add(HeatMapPoint(
          latitude: lat,
          longitude: lng,
          intensity: 1,
        ));
      }
    }

    return clusters;
  }

  /// Calculate simple distance between two points (in degrees)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return math.sqrt(math.pow(lat2 - lat1, 2) + math.pow(lon2 - lon1, 2));
  }

  /// Convert heat map points to map circles for visualization
  static Set<gmaps.Circle> generateHeatMapCircles(
    List<HeatMapPoint> points,
  ) {
    if (points.isEmpty) return {};

    // Find max intensity for normalization
    final maxIntensity =
        points.map((p) => p.intensity).reduce(math.max).toDouble();

    return points.map((point) {
      // Normalize intensity to 0-1
      final normalizedIntensity = point.intensity / maxIntensity;

      // Calculate color based on intensity (blue to red gradient)
      final color = _getHeatColor(normalizedIntensity);

      // Calculate radius based on intensity
      final radius = 100.0 + (normalizedIntensity * 300); // 100-400 meters

      return gmaps.Circle(
        circleId: gmaps.CircleId('heat_${point.latitude}_${point.longitude}'),
        center: gmaps.LatLng(point.latitude, point.longitude),
        radius: radius,
        fillColor: color.withOpacity(0.4),
        strokeColor: color.withOpacity(0.7),
        strokeWidth: 2,
      );
    }).toSet();
  }

  /// Get color for heat intensity (blue -> yellow -> red)
  static Color _getHeatColor(double intensity) {
    // Blue (low) -> Yellow (medium) -> Red (high)
    if (intensity < 0.33) {
      // Blue to Cyan
      final t = intensity / 0.33;
      return Color.fromARGB(
        255,
        0,
        (100 + t * 155).toInt(),
        (255 - t * 100).toInt(),
      );
    } else if (intensity < 0.67) {
      // Cyan to Yellow
      final t = (intensity - 0.33) / 0.34;
      return Color.fromARGB(
        255,
        (t * 255).toInt(),
        255,
        ((1 - t) * 155).toInt(),
      );
    } else {
      // Yellow to Red
      final t = (intensity - 0.67) / 0.33;
      return Color.fromARGB(
        255,
        255,
        ((1 - t) * 255).toInt(),
        0,
      );
    }
  }
}
