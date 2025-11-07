import '/backend/supabase/supabase.dart';
import 'offers_service.dart';

/// Service to handle new user offers (50% discount on first game)
class NewUserOfferService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Check if user is eligible for new user offer (hasn't played any game yet)
  static Future<bool> isEligibleForNewUserOffer(String userId) async {
    try {
      // Check if user has any completed games
      final games = await _client
          .schema('playnow')
          .from('game_participants')
          .select('id')
          .eq('user_id', userId)
          .limit(1);

      // If no games, user is eligible
      return games.isEmpty;
    } catch (e) {
      print('Error checking new user eligibility: $e');
      return false;
    }
  }

  /// Check if user already has a new user offer
  static Future<bool> hasNewUserOffer(String userId) async {
    try {
      final offers = await _client
          .schema('playnow')
          .from('user_offers')
          .select('id')
          .eq('user_id', userId)
          .eq('offer_type', 'new_user_discount')
          .limit(1);

      return offers.isNotEmpty;
    } catch (e) {
      print('Error checking existing offers: $e');
      return false;
    }
  }

  /// Create new user offer (50% off first game)
  static Future<bool> createNewUserOffer(String userId) async {
    try {
      // Check if user is eligible
      final isEligible = await isEligibleForNewUserOffer(userId);
      if (!isEligible) {
        print('User not eligible for new user offer');
        return false;
      }

      // Check if user already has the offer
      final hasOffer = await hasNewUserOffer(userId);
      if (hasOffer) {
        print('User already has new user offer');
        return false;
      }

      // Create the offer
      await OffersService.createOffer(
        userId: userId,
        offerType: 'new_user_discount',
        title: '50% OFF Your First Game!',
        description: 'Welcome to Fun Circle! Get 50% discount on your first official game.',
        discountPercentage: 50,
        expiresInDays: 90, // 3 months to use the offer
      );

      print('✓ Created new user offer for $userId');
      return true;
    } catch (e) {
      print('✗ Error creating new user offer: $e');
      return false;
    }
  }

  /// Auto-create offer for new users when they visit the PlayNow screen for the first time
  static Future<void> checkAndCreateNewUserOffer(String userId) async {
    try {
      // Check if user already has the offer
      final hasOffer = await hasNewUserOffer(userId);
      if (hasOffer) {
        return; // Already has offer
      }

      // Check if eligible and create
      final created = await createNewUserOffer(userId);
      if (created) {
        print('✓ Auto-created new user offer for $userId');
      }
    } catch (e) {
      print('Error in auto-create new user offer: $e');
    }
  }
}
