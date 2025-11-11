import '/backend/supabase/supabase.dart';
import '../models/game_model.dart';
import '../../services/notifications_service.dart';

/// Service for managing games in playnow schema
class GameService {
  static SupabaseClient get _client => SupaFlow.client;
  static NotificationsService get _notificationService => NotificationsService(_client);

  /// Create a new game
  static Future<Game?> createGame(CreateGameRequest request) async {
    try {
      print('\n========================================');
      print('CREATING GAME - START');
      print('========================================');

      final jsonData = request.toJson();
      print('Request data:');
      jsonData.forEach((key, value) {
        print('  $key: $value (${value.runtimeType})');
      });

      print('\nAttempting to insert into playnow.games...');

      try {
        final gameData = await _client
            .schema('playnow').from('games')
            .insert(jsonData)
            .select()
            .single();

        print('✓ Game inserted successfully!');
        print('Game data received: $gameData');

        final game = Game.fromJson(gameData);
        print('✓ Game model created with ID: ${game.id}');

        // Create chat room first
        print('\nCreating chat room...');
        String? chatRoomId;
        try {
          chatRoomId = await _createGameChatRoom(game);
          if (chatRoomId != null) {
            // Update game with chat_room_id
            await _client.schema('playnow').from('games')
                .update({'chat_room_id': chatRoomId})
                .eq('id', game.id);
            print('✓ Chat room created and linked to game');
          }
        } catch (e) {
          print('✗ Error creating chat room: $e');
          // Don't fail if chat room creation fails
        }

        // Add creator as first participant (after chat room is created)
        print('\nAdding creator as participant...');
        try {
          await _client.schema('playnow').from('game_participants').insert({
            'game_id': game.id,
            'user_id': request.userId,
            'join_type': 'creator',
          });
          print('✓ Creator added as participant');
        } catch (e) {
          print('✗ Error adding participant: $e');
          // Continue anyway
        }

        print('\n========================================');
        print('GAME CREATION SUCCESSFUL');
        print('========================================\n');
        return game;

      } catch (insertError) {
        print('\n✗ INSERT FAILED!');
        print('Error: $insertError');

        if (insertError.toString().contains('relation') ||
            insertError.toString().contains('does not exist')) {
          print('\n⚠ TABLE DOES NOT EXIST');
          print('Please run the database migration script.');
        } else if (insertError.toString().contains('permission') ||
                   insertError.toString().contains('policy')) {
          print('\n⚠ PERMISSION DENIED');
          print('Please check RLS policies on playnow.games table.');
        } else if (insertError.toString().contains('violates')) {
          print('\n⚠ CONSTRAINT VIOLATION');
          print('Check foreign keys and required fields.');
        }

        throw insertError;
      }

    } catch (e, stackTrace) {
      print('\n========================================');
      print('GAME CREATION FAILED');
      print('========================================');
      print('Error: $e');
      print('Stack trace:');
      print(stackTrace);
      print('========================================\n');
      return null;
    }
  }

  /// Join a game (auto-join if allowed, otherwise request)
  static Future<JoinGameResult> joinGame({
    required String gameId,
    required String userId,
    String? message,
  }) async {
    try {
      // Get game details
      final gameData = await _client
          .schema('playnow').from('games')
          .select()
          .eq('id', gameId)
          .single();

      final game = Game.fromJson(gameData);

      // Check if already joined
      final existingParticipant = await _client
          .schema('playnow').from('game_participants')
          .select()
          .eq('game_id', gameId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingParticipant != null) {
        return JoinGameResult(
          success: false,
          message: 'You have already joined this game',
        );
      }

      // Check if game is full
      if (game.isFull) {
        return JoinGameResult(
          success: false,
          message: 'Game is full',
        );
      }

      // Check if game is open
      if (game.status != 'open') {
        return JoinGameResult(
          success: false,
          message: 'Game is no longer accepting players',
        );
      }

      // Auto join or request to join
      if (game.joinType == 'auto') {
        // Auto join
        await _client.schema('playnow').from('game_participants').insert({
          'game_id': gameId,
          'user_id': userId,
          'join_type': 'auto_join',
        });

        // Update current players count
        await _updatePlayersCount(gameId);

        // Add user to chat room
        await _addUserToChatRoom(gameId, userId);

        // Notify game creator
        final userData = await _client
            .from('users')
            .select('first_name')
            .eq('user_id', userId)
            .maybeSingle();

        if (userData != null) {
          await _notificationService.notifyFriendJoinedGame(
            userId: game.createdBy,
            friendId: userId,
            friendName: userData['first_name'] as String? ?? 'A player',
            gameId: gameId,
            gameDetails: game.autoTitle,
          );
        }

        return JoinGameResult(
          success: true,
          message: 'Successfully joined the game!',
          isAutoJoined: true,
        );
      } else {
        // Request to join
        await _client.schema('playnow').from('game_join_requests').insert({
          'game_id': gameId,
          'user_id': userId,
          'message': message,
          'status': 'pending',
        });

        // Notify game creator
        final userData = await _client
            .from('users')
            .select('first_name')
            .eq('user_id', userId)
            .maybeSingle();

        if (userData != null) {
          await _notificationService.notifyJoinRequestReceived(
            creatorId: game.createdBy,
            requesterId: userId,
            requesterName: userData['first_name'] as String? ?? 'A player',
            gameId: gameId,
            requestId: '', // Will be set by insert
            gameTitle: game.autoTitle,
          );
        }

        return JoinGameResult(
          success: true,
          message: 'Join request sent to game creator',
          isAutoJoined: false,
        );
      }
    } catch (e) {
      print('Error joining game: $e');
      return JoinGameResult(
        success: false,
        message: 'Failed to join game. Please try again.',
      );
    }
  }

  /// Approve a join request (only game creator can do this)
  static Future<bool> approveJoinRequest({
    required String requestId,
    required String gameId,
    required String approverId,
  }) async {
    try {
      // Get request details
      final requestData = await _client
          .schema('playnow').from('game_join_requests')
          .select('user_id')
          .eq('id', requestId)
          .single();

      final userId = requestData['user_id'] as String;

      // Verify game creator
      final gameData = await _client
          .schema('playnow').from('games')
          .select('created_by, current_players_count, players_needed')
          .eq('id', gameId)
          .single();

      if (gameData['created_by'] != approverId) {
        return false; // Only creator can approve
      }

      // Check if game is full
      final currentPlayers = gameData['current_players_count'] as int;
      final playersNeeded = gameData['players_needed'] as int;
      if (currentPlayers >= playersNeeded) {
        return false; // Game is full
      }

      // Update request status
      await _client
          .schema('playnow').from('game_join_requests')
          .update({'status': 'approved', 'responded_at': DateTime.now().toIso8601String()})
          .eq('id', requestId);

      // Add participant
      await _client.schema('playnow').from('game_participants').insert({
        'game_id': gameId,
        'user_id': userId,
        'join_type': 'request',
      });

      // Update players count
      await _updatePlayersCount(gameId);

      // Add to chat room
      await _addUserToChatRoom(gameId, userId);

      // Notify user
      final gameData2 = await _client
          .schema('playnow').from('games')
          .select()
          .eq('id', gameId)
          .single();
      final game = Game.fromJson(gameData2);

      await _notificationService.notifyJoinRequestApproved(
        requesterId: userId,
        gameId: gameId,
        gameTitle: game.autoTitle,
      );

      return true;
    } catch (e) {
      print('Error approving join request: $e');
      return false;
    }
  }

  /// Decline a join request
  static Future<bool> declineJoinRequest({
    required String requestId,
    required String gameId,
    required String approverId,
  }) async {
    try {
      // Verify game creator
      final gameData = await _client
          .schema('playnow').from('games')
          .select('created_by')
          .eq('id', gameId)
          .single();

      if (gameData['created_by'] != approverId) {
        return false; // Only creator can decline
      }

      // Get user ID and game info for notification
      final requestData = await _client
          .schema('playnow').from('game_join_requests')
          .select('user_id')
          .eq('id', requestId)
          .single();

      final userId = requestData['user_id'] as String;

      final gameData2 = await _client
          .schema('playnow').from('games')
          .select()
          .eq('id', gameId)
          .single();
      final game = Game.fromJson(gameData2);

      // Update request status
      await _client
          .schema('playnow').from('game_join_requests')
          .update({'status': 'declined', 'responded_at': DateTime.now().toIso8601String()})
          .eq('id', requestId);

      // Notify user
      await _notificationService.notifyJoinRequestDeclined(
        requesterId: userId,
        gameId: gameId,
        gameTitle: game.autoTitle,
      );

      return true;
    } catch (e) {
      print('Error declining join request: $e');
      return false;
    }
  }

  /// Cancel a game (creator only)
  static Future<bool> cancelGame({
    required String gameId,
    required String userId,
    String? reason,
  }) async {
    try {
      // Get game info
      final gameData = await _client
          .schema('playnow').from('games')
          .select()
          .eq('id', gameId)
          .single();

      final game = Game.fromJson(gameData);

      // Verify user is the creator
      if (game.createdBy != userId) {
        throw Exception('Only the game creator can cancel the game');
      }

      // Check if game can be cancelled (not already completed)
      if (game.status == 'completed') {
        throw Exception('Cannot cancel a completed game');
      }

      // Get all participants
      final participants = await _client
          .schema('playnow').from('game_participants')
          .select('user_id')
          .eq('game_id', gameId) as List;

      final participantIds = participants
          .map((p) => p['user_id'] as String)
          .where((id) => id != userId) // Don't notify creator
          .toList();

      // Update game status
      await _client
          .schema('playnow').from('games')
          .update({'status': 'cancelled'})
          .eq('id', gameId);

      // Notify all participants
      if (participantIds.isNotEmpty) {
        await _notificationService.notifyGameCancelled(
          participantIds: participantIds,
          gameId: gameId,
          gameTitle: game.autoTitle,
          reason: reason ?? 'The game has been cancelled by the creator.',
        );
      }

      return true;
    } catch (e) {
      print('Error cancelling game: $e');
      rethrow;
    }
  }

  /// Edit a game (creator only)
  static Future<bool> editGame({
    required String gameId,
    required String userId,
    DateTime? gameDate,
    String? startTime,
    String? endTime,
    int? venueId,
    String? customLocation,
    int? playersNeeded,
    String? description,
    bool? isFree,
    double? costPerPlayer,
  }) async {
    try {
      // Get game info
      final gameData = await _client
          .schema('playnow').from('games')
          .select()
          .eq('id', gameId)
          .single();

      final game = Game.fromJson(gameData);

      // Verify user is the creator
      if (game.createdBy != userId) {
        throw Exception('Only the game creator can edit the game');
      }

      // Check if game can be edited (not started or completed)
      if (game.status == 'completed' || game.status == 'in_progress') {
        throw Exception('Cannot edit a game that has started or completed');
      }

      // Build update map
      final updates = <String, dynamic>{};

      if (gameDate != null) {
        updates['game_date'] = gameDate.toIso8601String().split('T')[0];
      }
      if (startTime != null) updates['start_time'] = startTime;
      if (endTime != null) updates['end_time'] = endTime;
      if (venueId != null) updates['venue_id'] = venueId;
      if (customLocation != null) updates['custom_location'] = customLocation;
      if (playersNeeded != null) {
        // Don't allow reducing below current player count
        if (playersNeeded < game.currentPlayersCount) {
          throw Exception('Cannot reduce player count below current participants');
        }
        updates['players_needed'] = playersNeeded;
        // Update status if needed
        if (playersNeeded > game.currentPlayersCount) {
          updates['status'] = 'open';
        }
      }
      if (description != null) updates['description'] = description;
      if (isFree != null) updates['is_free'] = isFree;
      if (costPerPlayer != null) updates['cost_per_player'] = costPerPlayer;

      // Update game
      await _client
          .schema('playnow').from('games')
          .update(updates)
          .eq('id', gameId);

      // TODO: Notify participants about changes

      return true;
    } catch (e) {
      print('Error editing game: $e');
      rethrow;
    }
  }

  /// Leave a game
  static Future<bool> leaveGame({
    required String gameId,
    required String userId,
  }) async {
    try {
      // Get game creator
      final gameData = await _client
          .schema('playnow').from('games')
          .select('created_by')
          .eq('id', gameId)
          .single();

      // If creator is leaving, cancel the game
      if (gameData['created_by'] == userId) {
        return await cancelGame(
          gameId: gameId,
          userId: userId,
          reason: 'The creator left the game.',
        );
      } else {
        // Remove participant
        await _client
            .schema('playnow').from('game_participants')
            .delete()
            .eq('game_id', gameId)
            .eq('user_id', userId);

        // Update players count
        await _updatePlayersCount(gameId);

        // Remove from chat room
        await _removeUserFromChatRoom(gameId, userId);
      }

      return true;
    } catch (e) {
      print('Error leaving game: $e');
      return false;
    }
  }

  /// Get open games for a sport type
  static Future<List<Game>> getOpenGames({
    required String sportType,
    String? gameType,
    int? skillLevel,
    bool? isFree,
    int limit = 20,
  }) async {
    try {
      var query = _client
          .schema('playnow').from('games')
          .select()
          .eq('sport_type', sportType)
          .eq('status', 'open');

      if (gameType != null) {
        query = query.eq('game_type', gameType);
      }

      if (skillLevel != null) {
        query = query.eq('skill_level', skillLevel);
      }

      if (isFree != null) {
        query = query.eq('is_free', isFree);
      }

      final results = await query
          .order('game_date', ascending: true)
          .order('start_time', ascending: true)
          .limit(limit) as List;

      if (results.isEmpty) {
        return [];
      }

      // Get unique creator user IDs
      final creatorIds = results
          .map((g) => g['created_by'] as String)
          .toSet()
          .toList();

      // Fetch creator data from public.users schema
      final userResults = await _client
          .from('users')
          .select('user_id, first_name')
          .inFilter('user_id', creatorIds) as List;

      // Create a map of user data
      final userMap = {
        for (var user in userResults)
          user['user_id'] as String: user as Map<String, dynamic>
      };

      // Get unique venue IDs
      final venueIds = results
          .where((g) => g['venue_id'] != null)
          .map((g) => g['venue_id'] as int)
          .toSet()
          .toList();

      // Fetch venue data from public.venues schema
      Map<int, String> venueMap = {};
      if (venueIds.isNotEmpty) {
        final venueResults = await _client
            .from('venues')
            .select('id, venue_name')
            .inFilter('id', venueIds) as List;

        venueMap = {
          for (var venue in venueResults)
            venue['id'] as int: venue['venue_name'] as String
        };
      }

      // Combine game, creator, and venue data
      final combinedResults = results.map((game) {
        final gameData = game as Map<String, dynamic>;
        final creatorId = gameData['created_by'] as String;
        final creatorData = userMap[creatorId];
        final venueId = gameData['venue_id'] as int?;
        final venueName = venueId != null ? venueMap[venueId] : null;

        return {
          ...gameData,
          'creator': creatorData,
          'venue_name': venueName,
        };
      }).toList();

      // Convert to Game objects
      final games = combinedResults.map((json) => Game.fromJson(json)).toList();

      // Sort Fun Circle organized games to the top
      games.sort((a, b) {
        // Fun Circle games come first
        if (a.isFunCircleOrganized && !b.isFunCircleOrganized) return -1;
        if (!a.isFunCircleOrganized && b.isFunCircleOrganized) return 1;

        // If both are or both aren't Fun Circle games, maintain date/time order
        final dateCompare = a.gameDate.compareTo(b.gameDate);
        if (dateCompare != 0) return dateCompare;

        return a.startTime.compareTo(b.startTime);
      });

      return games;
    } catch (e) {
      print('Error getting open games: $e');
      return [];
    }
  }

  /// Get games filtered by venue, date, and time range
  static Future<List<Game>> getGamesForVenueAndDate({
    required String sportType,
    int? venueId,
    String? date, // Date string in 'yyyy-MM-dd' format
    String? timeOfDay, // 'am' or 'pm'
  }) async {
    try {
      var query = _client
          .schema('playnow')
          .from('games')
          .select()
          .eq('sport_type', sportType)
          .eq('status', 'open');

      // Filter by venue if provided
      if (venueId != null) {
        query = query.eq('venue_id', venueId);
      }

      // Filter by date if provided
      if (date != null) {
        query = query.eq('game_date', date);
      }

      final results = await query
          .order('game_date', ascending: true)
          .order('start_time', ascending: true) as List;

      if (results.isEmpty) {
        return [];
      }

      // Get unique creator user IDs
      final creatorIds = results
          .map((g) => g['created_by'] as String)
          .toSet()
          .toList();

      // Fetch creator data from public.users schema
      final userResults = await _client
          .from('users')
          .select('user_id, first_name')
          .inFilter('user_id', creatorIds) as List;

      // Create a map of user data
      final userMap = {
        for (var user in userResults)
          user['user_id'] as String: user as Map<String, dynamic>
      };

      // Get unique venue IDs
      final venueIds = results
          .where((g) => g['venue_id'] != null)
          .map((g) => g['venue_id'] as int)
          .toSet()
          .toList();

      // Fetch venue data from public.venues schema
      Map<int, String> venueMap = {};
      if (venueIds.isNotEmpty) {
        final venueResults = await _client
            .from('venues')
            .select('id, venue_name')
            .inFilter('id', venueIds) as List;

        venueMap = {
          for (var venue in venueResults)
            venue['id'] as int: venue['venue_name'] as String
        };
      }

      // Combine game, creator, and venue data
      final combinedResults = results.map((game) {
        final gameData = game as Map<String, dynamic>;
        final creatorId = gameData['created_by'] as String;
        final creatorData = userMap[creatorId];
        final venueId = gameData['venue_id'] as int?;
        final venueName = venueId != null ? venueMap[venueId] : null;

        return {
          ...gameData,
          'creator': creatorData,
          'venue_name': venueName,
        };
      }).toList();

      // Convert to Game objects
      var games = combinedResults
          .map((json) => Game.fromJson(json))
          .toList();

      // Filter by time of day if provided (am = 00:00-11:59, pm = 12:00-23:59)
      if (timeOfDay != null) {
        games = games.where((game) {
          try {
            // Parse startTime (format: "HH:mm")
            final hour = int.parse(game.startTime.split(':')[0]);
            if (timeOfDay == 'am') {
              return hour < 12;
            } else {
              return hour >= 12;
            }
          } catch (e) {
            return true; // Include game if time parsing fails
          }
        }).toList();
      }

      // Sort Fun Circle organized games to the top
      games.sort((a, b) {
        // Fun Circle games come first
        if (a.isFunCircleOrganized && !b.isFunCircleOrganized) return -1;
        if (!a.isFunCircleOrganized && b.isFunCircleOrganized) return 1;

        // If both are or both aren't Fun Circle games, maintain date/time order
        final dateCompare = a.gameDate.compareTo(b.gameDate);
        if (dateCompare != 0) return dateCompare;

        return a.startTime.compareTo(b.startTime);
      });

      return games;
    } catch (e) {
      print('Error getting games for venue and date: $e');
      return [];
    }
  }

  /// Get available game dates for the next N days
  static Future<List<DateTime>> getAvailableDates({
    required String sportType,
    int? venueId,
    int daysAhead = 7,
  }) async {
    try {
      final today = DateTime.now();
      final endDate = today.add(Duration(days: daysAhead));

      var query = _client
          .schema('playnow')
          .from('games')
          .select('game_date')
          .eq('sport_type', sportType)
          .eq('status', 'open')
          .gte('game_date', today.toIso8601String().split('T')[0])
          .lte('game_date', endDate.toIso8601String().split('T')[0]);

      if (venueId != null) {
        query = query.eq('venue_id', venueId);
      }

      final results = await query as List;

      // Extract unique dates
      final dates = results
          .map((r) => DateTime.parse(r['game_date'] as String))
          .toSet()
          .toList();

      dates.sort();
      return dates;
    } catch (e) {
      print('Error getting available dates: $e');
      return [];
    }
  }

  /// Get games created by a user
  static Future<List<Game>> getUserCreatedGames(String userId) async {
    try {
      final results = await _client
          .schema('playnow').from('games')
          .select()
          .eq('created_by', userId)
          .order('game_date', ascending: false)
          .limit(50);

      return results.map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      print('Error getting user created games: $e');
      return [];
    }
  }

  /// Get games a user has joined
  static Future<List<Game>> getUserJoinedGames(String userId) async {
    try {
      final results = await _client
          .schema('playnow').from('game_participants')
          .select('game_id, playnow.games(*)')
          .eq('user_id', userId);

      return results.map((row) {
        final gameData = row['playnow_games'] as Map<String, dynamic>;
        return Game.fromJson(gameData);
      }).toList();
    } catch (e) {
      print('Error getting user joined games: $e');
      return [];
    }
  }

  /// Get pending join requests for a game (for game creator)
  static Future<List<JoinRequest>> getGameJoinRequests(String gameId) async {
    try {
      final response = await _client
          .schema('playnow').from('game_join_requests')
          .select('*, users!game_join_requests_user_id_fkey(user_id, first_name, profile_picture)')
          .eq('game_id', gameId)
          .eq('status', 'pending')
          .order('created_at', ascending: true) as List;

      return response.map((json) => JoinRequest.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting join requests: $e');
      return [];
    }
  }

  /// Update game status
  static Future<bool> updateGameStatus(String gameId, String status) async {
    try {
      await _client
          .schema('playnow').from('games')
          .update({'status': status})
          .eq('id', gameId);
      return true;
    } catch (e) {
      print('Error updating game status: $e');
      return false;
    }
  }

  // Private helper methods

  static Future<void> _updatePlayersCount(String gameId) async {
    // Get current count
    final participants = await _client
        .schema('playnow').from('game_participants')
        .select('id')
        .eq('game_id', gameId);

    final count = participants.length;

    // Update game
    await _client
        .schema('playnow').from('games')
        .update({'current_players_count': count})
        .eq('id', gameId);

    // Check if full
    final gameData = await _client
        .schema('playnow').from('games')
        .select('players_needed')
        .eq('id', gameId)
        .single();

    if (count >= gameData['players_needed']) {
      await _client
          .schema('playnow').from('games')
          .update({'status': 'full'})
          .eq('id', gameId);
    }
  }

  static Future<String?> _createGameChatRoom(Game game) async {
    try {
      // Generate room name from game details
      final roomName = '${game.autoTitle} - ${_formatGameDate(game.gameDate)}';

      final result = await _client.schema('chat').from('rooms').insert({
        'name': roomName,
        'type': 'group',
        'sport_type': game.sportType,
        'meta_data': {'game_id': game.id},
        'created_at': DateTime.now().toIso8601String(),
      }).select('id').single();

      print('Chat room created with name: $roomName');
      return result['id'] as String;
    } catch (e) {
      print('Error creating game chat room: $e');
      return null;
    }
  }

  static String _formatGameDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final gameDay = DateTime(date.year, date.month, date.day);

    if (gameDay == today) {
      return 'Today';
    } else if (gameDay == tomorrow) {
      return 'Tomorrow';
    } else {
      // Format as "Nov 15" or "15 Nov" depending on locale
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  static Future<void> _addUserToChatRoom(String gameId, String userId) async {
    try {
      // Get chat room ID from game
      final gameData = await _client
          .schema('playnow').from('games')
          .select('chat_room_id')
          .eq('id', gameId)
          .maybeSingle();

      final chatRoomId = gameData?['chat_room_id'];
      if (chatRoomId != null) {
        // Check if already a member
        final existing = await _client
            .schema('chat')
            .from('room_members')
            .select('id')
            .eq('room_id', chatRoomId)
            .eq('user_id', userId)
            .maybeSingle();

        if (existing == null) {
          await _client.schema('chat').from('room_members').insert({
            'room_id': chatRoomId,
            'user_id': userId,
            'role': 'member',
          });
        }
      }
    } catch (e) {
      print('Error adding user to chat room: $e');
    }
  }

  static Future<void> _removeUserFromChatRoom(String gameId, String userId) async {
    try {
      // Get chat room ID from game
      final gameData = await _client
          .schema('playnow').from('games')
          .select('chat_room_id')
          .eq('id', gameId)
          .maybeSingle();

      final chatRoomId = gameData?['chat_room_id'];
      if (chatRoomId != null) {
        await _client
            .schema('chat').from('room_members')
            .delete()
            .eq('room_id', chatRoomId)
            .eq('user_id', userId);
      }
    } catch (e) {
      print('Error removing user from chat room: $e');
    }
  }
}

/// Result of joining a game
class JoinGameResult {
  final bool success;
  final String message;
  final bool isAutoJoined;

  JoinGameResult({
    required this.success,
    required this.message,
    this.isAutoJoined = false,
  });
}

/// Join request model
class JoinRequest {
  final String id;
  final String gameId;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final String? message;
  final String status;
  final DateTime createdAt;

  JoinRequest({
    required this.id,
    required this.gameId,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    this.message,
    required this.status,
    required this.createdAt,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    final userData = json['users'] as Map<String, dynamic>?;
    return JoinRequest(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      userId: json['user_id'] as String,
      userName: userData?['first_name'] as String?,
      userPhotoUrl: userData?['profile_picture'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
