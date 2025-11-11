import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room_invite.dart';

/// Service for managing chat room invites
class RoomInviteService {
  final SupabaseClient _supabase;

  RoomInviteService(this._supabase);

  /// Generate a unique invite code
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Create a shareable invite link for a chat room
  ///
  /// [roomId] - The ID of the chat room
  /// [userId] - The ID of the user creating the invite
  /// [maxUses] - Maximum number of times the invite can be used (null = unlimited)
  /// [expiresInDays] - Number of days until the invite expires (null = never)
  Future<RoomInvite> createInvite({
    required String roomId,
    required String userId,
    int? maxUses,
    int? expiresInDays,
  }) async {
    try {
      // Generate unique invite code
      final inviteCode = _generateInviteCode();

      // Create the invite link using custom URL scheme
      final inviteLink = 'funcircle://room/join/$inviteCode';

      // Calculate expiry date
      DateTime? expiresAt;
      if (expiresInDays != null) {
        expiresAt = DateTime.now().add(Duration(days: expiresInDays));
      }

      // Insert into database
      final response = await _supabase
          .schema('chat')
          .from('room_invites')
          .insert({
        'room_id': roomId,
        'created_by': userId,
        'invite_code': inviteCode,
        'invite_link': inviteLink,
        'max_uses': maxUses,
        'expires_at': expiresAt?.toIso8601String(),
      }).select().single();

      return RoomInvite.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create invite: $e');
    }
  }

  /// Get all invites for a specific room
  Future<List<RoomInvite>> getRoomInvites(String roomId) async {
    try {
      final response = await _supabase
          .schema('chat')
          .from('room_invites_view')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => RoomInvite.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load invites: $e');
    }
  }

  /// Get invites created by a specific user
  Future<List<RoomInvite>> getUserInvites(String userId) async {
    try {
      final response = await _supabase
          .schema('chat')
          .from('room_invites_view')
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => RoomInvite.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load user invites: $e');
    }
  }

  /// Get invite details by invite code
  Future<RoomInviteDetails?> getInviteDetails(String inviteCode) async {
    try {
      final response = await _supabase
          .schema('chat')
          .rpc('get_invite_details', params: {'p_invite_code': inviteCode});

      if (response == null || (response as List).isEmpty) {
        return null;
      }

      return RoomInviteDetails.fromJson(response[0]);
    } catch (e) {
      throw Exception('Failed to get invite details: $e');
    }
  }

  /// Check if an invite code is valid
  Future<bool> isInviteValid(String inviteCode) async {
    try {
      final result = await _supabase
          .schema('chat')
          .rpc('is_invite_valid', params: {'p_invite_code': inviteCode});

      return result as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Join a room using an invite code
  ///
  /// [inviteCode] - The invite code to use
  /// [userId] - The ID of the user joining
  /// Returns the room ID if successful
  Future<String?> joinRoomViaInvite({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      // 1. Get invite details
      final inviteDetails = await getInviteDetails(inviteCode);

      if (inviteDetails == null || !inviteDetails.isValid) {
        throw Exception('Invalid or expired invite code');
      }

      if (inviteDetails.isFull) {
        throw Exception('Room is full');
      }

      final roomId = inviteDetails.roomId;

      // 2. Check if user is already a member
      final existingMember = await _supabase
          .schema('chat')
          .from('room_members')
          .select('id')
          .eq('room_id', roomId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingMember != null) {
        // User is already a member, just return room ID
        return roomId;
      }

      // 3. Add user to room
      await _supabase.schema('chat').from('room_members').insert({
        'room_id': roomId,
        'user_id': userId,
        'role': 'member',
      });

      // 4. Record invite usage
      final invite = await _getInviteByCode(inviteCode);
      if (invite != null) {
        await _supabase.schema('chat').from('room_invite_usage').insert({
          'invite_id': invite['id'],
          'user_id': userId,
        });
      }

      // 5. Send a system message to the room (optional)
      await _sendJoinMessage(roomId, userId);

      return roomId;
    } catch (e) {
      throw Exception('Failed to join room: $e');
    }
  }

  /// Get invite by code (internal helper)
  Future<Map<String, dynamic>?> _getInviteByCode(String inviteCode) async {
    try {
      final response = await _supabase
          .schema('chat')
          .from('room_invites')
          .select()
          .eq('invite_code', inviteCode)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  /// Send a system message when someone joins via invite
  Future<void> _sendJoinMessage(String roomId, String userId) async {
    try {
      // Get user name (users table is in public schema)
      final user = await _supabase
          .from('users')
          .select('first_name')
          .eq('user_id', userId)
          .single();

      final userName = user['first_name'] ?? 'Someone';

      // Send system message (messages table is in chat schema)
      await _supabase.schema('chat').from('messages').insert({
        'room_id': roomId,
        'sender_id': userId,
        'content': '$userName joined via invite link',
        'message_type': 'system',
      });
    } catch (e) {
      // Silently fail - don't block join if message fails
      print('Failed to send join message: $e');
    }
  }

  /// Deactivate an invite
  Future<void> deactivateInvite(String inviteId) async {
    try {
      await _supabase
          .schema('chat')
          .from('room_invites')
          .update({'is_active': false}).eq('id', inviteId);
    } catch (e) {
      throw Exception('Failed to deactivate invite: $e');
    }
  }

  /// Delete an invite
  Future<void> deleteInvite(String inviteId) async {
    try {
      await _supabase.schema('chat').from('room_invites').delete().eq('id', inviteId);
    } catch (e) {
      throw Exception('Failed to delete invite: $e');
    }
  }

  /// Get usage statistics for an invite
  Future<List<Map<String, dynamic>>> getInviteUsage(String inviteId) async {
    try {
      final response = await _supabase
          .schema('chat')
          .from('room_invite_usage')
          .select('''
            used_at,
            user_id,
            users:user_id (
              first_name,
              images
            )
          ''')
          .eq('invite_id', inviteId)
          .order('used_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get invite usage: $e');
    }
  }

  /// Clean up expired invites (call this periodically or via cron)
  Future<int> cleanupExpiredInvites() async {
    try {
      final result =
          await _supabase.schema('chat').rpc('deactivate_expired_invites');
      return result as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Clean up maxed out invites
  Future<int> cleanupMaxedInvites() async {
    try {
      final result = await _supabase.schema('chat').rpc('deactivate_maxed_invites');
      return result as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Subscribe to invite changes for a room
  Stream<List<RoomInvite>> subscribeToRoomInvites(String roomId) {
    return _supabase
        .schema('chat')
        .from('room_invites_view')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .map((data) => data.map((json) => RoomInvite.fromJson(json)).toList());
  }

  // Optional: Create Firebase Dynamic Link
  // Uncomment if you want to use Firebase Dynamic Links
  /*
  Future<String> _createDynamicLink(String inviteCode) async {
    try {
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://funcircle.app/room/join/$inviteCode'),
        uriPrefix: 'https://funcircle.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.funcircle.app',
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.funcircle.app',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join our chat room!',
          description: 'Tap to join the conversation',
        ),
      );

      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
        dynamicLinkParams,
      );

      return dynamicLink.shortUrl.toString();
    } catch (e) {
      // Fallback to simple link
      return 'https://funcircle.app/room/join/$inviteCode';
    }
  }
  */
}
