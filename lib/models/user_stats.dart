class UserStats {
  final String userId;
  final int totalGames;
  final int gamesWon;
  final int currentStreak;
  final double rating;
  final int totalFriends;
  final int totalBookings;
  final Map<String, int> sportStats; // sport -> games played

  UserStats({
    required this.userId,
    this.totalGames = 0,
    this.gamesWon = 0,
    this.currentStreak = 0,
    this.rating = 0.0,
    this.totalFriends = 0,
    this.totalBookings = 0,
    this.sportStats = const {},
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['user_id'] as String,
      totalGames: json['total_games'] as int? ?? 0,
      gamesWon: json['games_won'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalFriends: json['total_friends'] as int? ?? 0,
      totalBookings: json['total_bookings'] as int? ?? 0,
      sportStats: json['sport_stats'] != null
          ? Map<String, int>.from(json['sport_stats'] as Map)
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_games': totalGames,
      'games_won': gamesWon,
      'current_streak': currentStreak,
      'rating': rating,
      'total_friends': totalFriends,
      'total_bookings': totalBookings,
      'sport_stats': sportStats,
    };
  }

  double get winRate {
    if (totalGames == 0) return 0.0;
    return (gamesWon / totalGames) * 100;
  }

  String get winRateDisplay => '${winRate.toStringAsFixed(1)}%';
}
