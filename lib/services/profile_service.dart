import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_stats.dart';
import '../backend/supabase/database/tables/users.dart';

class ProfileService {
  final SupabaseClient _supabase;

  ProfileService(this._supabase);

  Future<UsersRow?> getUserProfile(String userId) async {
    try {
      final result = await _supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .single();

      return UsersRow(result);
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  Future<UserStats> getUserStats(String userId) async {
    try {
      // This would typically call an RPC function or aggregate from multiple tables
      // For now, we'll create a basic implementation
      final result = await _supabase
          .rpc('get_user_stats', params: {'p_user_id': userId});

      return UserStats.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      // If RPC doesn't exist, return default stats
      return UserStats(userId: userId);
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('users')
          .update(data)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updateProfilePicture(String userId, String imageUrl) async {
    try {
      final result = await _supabase
          .from('users')
          .select('images')
          .eq('user_id', userId)
          .single();

      List<String> images = (result['images'] as List?)?.map((e) => e as String).toList() ?? [];

      // Add new image at the beginning
      images.insert(0, imageUrl);

      await _supabase.from('users').update({
        'images': images,
      }).eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  Future<List<String>> getUserTags(String userId) async {
    try {
      final result = await _supabase
          .from('tags')
          .select('tag')
          .eq('user_id', userId);

      return (result as List)
          .map((item) => item['tag'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
