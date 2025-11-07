import '/flutter_flow/flutter_flow_util.dart';
import '/playnow/models/game_model.dart';
import 'package:flutter/material.dart';

class GameDetailsModel extends FlutterFlowModel {
  /// State fields
  Game? game;
  List<GameParticipant> participants = [];
  bool isLoading = false;
  bool isJoining = false;

  // Additional loaded data
  String? organizerName;
  String? venueName;
  String? venueAddress;
  double? venueLatitude;
  double? venueLongitude;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

/// Model for game participant with user info
class GameParticipant {
  final String id;
  final String gameId;
  final String userId;
  final String joinType; // 'creator', 'auto_join', 'accepted_request'
  final DateTime joinedAt;
  final String? paymentStatus;

  // User info
  final String? firstName;
  final String? profilePicture;
  final int? skillLevelBadminton;
  final int? skillLevelPickleball;

  GameParticipant({
    required this.id,
    required this.gameId,
    required this.userId,
    required this.joinType,
    required this.joinedAt,
    this.paymentStatus,
    this.firstName,
    this.profilePicture,
    this.skillLevelBadminton,
    this.skillLevelPickleball,
  });

  factory GameParticipant.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>?;

    return GameParticipant(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      userId: json['user_id'] as String,
      joinType: json['join_type'] as String? ?? 'auto_join',
      joinedAt: DateTime.parse(json['joined_at'] as String),
      paymentStatus: json['payment_status'] as String?,
      firstName: userData?['first_name'] as String?,
      profilePicture: userData?['profile_picture'] as String?,
      skillLevelBadminton: userData?['skill_level_badminton'] as int?,
      skillLevelPickleball: userData?['skill_level_pickleball'] as int?,
    );
  }
}
