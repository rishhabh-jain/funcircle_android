import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/play_friend.dart';
import '../backend/supabase/supabase.dart';

class PlayFriendsService {
  final SupabaseClient _supabase;
  static SupabaseClient get _client => SupaFlow.client;

  PlayFriendsService(this._supabase);

  Future<List<PlayFriend>> getPlayFriends(
    String userId, {
    bool favoritesOnly = false,
    String? sportType,
  }) async {
    try {
      print('Fetching play pals for user: $userId');

      // Query play_pals table from playnow schema
      var query = _supabase
          .schema('playnow')
          .from('play_pals')
          .select('''
            id,
            user_id,
            partner_id,
            sport_type,
            games_played_together,
            is_favorite,
            last_played_at,
            created_at
          ''')
          .eq('user_id', userId);

      if (favoritesOnly) {
        query = query.eq('is_favorite', true);
      }

      if (sportType != null && sportType != 'all') {
        query = query.eq('sport_type', sportType.toLowerCase());
      }

      final results = await query.order('games_played_together', ascending: false);

      print('Received ${(results as List).length} play pals');

      final friends = <PlayFriend>[];
      for (final item in results) {
        try {
          // Get partner user info
          final partnerData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton')
              .eq('user_id', item['partner_id'])
              .maybeSingle();

          if (partnerData == null) continue;

          friends.add(PlayFriend(
            friendshipId: item['id'].toString(),
            friendId: item['partner_id'] as String,
            friendName: partnerData['first_name'] ?? 'Friend',
            friendImage: (partnerData['images'] as List?)?.isNotEmpty == true
                ? partnerData['images'][0]
                : null,
            friendLevel: partnerData['skill_level_badminton']?.toString(),
            gamesPlayedTogether: item['games_played_together'] as int? ?? 0,
            isFavorite: item['is_favorite'] as bool? ?? false,
            preferredSport: item['sport_type'] as String?,
            lastPlayedAt: item['last_played_at'] != null
                ? DateTime.parse(item['last_played_at'] as String)
                : null,
            friendsSince: DateTime.parse(item['created_at'] as String),
            sportsPlayed: [item['sport_type'] as String],
          ));
        } catch (e) {
          print('Error parsing play pal: $e');
        }
      }

      return friends;
    } catch (e) {
      print('Error fetching play pals: $e');
      throw Exception('Failed to load play friends: $e');
    }
  }

  Future<void> toggleFavorite(String friendshipId, bool isFavorite) async {
    try {
      await _supabase.schema('playnow').from('play_pals').update({
        'is_favorite': isFavorite,
      }).eq('id', friendshipId);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  Future<void> addPlayFriend({
    required String userId,
    required String friendId,
    required String sportType,
  }) async {
    try {
      await _supabase.schema('playnow').from('play_pals').insert({
        'user_id': userId,
        'partner_id': friendId,
        'sport_type': sportType.toLowerCase(),
        'games_played_together': 0,
        'is_favorite': false,
      });
    } catch (e) {
      throw Exception('Failed to add play friend: $e');
    }
  }

  Future<void> removePlayFriend(String friendshipId) async {
    try {
      await _supabase
          .schema('playnow')
          .from('play_pals')
          .delete()
          .eq('id', friendshipId);
    } catch (e) {
      throw Exception('Failed to remove play friend: $e');
    }
  }

  Future<String?> findOrCreateChatRoom(String userId, String friendId) async {
    try {
      print('=== CHAT DEBUG: Finding or creating chat room between $userId and $friendId ===');

      // First, try to find existing single chat room between these users
      // We need to check room_members for both users
      print('DEBUG: Querying chat.room_members for userId: $userId');
      final existingRooms = await _client
          .schema('chat')
          .from('room_members')
          .select('room_id')
          .eq('user_id', userId);
      print('DEBUG: Found ${(existingRooms as List).length} rooms');

      if (existingRooms.isEmpty) {
        // No rooms for current user, create new one
        return await _createChatRoom(userId, friendId);
      }

      // Check if any of these rooms also has the friend as a member
      for (final roomData in existingRooms) {
        final roomId = roomData['room_id'];

        // Get room details to check if it's a single chat
        final room = await _client
            .schema('chat')
            .from('rooms')
            .select('id, type')
            .eq('id', roomId)
            .eq('type', 'single')
            .maybeSingle();

        if (room == null) continue;

        // Check if friend is a member of this room
        final friendMember = await _client
            .schema('chat')
            .from('room_members')
            .select('id')
            .eq('room_id', roomId)
            .eq('user_id', friendId)
            .maybeSingle();

        if (friendMember != null) {
          print('Found existing chat room: $roomId');
          return roomId;
        }
      }

      // No existing room found, create new one
      return await _createChatRoom(userId, friendId);
    } catch (e) {
      print('=== ERROR finding/creating chat room: $e ===');
      print('ERROR Type: ${e.runtimeType}');
      if (e is PostgrestException) {
        print('Postgrest error code: ${e.code}');
        print('Postgrest error message: ${e.message}');
        print('Postgrest error details: ${e.details}');
      }
      throw Exception('Failed to open chat: $e');
    }
  }

  Future<String> _createChatRoom(String userId, String friendId) async {
    try {
      print('Creating new chat room between $userId and $friendId');

      // Get friend name for room name
      final friendData = await _supabase
          .from('users')
          .select('first_name')
          .eq('user_id', friendId)
          .single();

      // Create room in chat schema
      final room = await _client.schema('chat').from('rooms').insert({
        'type': 'single',
        'created_by': userId,
        'is_active': true,
        'name': friendData['first_name'] ?? 'Chat',
      }).select('id').single();

      final roomId = room['id'];

      // Add both users as members
      await _client.schema('chat').from('room_members').insert([
        {
          'room_id': roomId,
          'user_id': userId,
          'role': 'member',
        },
        {
          'room_id': roomId,
          'user_id': friendId,
          'role': 'member',
        },
      ]);

      print('Created chat room: $roomId');
      return roomId;
    } catch (e) {
      print('Error creating chat room: $e');
      throw Exception('Failed to create chat: $e');
    }
  }
}
