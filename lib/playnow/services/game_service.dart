import '/backend/supabase/supabase.dart';
import '../models/game_model.dart';
import 'notification_service.dart';

/// Service for managing games in playnow schema
class GameService {
  static SupabaseClient get _client => SupaFlow.client;

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

        // Add creator as first participant
        print('\nAdding creator as participant...');
        try {
          await _client.schema('playnow').from('game_participants').insert({
            'game_id': game.id,
            'user_id': request.userId,
            'join_type': 'auto',
            'status': 'confirmed',
          });
          print('✓ Creator added as participant');
        } catch (e) {
          print('✗ Error adding participant: $e');
          // Continue anyway
        }

        // Create chat room if needed
        print('\nCreating chat room...');
        try {
          await _createGameChatRoom(game.id);
          print('✓ Chat room created');
        } catch (e) {
          print('✗ Error creating chat room: $e');
          // Don't fail if chat room creation fails
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
          'join_type': 'auto',
          'status': 'confirmed',
        });

        // Update current players count
        await _updatePlayersCount(gameId);

        // Add user to chat room
        await _addUserToChatRoom(gameId, userId);

        // Notify game creator
        final userData = await _client
            .from('users')
            .select('display_name')
            .eq('id', userId)
            .maybeSingle();

        if (userData != null) {
          await NotificationService.notifyPlayerJoinedGame(
            creatorId: game.createdBy,
            playerName: userData['display_name'] as String? ?? 'A player',
            gameId: gameId,
            gameTitle: game.autoTitle,
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
            .select('display_name')
            .eq('id', userId)
            .maybeSingle();

        if (userData != null) {
          await NotificationService.notifyJoinRequestReceived(
            creatorId: game.createdBy,
            playerName: userData['display_name'] as String? ?? 'A player',
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
        'status': 'confirmed',
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

      await NotificationService.notifyJoinRequestApproved(
        playerId: userId,
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
      await NotificationService.notifyJoinRequestDeclined(
        playerId: userId,
        gameId: gameId,
        gameTitle: game.autoTitle,
      );

      return true;
    } catch (e) {
      print('Error declining join request: $e');
      return false;
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
        // Get game info and participants
        final gameData2 = await _client
            .schema('playnow').from('games')
            .select()
            .eq('id', gameId)
            .single();
        final game = Game.fromJson(gameData2);

        final participants = await _client
            .schema('playnow').from('game_participants')
            .select('user_id')
            .eq('game_id', gameId)
            .eq('status', 'confirmed') as List;

        final participantIds = participants
            .map((p) => p['user_id'] as String)
            .where((id) => id != userId) // Don't notify creator
            .toList();

        await _client
            .schema('playnow').from('games')
            .update({'status': 'cancelled'})
            .eq('id', gameId);

        // Notify all participants
        if (participantIds.isNotEmpty) {
          await NotificationService.notifyGameCancelled(
            participantIds: participantIds,
            gameId: gameId,
            gameTitle: game.autoTitle,
            reason: 'The creator left the game.',
          );
        }
      } else {
        // Remove participant
        await _client
            .schema('playnow').from('game_participants')
            .delete()
            .eq('game_id', gameId)
            .eq('user_id', userId);

        // Update players count
        await _updatePlayersCount(gameId);
      }

      // Remove from chat room
      await _removeUserFromChatRoom(gameId, userId);

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

      return results.map((json) => Game.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting open games: $e');
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
          .eq('user_id', userId)
          .eq('status', 'confirmed');

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
          .select('*, users!game_join_requests_user_id_fkey(id, display_name, photo_url)')
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
        .eq('game_id', gameId)
        .eq('status', 'confirmed');

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

  static Future<void> _createGameChatRoom(String gameId) async {
    try {
      await _client.schema('chat').from('rooms').insert({
        'room_type': 'group',
        'game_id': gameId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error creating game chat room: $e');
    }
  }

  static Future<void> _addUserToChatRoom(String gameId, String userId) async {
    try {
      // Get chat room for game
      final room = await _client
          .schema('chat').from('rooms')
          .select('id')
          .eq('game_id', gameId)
          .maybeSingle();

      if (room != null) {
        await _client.schema('chat').from('room_members').insert({
          'room_id': room['id'],
          'user_id': userId,
          'role': 'member',
        });
      }
    } catch (e) {
      print('Error adding user to chat room: $e');
    }
  }

  static Future<void> _removeUserFromChatRoom(String gameId, String userId) async {
    try {
      // Get chat room for game
      final room = await _client
          .schema('chat').from('rooms')
          .select('id')
          .eq('game_id', gameId)
          .maybeSingle();

      if (room != null) {
        await _client
            .schema('chat').from('room_members')
            .delete()
            .eq('room_id', room['id'])
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
      userName: userData?['display_name'] as String?,
      userPhotoUrl: userData?['photo_url'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
