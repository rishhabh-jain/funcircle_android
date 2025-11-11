import '/backend/supabase/supabase.dart';
import '../models/user_location_model.dart';
import '../models/skill_level.dart';
import 'location_service.dart';

/// Match recommendation model
class MatchRecommendation {
  final UserLocationModel player;
  final double distanceKm;
  final double compatibilityScore; // 0-1
  final String compatibilityReason;

  MatchRecommendation({
    required this.player,
    required this.distanceKm,
    required this.compatibilityScore,
    required this.compatibilityReason,
  });
}

/// Service for Quick Match feature - AI-powered player matching
class QuickMatchService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Get recommended matches for a user based on various factors
  static Future<List<MatchRecommendation>> getRecommendedMatches({
    required String userId,
    required String sportType,
    required double userLatitude,
    required double userLongitude,
    int? userSkillLevel,
    double maxDistanceKm = 10.0,
    int maxResults = 5,
  }) async {
    try {
      // Fetch all available players for the sport
      final players = await _fetchAvailablePlayers(sportType, userId);

      // Calculate compatibility scores for each player
      final recommendations = <MatchRecommendation>[];

      for (final player in players) {
        // Calculate distance
        final distance = LocationService.calculateDistance(
          startLatitude: userLatitude,
          startLongitude: userLongitude,
          endLatitude: player.latitude,
          endLongitude: player.longitude,
        );

        // Skip if beyond max distance
        if (distance > maxDistanceKm) continue;

        // Calculate compatibility score
        final scoreData = _calculateCompatibilityScore(
          distance: distance,
          maxDistance: maxDistanceKm,
          userSkillLevel: userSkillLevel,
          playerSkillLevel: player.skillLevel,
        );

        recommendations.add(MatchRecommendation(
          player: player,
          distanceKm: distance,
          compatibilityScore: scoreData['score'] as double,
          compatibilityReason: scoreData['reason'] as String,
        ));
      }

      // Sort by compatibility score (highest first)
      recommendations
          .sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));

      // Return top N matches
      return recommendations.take(maxResults).toList();
    } catch (e) {
      print('Error getting recommended matches: $e');
      return [];
    }
  }

  /// Fetch available players excluding the current user
  static Future<List<UserLocationModel>> _fetchAvailablePlayers(
    String sportType,
    String excludeUserId,
  ) async {
    try {
      final response = await _client
          .schema('findplayers')
          .from('user_locations')
          .select('''
            id,
            user_id,
            latitude,
            longitude,
            is_available,
            sport_type,
            skill_level,
            updated_at
          ''')
          .eq('is_available', true)
          .eq('sport_type', sportType)
          .neq('user_id', excludeUserId);

      // Fetch user details separately for each location
      final List<UserLocationModel> locations = [];
      for (final json in (response as List)) {
        final userId = json['user_id'] as String?;
        Map<String, dynamic>? userData;

        if (userId != null) {
          try {
            userData = await _client
                .from('users')
                .select('first_name, profile_picture')
                .eq('user_id', userId)
                .maybeSingle();
          } catch (e) {
            print('Error fetching user $userId: $e');
          }
        }

        locations.add(UserLocationModel.fromJson({
          ...json,
          'user_name': userData?['first_name'],
          'user_profile_picture': userData?['profile_picture'],
        }));
      }

      return locations;
    } catch (e) {
      print('Error fetching available players: $e');
      return [];
    }
  }

  /// Calculate compatibility score based on multiple factors
  static Map<String, dynamic> _calculateCompatibilityScore({
    required double distance,
    required double maxDistance,
    int? userSkillLevel,
    int? playerSkillLevel,
  }) {
    double score = 0.0;
    final reasons = <String>[];

    // Distance factor (50% weight)
    // Closer players get higher scores
    final distanceScore = 1.0 - (distance / maxDistance);
    score += distanceScore * 0.5;

    if (distance < 2.0) {
      reasons.add('Very close by');
    } else if (distance < 5.0) {
      reasons.add('Nearby');
    }

    // Skill level compatibility (50% weight)
    if (userSkillLevel != null && playerSkillLevel != null) {
      final skillDifference = (userSkillLevel - playerSkillLevel).abs();

      if (skillDifference == 0) {
        // Perfect match
        score += 0.5;
        reasons.add('Same skill level');
      } else if (skillDifference == 1) {
        // Good match (±1 level)
        score += 0.4;
        reasons.add('Similar skill level');
      } else if (skillDifference == 2) {
        // Acceptable match
        score += 0.25;
        reasons.add('Compatible skill level');
      } else {
        // Different skill levels
        score += 0.1;
        if (playerSkillLevel > userSkillLevel) {
          reasons.add('More experienced player');
        } else {
          reasons.add('Less experienced player');
        }
      }
    } else {
      // No skill level data, give neutral score
      score += 0.25;
    }

    // Format reason string
    String reason =
        reasons.isNotEmpty ? reasons.join(' • ') : 'Compatible player';

    return {
      'score': score.clamp(0.0, 1.0),
      'reason': reason,
    };
  }

  /// Record a match interaction (for future ML improvements)
  static Future<void> recordMatchInteraction({
    required String userId,
    required String matchedUserId,
    required String sportType,
    required String action, // 'connect', 'skip', 'later'
    double? compatibilityScore,
  }) async {
    try {
      await _client.schema('findplayers').from('match_history').insert({
        'user1_id': userId,
        'user2_id': matchedUserId,
        'sport_type': sportType,
        'match_quality_score': compatibilityScore,
        'user1_feedback': action == 'connect'
            ? 'positive'
            : (action == 'skip' ? 'negative' : 'neutral'),
        'played_together': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error recording match interaction: $e');
    }
  }

  /// Get user's match preferences
  static Future<Map<String, dynamic>?> getUserPreferences({
    required String userId,
    required String sportType,
  }) async {
    try {
      final response = await _client
          .schema('findplayers')
          .from('match_preferences')
          .select()
          .eq('user_id', userId)
          .eq('sport_type', sportType)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error getting user preferences: $e');
      return null;
    }
  }

  /// Update user's match preferences
  static Future<bool> updateUserPreferences({
    required String userId,
    required String sportType,
    double? maxDistanceKm,
    List<int>? skillLevelRange,
    bool? autoMatchEnabled,
    bool? notificationEnabled,
  }) async {
    try {
      await _client.schema('findplayers').from('match_preferences').upsert({
        'user_id': userId,
        'sport_type': sportType,
        if (maxDistanceKm != null) 'max_distance_km': maxDistanceKm,
        if (skillLevelRange != null) 'skill_level_range': skillLevelRange,
        if (autoMatchEnabled != null) 'auto_match_enabled': autoMatchEnabled,
        if (notificationEnabled != null)
          'notification_enabled': notificationEnabled,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error updating user preferences: $e');
      return false;
    }
  }

  /// Cancel a player request (creator only)
  static Future<bool> cancelRequest({
    required String requestId,
    required String userId,
  }) async {
    try {
      // Get request info
      final requestData = await _client
          .schema('findplayers')
          .from('player_requests')
          .select()
          .eq('id', requestId)
          .single();

      // Verify user is the creator
      if (requestData['user_id'] != userId) {
        throw Exception('Only the request creator can cancel the request');
      }

      // Check if request can be cancelled
      final status = requestData['status'] as String;
      if (status == 'fulfilled' || status == 'expired') {
        throw Exception('Cannot cancel a fulfilled or expired request');
      }

      // Update request status
      await _client
          .schema('findplayers')
          .from('player_requests')
          .update({'status': 'cancelled'})
          .eq('id', requestId);

      // TODO: Notify interested users

      return true;
    } catch (e) {
      print('Error cancelling request: $e');
      rethrow;
    }
  }

  /// Edit a player request (creator only)
  static Future<bool> editRequest({
    required String requestId,
    required String userId,
    DateTime? scheduledTime,
    int? venueId,
    String? customLocation,
    double? latitude,
    double? longitude,
    int? playersNeeded,
    int? skillLevel,
    String? description,
  }) async {
    try {
      // Get request info
      final requestData = await _client
          .schema('findplayers')
          .from('player_requests')
          .select()
          .eq('id', requestId)
          .single();

      // Verify user is the creator
      if (requestData['user_id'] != userId) {
        throw Exception('Only the request creator can edit the request');
      }

      // Check if request can be edited
      final status = requestData['status'] as String;
      if (status == 'fulfilled' || status == 'expired' || status == 'cancelled') {
        throw Exception('Cannot edit a fulfilled, expired, or cancelled request');
      }

      // Build update map
      final updates = <String, dynamic>{};

      if (scheduledTime != null) {
        updates['scheduled_time'] = scheduledTime.toIso8601String();
        // Update expiry time (24 hours after scheduled time or current time, whichever is later)
        final expiresAt = scheduledTime.isAfter(DateTime.now())
            ? scheduledTime.add(const Duration(hours: 24))
            : DateTime.now().add(const Duration(hours: 24));
        updates['expires_at'] = expiresAt.toIso8601String();
      }
      if (venueId != null) updates['venue_id'] = venueId;
      if (customLocation != null) updates['custom_location'] = customLocation;
      if (latitude != null) updates['latitude'] = latitude;
      if (longitude != null) updates['longitude'] = longitude;
      if (playersNeeded != null) updates['players_needed'] = playersNeeded;
      if (skillLevel != null) updates['skill_level'] = skillLevel;
      if (description != null) updates['description'] = description;

      // Update request
      await _client
          .schema('findplayers')
          .from('player_requests')
          .update(updates)
          .eq('id', requestId);

      // TODO: Notify interested users about changes

      return true;
    } catch (e) {
      print('Error editing request: $e');
      rethrow;
    }
  }
}
