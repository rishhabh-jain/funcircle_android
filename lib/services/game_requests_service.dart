import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game_request.dart';

class GameRequestsService {
  final SupabaseClient _supabase;

  GameRequestsService(this._supabase);

  /// Fetches all received requests from all 3 sources
  Future<List<GameRequest>> getReceivedRequests(String userId) async {
    try {
      print('Fetching all received requests for user: $userId');

      final allRequests = <GameRequest>[];

      // 1. Fetch general game requests
      final generalRequests = await _fetchGeneralReceivedRequests(userId);
      allRequests.addAll(generalRequests);

      // 2. Fetch Find Players requests (responses to my player requests)
      final findPlayersRequests = await _fetchFindPlayersReceivedRequests(userId);
      allRequests.addAll(findPlayersRequests);

      // 3. Fetch Play Now game join requests (requests to join my games)
      final playNowRequests = await _fetchPlayNowReceivedRequests(userId);
      allRequests.addAll(playNowRequests);

      // Sort by date (newest first)
      allRequests.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      print('Total received requests: ${allRequests.length}');
      return allRequests;
    } catch (e) {
      print('Error fetching received requests: $e');
      throw Exception('Failed to load received requests: $e');
    }
  }

  /// Fetches all sent requests from all 3 sources
  Future<List<GameRequest>> getSentRequests(String userId) async {
    try {
      print('Fetching all sent requests for user: $userId');

      final allRequests = <GameRequest>[];

      // 1. Fetch general game requests I sent
      final generalRequests = await _fetchGeneralSentRequests(userId);
      allRequests.addAll(generalRequests);

      // 2. Fetch Find Players responses I made
      final findPlayersRequests = await _fetchFindPlayersSentRequests(userId);
      allRequests.addAll(findPlayersRequests);

      // 3. Fetch Play Now game join requests I sent
      final playNowRequests = await _fetchPlayNowSentRequests(userId);
      allRequests.addAll(playNowRequests);

      // Sort by date (newest first)
      allRequests.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      print('Total sent requests: ${allRequests.length}');
      return allRequests;
    } catch (e) {
      print('Error fetching sent requests: $e');
      throw Exception('Failed to load sent requests: $e');
    }
  }

  // ========== GENERAL GAME REQUESTS (original) ==========

  Future<List<GameRequest>> _fetchGeneralReceivedRequests(String userId) async {
    try {
      final results = await _supabase
          .from('game_requests')
          .select('id, sender, reciever, type, data, created_at')
          .eq('reciever', userId)
          .order('created_at', ascending: false);

      final requests = <GameRequest>[];
      for (final item in results) {
        try {
          final senderData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton, skill_level_pickleball')
              .eq('user_id', item['sender'])
              .maybeSingle();

          final data = item['data'] as Map<String, dynamic>? ?? {};
          final sportType = data['sport_type'] as String? ?? 'Badminton';
          final isPickleball = sportType.toLowerCase() == 'pickleball';

          requests.add(GameRequest(
            requestId: item['id'].toString(),
            senderId: item['sender'] as String,
            senderName: senderData?['first_name'] ?? 'User',
            senderImage: (senderData?['images'] as List?)?.isNotEmpty == true
                ? senderData!['images'][0]
                : null,
            senderLevel: _getSkillLevel(senderData, isPickleball),
            receiverId: item['reciever'] as String,
            receiverName: '',
            sportType: sportType,
            message: data['message'] as String?,
            status: data['status'] as String? ?? 'pending',
            requestedAt: DateTime.parse(item['created_at'] as String),
            respondedAt: data['responded_at'] != null
                ? DateTime.parse(data['responded_at'] as String)
                : null,
            venueId: data['venue_id']?.toString(),
            venueName: data['venue_name'] as String?,
            proposedDateTime: data['proposed_date_time'] != null
                ? DateTime.parse(data['proposed_date_time'] as String)
                : null,
            source: 'general',
            requestType: 'game_request',
          ));
        } catch (e) {
          print('Error parsing general received request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching general received requests: $e');
      return [];
    }
  }

  Future<List<GameRequest>> _fetchGeneralSentRequests(String userId) async {
    try {
      final results = await _supabase
          .from('game_requests')
          .select('id, sender, reciever, type, data, created_at')
          .eq('sender', userId)
          .order('created_at', ascending: false);

      final requests = <GameRequest>[];
      for (final item in results) {
        try {
          final receiverData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton, skill_level_pickleball')
              .eq('user_id', item['reciever'])
              .maybeSingle();

          final data = item['data'] as Map<String, dynamic>? ?? {};
          final sportType = data['sport_type'] as String? ?? 'Badminton';
          final isPickleball = sportType.toLowerCase() == 'pickleball';

          requests.add(GameRequest(
            requestId: item['id'].toString(),
            senderId: item['sender'] as String,
            senderName: '',
            receiverId: item['reciever'] as String,
            receiverName: receiverData?['first_name'] ?? 'User',
            receiverImage: (receiverData?['images'] as List?)?.isNotEmpty == true
                ? receiverData!['images'][0]
                : null,
            receiverLevel: _getSkillLevel(receiverData, isPickleball),
            sportType: sportType,
            message: data['message'] as String?,
            status: data['status'] as String? ?? 'pending',
            requestedAt: DateTime.parse(item['created_at'] as String),
            respondedAt: data['responded_at'] != null
                ? DateTime.parse(data['responded_at'] as String)
                : null,
            venueId: data['venue_id']?.toString(),
            venueName: data['venue_name'] as String?,
            proposedDateTime: data['proposed_date_time'] != null
                ? DateTime.parse(data['proposed_date_time'] as String)
                : null,
            source: 'general',
            requestType: 'game_request',
          ));
        } catch (e) {
          print('Error parsing general sent request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching general sent requests: $e');
      return [];
    }
  }

  // ========== FIND PLAYERS REQUESTS ==========

  Future<List<GameRequest>> _fetchFindPlayersReceivedRequests(String userId) async {
    try {
      // Get my player requests
      final myPlayerRequests = await _supabase
          .schema('findplayers')
          .from('player_requests')
          .select('id')
          .eq('user_id', userId);

      if (myPlayerRequests.isEmpty) return [];

      final requestIds = (myPlayerRequests as List).map((r) => r['id']).toList();

      // Get responses to my requests
      final responses = await _supabase
          .schema('findplayers')
          .from('player_request_responses')
          .select('''
            id,
            request_id,
            responder_id,
            status,
            message,
            created_at
          ''')
          .inFilter('request_id', requestIds)
          .order('created_at', ascending: false);

      final requests = <GameRequest>[];
      for (final response in responses) {
        try {
          // Get responder info
          final responderData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton, skill_level_pickleball')
              .eq('user_id', response['responder_id'])
              .maybeSingle();

          // Get original request details
          final requestData = await _supabase
              .schema('findplayers')
              .from('player_requests')
              .select('sport_type, venue_id, scheduled_time, players_needed')
              .eq('id', response['request_id'])
              .maybeSingle();

          if (requestData != null) {
            final sportType = requestData['sport_type'] as String? ?? 'badminton';
            final isPickleball = sportType.toLowerCase() == 'pickleball';

            requests.add(GameRequest(
              requestId: response['id'].toString(),
              senderId: response['responder_id'] as String,
              senderName: responderData?['first_name'] ?? 'User',
              senderImage: (responderData?['images'] as List?)?.isNotEmpty == true
                  ? responderData!['images'][0]
                  : null,
              senderLevel: _getSkillLevel(responderData, isPickleball),
              receiverId: userId,
              receiverName: '',
              sportType: sportType,
              message: response['message'] as String?,
              status: response['status'] as String? ?? 'pending',
              requestedAt: DateTime.parse(response['created_at'] as String),
              venueId: requestData['venue_id']?.toString(),
              proposedDateTime: requestData['scheduled_time'] != null
                  ? DateTime.parse(requestData['scheduled_time'] as String)
                  : null,
              playersNeeded: requestData['players_needed'] as int?,
              source: 'findplayers',
              requestType: 'player_request',
            ));
          }
        } catch (e) {
          print('Error parsing findplayers received request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching findplayers received requests: $e');
      return [];
    }
  }

  Future<List<GameRequest>> _fetchFindPlayersSentRequests(String userId) async {
    try {
      // Get responses I made to others' requests
      final myResponses = await _supabase
          .schema('findplayers')
          .from('player_request_responses')
          .select('''
            id,
            request_id,
            responder_id,
            status,
            message,
            created_at
          ''')
          .eq('responder_id', userId)
          .order('created_at', ascending: false);

      final requests = <GameRequest>[];
      for (final response in myResponses) {
        try {
          // Get original request details and creator info
          final requestData = await _supabase
              .schema('findplayers')
              .from('player_requests')
              .select('user_id, sport_type, venue_id, scheduled_time, players_needed')
              .eq('id', response['request_id'])
              .maybeSingle();

          if (requestData != null) {
            // Get request creator info
            final creatorData = await _supabase
                .from('users')
                .select('first_name, images, skill_level_badminton, skill_level_pickleball')
                .eq('user_id', requestData['user_id'])
                .maybeSingle();

            final sportType = requestData['sport_type'] as String? ?? 'badminton';
            final isPickleball = sportType.toLowerCase() == 'pickleball';

            requests.add(GameRequest(
              requestId: response['id'].toString(),
              senderId: userId,
              senderName: '',
              receiverId: requestData['user_id'] as String,
              receiverName: creatorData?['first_name'] ?? 'User',
              receiverImage: (creatorData?['images'] as List?)?.isNotEmpty == true
                  ? creatorData!['images'][0]
                  : null,
              receiverLevel: _getSkillLevel(creatorData, isPickleball),
              sportType: sportType,
              message: response['message'] as String?,
              status: response['status'] as String? ?? 'pending',
              requestedAt: DateTime.parse(response['created_at'] as String),
              venueId: requestData['venue_id']?.toString(),
              proposedDateTime: requestData['scheduled_time'] != null
                  ? DateTime.parse(requestData['scheduled_time'] as String)
                  : null,
              playersNeeded: requestData['players_needed'] as int?,
              source: 'findplayers',
              requestType: 'player_request',
            ));
          }
        } catch (e) {
          print('Error parsing findplayers sent request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching findplayers sent requests: $e');
      return [];
    }
  }

  // ========== PLAY NOW GAME JOIN REQUESTS ==========

  Future<List<GameRequest>> _fetchPlayNowReceivedRequests(String userId) async {
    try {
      // Get my games
      final myGames = await _supabase
          .schema('playnow')
          .from('games')
          .select('id, sport_type, game_date, start_time, players_needed, current_players_count, venue_id, custom_location')
          .eq('created_by', userId);

      if (myGames.isEmpty) return [];

      final gameIds = (myGames as List).map((g) => g['id']).toList();

      // Get join requests to my games
      final joinRequests = await _supabase
          .schema('playnow')
          .from('game_join_requests')
          .select('''
            id,
            game_id,
            user_id,
            status,
            message,
            requested_at,
            responded_at
          ''')
          .inFilter('game_id', gameIds)
          .order('requested_at', ascending: false);

      final requests = <GameRequest>[];
      for (final joinRequest in joinRequests) {
        try {
          // Get requester info
          final requesterData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton, skill_level_pickleball')
              .eq('user_id', joinRequest['user_id'])
              .maybeSingle();

          // Get game details
          final gameData = myGames.firstWhere(
            (g) => g['id'] == joinRequest['game_id'],
            orElse: () => <String, dynamic>{},
          );

          if (gameData.isNotEmpty) {
            final sportType = gameData['sport_type'] as String? ?? 'badminton';
            final isPickleball = sportType.toLowerCase() == 'pickleball';

            // Construct date time
            DateTime? gameDateTime;
            if (gameData['game_date'] != null && gameData['start_time'] != null) {
              try {
                final date = DateTime.parse(gameData['game_date'] as String);
                final time = gameData['start_time'] as String;
                final timeParts = time.split(':');
                gameDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  int.parse(timeParts[0]),
                  int.parse(timeParts[1]),
                );
              } catch (e) {
                print('Error parsing game date/time: $e');
              }
            }

            requests.add(GameRequest(
              requestId: joinRequest['id'].toString(),
              senderId: joinRequest['user_id'] as String,
              senderName: requesterData?['first_name'] ?? 'User',
              senderImage: (requesterData?['images'] as List?)?.isNotEmpty == true
                  ? requesterData!['images'][0]
                  : null,
              senderLevel: _getSkillLevel(requesterData, isPickleball),
              receiverId: userId,
              receiverName: '',
              sportType: sportType,
              message: joinRequest['message'] as String?,
              status: joinRequest['status'] as String? ?? 'pending',
              requestedAt: DateTime.parse(joinRequest['requested_at'] as String),
              respondedAt: joinRequest['responded_at'] != null
                  ? DateTime.parse(joinRequest['responded_at'] as String)
                  : null,
              venueId: gameData['venue_id']?.toString(),
              venueName: gameData['custom_location'] as String?,
              proposedDateTime: gameDateTime,
              gameId: joinRequest['game_id'].toString(),
              playersNeeded: gameData['players_needed'] as int?,
              currentPlayers: gameData['current_players_count'] as int?,
              source: 'playnow',
              requestType: 'game_join',
            ));
          }
        } catch (e) {
          print('Error parsing playnow received request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching playnow received requests: $e');
      return [];
    }
  }

  Future<List<GameRequest>> _fetchPlayNowSentRequests(String userId) async {
    try {
      // Get join requests I sent
      final myJoinRequests = await _supabase
          .schema('playnow')
          .from('game_join_requests')
          .select('''
            id,
            game_id,
            user_id,
            status,
            message,
            requested_at,
            responded_at
          ''')
          .eq('user_id', userId)
          .order('requested_at', ascending: false);

      final requests = <GameRequest>[];
      for (final joinRequest in myJoinRequests) {
        try {
          // Get game details and creator
          final gameData = await _supabase
              .schema('playnow')
              .from('games')
              .select('created_by, sport_type, game_date, start_time, players_needed, current_players_count, venue_id, custom_location')
              .eq('id', joinRequest['game_id'])
              .maybeSingle();

          if (gameData != null) {
            // Get game creator info
            final creatorData = await _supabase
                .from('users')
                .select('first_name, images, skill_level_badminton, skill_level_pickleball')
                .eq('user_id', gameData['created_by'])
                .maybeSingle();

            final sportType = gameData['sport_type'] as String? ?? 'badminton';
            final isPickleball = sportType.toLowerCase() == 'pickleball';

            // Construct date time
            DateTime? gameDateTime;
            if (gameData['game_date'] != null && gameData['start_time'] != null) {
              try {
                final date = DateTime.parse(gameData['game_date'] as String);
                final time = gameData['start_time'] as String;
                final timeParts = time.split(':');
                gameDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  int.parse(timeParts[0]),
                  int.parse(timeParts[1]),
                );
              } catch (e) {
                print('Error parsing game date/time: $e');
              }
            }

            requests.add(GameRequest(
              requestId: joinRequest['id'].toString(),
              senderId: userId,
              senderName: '',
              receiverId: gameData['created_by'] as String,
              receiverName: creatorData?['first_name'] ?? 'User',
              receiverImage: (creatorData?['images'] as List?)?.isNotEmpty == true
                  ? creatorData!['images'][0]
                  : null,
              receiverLevel: _getSkillLevel(creatorData, isPickleball),
              sportType: sportType,
              message: joinRequest['message'] as String?,
              status: joinRequest['status'] as String? ?? 'pending',
              requestedAt: DateTime.parse(joinRequest['requested_at'] as String),
              respondedAt: joinRequest['responded_at'] != null
                  ? DateTime.parse(joinRequest['responded_at'] as String)
                  : null,
              venueId: gameData['venue_id']?.toString(),
              venueName: gameData['custom_location'] as String?,
              proposedDateTime: gameDateTime,
              gameId: joinRequest['game_id'].toString(),
              playersNeeded: gameData['players_needed'] as int?,
              currentPlayers: gameData['current_players_count'] as int?,
              source: 'playnow',
              requestType: 'game_join',
            ));
          }
        } catch (e) {
          print('Error parsing playnow sent request: $e');
        }
      }
      return requests;
    } catch (e) {
      print('Error fetching playnow sent requests: $e');
      return [];
    }
  }

  // ========== ACTION METHODS ==========

  Future<void> acceptRequest(String requestId, String source, String requestType) async {
    try {
      if (source == 'general') {
        // Original general game request
        final request = await _supabase
            .from('game_requests')
            .select('data')
            .eq('id', requestId)
            .single();

        final data = Map<String, dynamic>.from(request['data'] as Map? ?? {});
        data['status'] = 'accepted';
        data['responded_at'] = DateTime.now().toIso8601String();

        await _supabase
            .from('game_requests')
            .update({'data': data})
            .eq('id', requestId);
      } else if (source == 'findplayers') {
        // Find Players request response
        await _supabase
            .schema('findplayers')
            .from('player_request_responses')
            .update({'status': 'accepted'})
            .eq('id', requestId);
      } else if (source == 'playnow') {
        // Play Now game join request
        await _supabase
            .schema('playnow')
            .from('game_join_requests')
            .update({
              'status': 'accepted',
              'responded_at': DateTime.now().toIso8601String(),
            })
            .eq('id', requestId);
      }
    } catch (e) {
      throw Exception('Failed to accept request: $e');
    }
  }

  Future<void> rejectRequest(String requestId, String source, String requestType) async {
    try {
      if (source == 'general') {
        final request = await _supabase
            .from('game_requests')
            .select('data')
            .eq('id', requestId)
            .single();

        final data = Map<String, dynamic>.from(request['data'] as Map? ?? {});
        data['status'] = 'rejected';
        data['responded_at'] = DateTime.now().toIso8601String();

        await _supabase
            .from('game_requests')
            .update({'data': data})
            .eq('id', requestId);
      } else if (source == 'findplayers') {
        await _supabase
            .schema('findplayers')
            .from('player_request_responses')
            .update({'status': 'rejected'})
            .eq('id', requestId);
      } else if (source == 'playnow') {
        await _supabase
            .schema('playnow')
            .from('game_join_requests')
            .update({
              'status': 'rejected',
              'responded_at': DateTime.now().toIso8601String(),
            })
            .eq('id', requestId);
      }
    } catch (e) {
      throw Exception('Failed to reject request: $e');
    }
  }

  Future<void> cancelRequest(String requestId, String source, String requestType) async {
    try {
      if (source == 'general') {
        final request = await _supabase
            .from('game_requests')
            .select('data')
            .eq('id', requestId)
            .single();

        final data = Map<String, dynamic>.from(request['data'] as Map? ?? {});
        data['status'] = 'cancelled';
        data['responded_at'] = DateTime.now().toIso8601String();

        await _supabase
            .from('game_requests')
            .update({'data': data})
            .eq('id', requestId);
      } else if (source == 'findplayers') {
        await _supabase
            .schema('findplayers')
            .from('player_request_responses')
            .update({'status': 'cancelled'})
            .eq('id', requestId);
      } else if (source == 'playnow') {
        await _supabase
            .schema('playnow')
            .from('game_join_requests')
            .update({
              'status': 'cancelled',
              'responded_at': DateTime.now().toIso8601String(),
            })
            .eq('id', requestId);
      }
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  Future<void> sendGameRequest({
    required String senderId,
    required String receiverId,
    required String sportType,
    String? message,
    String? venueId,
    String? venueName,
    DateTime? proposedDateTime,
  }) async {
    try {
      final data = {
        'sport_type': sportType,
        'message': message,
        'venue_id': venueId,
        'venue_name': venueName,
        'proposed_date_time': proposedDateTime?.toIso8601String(),
        'status': 'pending',
      };

      await _supabase.from('game_requests').insert({
        'sender': senderId,
        'reciever': receiverId,
        'type': 'game_request',
        'data': data,
      });
    } catch (e) {
      throw Exception('Failed to send game request: $e');
    }
  }

  // Helper method to safely get skill level
  String? _getSkillLevel(Map<String, dynamic>? userData, bool isPickleball) {
    if (userData == null) return null;
    final skillLevel = isPickleball
        ? userData['skill_level_pickleball']
        : userData['skill_level_badminton'];
    return skillLevel?.toString();
  }
}
