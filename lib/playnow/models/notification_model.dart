/// Notification types for the app
enum NotificationType {
  gameCreatedByFriend('game_created_by_friend'),
  playerJoinedGame('player_joined_game'),
  joinRequestReceived('join_request_received'),
  joinRequestApproved('join_request_approved'),
  joinRequestDeclined('join_request_declined'),
  gameStartingSoon('game_starting_soon'),
  gameCancelled('game_cancelled'),
  newMessageInGameChat('new_message_in_game_chat'),
  referralRewardEarned('referral_reward_earned'),
  offerActivated('offer_activated');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.gameCreatedByFriend,
    );
  }
}

/// Notification model
class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  /// Get icon for notification type
  String get icon {
    switch (type) {
      case NotificationType.gameCreatedByFriend:
        return '🎮';
      case NotificationType.playerJoinedGame:
        return '👥';
      case NotificationType.joinRequestReceived:
        return '📨';
      case NotificationType.joinRequestApproved:
        return '✅';
      case NotificationType.joinRequestDeclined:
        return '❌';
      case NotificationType.gameStartingSoon:
        return '⏰';
      case NotificationType.gameCancelled:
        return '🚫';
      case NotificationType.newMessageInGameChat:
        return '💬';
      case NotificationType.referralRewardEarned:
        return '🎁';
      case NotificationType.offerActivated:
        return '🎉';
    }
  }

  /// Get action label for notification type
  String? get actionLabel {
    switch (type) {
      case NotificationType.gameCreatedByFriend:
      case NotificationType.gameStartingSoon:
        return 'View Game';
      case NotificationType.playerJoinedGame:
        return 'View Players';
      case NotificationType.joinRequestReceived:
        return 'View Request';
      case NotificationType.joinRequestApproved:
        return 'Open Chat';
      case NotificationType.newMessageInGameChat:
        return 'Open Chat';
      case NotificationType.referralRewardEarned:
        return 'View Reward';
      case NotificationType.offerActivated:
        return 'View Offer';
      default:
        return null;
    }
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: NotificationType.fromString(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.value,
      'title': title,
      'message': message,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
