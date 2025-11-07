import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '/backend/supabase/supabase.dart';
import '/backend/cloud_functions/cloud_functions.dart';
import '../models/game_model.dart';

/// Service for handling game payments for official Fun Circle games
class GamePaymentService {
  static SupabaseClient get _client => SupaFlow.client;

  // Razorpay credentials (same as existing app)
  static const bool _isProd = true;
  static const _kProdRazorpayKeyId = 'rzp_live_Kz3EmkP4EWRTam';
  static const _kTestRazorpayKeyId = 'rzp_test_MWaSePvLjRYpqq';
  static String get razorpayKeyId =>
      _isProd ? _kProdRazorpayKeyId : _kTestRazorpayKeyId;
  static String get _createOrderCallName =>
      _isProd ? 'createOrder' : 'testCreateOrder';
  static String get _verifySignatureCallName =>
      _isProd ? 'verifySignature' : 'testVerifySignature';

  /// Process payment for a game booking
  static Future<PaymentResult> processGamePayment({
    required Game game,
    required String userId,
    required String userName,
    String? userEmail,
    String? userContact,
  }) async {
    try {
      // Verify game is official and paid
      if (!game.isOfficial) {
        return PaymentResult(
          success: false,
          message: 'This game is not an official Fun Circle game',
        );
      }

      if (game.isFree || game.costPerPlayer == null) {
        return PaymentResult(
          success: false,
          message: 'This game is free, no payment required',
        );
      }

      // Check if already paid
      final alreadyPaid = await hasUserPaid(gameId: game.id, userId: userId);
      if (alreadyPaid) {
        return PaymentResult(
          success: false,
          message: 'You have already booked this game',
        );
      }

      // Amount in paise (₹1 = 100 paise)
      final amountInPaise = (game.costPerPlayer! * 100).toInt();

      // Create a short receipt ID (max 40 chars) using timestamp and short IDs
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final shortGameId = game.id.substring(0, 8);
      final shortUserId = userId.substring(0, 8);
      final receipt = 'g${shortGameId}_u${shortUserId}_$timestamp';

      // Create Razorpay order via Firebase Cloud Function
      final orderResponse = await makeCloudCall(
        _createOrderCallName,
        {
          'amount': amountInPaise,
          'currency': 'INR',
          'receipt': receipt,
          'description':
              'FunCircle PlayTime - ${game.autoTitle} on ${game.formattedDate}',
        },
      );

      if (orderResponse['id'] == null) {
        return PaymentResult(
          success: false,
          message: 'Failed to create payment order',
        );
      }

      final orderId = orderResponse['id'] as String;

      return PaymentResult(
        success: true,
        message: 'Order created successfully',
        orderId: orderId,
        amount: amountInPaise,
      );
    } on FirebaseFunctionsException catch (error) {
      debugPrint('Payment error: ${error.code} (${error.details}): ${error.message}');
      return PaymentResult(
        success: false,
        message: 'Payment service error: ${error.message}',
      );
    } catch (e) {
      debugPrint('Payment error: $e');
      return PaymentResult(
        success: false,
        message: 'Failed to process payment: $e',
      );
    }
  }

  /// Verify Razorpay payment signature
  static Future<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await makeCloudCall(
        _verifySignatureCallName,
        {
          'orderId': orderId,
          'paymentId': paymentId,
          'signature': signature,
        },
      );
      return response['isValid'] == true;
    } on FirebaseFunctionsException catch (error) {
      debugPrint('Verification error: ${error.code} (${error.details}): ${error.message}');
      return false;
    } catch (e) {
      debugPrint('Verification error: $e');
      return false;
    }
  }

  /// Record a successful payment in database
  static Future<bool> recordGamePayment({
    required String gameId,
    required String userId,
    required String paymentId,
    required double amount,
  }) async {
    try {
      // Check if participant record exists
      final participant = await _client
          .schema('playnow')
          .from('game_participants')
          .select('id')
          .eq('game_id', gameId)
          .eq('user_id', userId)
          .maybeSingle();

      if (participant != null) {
        // Update existing participant record with payment info
        await _client
            .schema('playnow')
            .from('game_participants')
            .update({
          'payment_status': 'paid',
          'payment_amount': amount,
          'payment_id': paymentId,
        }).eq('id', participant['id']);
      } else {
        // Create new participant record with payment
        await _client.schema('playnow').from('game_participants').insert({
          'game_id': gameId,
          'user_id': userId,
          'join_type': 'auto_join',
          'payment_status': 'paid',
          'payment_amount': amount,
          'payment_id': paymentId,
        });
      }

      // Update current players count
      await _updatePlayersCount(gameId);

      // Add user to chat room if exists
      await _addUserToChatRoom(gameId, userId);

      return true;
    } catch (e) {
      print('Error recording game payment: $e');
      return false;
    }
  }

  /// Check if a user has already paid for a game
  static Future<bool> hasUserPaid({
    required String gameId,
    required String userId,
  }) async {
    try {
      final participant = await _client
          .schema('playnow')
          .from('game_participants')
          .select('payment_status')
          .eq('game_id', gameId)
          .eq('user_id', userId)
          .maybeSingle();

      if (participant == null) return false;

      return participant['payment_status'] == 'paid';
    } catch (e) {
      print('Error checking payment status: $e');
      return false;
    }
  }

  /// Create a free booking (no payment required)
  static Future<bool> createFreeBooking({
    required String gameId,
    required String userId,
  }) async {
    try {
      // Check if already booked
      final existing = await _client
          .schema('playnow')
          .from('game_participants')
          .select('id')
          .eq('game_id', gameId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        return false; // Already booked
      }

      // Create participant record with waived payment
      await _client.schema('playnow').from('game_participants').insert({
        'game_id': gameId,
        'user_id': userId,
        'join_type': 'auto_join',
        'payment_status': 'waived',
        'payment_amount': 0,
      });

      // Update current players count
      await _updatePlayersCount(gameId);

      // Add user to chat room if exists
      await _addUserToChatRoom(gameId, userId);

      return true;
    } catch (e) {
      print('Error creating free booking: $e');
      return false;
    }
  }

  // Helper methods

  static Future<void> _updatePlayersCount(String gameId) async {
    try {
      // Get current count
      final participants = await _client
          .schema('playnow')
          .from('game_participants')
          .select('id')
          .eq('game_id', gameId);

      final count = participants.length;

      // Update game
      await _client
          .schema('playnow')
          .from('games')
          .update({'current_players_count': count}).eq('id', gameId);

      // Check if full
      final gameData = await _client
          .schema('playnow')
          .from('games')
          .select('players_needed')
          .eq('id', gameId)
          .single();

      if (count >= gameData['players_needed']) {
        await _client
            .schema('playnow')
            .from('games')
            .update({'status': 'full'}).eq('id', gameId);
      }
    } catch (e) {
      print('Error updating players count: $e');
    }
  }

  static Future<void> _addUserToChatRoom(String gameId, String userId) async {
    try {
      // Get chat room ID from game
      final gameData = await _client
          .schema('playnow')
          .from('games')
          .select('chat_room_id')
          .eq('id', gameId)
          .maybeSingle();

      final chatRoomId = gameData?['chat_room_id'];
      if (chatRoomId != null) {
        // Check if already member
        final existing = await _client
            .schema('chat')
            .from('room_members')
            .select('id')
            .eq('room_id', chatRoomId)
            .eq('user_id', userId)
            .maybeSingle();

        if (existing == null) {
          await _client.schema('chat').from('room_members').insert({
            'room_id': chatRoomId,
            'user_id': userId,
            'role': 'member',
          });
        }
      }
    } catch (e) {
      print('Error adding user to chat room: $e');
    }
  }
}

/// Result of a payment operation
class PaymentResult {
  final bool success;
  final String message;
  final String? orderId;
  final int? amount;
  final String? paymentId;

  PaymentResult({
    required this.success,
    required this.message,
    this.orderId,
    this.amount,
    this.paymentId,
  });
}
