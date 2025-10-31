import 'dart:math';
import '/backend/supabase/supabase.dart';
import '../models/offers_model.dart';
import 'notification_service.dart';

/// Service for managing offers and referrals
class OffersService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Generate unique referral code for user
  static String generateReferralCode(String userId) {
    final random = Random();
    final code = userId.substring(0, min(4, userId.length)).toUpperCase() +
        random.nextInt(9999).toString().padLeft(4, '0');
    return code;
  }

  /// Get user's referral code
  static Future<String> getUserReferralCode(String userId) async {
    try {
      final result = await _client
          .from('users')
          .select('referral_code')
          .eq('id', userId)
          .maybeSingle();

      if (result != null && result['referral_code'] != null) {
        return result['referral_code'] as String;
      }

      // Generate and save new code
      final code = generateReferralCode(userId);
      await _client
          .from('users')
          .update({'referral_code': code})
          .eq('id', userId);

      return code;
    } catch (e) {
      print('Error getting referral code: $e');
      return generateReferralCode(userId);
    }
  }

  /// Apply referral code (when new user signs up)
  static Future<bool> applyReferralCode({
    required String newUserId,
    required String referralCode,
  }) async {
    try {
      // Find referrer
      final referrerResult = await _client
          .from('users')
          .select('id, display_name')
          .eq('referral_code', referralCode)
          .maybeSingle();

      if (referrerResult == null) {
        return false; // Invalid code
      }

      final referrerId = referrerResult['id'] as String;

      // Create referral record
      await _client.from('playnow_referrals').insert({
        'referrer_user_id': referrerId,
        'referred_user_id': newUserId,
        'referral_code': referralCode,
        'status': 'pending',
      });

      // Give welcome offer to new user
      await createOffer(
        userId: newUserId,
        offerType: 'first_game_free',
        title: 'Welcome Bonus!',
        description: 'Your first game is on us!',
        discountPercentage: 100,
        expiresInDays: 30,
      );

      return true;
    } catch (e) {
      print('Error applying referral code: $e');
      return false;
    }
  }

  /// Complete referral (when referred user completes first game)
  static Future<bool> completeReferral(String referredUserId) async {
    try {
      final referralResult = await _client
          .from('playnow_referrals')
          .select('id, referrer_user_id, status')
          .eq('referred_user_id', referredUserId)
          .eq('status', 'pending')
          .maybeSingle();

      if (referralResult == null) {
        return false;
      }

      final referrerId = referralResult['referrer_user_id'] as String;
      final referralId = referralResult['id'] as String;

      // Update referral status
      await _client
          .from('playnow_referrals')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
            'reward_amount': 50.0,
          })
          .eq('id', referralId);

      // Give reward to referrer
      await createOffer(
        userId: referrerId,
        offerType: 'referral_bonus',
        title: 'Referral Reward',
        description: 'Thank you for referring a friend!',
        discountAmount: 50.0,
        expiresInDays: 90,
      );

      // Notify referrer
      final referredUserData = await _client
          .from('users')
          .select('display_name')
          .eq('id', referredUserId)
          .maybeSingle();

      if (referredUserData != null) {
        await NotificationService.notifyReferralRewardEarned(
          userId: referrerId,
          amount: 50.0,
          referredUserName: referredUserData['display_name'] as String? ?? 'Someone',
        );
      }

      return true;
    } catch (e) {
      print('Error completing referral: $e');
      return false;
    }
  }

  /// Create an offer for a user
  static Future<bool> createOffer({
    required String userId,
    required String offerType,
    required String title,
    required String description,
    double? discountAmount,
    int? discountPercentage,
    int? expiresInDays,
  }) async {
    try {
      DateTime? expiresAt;
      if (expiresInDays != null) {
        expiresAt = DateTime.now().add(Duration(days: expiresInDays));
      }

      await _client.schema('playnow').from('user_offers').insert({
        'user_id': userId,
        'offer_type': offerType,
        'title': title,
        'description': description,
        'discount_amount': discountAmount,
        'discount_percentage': discountPercentage,
        'status': 'active',
        'expires_at': expiresAt?.toIso8601String(),
      });

      // Notify user
      await NotificationService.notifyOfferActivated(
        userId: userId,
        offerTitle: title,
        offerId: '', // Will be set by insert
      );

      return true;
    } catch (e) {
      print('Error creating offer: $e');
      return false;
    }
  }

  /// Get user's active offers
  static Future<List<UserOffer>> getUserOffers({
    required String userId,
    bool activeOnly = false,
  }) async {
    try {
      var query = _client
          .schema('playnow').from('user_offers')
          .select()
          .eq('user_id', userId);

      if (activeOnly) {
        query = query.eq('status', 'active');
      }

      final response = await query.order('created_at', ascending: false) as List;

      return response
          .map((json) => UserOffer.fromJson(json as Map<String, dynamic>))
          .where((offer) => !activeOnly || !offer.isExpired)
          .toList();
    } catch (e) {
      print('Error getting user offers: $e');
      return [];
    }
  }

  /// Use an offer
  static Future<bool> useOffer(String offerId) async {
    try {
      await _client
          .schema('playnow').from('user_offers')
          .update({'status': 'used'})
          .eq('id', offerId);
      return true;
    } catch (e) {
      print('Error using offer: $e');
      return false;
    }
  }

  /// Get user's referral stats
  static Future<Map<String, dynamic>> getReferralStats(String userId) async {
    try {
      final referrals = await _client
          .from('playnow_referrals')
          .select()
          .eq('referrer_user_id', userId) as List;

      final pending = referrals.where((r) => r['status'] == 'pending').length;
      final completed = referrals.where((r) => r['status'] == 'completed').length;
      final totalRewards = referrals
          .where((r) => r['reward_amount'] != null)
          .fold<double>(
            0,
            (sum, r) => sum + ((r['reward_amount'] as num?)?.toDouble() ?? 0),
          );

      return {
        'total': referrals.length,
        'pending': pending,
        'completed': completed,
        'totalRewards': totalRewards,
      };
    } catch (e) {
      print('Error getting referral stats: $e');
      return {
        'total': 0,
        'pending': 0,
        'completed': 0,
        'totalRewards': 0.0,
      };
    }
  }

  /// Award milestone offer
  static Future<bool> awardMilestoneOffer({
    required String userId,
    required String milestone,
    required String title,
    required String description,
    double? discountAmount,
    int? discountPercentage,
  }) async {
    return await createOffer(
      userId: userId,
      offerType: 'milestone_reward',
      title: title,
      description: description,
      discountAmount: discountAmount,
      discountPercentage: discountPercentage,
      expiresInDays: 60,
    );
  }
}
