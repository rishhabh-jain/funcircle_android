import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/game_model.dart';
import '../services/game_payment_service.dart';
import '../services/payment_reconciliation_service.dart';
import '../services/offers_service.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Payment sheet for booking official Fun Circle games
class GamePaymentSheet extends StatefulWidget {
  final Game game;
  final String userName;
  final String? userEmail;
  final String? userContact;

  const GamePaymentSheet({
    super.key,
    required this.game,
    required this.userName,
    this.userEmail,
    this.userContact,
  });

  @override
  State<GamePaymentSheet> createState() => _GamePaymentSheetState();
}

class _GamePaymentSheetState extends State<GamePaymentSheet> {
  late Razorpay _razorpay;
  PaymentStatus _status = PaymentStatus.initiating;
  String _message = '';
  String? _orderId;
  int? _amount;
  int? _originalAmount;
  double? _discountPercentage;
  double? _discountAmount;
  Map<String, dynamic>? _appliedOffer;
  String? _paymentAttemptId;
  String? _paymentId;
  String? _signature;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _initiatePayment();
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _razorpay.clear();
    }
    super.dispose();
  }

  void _initializeRazorpay() {
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  Future<void> _initiatePayment() async {
    setState(() {
      _status = PaymentStatus.initiating;
      _message = 'Checking for offers...';
    });

    // Check for available offers
    final offers = await OffersService.getUserOffers(
      userId: currentUserUid,
      activeOnly: true,
    );

    Map<String, dynamic>? bestOffer;
    double bestDiscount = 0;

    for (final offer in offers) {
      double discount = 0;
      final discountPercentage = offer['discount_percentage'] as int?;
      final discountAmount = offer['discount_amount'] as num?;

      if (discountPercentage != null) {
        discount = widget.game.costPerPlayer! * (discountPercentage / 100);
      } else if (discountAmount != null) {
        discount = discountAmount.toDouble();
      }
      if (discount > bestDiscount) {
        bestDiscount = discount;
        bestOffer = offer;
      }
    }

    setState(() {
      _appliedOffer = bestOffer;
      _originalAmount = (widget.game.costPerPlayer! * 100).toInt();
      if (bestOffer != null) {
        final discountedPrice = widget.game.costPerPlayer! - bestDiscount;
        _amount = (discountedPrice * 100).toInt();
        final discountPercentage = bestOffer['discount_percentage'] as int?;
        _discountPercentage = discountPercentage?.toDouble();
        _discountAmount = bestDiscount;
        _message = 'Offer applied! Creating order...';
      } else {
        _amount = _originalAmount;
      }
    });

    // Wait a moment to show discount message
    if (bestOffer != null) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    setState(() {
      _message = 'Creating payment order...';
    });

    final result = await GamePaymentService.processGamePayment(
      game: widget.game,
      userId: currentUserUid,
      userName: widget.userName,
      userEmail: widget.userEmail,
      userContact: widget.userContact,
    );

    if (!result.success) {
      setState(() {
        _status = PaymentStatus.failed;
        _message = result.message;
      });
      _autoClose();
      return;
    }

    setState(() {
      _orderId = result.orderId;
      // Use discounted amount if offer is applied
      if (_appliedOffer == null) {
        _amount = result.amount;
      }
      _status = PaymentStatus.processing;
      _message = 'Opening payment gateway...';
    });

    // Create payment attempt record for reconciliation
    if (_orderId != null && _amount != null) {
      _paymentAttemptId = await PaymentReconciliationService.createPaymentAttempt(
        gameId: widget.game.id,
        userId: currentUserUid,
        amount: (_amount! / 100).toDouble(), // Convert paise to rupees
        orderId: _orderId!,
      );

      if (_paymentAttemptId != null) {
        await PaymentReconciliationService.updatePaymentAttemptProcessing(_paymentAttemptId!);
      }
    }

    // Open Razorpay checkout
    final options = {
      'key': GamePaymentService.razorpayKeyId,
      'amount': _amount,
      'name': 'Fun Circle',
      'description': 'PlayTime - ${widget.game.autoTitle}',
      'order_id': _orderId,
      'prefill': {
        'name': widget.userName,
        if (widget.userEmail != null) 'email': widget.userEmail,
        if (widget.userContact != null) 'contact': widget.userContact,
      },
      'theme': {
        'color': '#6C63FF',
      },
    };

    try {
      if (kIsWeb) {
        // For web, you would need to use Razorpay checkout.js
        // This is a placeholder - implement web checkout separately
        setState(() {
          _status = PaymentStatus.failed;
          _message = 'Web payments not yet implemented';
        });
        _autoClose();
      } else {
        _razorpay.open(options);
      }
    } catch (e) {
      setState(() {
        _status = PaymentStatus.failed;
        _message = 'Failed to open payment: $e';
      });
      _autoClose();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _status = PaymentStatus.verifying;
      _message = 'Verifying payment...';
    });

    // Store payment details for retry
    _paymentId = response.paymentId;
    _signature = response.signature;

    // Update payment attempt with captured details
    if (_paymentAttemptId != null) {
      await PaymentReconciliationService.updatePaymentAttemptCaptured(
        attemptId: _paymentAttemptId!,
        paymentId: response.paymentId!,
        signature: response.signature!,
      );
    }

    // Verify and record payment (with retry logic)
    await _verifyAndRecordPayment();
  }

  Future<void> _verifyAndRecordPayment() async {
    try {
      // Verify payment signature
      final isValid = await GamePaymentService.verifyPaymentSignature(
        orderId: _orderId!,
        paymentId: _paymentId!,
        signature: _signature!,
      );

      if (!isValid) {
        if (_paymentAttemptId != null) {
          await PaymentReconciliationService.updatePaymentAttemptFailed(
            attemptId: _paymentAttemptId!,
            errorMessage: 'Payment signature verification failed',
          );
        }

        setState(() {
          _status = PaymentStatus.failed;
          _message = 'Payment verification failed';
        });
        _autoClose();
        return;
      }

      // Record payment in database
      final recorded = await GamePaymentService.recordGamePayment(
        gameId: widget.game.id,
        userId: currentUserUid,
        paymentId: _paymentId!,
        amount: widget.game.costPerPlayer!,
      );

      if (recorded) {
        // Mark payment attempt as verified
        if (_paymentAttemptId != null) {
          await PaymentReconciliationService.updatePaymentAttemptVerified(_paymentAttemptId!);
        }

        // Mark offer as used if applied
        if (_appliedOffer != null) {
          await OffersService.useOffer(_appliedOffer!['id'] as String);
        }

        setState(() {
          _status = PaymentStatus.success;
          _message = 'Booking successful!';
        });
        _autoClose(delay: 2);
      } else {
        // Recording failed - offer retry
        if (_retryCount < maxRetries) {
          _retryCount++;
          setState(() {
            _message = 'Retrying... (${_retryCount}/$maxRetries)';
          });
          await Future.delayed(const Duration(seconds: 2));
          await _verifyAndRecordPayment(); // Retry
        } else {
          setState(() {
            _status = PaymentStatus.failed;
            _message = 'Payment captured but booking failed.\nDon\'t worry, our team will process it.\nContact support with payment ID: $_paymentId';
          });
          _autoClose(delay: 5);
        }
      }
    } catch (e) {
      print('Error verifying payment: $e');

      // Network error - offer retry
      if (_retryCount < maxRetries) {
        _retryCount++;
        setState(() {
          _message = 'Connection error. Retrying... (${_retryCount}/$maxRetries)';
        });
        await Future.delayed(const Duration(seconds: 2));
        await _verifyAndRecordPayment(); // Retry
      } else {
        if (_paymentAttemptId != null) {
          await PaymentReconciliationService.updatePaymentAttemptFailed(
            attemptId: _paymentAttemptId!,
            errorMessage: 'Network error during verification: $e',
          );
        }

        setState(() {
          _status = PaymentStatus.failed;
          _message = 'Payment captured but verification failed.\nYour payment is safe. We\'ll verify it shortly.\nPayment ID: $_paymentId';
        });
        _autoClose(delay: 5);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // Update payment attempt with error
    if (_paymentAttemptId != null) {
      await PaymentReconciliationService.updatePaymentAttemptFailed(
        attemptId: _paymentAttemptId!,
        errorMessage: response.message ?? 'Payment failed',
        errorCode: response.code?.toString(),
      );
    }

    setState(() {
      _status = PaymentStatus.failed;
      _message = response.message ?? 'Payment failed';
    });
    _autoClose();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _status = PaymentStatus.failed;
      _message = 'External wallet not supported';
    });
    _autoClose();
  }

  void _autoClose({int delay = 3}) {
    Future.delayed(Duration(seconds: delay), () {
      if (mounted) {
        Navigator.pop(context, _status == PaymentStatus.success);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getStatusColor().withValues(alpha: 0.95),
            _getStatusColor(),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: _buildStatusIcon(),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                _getStatusTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                _message,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              // Amount (show during processing)
              if (_status == PaymentStatus.processing && _amount != null) ...[
                const SizedBox(height: 20),

                // Show discount if applied
                if (_appliedOffer != null && _originalAmount != null) ...[
                  Text(
                    '₹${(_originalAmount! / 100).toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 20,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_discountPercentage != null ? "${_discountPercentage!.toInt()}%" : "₹${_discountAmount!.toStringAsFixed(0)}"} OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹${(_amount! / 100).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (_status) {
      case PaymentStatus.initiating:
      case PaymentStatus.processing:
      case PaymentStatus.verifying:
        return const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 4,
          ),
        );
      case PaymentStatus.success:
        return const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
          size: 50,
        );
      case PaymentStatus.failed:
        return const Icon(
          Icons.error_rounded,
          color: Colors.white,
          size: 50,
        );
    }
  }

  String _getStatusTitle() {
    switch (_status) {
      case PaymentStatus.initiating:
        return 'Initializing...';
      case PaymentStatus.processing:
        return 'Complete Payment';
      case PaymentStatus.verifying:
        return 'Verifying...';
      case PaymentStatus.success:
        return 'Success!';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case PaymentStatus.initiating:
      case PaymentStatus.processing:
        return const Color(0xFF6C63FF);
      case PaymentStatus.verifying:
        return Colors.orange;
      case PaymentStatus.success:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
    }
  }
}

enum PaymentStatus {
  initiating,
  processing,
  verifying,
  success,
  failed,
}
