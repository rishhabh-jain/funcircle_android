import 'dart:math';
import '/backend/supabase/supabase.dart';
import '../models/offers_model.dart';

/// Service for managing offers and referrals
class OffersService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Generate unique referral code for user (deterministic)
  static String generateReferralCode(String userId) {
    // Use user ID to generate a deterministic code (always same for same user)
    // Take first 4 chars + last 4 chars of user ID
    final cleaned = userId.replaceAll('-', '').toUpperCase();
    final prefix = cleaned.substring(0, min(4, cleaned.length));
    final suffix = cleaned.substring(max(0, cleaned.length - 4));
    return '$prefix$suffix';
  }

  /// Get user's referral code
  static Future<String> getUserReferralCode(String userId) async {
    try {
      // Generate deterministic code from user ID
      // This ensures the same user always gets the same code
      // without needing to store it in the database
      return generateReferralCode(userId);
    } catch (e) {
      print('Error getting referral code: $e');
      // Fallback to generating a code
      return generateReferralCode(userId);
    }
  }

  /// Apply referral code (when new user signs up)
  static Future<bool> applyReferralCode({
    required String newUserId,
    required String referralCode,
  }) async {
    try {
      String? referrerId;

      // First, try to find the code in existing referrals
      // (if someone has referred others before, their code will be there)
      final existingReferral = await _client
          .schema('playnow')
          .from('referrals')
          .select('referrer_id')
          .eq('referral_code', referralCode)
          .limit(1)
          .maybeSingle();

      if (existingReferral != null) {
        referrerId = existingReferral['referrer_id'] as String;
      } else {
        // Code not found in referrals, so search users by generating codes
        // This is less efficient but necessary for first-time referrers
        final users = await _client
            .from('users')
            .select('id')
            .limit(1000); // Reasonable limit

        for (final user in users) {
          final userId = user['id'] as String;
          if (generateReferralCode(userId) == referralCode) {
            referrerId = userId;
            break;
          }
        }
      }

      if (referrerId == null) {
        return false; // Invalid code - no matching user found
      }

      // Don't allow self-referral
      if (referrerId == newUserId) {
        return false;
      }

      // Create referral record
      await _client.schema('playnow').from('referrals').insert({
        'referrer_id': referrerId,
        'referred_id': newUserId,
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
          .schema('playnow')
          .from('referrals')
          .select('id, referrer_id, status')
          .eq('referred_id', referredUserId)
          .eq('status', 'pending')
          .maybeSingle();

      if (referralResult == null) {
        return false;
      }

      final referrerId = referralResult['referrer_id'] as String;
      final referralId = referralResult['id'] as String;

      // Update referral status
      await _client
          .schema('playnow')
          .from('referrals')
          .update({
            'status': 'completed',
            'reward_amount': 50.0,
            'reward_claimed': true,
            'claimed_at': DateTime.now().toIso8601String(),
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
        // TODO: Call notification service when integrated
        // await NotificationsService.notifyReferralRewardEarned(
        //   userId: referrerId,
        //   amount: 50.0,
        //   referredUserName: referredUserData['display_name'] as String? ?? 'Someone',
        // );
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
        'expires_at': expiresAt?.toIso8601String(),
      });

      // Notify user
      // TODO: Call notification service when integrated
      // await NotificationsService.notifyOfferActivated(
      //   userId: userId,
      //   offerTitle: title,
      //   offerId: '', // Will be set by insert
      // );

      return true;
    } catch (e) {
      print('Error creating offer: $e');
      return false;
    }
  }

  /// Get user's active offers
  static Future<List<Map<String, dynamic>>> getUserOffers({
    required String userId,
    bool activeOnly = false,
  }) async {
    try {
      var query = _client
          .schema('playnow').from('user_offers')
          .select()
          .eq('user_id', userId);

      final response = await query.order('created_at', ascending: false) as List;

      // Filter by expiration and usage if activeOnly
      if (activeOnly) {
        final now = DateTime.now();
        return response
            .cast<Map<String, dynamic>>()
            .where((offer) {
              // Check if already used
              if (offer['used_at'] != null) return false;

              // Check if expired
              if (offer['expires_at'] == null) return true;
              final expiresAt = DateTime.parse(offer['expires_at'] as String);
              return now.isBefore(expiresAt);
            })
            .toList();
      }

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting user offers: $e');
      return [];
    }
  }

  /// Use an offer (mark as used by setting used_at timestamp)
  static Future<bool> useOffer(String offerId) async {
    try {
      await _client
          .schema('playnow').from('user_offers')
          .update({'used_at': DateTime.now().toIso8601String()})
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
          .schema('playnow')
          .from('referrals')
          .select()
          .eq('referrer_id', userId) as List;

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
