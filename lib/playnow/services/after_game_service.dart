import '/backend/supabase/supabase.dart';

/// Service for handling after-game operations
class AfterGameService {
  static final _client = SupaFlow.client;

  /// Record game scores (3 sets for badminton)
  static Future<Map<String, dynamic>> recordGameScores({
    required String gameId,
    required String submittedBy,
    required List<String> team1Players,
    required List<String> team2Players,
    required int set1Team1Score,
    required int set1Team2Score,
    int? set2Team1Score,
    int? set2Team2Score,
    int? set3Team1Score,
    int? set3Team2Score,
  }) async {
    try {
      // Calculate winning team (1 or 2)
      int team1Wins = 0;
      int team2Wins = 0;

      // Set 1
      if (set1Team1Score > set1Team2Score) {
        team1Wins++;
      } else {
        team2Wins++;
      }

      // Set 2
      if (set2Team1Score != null && set2Team2Score != null) {
        if (set2Team1Score > set2Team2Score) {
          team1Wins++;
        } else {
          team2Wins++;
        }
      }

      // Set 3
      if (set3Team1Score != null && set3Team2Score != null) {
        if (set3Team1Score > set3Team2Score) {
          team1Wins++;
        } else {
          team2Wins++;
        }
      }

      final winningTeam = team1Wins > team2Wins ? 1 : 2;

      final result =
          await _client.schema('playnow').from('game_results').insert({
        'game_id': gameId,
        'submitted_by': submittedBy,
        'team1_players': team1Players,
        'team2_players': team2Players,
        'set1_team1_score': set1Team1Score,
        'set1_team2_score': set1Team2Score,
        'set2_team1_score': set2Team1Score,
        'set2_team2_score': set2Team2Score,
        'set3_team1_score': set3Team1Score,
        'set3_team2_score': set3Team2Score,
        'winning_team': winningTeam,
        'is_verified': false,
      }).select();

      return {
        'success': true,
        'message': 'Scores recorded successfully',
        'data': result,
      };
    } catch (e) {
      print('Error recording scores: $e');
      return {
        'success': false,
        'message': 'Failed to record scores: ${e.toString()}',
      };
    }
  }

  /// Rate a player
  static Future<Map<String, dynamic>> ratePlayer({
    required String gameId,
    required String ratedUserId,
    required String ratedByUserId,
    required int rating,
    int? skillRating,
    int? sportsmanshipRating,
    String? comment,
  }) async {
    try {
      // Check if rating already exists
      final existing = await _client
          .schema('playnow')
          .from('game_ratings')
          .select()
          .eq('game_id', gameId)
          .eq('rated_user_id', ratedUserId)
          .eq('rated_by_user_id', ratedByUserId)
          .maybeSingle();

      if (existing != null) {
        return {
          'success': false,
          'message': 'You have already rated this player',
        };
      }

      final result =
          await _client.schema('playnow').from('game_ratings').insert({
        'game_id': gameId,
        'rated_user_id': ratedUserId,
        'rated_by_user_id': ratedByUserId,
        'rating': rating,
        'skill_rating': skillRating,
        'sportsmanship_rating': sportsmanshipRating,
        'comment': comment,
      }).select();

      return {
        'success': true,
        'message': 'Rating submitted successfully',
        'data': result,
      };
    } catch (e) {
      print('Error rating player: $e');
      return {
        'success': false,
        'message': 'Failed to submit rating: ${e.toString()}',
      };
    }
  }

  /// Tag a player
  static Future<Map<String, dynamic>> tagPlayer({
    required String gameId,
    required String taggedUserId,
    required String taggedByUserId,
    required String tag,
  }) async {
    try {
      final result =
          await _client.schema('playnow').from('game_player_tags').insert({
        'game_id': gameId,
        'tagged_user_id': taggedUserId,
        'tagged_by_user_id': taggedByUserId,
        'tag': tag,
      }).select();

      return {
        'success': true,
        'message': 'Tag added successfully',
        'data': result,
      };
    } catch (e) {
      print('Error tagging player: $e');
      return {
        'success': false,
        'message': 'Failed to add tag: ${e.toString()}',
      };
    }
  }

  /// Add a play pal
  static Future<Map<String, dynamic>> addPlayPal({
    required String userId,
    required String partnerId,
    required String sportType,
    bool isFavorite = false,
  }) async {
    try {
      // Check if play pal already exists
      final existing = await _client
          .schema('playnow')
          .from('play_pals')
          .select()
          .eq('user_id', userId)
          .eq('partner_id', partnerId)
          .eq('sport_type', sportType)
          .maybeSingle();

      if (existing != null) {
        return {
          'success': false,
          'message': 'This player is already in your play pals',
        };
      }

      final result = await _client.schema('playnow').from('play_pals').insert({
        'user_id': userId,
        'partner_id': partnerId,
        'sport_type': sportType,
        'is_favorite': isFavorite,
        'games_played_together': 1,
        'last_played_at': DateTime.now().toIso8601String(),
      }).select();

      return {
        'success': true,
        'message': 'Play pal added successfully',
        'data': result,
      };
    } catch (e) {
      print('Error adding play pal: $e');
      return {
        'success': false,
        'message': 'Failed to add play pal: ${e.toString()}',
      };
    }
  }

  /// Get existing ratings for a game by current user
  static Future<List<String>> getRatedPlayerIds({
    required String gameId,
    required String userId,
  }) async {
    try {
      final results = await _client
          .schema('playnow')
          .from('game_ratings')
          .select('rated_user_id')
          .eq('game_id', gameId)
          .eq('rated_by_user_id', userId);

      return results.map((r) => r['rated_user_id'] as String).toList();
    } catch (e) {
      print('Error fetching rated players: $e');
      return [];
    }
  }

  /// Get existing play pals
  static Future<List<String>> getPlayPalIds({
    required String userId,
    required String sportType,
  }) async {
    try {
      final results = await _client
          .schema('playnow')
          .from('play_pals')
          .select('partner_id')
          .eq('user_id', userId)
          .eq('sport_type', sportType);

      return results.map((r) => r['partner_id'] as String).toList();
    } catch (e) {
      print('Error fetching play pals: $e');
      return [];
    }
  }

  /// Check if scores have been recorded for a game
  static Future<bool> hasRecordedScores({
    required String gameId,
    required String userId,
  }) async {
    try {
      final result = await _client
          .schema('playnow')
          .from('game_results')
          .select()
          .eq('game_id', gameId)
          .eq('submitted_by', userId)
          .maybeSingle();

      return result != null;
    } catch (e) {
      print('Error checking recorded scores: $e');
      return false;
    }
  }
}
