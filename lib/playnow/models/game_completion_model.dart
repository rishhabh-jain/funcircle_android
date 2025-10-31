/// Game completion model for playnow.game_completions table
class GameCompletion {
  final String id;
  final String gameId;
  final String userId;
  final String? result; // 'won', 'lost', 'draw'
  final int? rating; // 1-5 rating of the game
  final String? feedback;
  final DateTime completedAt;

  GameCompletion({
    required this.id,
    required this.gameId,
    required this.userId,
    this.result,
    this.rating,
    this.feedback,
    required this.completedAt,
  });

  factory GameCompletion.fromJson(Map<String, dynamic> json) {
    return GameCompletion(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      userId: json['user_id'] as String,
      result: json['result'] as String?,
      rating: json['rating'] as int?,
      feedback: json['feedback'] as String?,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'user_id': userId,
      'result': result,
      'rating': rating,
      'feedback': feedback,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}

/// Player rating model for playnow.player_ratings table
class PlayerRating {
  final String id;
  final String gameId;
  final String raterUserId;
  final String ratedUserId;
  final int skillRating; // 1-5
  final int sportsmanshipRating; // 1-5
  final String? comment;
  final DateTime createdAt;

  PlayerRating({
    required this.id,
    required this.gameId,
    required this.raterUserId,
    required this.ratedUserId,
    required this.skillRating,
    required this.sportsmanshipRating,
    this.comment,
    required this.createdAt,
  });

  factory PlayerRating.fromJson(Map<String, dynamic> json) {
    return PlayerRating(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      raterUserId: json['rater_user_id'] as String,
      ratedUserId: json['rated_user_id'] as String,
      skillRating: json['skill_rating'] as int,
      sportsmanshipRating: json['sportsmanship_rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'rater_user_id': raterUserId,
      'rated_user_id': ratedUserId,
      'skill_rating': skillRating,
      'sportsmanship_rating': sportsmanshipRating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Game participant with user info for rating
class RatablePlayer {
  final String userId;
  final String displayName;
  final String? photoUrl;
  bool isRated;

  RatablePlayer({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    this.isRated = false,
  });

  factory RatablePlayer.fromJson(Map<String, dynamic> json) {
    return RatablePlayer(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String? ?? 'Unknown',
      photoUrl: json['photo_url'] as String?,
      isRated: json['is_rated'] as bool? ?? false,
    );
  }
}
