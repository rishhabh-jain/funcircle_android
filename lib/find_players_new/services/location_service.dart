import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Service class for location-related operations
class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current user location
  /// Returns null if permission is denied or service is disabled
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      // Check permission
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Get current location as LatLng
  static Future<LatLng?> getCurrentLatLng() async {
    final position = await getCurrentLocation();
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convert meters to kilometers
  }

  /// Calculate distance between two LatLng points in kilometers
  static double calculateDistanceLatLng({
    required LatLng start,
    required LatLng end,
  }) {
    return calculateDistance(
      startLatitude: start.latitude,
      startLongitude: start.longitude,
      endLatitude: end.latitude,
      endLongitude: end.longitude,
    );
  }

  /// Get a stream of location updates
  static Stream<Position> getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update every 100 meters
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Format distance for display
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    } else if (distanceInKm < 10) {
      return '${distanceInKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceInKm.toStringAsFixed(0)} km';
    }
  }
}
