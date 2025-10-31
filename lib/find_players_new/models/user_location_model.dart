import 'package:google_maps_flutter/google_maps_flutter.dart';

/// User location model with availability status
class UserLocationModel {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final String? sportType;
  final int? skillLevel; // 1-5
  final DateTime updatedAt;

  // User information from join
  final String? userName;
  final String? userProfilePicture;

  UserLocationModel({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    this.sportType,
    this.skillLevel,
    required this.updatedAt,
    this.userName,
    this.userProfilePicture,
  });

  /// Create from JSON map (from Supabase query)
  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isAvailable: json['is_available'] as bool,
      sportType: json['sport_type'] as String?,
      skillLevel: json['skill_level'] as int?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userName: json['user_name'] as String?,
      userProfilePicture: json['user_profile_picture'] as String?,
    );
  }

  /// Get LatLng for map marker
  LatLng get latLng => LatLng(latitude, longitude);

  /// Check if location is recent (within last 15 minutes)
  bool get isRecent {
    return DateTime.now().difference(updatedAt).inMinutes < 15;
  }
}
