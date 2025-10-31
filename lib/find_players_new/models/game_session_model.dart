import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Game session model for group play
class GameSessionModel {
  final String id;
  final String creatorId;
  final String sportType;
  final int? venueId;
  final String sessionType; // 'singles', 'doubles', 'group'
  final int maxPlayers;
  final List<dynamic> currentPlayers;
  final DateTime scheduledTime;
  final int durationMinutes;
  final int? skillLevelRequired; // 1-5 (null means any level)
  final bool isPrivate;
  final String? sessionCode;
  final String
      status; // 'open', 'full', 'in_progress', 'completed', 'cancelled'
  final double? latitude;
  final double? longitude;
  final double? costPerPlayer;
  final String? notes;
  final DateTime createdAt;

  // Creator information from join
  final String? creatorName;
  final String? creatorProfilePicture;

  GameSessionModel({
    required this.id,
    required this.creatorId,
    required this.sportType,
    this.venueId,
    required this.sessionType,
    required this.maxPlayers,
    required this.currentPlayers,
    required this.scheduledTime,
    required this.durationMinutes,
    this.skillLevelRequired,
    required this.isPrivate,
    this.sessionCode,
    required this.status,
    this.latitude,
    this.longitude,
    this.costPerPlayer,
    this.notes,
    required this.createdAt,
    this.creatorName,
    this.creatorProfilePicture,
  });

  /// Create from JSON map (from Supabase query)
  factory GameSessionModel.fromJson(Map<String, dynamic> json) {
    return GameSessionModel(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      sportType: json['sport_type'] as String,
      venueId: json['venue_id'] as int?,
      sessionType: json['session_type'] as String,
      maxPlayers: json['max_players'] as int,
      currentPlayers: json['current_players'] as List<dynamic>? ?? [],
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      durationMinutes: json['duration_minutes'] as int,
      skillLevelRequired: json['skill_level_required'] as int?,
      isPrivate: json['is_private'] as bool? ?? false,
      sessionCode: json['session_code'] as String?,
      status: json['status'] as String,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      costPerPlayer: json['cost_per_player'] != null
          ? (json['cost_per_player'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      creatorName: json['creator_name'] as String?,
      creatorProfilePicture: json['creator_profile_picture'] as String?,
    );
  }

  /// Get LatLng for map marker
  LatLng? get latLng {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }

  /// Get number of joined players
  int get joinedPlayersCount => currentPlayers.length;

  /// Check if session is full
  bool get isFull => joinedPlayersCount >= maxPlayers || status == 'full';

  /// Check if session is open for joining
  bool get isOpen => status == 'open' && !isFull;

  /// Get slots remaining
  int get slotsRemaining => maxPlayers - joinedPlayersCount;
}
