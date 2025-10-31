class PlayFriend {
  final String friendshipId;
  final String friendId;
  final String friendName;
  final String? friendImage;
  final String? friendLevel;
  final int gamesPlayedTogether;
  final bool isFavorite;
  final String? nickname;
  final String? preferredSport;
  final DateTime? lastPlayedAt;
  final DateTime friendsSince;
  final List<String> sportsPlayed;

  PlayFriend({
    required this.friendshipId,
    required this.friendId,
    required this.friendName,
    this.friendImage,
    this.friendLevel,
    required this.gamesPlayedTogether,
    this.isFavorite = false,
    this.nickname,
    this.preferredSport,
    this.lastPlayedAt,
    required this.friendsSince,
    this.sportsPlayed = const [],
  });

  factory PlayFriend.fromJson(Map<String, dynamic> json) {
    return PlayFriend(
      friendshipId: json['friendship_id'] as String,
      friendId: json['friend_id'] as String,
      friendName: json['friend_name'] as String? ?? 'Friend',
      friendImage: json['friend_image'] as String?,
      friendLevel: json['friend_level'] as String?,
      gamesPlayedTogether: json['games_played_together'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      nickname: json['nickname'] as String?,
      preferredSport: json['preferred_sport'] as String?,
      lastPlayedAt: json['last_played_at'] != null
          ? DateTime.parse(json['last_played_at'] as String)
          : null,
      friendsSince: json['friends_since'] != null
          ? DateTime.parse(json['friends_since'] as String)
          : DateTime.now(),
      sportsPlayed: (json['sports_played'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendship_id': friendshipId,
      'friend_id': friendId,
      'friend_name': friendName,
      'friend_image': friendImage,
      'friend_level': friendLevel,
      'games_played_together': gamesPlayedTogether,
      'is_favorite': isFavorite,
      'nickname': nickname,
      'preferred_sport': preferredSport,
      'last_played_at': lastPlayedAt?.toIso8601String(),
      'friends_since': friendsSince.toIso8601String(),
      'sports_played': sportsPlayed,
    };
  }

  String get displayName => nickname ?? friendName;

  bool playsSport(String sport) {
    return sportsPlayed.contains(sport) || preferredSport == sport;
  }
}
