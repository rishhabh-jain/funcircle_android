import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game_request.dart';

class GameRequestsService {
  final SupabaseClient _supabase;

  GameRequestsService(this._supabase);

  Future<List<GameRequest>> getReceivedRequests(String userId) async {
    try {
      print('Fetching received requests for user: $userId');

      final results = await _supabase
          .from('game_requests')
          .select('''
            id,
            sender,
            reciever,
            type,
            data,
            created_at
          ''')
          .eq('reciever', userId)
          .order('created_at', ascending: false);

      print('Received ${(results as List).length} requests');

      final requests = <GameRequest>[];
      for (final item in results) {
        try {
          // Get sender info
          final senderData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton')
              .eq('user_id', item['sender'])
              .maybeSingle();

          final data = item['data'] as Map<String, dynamic>? ?? {};

          requests.add(GameRequest(
            requestId: item['id'].toString(),
            senderId: item['sender'] as String,
            senderName: senderData?['first_name'] ?? 'User',
            senderImage: (senderData?['images'] as List?)?.isNotEmpty == true
                ? senderData!['images'][0]
                : null,
            senderLevel: senderData?['skill_level_badminton']?.toString(),
            receiverId: item['reciever'] as String,
            receiverName: '', // Will be filled by received user
            sportType: data['sport_type'] as String? ?? 'Badminton',
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
          ));
        } catch (e) {
          print('Error parsing request: $e');
        }
      }

      return requests;
    } catch (e) {
      print('Error fetching received requests: $e');
      throw Exception('Failed to load received requests: $e');
    }
  }

  Future<List<GameRequest>> getSentRequests(String userId) async {
    try {
      print('Fetching sent requests for user: $userId');

      final results = await _supabase
          .from('game_requests')
          .select('''
            id,
            sender,
            reciever,
            type,
            data,
            created_at
          ''')
          .eq('sender', userId)
          .order('created_at', ascending: false);

      print('Sent ${(results as List).length} requests');

      final requests = <GameRequest>[];
      for (final item in results) {
        try {
          // Get receiver info
          final receiverData = await _supabase
              .from('users')
              .select('first_name, images, skill_level_badminton')
              .eq('user_id', item['reciever'])
              .maybeSingle();

          final data = item['data'] as Map<String, dynamic>? ?? {};

          requests.add(GameRequest(
            requestId: item['id'].toString(),
            senderId: item['sender'] as String,
            senderName: '', // Will be filled by sender user
            receiverId: item['reciever'] as String,
            receiverName: receiverData?['first_name'] ?? 'User',
            receiverImage: (receiverData?['images'] as List?)?.isNotEmpty == true
                ? receiverData!['images'][0]
                : null,
            receiverLevel: receiverData?['skill_level_badminton']?.toString(),
            sportType: data['sport_type'] as String? ?? 'Badminton',
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
          ));
        } catch (e) {
          print('Error parsing request: $e');
        }
      }

      return requests;
    } catch (e) {
      print('Error fetching sent requests: $e');
      throw Exception('Failed to load sent requests: $e');
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      // Get current request
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
    } catch (e) {
      throw Exception('Failed to accept request: $e');
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      // Get current request
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
    } catch (e) {
      throw Exception('Failed to reject request: $e');
    }
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      // Get current request
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
}
