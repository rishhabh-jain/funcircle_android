import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Venue marker model for map display
class VenueMarkerModel {
  final int id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final List<String>? images;
  final String? description;

  VenueMarkerModel({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.images,
    this.description,
  });

  /// Create from JSON map (from Supabase query)
  factory VenueMarkerModel.fromJson(Map<String, dynamic> json) {
    return VenueMarkerModel(
      id: json['id'] as int,
      name: json['venue_name'] as String? ?? 'Unknown Venue',
      address: json['location'] as String?,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      description: json['description'] as String?,
    );
  }

  /// Get LatLng for map marker
  LatLng get latLng => LatLng(latitude, longitude);
}
