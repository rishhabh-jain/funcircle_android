import '/backend/supabase/supabase.dart';
import '../models/player_request_model.dart';
import '../models/user_location_model.dart';
import '../models/venue_marker_model.dart';
import '../models/game_session_model.dart';

/// Service class for map-related database operations
class MapService {
  static final SupabaseClient _client = SupaFlow.client;

  // ==================== VENUES ====================

  /// Fetch venues for a specific sport type
  /// Returns all venues (since venues don't have sport_type filtering in the schema)
  static Future<List<VenueMarkerModel>> getVenues() async {
    try {
      final response = await _client
          .from('venues')
          .select('id, venue_name, location, lat, lng, images, description')
          .not('lat', 'is', null)
          .not('lng', 'is', null);

      return (response as List)
          .map((json) => VenueMarkerModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return [];
    }
  }

  // ==================== PLAYER LOCATIONS ====================

  /// Fetch available players by sport type
  static Future<List<UserLocationModel>> getAvailablePlayersBySport(
    String sportType,
  ) async {
    try {
      final response =
          await _client.from('findplayers.user_locations').select('''
            id,
            user_id,
            latitude,
            longitude,
            is_available,
            sport_type,
            skill_level,
            updated_at,
            user:user_id (
              first_name,
              profile_picture
            )
          ''').eq('is_available', true).eq('sport_type', sportType);

      return (response as List).map((json) {
        // Flatten user data
        final userData = json['user'] as Map<String, dynamic>?;
        return UserLocationModel.fromJson({
          ...json,
          'user_name': userData?['first_name'],
          'user_profile_picture': userData?['profile_picture'],
        });
      }).toList();
    } catch (e) {
      print('Error fetching available players: $e');
      return [];
    }
  }

  /// Update user location and availability
  static Future<bool> updateUserLocation({
    required String userId,
    required double latitude,
    required double longitude,
    required bool isAvailable,
    String? sportType,
    int? skillLevel,
  }) async {
    try {
      await _client.from('findplayers.user_locations').upsert({
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
        'is_available': isAvailable,
        'sport_type': sportType,
        'skill_level': skillLevel,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error updating user location: $e');
      return false;
    }
  }

  /// Remove user from available players
  static Future<bool> setUserUnavailable(String userId) async {
    try {
      await _client
          .from('findplayers.user_locations')
          .update({'is_available': false}).eq('user_id', userId);
      return true;
    } catch (e) {
      print('Error setting user unavailable: $e');
      return false;
    }
  }

  // ==================== PLAYER REQUESTS ====================

  /// Fetch active player requests by sport type
  static Future<List<PlayerRequestModel>> getActiveRequestsBySport(
    String sportType,
  ) async {
    try {
      final response = await _client
          .from('findplayers.player_requests')
          .select('''
            id,
            user_id,
            sport_type,
            venue_id,
            custom_location,
            latitude,
            longitude,
            players_needed,
            scheduled_time,
            skill_level,
            description,
            status,
            created_at,
            expires_at,
            user:user_id (
              first_name,
              profile_picture,
              skill_level_badminton,
              skill_level_pickleball
            )
          ''')
          .eq('status', 'active')
          .eq('sport_type', sportType)
          .gt('expires_at', DateTime.now().toIso8601String());

      return (response as List).map((json) {
        // Flatten user data and get appropriate skill level
        final userData = json['user'] as Map<String, dynamic>?;
        final int? userSkillLevel = sportType.toLowerCase() == 'badminton'
            ? (userData?['skill_level_badminton'] as int?)
            : (userData?['skill_level_pickleball'] as int?);

        return PlayerRequestModel.fromJson({
          ...json,
          'user_name': userData?['first_name'],
          'user_profile_picture': userData?['profile_picture'],
          'user_skill_level': userSkillLevel,
        });
      }).toList();
    } catch (e) {
      print('Error fetching active requests: $e');
      return [];
    }
  }

  /// Create a new player request
  static Future<String?> createPlayerRequest({
    required String userId,
    required String sportType,
    int? venueId,
    String? customLocation,
    double? latitude,
    double? longitude,
    required int playersNeeded,
    required DateTime scheduledTime,
    int? skillLevel,
    String? description,
    required DateTime expiresAt,
  }) async {
    try {
      final response = await _client
          .from('findplayers.player_requests')
          .insert({
            'user_id': userId,
            'sport_type': sportType,
            'venue_id': venueId,
            'custom_location': customLocation,
            'latitude': latitude,
            'longitude': longitude,
            'players_needed': playersNeeded,
            'scheduled_time': scheduledTime.toIso8601String(),
            'skill_level': skillLevel,
            'description': description,
            'status': 'active',
            'expires_at': expiresAt.toIso8601String(),
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating player request: $e');
      return null;
    }
  }

  /// Respond to a player request
  static Future<bool> respondToRequest({
    required String requestId,
    required String responderId,
    String? message,
  }) async {
    try {
      await _client.from('findplayers.player_request_responses').insert({
        'request_id': requestId,
        'responder_id': responderId,
        'message': message,
        'status': 'pending',
      });
      return true;
    } catch (e) {
      print('Error responding to request: $e');
      return false;
    }
  }

  // ==================== GAME SESSIONS ====================

  /// Fetch open game sessions by sport type
  static Future<List<GameSessionModel>> getGameSessionsBySport(
    String sportType,
  ) async {
    try {
      final response = await _client
          .from('findplayers.game_sessions')
          .select('''
            id,
            creator_id,
            sport_type,
            venue_id,
            session_type,
            max_players,
            current_players,
            scheduled_time,
            duration_minutes,
            skill_level_required,
            is_private,
            session_code,
            status,
            latitude,
            longitude,
            cost_per_player,
            notes,
            created_at,
            creator:creator_id (
              first_name,
              profile_picture
            )
          ''')
          .eq('sport_type', sportType)
          .inFilter('status', ['open', 'full'])
          .gt('scheduled_time', DateTime.now().toIso8601String());

      return (response as List).map((json) {
        // Flatten creator data
        final creatorData = json['creator'] as Map<String, dynamic>?;
        return GameSessionModel.fromJson({
          ...json,
          'creator_name': creatorData?['first_name'],
          'creator_profile_picture': creatorData?['profile_picture'],
        });
      }).toList();
    } catch (e) {
      print('Error fetching game sessions: $e');
      return [];
    }
  }

  /// Create a new game session
  static Future<String?> createGameSession({
    required String creatorId,
    required String sportType,
    int? venueId,
    required String sessionType,
    required int maxPlayers,
    required DateTime scheduledTime,
    int durationMinutes = 60,
    int? skillLevelRequired,
    bool isPrivate = false,
    String? sessionCode,
    double? latitude,
    double? longitude,
    double? costPerPlayer,
    String? notes,
  }) async {
    try {
      final response = await _client
          .from('findplayers.game_sessions')
          .insert({
            'creator_id': creatorId,
            'sport_type': sportType,
            'venue_id': venueId,
            'session_type': sessionType,
            'max_players': maxPlayers,
            'current_players': [creatorId], // Creator auto-joins
            'scheduled_time': scheduledTime.toIso8601String(),
            'duration_minutes': durationMinutes,
            'skill_level_required': skillLevelRequired,
            'is_private': isPrivate,
            'session_code': sessionCode,
            'status': 'open',
            'latitude': latitude,
            'longitude': longitude,
            'cost_per_player': costPerPlayer,
            'notes': notes,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating game session: $e');
      return null;
    }
  }

  /// Join a game session
  static Future<bool> joinGameSession({
    required String sessionId,
    required String userId,
  }) async {
    try {
      // First, get the current session
      final session = await _client
          .from('findplayers.game_sessions')
          .select('current_players, max_players, status')
          .eq('id', sessionId)
          .single();

      final currentPlayers = List<String>.from(session['current_players'] ?? []);
      final maxPlayers = session['max_players'] as int;
      final status = session['status'] as String;

      // Check if user already joined
      if (currentPlayers.contains(userId)) {
        print('User already in session');
        return false;
      }

      // Check if session is full
      if (currentPlayers.length >= maxPlayers) {
        print('Session is full');
        return false;
      }

      // Check if session is still open
      if (status != 'open') {
        print('Session is not open');
        return false;
      }

      // Add user to session
      currentPlayers.add(userId);
      final newStatus = currentPlayers.length >= maxPlayers ? 'full' : 'open';

      await _client.from('findplayers.game_sessions').update({
        'current_players': currentPlayers,
        'status': newStatus,
      }).eq('id', sessionId);

      return true;
    } catch (e) {
      print('Error joining game session: $e');
      return false;
    }
  }

  /// Leave a game session
  static Future<bool> leaveGameSession({
    required String sessionId,
    required String userId,
  }) async {
    try {
      // Get the current session
      final session = await _client
          .from('findplayers.game_sessions')
          .select('current_players, creator_id')
          .eq('id', sessionId)
          .single();

      final currentPlayers = List<String>.from(session['current_players'] ?? []);
      final creatorId = session['creator_id'] as String;

      // Check if user is in session
      if (!currentPlayers.contains(userId)) {
        print('User not in session');
        return false;
      }

      // Creator cannot leave their own session, they must cancel it
      if (userId == creatorId) {
        print('Creator cannot leave, must cancel session');
        return false;
      }

      // Remove user from session
      currentPlayers.remove(userId);

      await _client.from('findplayers.game_sessions').update({
        'current_players': currentPlayers,
        'status': 'open', // Session becomes open again
      }).eq('id', sessionId);

      return true;
    } catch (e) {
      print('Error leaving game session: $e');
      return false;
    }
  }

  // ==================== CHAT / CONNECTION ====================

  /// Create or get existing 1-on-1 chat room between two users
  /// Returns the room ID that can be used to navigate to chat
  static Future<String?> createOrGetChatRoom({
    required String userId1,
    required String userId2,
  }) async {
    try {
      // Check if a chat room already exists between these two users
      final existingRooms = await _client
          .from('chat.rooms')
          .select('id, room_members!inner(user_id)')
          .eq('type', 'single');

      // Find room where both users are members
      for (final room in existingRooms as List) {
        final members = await _client
            .from('chat.room_members')
            .select('user_id')
            .eq('room_id', room['id']);

        final memberIds =
            (members as List).map((m) => m['user_id'] as String).toList();
        if (memberIds.contains(userId1) && memberIds.contains(userId2)) {
          return room['id'] as String;
        }
      }

      // Create new chat room if none exists
      final roomResponse = await _client
          .from('chat.rooms')
          .insert({
            'type': 'single',
            'is_active': true,
            'created_by': userId1,
          })
          .select('id')
          .single();

      final roomId = roomResponse['id'] as String;

      // Add both users as members
      await _client.from('chat.room_members').insert([
        {
          'room_id': roomId,
          'user_id': userId1,
          'role': 'member',
        },
        {
          'room_id': roomId,
          'user_id': userId2,
          'role': 'member',
        },
      ]);

      return roomId;
    } catch (e) {
      print('Error creating/getting chat room: $e');
      return null;
    }
  }

  // ==================== REAL-TIME SUBSCRIPTIONS ====================

  /// Subscribe to player requests for a sport type
  static Stream<List<PlayerRequestModel>> subscribeToRequests(
    String sportType,
  ) {
    return _client
        .from('findplayers.player_requests')
        .stream(primaryKey: ['id']).map((data) {
      return data
          .where((json) =>
              json['sport_type'] == sportType && json['status'] == 'active')
          .map((json) => PlayerRequestModel.fromJson(json))
          .toList();
    });
  }

  /// Subscribe to player locations for a sport type
  static Stream<List<UserLocationModel>> subscribeToPlayerLocations(
    String sportType,
  ) {
    return _client
        .from('findplayers.user_locations')
        .stream(primaryKey: ['id']).map((data) {
      return data
          .where((json) =>
              json['sport_type'] == sportType && json['is_available'] == true)
          .map((json) => UserLocationModel.fromJson(json))
          .toList();
    });
  }

  /// Subscribe to game sessions for a sport type
  static Stream<List<GameSessionModel>> subscribeToGameSessions(
    String sportType,
  ) {
    return _client
        .from('findplayers.game_sessions')
        .stream(primaryKey: ['id']).map((data) {
      return data
          .where((json) => json['sport_type'] == sportType)
          .map((json) => GameSessionModel.fromJson(json))
          .toList();
    });
  }
}
