import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class MoreOptionsService {
  final SupabaseClient _supabase;

  MoreOptionsService(this._supabase);

  Future<UserQuickStats> getUserQuickStats(String userId) async {
    try {
      // Get booking stats using RPC function
      final bookingStatsResponse = await _supabase
          .rpc('get_user_booking_stats', params: {'p_user_id': userId});

      // Get play friend stats using RPC function
      final friendStatsResponse = await _supabase
          .rpc('get_play_friend_stats', params: {'p_user_id': userId});

      return UserQuickStats(
        totalBookings: bookingStatsResponse['total_bookings'] as int? ?? 0,
        upcomingBookings: bookingStatsResponse['upcoming_bookings'] as int? ?? 0,
        totalFriends: friendStatsResponse['total_friends'] as int? ?? 0,
        totalGamesPlayed: friendStatsResponse['total_games_played'] as int? ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to load user stats: $e');
    }
  }

  Future<int> getPendingGameRequestsCount(String userId) async {
    try {
      final response = await _supabase
          .from('game_requests_view')
          .select()
          .eq('receiver_id', userId)
          .eq('status', 'pending')
          .count();

      return response.count;
    } catch (e) {
      throw Exception('Failed to load pending requests count: $e');
    }
  }
}
