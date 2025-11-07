import 'package:flutter/foundation.dart';
import '/backend/supabase/supabase.dart';
import '/backend/cloud_functions/cloud_functions.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'game_payment_service.dart';

/// Service for handling payment reconciliation and fallbacks
/// Ensures no payments are lost even if app crashes or network fails
class PaymentReconciliationService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Check for pending payments on app startup
  /// This catches any payments that were completed but not recorded
  static Future<void> checkPendingPayments() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) return;

      debugPrint('Checking for pending payments...');

      // 1. Check local payment attempts that are not verified
      final pendingAttempts = await _client
          .schema('playnow')
          .from('payment_attempts')
          .select('*')
          .eq('user_id', userId)
          .inFilter('status', ['processing', 'captured'])
          .eq('reconciled', false)
          .order('created_at', ascending: false)
          .limit(10);

      if ((pendingAttempts as List).isEmpty) {
        debugPrint('No pending payment attempts found');
        return;
      }

      debugPrint('Found ${pendingAttempts.length} pending payment attempts');

      // 2. Check Firebase webhook events
      final webhookResponse = await makeCloudCall(
        'processPendingPayments',
        {},
      );

      final pendingWebhooks = webhookResponse['pending_payments'] as List? ?? [];
      debugPrint('Found ${pendingWebhooks.length} pending webhook events');

      // 3. Process each pending attempt
      for (final attempt in pendingAttempts) {
        await _reconcilePaymentAttempt(attempt);
      }
    } catch (e) {
      // Silently handle permission errors - table may not be accessible yet
      if (e.toString().contains('42501') || e.toString().contains('permission denied')) {
        // Permission error - ignore silently
        return;
      }
      debugPrint('Error checking pending payments: $e');
    }
  }

  /// Reconcile a specific payment attempt
  static Future<bool> _reconcilePaymentAttempt(Map<String, dynamic> attempt) async {
    try {
      final attemptId = attempt['id'] as String;
      final gameId = attempt['game_id'] as String;
      final userId = attempt['user_id'] as String;
      final paymentId = attempt['razorpay_payment_id'] as String?;
      final orderId = attempt['razorpay_order_id'] as String?;
      final amount = attempt['amount'] as num;

      debugPrint('Reconciling payment attempt: $attemptId');

      // If payment was captured but not verified
      if (paymentId != null && orderId != null) {
        debugPrint('Payment was captured, verifying...');

        // Check if already recorded in game_participants
        final existingParticipant = await _client
            .schema('playnow')
            .from('game_participants')
            .select('payment_id')
            .eq('game_id', gameId)
            .eq('user_id', userId)
            .maybeSingle();

        if (existingParticipant != null &&
            existingParticipant['payment_id'] == paymentId) {
          // Already recorded, just mark as reconciled
          await _markPaymentReconciled(attemptId);
          debugPrint('Payment already recorded, marked as reconciled');
          return true;
        }

        // Not recorded yet, record it now
        final recorded = await GamePaymentService.recordGamePayment(
          gameId: gameId,
          userId: userId,
          paymentId: paymentId,
          amount: amount.toDouble(),
        );

        if (recorded) {
          await _markPaymentReconciled(attemptId);
          debugPrint('Payment reconciled and recorded successfully');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error reconciling payment attempt: $e');
      return false;
    }
  }

  /// Mark a payment attempt as reconciled
  static Future<void> _markPaymentReconciled(String attemptId) async {
    try {
      await _client
          .schema('playnow')
          .from('payment_attempts')
          .update({
        'reconciled': true,
        'reconciled_at': DateTime.now().toIso8601String(),
        'status': 'verified',
      }).eq('id', attemptId);
    } catch (e) {
      debugPrint('Error marking payment as reconciled: $e');
    }
  }

  /// Create a payment attempt record BEFORE starting payment
  /// This ensures we have a record even if payment completes but app crashes
  static Future<String?> createPaymentAttempt({
    required String gameId,
    required String userId,
    required double amount,
    required String orderId,
  }) async {
    try {
      final result = await _client
          .schema('playnow')
          .from('payment_attempts')
          .insert({
        'game_id': gameId,
        'user_id': userId,
        'amount': amount,
        'razorpay_order_id': orderId,
        'status': 'initiated',
        'currency': 'INR',
        'app_version': '1.0.0', // You can get this from package_info
      }).select('id').single();

      return result['id'] as String;
    } catch (e) {
      debugPrint('Error creating payment attempt: $e');
      return null;
    }
  }

  /// Update payment attempt when payment is processing
  static Future<void> updatePaymentAttemptProcessing(String attemptId) async {
    try {
      await _client
          .schema('playnow')
          .from('payment_attempts')
          .update({
        'status': 'processing',
      }).eq('id', attemptId);
    } catch (e) {
      debugPrint('Error updating payment attempt: $e');
    }
  }

  /// Update payment attempt when payment is captured
  static Future<void> updatePaymentAttemptCaptured({
    required String attemptId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      await _client
          .schema('playnow')
          .from('payment_attempts')
          .update({
        'status': 'captured',
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
        'payment_completed_at': DateTime.now().toIso8601String(),
      }).eq('id', attemptId);
    } catch (e) {
      debugPrint('Error updating payment attempt: $e');
    }
  }

  /// Update payment attempt when payment is verified
  static Future<void> updatePaymentAttemptVerified(String attemptId) async {
    try {
      await _client
          .schema('playnow')
          .from('payment_attempts')
          .update({
        'status': 'verified',
        'verified_at': DateTime.now().toIso8601String(),
        'reconciled': true,
        'reconciled_at': DateTime.now().toIso8601String(),
      }).eq('id', attemptId);
    } catch (e) {
      debugPrint('Error updating payment attempt: $e');
    }
  }

  /// Update payment attempt when payment fails
  static Future<void> updatePaymentAttemptFailed({
    required String attemptId,
    required String errorMessage,
    String? errorCode,
  }) async {
    try {
      await _client
          .schema('playnow')
          .from('payment_attempts')
          .update({
        'status': 'failed',
        'error_message': errorMessage,
        'error_code': errorCode,
      }).eq('id', attemptId);
    } catch (e) {
      debugPrint('Error updating payment attempt: $e');
    }
  }

  /// Retry verification for a failed payment
  /// Useful if network failed during verification
  static Future<bool> retryPaymentVerification({
    required String gameId,
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      debugPrint('Retrying payment verification...');

      // Verify signature
      final isValid = await GamePaymentService.verifyPaymentSignature(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );

      if (!isValid) {
        debugPrint('Payment signature verification failed');
        return false;
      }

      // Get game and user info
      final gameData = await _client
          .schema('playnow')
          .from('games')
          .select('cost_per_player')
          .eq('id', gameId)
          .single();

      final amount = (gameData['cost_per_player'] as num).toDouble();

      // Record payment
      final recorded = await GamePaymentService.recordGamePayment(
        gameId: gameId,
        userId: currentUserUid,
        paymentId: paymentId,
        amount: amount,
      );

      return recorded;
    } catch (e) {
      debugPrint('Error retrying payment verification: $e');
      return false;
    }
  }

  /// Get all unreconciled payments for admin review
  static Future<List<Map<String, dynamic>>> getUnreconciledPayments() async {
    try {
      final result = await _client
          .schema('playnow')
          .from('payment_attempts')
          .select('*')
          .eq('reconciled', false)
          .inFilter('status', ['captured', 'processing'])
          .order('created_at', ascending: false)
          .limit(100);

      return List<Map<String, dynamic>>.from(result as List);
    } catch (e) {
      debugPrint('Error getting unreconciled payments: $e');
      return [];
    }
  }

  /// Manual reconciliation by admin
  static Future<bool> manualReconcile({
    required String attemptId,
    required bool shouldRecord,
  }) async {
    try {
      if (shouldRecord) {
        // Get attempt details
        final attempt = await _client
            .schema('playnow')
            .from('payment_attempts')
            .select('*')
            .eq('id', attemptId)
            .single();

        // Record payment
        final recorded = await GamePaymentService.recordGamePayment(
          gameId: attempt['game_id'],
          userId: attempt['user_id'],
          paymentId: attempt['razorpay_payment_id'],
          amount: (attempt['amount'] as num).toDouble(),
        );

        if (!recorded) return false;
      }

      // Mark as reconciled
      await _markPaymentReconciled(attemptId);
      return true;
    } catch (e) {
      debugPrint('Error in manual reconciliation: $e');
      return false;
    }
  }
}
