import '/backend/supabase/supabase.dart';
import '../models/game_completion_model.dart';
import '../models/game_model.dart';

/// Service for managing game completions and ratings
class GameCompletionService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Complete a game with result and rating
  static Future<bool> completeGame({
    required String gameId,
    required String userId,
    String? result,
    int? rating,
    String? feedback,
  }) async {
    try {
      await _client.schema('playnow').from('game_completions').insert({
        'game_id': gameId,
        'user_id': userId,
        'result': result,
        'rating': rating,
        'feedback': feedback,
      });
      return true;
    } catch (e) {
      print('Error completing game: $e');
      return false;
    }
  }

  /// Check if user has completed a game
  static Future<bool> hasUserCompletedGame({
    required String gameId,
    required String userId,
  }) async {
    try {
      final result = await _client
          .schema('playnow').from('game_completions')
          .select('id')
          .eq('game_id', gameId)
          .eq('user_id', userId)
          .maybeSingle();

      return result != null;
    } catch (e) {
      print('Error checking game completion: $e');
      return false;
    }
  }

  /// Rate another player
  static Future<bool> ratePlayer({
    required String gameId,
    required String raterUserId,
    required String ratedUserId,
    required int skillRating,
    required int sportsmanshipRating,
    String? comment,
  }) async {
    try {
      // Check if already rated
      final existing = await _client
          .schema('playnow').from('player_ratings')
          .select('id')
          .eq('game_id', gameId)
          .eq('rater_user_id', raterUserId)
          .eq('rated_user_id', ratedUserId)
          .maybeSingle();

      if (existing != null) {
        // Update existing rating
        await _client
            .schema('playnow').from('player_ratings')
            .update({
              'skill_rating': skillRating,
              'sportsmanship_rating': sportsmanshipRating,
              'comment': comment,
            })
            .eq('id', existing['id']);
      } else {
        // Create new rating
        await _client.schema('playnow').from('player_ratings').insert({
          'game_id': gameId,
          'rater_user_id': raterUserId,
          'rated_user_id': ratedUserId,
          'skill_rating': skillRating,
          'sportsmanship_rating': sportsmanshipRating,
          'comment': comment,
        });
      }

      return true;
    } catch (e) {
      print('Error rating player: $e');
      return false;
    }
  }

  /// Get players to rate (other participants in the game)
  static Future<List<RatablePlayer>> getPlayersToRate({
    required String gameId,
    required String currentUserId,
  }) async {
    try {
      // Get all participants except current user
      final response = await _client
          .schema('playnow').from('game_participants')
          .select('user_id, users!game_participants_user_id_fkey(first_name, profile_picture)')
          .eq('game_id', gameId)
          .neq('user_id', currentUserId) as List;

      final players = <RatablePlayer>[];

      for (final row in response) {
        final userId = row['user_id'] as String;
        final userData = row['users'] as Map<String, dynamic>?;

        // Check if already rated
        final ratingExists = await _client
            .schema('playnow').from('player_ratings')
            .select('id')
            .eq('game_id', gameId)
            .eq('rater_user_id', currentUserId)
            .eq('rated_user_id', userId)
            .maybeSingle();

        players.add(RatablePlayer(
          userId: userId,
          displayName: userData?['first_name'] as String? ?? 'Unknown',
          photoUrl: userData?['profile_picture'] as String?,
          isRated: ratingExists != null,
        ));
      }

      return players;
    } catch (e) {
      print('Error getting players to rate: $e');
      return [];
    }
  }

  /// Get user's average ratings
  static Future<Map<String, double>> getUserAverageRatings(String userId) async {
    try {
      final response = await _client
          .schema('playnow').from('player_ratings')
          .select('skill_rating, sportsmanship_rating')
          .eq('rated_user_id', userId) as List;

      if (response.isEmpty) {
        return {'skill': 0.0, 'sportsmanship': 0.0, 'count': 0.0};
      }

      double skillSum = 0;
      double sportsmanshipSum = 0;

      for (final rating in response) {
        skillSum += (rating['skill_rating'] as int).toDouble();
        sportsmanshipSum += (rating['sportsmanship_rating'] as int).toDouble();
      }

      return {
        'skill': skillSum / response.length,
        'sportsmanship': sportsmanshipSum / response.length,
        'count': response.length.toDouble(),
      };
    } catch (e) {
      print('Error getting average ratings: $e');
      return {'skill': 0.0, 'sportsmanship': 0.0, 'count': 0.0};
    }
  }

  /// Get completed games for a user
  static Future<List<Game>> getUserCompletedGames(String userId) async {
    try {
      final response = await _client
          .schema('playnow').from('game_completions')
          .select('game_id, playnow.games(*)')
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .limit(20) as List;

      return response.map((row) {
        final gameData = row['playnow_games'] as Map<String, dynamic>;
        return Game.fromJson(gameData);
      }).toList();
    } catch (e) {
      print('Error getting completed games: $e');
      return [];
    }
  }

  /// Mark game as completed for all participants (call after game time)
  static Future<bool> markGameAsCompleted(String gameId) async {
    try {
      await _client
          .schema('playnow').from('games')
          .update({'status': 'completed'})
          .eq('id', gameId);
      return true;
    } catch (e) {
      print('Error marking game as completed: $e');
      return false;
    }
  }
}
