/// User offer model for playnow.user_offers table
class UserOffer {
  final String id;
  final String userId;
  final String offerType; // 'first_game_free', 'referral_bonus', 'milestone_reward'
  final String title;
  final String description;
  final double? discountAmount;
  final int? discountPercentage;
  final String status; // 'active', 'used', 'expired'
  final DateTime? expiresAt;
  final DateTime createdAt;

  UserOffer({
    required this.id,
    required this.userId,
    required this.offerType,
    required this.title,
    required this.description,
    this.discountAmount,
    this.discountPercentage,
    required this.status,
    this.expiresAt,
    required this.createdAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isActive => status == 'active' && !isExpired;

  String get displayDiscount {
    if (discountAmount != null) {
      return '₹${discountAmount!.toStringAsFixed(0)} off';
    } else if (discountPercentage != null) {
      return '$discountPercentage% off';
    }
    return 'Special Offer';
  }

  factory UserOffer.fromJson(Map<String, dynamic> json) {
    return UserOffer(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      offerType: json['offer_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      discountAmount: json['discount_amount'] != null
          ? (json['discount_amount'] as num).toDouble()
          : null,
      discountPercentage: json['discount_percentage'] as int?,
      status: json['status'] as String,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'offer_type': offerType,
      'title': title,
      'description': description,
      'discount_amount': discountAmount,
      'discount_percentage': discountPercentage,
      'status': status,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Referral model for playnow.referrals table
class Referral {
  final String id;
  final String referrerUserId;
  final String referredUserId;
  final String referralCode;
  final String status; // 'pending', 'completed', 'rewarded'
  final double? rewardAmount;
  final DateTime createdAt;
  final DateTime? completedAt;

  Referral({
    required this.id,
    required this.referrerUserId,
    required this.referredUserId,
    required this.referralCode,
    required this.status,
    this.rewardAmount,
    required this.createdAt,
    this.completedAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] as String,
      referrerUserId: json['referrer_user_id'] as String,
      referredUserId: json['referred_user_id'] as String,
      referralCode: json['referral_code'] as String,
      status: json['status'] as String,
      rewardAmount: json['reward_amount'] != null
          ? (json['reward_amount'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referrer_user_id': referrerUserId,
      'referred_user_id': referredUserId,
      'referral_code': referralCode,
      'status': status,
      'reward_amount': rewardAmount,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
