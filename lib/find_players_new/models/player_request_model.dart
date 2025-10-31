import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Player request model with user information
class PlayerRequestModel {
  final String id;
  final String userId;
  final String sportType;
  final int? venueId;
  final String? customLocation;
  final double? latitude;
  final double? longitude;
  final int playersNeeded;
  final DateTime scheduledTime;
  final int? skillLevel; // 1-5
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime expiresAt;

  // User information from join
  final String? userName;
  final String? userProfilePicture;
  final int? userSkillLevel;

  PlayerRequestModel({
    required this.id,
    required this.userId,
    required this.sportType,
    this.venueId,
    this.customLocation,
    this.latitude,
    this.longitude,
    required this.playersNeeded,
    required this.scheduledTime,
    this.skillLevel,
    this.description,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.userName,
    this.userProfilePicture,
    this.userSkillLevel,
  });

  /// Create from JSON map (from Supabase query)
  factory PlayerRequestModel.fromJson(Map<String, dynamic> json) {
    return PlayerRequestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sportType: json['sport_type'] as String,
      venueId: json['venue_id'] as int?,
      customLocation: json['custom_location'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      playersNeeded: json['players_needed'] as int,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      skillLevel: json['skill_level'] as int?,
      description: json['description'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      userName: json['user_name'] as String?,
      userProfilePicture: json['user_profile_picture'] as String?,
      userSkillLevel: json['user_skill_level'] as int?,
    );
  }

  /// Get LatLng for map marker
  LatLng? get latLng {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }

  /// Check if request is still active
  bool get isActive => status == 'active' && expiresAt.isAfter(DateTime.now());
}
