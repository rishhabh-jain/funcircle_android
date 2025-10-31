import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_settings.dart';
import '../models/support_ticket.dart';
import '../models/app_policy.dart';

class SettingsService {
  final SupabaseClient _supabase;

  SettingsService(this._supabase);

  Future<UserSettings> getUserSettings(String userId) async {
    try {
      final result = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (result == null) {
        // Create default settings if they don't exist
        final newSettings = UserSettings(
          userId: userId,
          updatedAt: DateTime.now(),
        );
        await _createDefaultSettings(userId);
        return newSettings;
      }

      return UserSettings.fromJson(result);
    } catch (e) {
      throw Exception('Failed to load user settings: $e');
    }
  }

  Future<void> _createDefaultSettings(String userId) async {
    try {
      await _supabase.from('user_settings').insert({
        'user_id': userId,
        'push_notifications': true,
        'email_notifications': true,
        'game_request_notifications': true,
        'booking_notifications': true,
        'chat_notifications': true,
        'friend_request_notifications': true,
        'theme': 'system',
        'language': 'en',
        'profile_visible': true,
        'show_online_status': true,
        'show_location': true,
        'allow_friend_requests': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Settings might already exist
    }
  }

  Future<void> updateSetting(String userId, String field, dynamic value) async {
    try {
      await _supabase.from('user_settings').upsert({
        'user_id': userId,
        field: value,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update setting: $e');
    }
  }

  Future<void> updateSettings(String userId, Map<String, dynamic> settings) async {
    try {
      settings['user_id'] = userId;
      settings['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from('user_settings').upsert(settings);
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  Future<void> submitSupportTicket(SupportTicket ticket) async {
    try {
      await _supabase.from('support_tickets').insert(ticket.toJson());
    } catch (e) {
      throw Exception('Failed to submit support ticket: $e');
    }
  }

  Future<List<AppPolicy>> getPolicies({String? policyType}) async {
    try {
      var query = _supabase.from('app_policies').select();

      if (policyType != null) {
        query = query.eq('policy_type', policyType);
      }

      final results = await query.order('effective_date', ascending: false);

      return (results as List)
          .map((json) => AppPolicy.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load policies: $e');
    }
  }

  Future<AppPolicy?> getPolicy(String policyType) async {
    try {
      final result = await _supabase
          .from('app_policies')
          .select()
          .eq('policy_type', policyType)
          .order('effective_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (result == null) return null;

      return AppPolicy.fromJson(result);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      // This should be handled carefully with proper cascading deletes
      // For now, just mark the user as deleted
      await _supabase.from('users').update({
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
