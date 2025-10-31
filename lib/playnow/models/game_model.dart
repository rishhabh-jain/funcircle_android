import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Game model for playnow.games table
class Game {
  final String id;
  final String createdBy;
  final String sportType; // 'badminton', 'pickleball'
  final DateTime gameDate;
  final String startTime; // Format: "HH:mm"
  final int? venueId;
  final String? venueName;
  final String? customLocation;
  final int playersNeeded;
  final String gameType; // 'singles', 'doubles', 'mixed_doubles'
  final int? skillLevel; // 1-5 or null for 'any'
  final double? costPerPlayer;
  final bool isFree;
  final String joinType; // 'auto', 'request'
  final bool isVenueBooked;
  final bool isWomenOnly;
  final bool isMixedOnly;
  final String? description;
  final String status; // 'open', 'full', 'in_progress', 'completed', 'cancelled'
  final String? chatRoomId;
  final int currentPlayersCount;
  final DateTime createdAt;

  Game({
    required this.id,
    required this.createdBy,
    required this.sportType,
    required this.gameDate,
    required this.startTime,
    this.venueId,
    this.venueName,
    this.customLocation,
    required this.playersNeeded,
    required this.gameType,
    this.skillLevel,
    this.costPerPlayer,
    required this.isFree,
    required this.joinType,
    this.isVenueBooked = false,
    this.isWomenOnly = false,
    this.isMixedOnly = false,
    this.description,
    this.status = 'open',
    this.chatRoomId,
    this.currentPlayersCount = 1,
    required this.createdAt,
  });

  /// Generate auto title
  String get autoTitle {
    final gameTypeLabel = _getGameTypeLabel();
    final sportLabel = sportType == 'badminton' ? 'Badminton' : 'Pickleball';
    final levelLabel = skillLevel != null ? 'Level $skillLevel' : 'Open';
    final dateLabel = _formatDateForTitle();

    return '$gameTypeLabel $sportLabel - $levelLabel - $dateLabel';
  }

  String _getGameTypeLabel() {
    switch (gameType) {
      case 'singles':
        return 'Singles';
      case 'doubles':
        return 'Doubles';
      case 'mixed_doubles':
        return 'Mixed Doubles';
      default:
        return gameType;
    }
  }

  String _formatDateForTitle() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final gameDay = DateTime(gameDate.year, gameDate.month, gameDate.day);

    if (gameDay == today) {
      return 'Today ${_formatTime()}';
    } else if (gameDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow ${_formatTime()}';
    } else {
      return '${DateFormat('E d MMM').format(gameDate)} ${_formatTime()}';
    }
  }

  String _formatTime() {
    try {
      final time = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]),
      );
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour ${period}';
    } catch (e) {
      return startTime;
    }
  }

  /// Formatted date for display
  String get formattedDate =>
      DateFormat('EEEE, MMM d, yyyy').format(gameDate);

  /// Formatted time for display
  String get formattedTime => _formatTime();

  /// Check if game is full
  bool get isFull => currentPlayersCount >= playersNeeded;

  /// Slots remaining
  int get slotsRemaining => playersNeeded - currentPlayersCount;

  /// Location display
  String get locationDisplay => venueName ?? customLocation ?? 'Location TBD';

  /// Cost display
  String get costDisplay =>
      isFree ? 'Free' : '₹${costPerPlayer?.toStringAsFixed(0)} per player';

  /// Create from JSON
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      createdBy: json['created_by'] as String,
      sportType: json['sport_type'] as String,
      gameDate: DateTime.parse(json['game_date'] as String),
      startTime: json['start_time'] as String,
      venueId: json['venue_id'] as int?,
      venueName: json['venue_name'] as String?,
      customLocation: json['custom_location'] as String?,
      playersNeeded: json['players_needed'] as int,
      gameType: json['game_type'] as String,
      skillLevel: json['skill_level'] as int?,
      costPerPlayer: json['cost_per_player'] != null
          ? (json['cost_per_player'] as num).toDouble()
          : null,
      isFree: json['is_free'] as bool? ?? false,
      joinType: json['join_type'] as String? ?? 'auto',
      isVenueBooked: json['is_venue_booked'] as bool? ?? false,
      isWomenOnly: json['is_women_only'] as bool? ?? false,
      isMixedOnly: json['is_mixed_only'] as bool? ?? false,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'open',
      chatRoomId: json['chat_room_id'] as String?,
      currentPlayersCount: json['current_players_count'] as int? ?? 1,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'sport_type': sportType,
      'game_date': gameDate.toIso8601String(),
      'start_time': startTime,
      'venue_id': venueId,
      'custom_location': customLocation,
      'players_needed': playersNeeded,
      'game_type': gameType,
      'skill_level': skillLevel,
      'cost_per_player': costPerPlayer,
      'is_free': isFree,
      'join_type': joinType,
      'is_venue_booked': isVenueBooked,
      'is_women_only': isWomenOnly,
      'is_mixed_only': isMixedOnly,
      'description': description,
      'status': status,
      'chat_room_id': chatRoomId,
      'current_players_count': currentPlayersCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copy with method
  Game copyWith({
    String? id,
    String? createdBy,
    String? sportType,
    DateTime? gameDate,
    String? startTime,
    int? venueId,
    String? venueName,
    String? customLocation,
    int? playersNeeded,
    String? gameType,
    int? skillLevel,
    double? costPerPlayer,
    bool? isFree,
    String? joinType,
    bool? isVenueBooked,
    bool? isWomenOnly,
    bool? isMixedOnly,
    String? description,
    String? status,
    String? chatRoomId,
    int? currentPlayersCount,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      sportType: sportType ?? this.sportType,
      gameDate: gameDate ?? this.gameDate,
      startTime: startTime ?? this.startTime,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      customLocation: customLocation ?? this.customLocation,
      playersNeeded: playersNeeded ?? this.playersNeeded,
      gameType: gameType ?? this.gameType,
      skillLevel: skillLevel ?? this.skillLevel,
      costPerPlayer: costPerPlayer ?? this.costPerPlayer,
      isFree: isFree ?? this.isFree,
      joinType: joinType ?? this.joinType,
      isVenueBooked: isVenueBooked ?? this.isVenueBooked,
      isWomenOnly: isWomenOnly ?? this.isWomenOnly,
      isMixedOnly: isMixedOnly ?? this.isMixedOnly,
      description: description ?? this.description,
      status: status ?? this.status,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      currentPlayersCount: currentPlayersCount ?? this.currentPlayersCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Request model for creating a game
class CreateGameRequest {
  final String userId;
  final String sportType;
  final DateTime gameDate;
  final String startTime;
  final int? venueId;
  final String? customLocation;
  final int playersNeeded;
  final String gameType;
  final int? skillLevel;
  final double? costPerPlayer;
  final bool isFree;
  final String joinType;
  final bool isVenueBooked;
  final bool isWomenOnly;
  final bool isMixedOnly;
  final String? description;

  CreateGameRequest({
    required this.userId,
    required this.sportType,
    required this.gameDate,
    required this.startTime,
    this.venueId,
    this.customLocation,
    required this.playersNeeded,
    required this.gameType,
    this.skillLevel,
    this.costPerPlayer,
    required this.isFree,
    required this.joinType,
    this.isVenueBooked = false,
    this.isWomenOnly = false,
    this.isMixedOnly = false,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'created_by': userId,
      'sport_type': sportType,
      'game_date': gameDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'venue_id': venueId,
      'custom_location': customLocation,
      'players_needed': playersNeeded,
      'game_type': gameType,
      'skill_level': skillLevel,
      'cost_per_player': costPerPlayer,
      'is_free': isFree,
      'join_type': joinType,
      'is_venue_booked': isVenueBooked,
      'is_women_only': isWomenOnly,
      'is_mixed_only': isMixedOnly,
      'description': description,
      'status': 'open',
    };
  }
}
