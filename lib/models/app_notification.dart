import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotification {
  final String id;
  final String userId;
  final String notificationType;
  final String title;
  final String body;
  final String? gameId;
  final String? chatRoomId;
  final String? fromUserId;
  final Map<String, dynamic>? data;
  final bool isRead;
  final bool isSent;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime? scheduledFor;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.notificationType,
    required this.title,
    required this.body,
    this.gameId,
    this.chatRoomId,
    this.fromUserId,
    this.data,
    required this.isRead,
    required this.isSent,
    this.sentAt,
    this.readAt,
    this.scheduledFor,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      notificationType: json['notification_type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      gameId: json['game_id'] as String?,
      chatRoomId: json['chat_room_id'] as String?,
      fromUserId: json['from_user_id'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      isSent: json['is_sent'] as bool? ?? false,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      scheduledFor: json['scheduled_for'] != null ? DateTime.parse(json['scheduled_for'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notification_type': notificationType,
      'title': title,
      'body': body,
      'game_id': gameId,
      'chat_room_id': chatRoomId,
      'from_user_id': fromUserId,
      'data': data,
      'is_read': isRead,
      'is_sent': isSent,
      'sent_at': sentAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'scheduled_for': scheduledFor?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      notificationType: notificationType,
      title: title,
      body: body,
      gameId: gameId,
      chatRoomId: chatRoomId,
      fromUserId: fromUserId,
      data: data,
      isRead: isRead ?? this.isRead,
      isSent: isSent,
      sentAt: sentAt,
      readAt: readAt ?? this.readAt,
      scheduledFor: scheduledFor,
      createdAt: createdAt,
    );
  }
}

// Notification types enum
class NotificationType {
  // Existing types
  static const String chatMessage = 'chat_message';
  static const String postGame = 'post_game';
  static const String gameReminder = 'game_reminder';
  static const String friendJoinedGame = 'friend_joined_game';
  static const String bookingConfirmation = 'booking_confirmation';
  static const String spotLeft = 'spot_left';
  static const String gameUpdate = 'game_update';
  static const String joinRequest = 'join_request';
  static const String requestAccepted = 'request_accepted';

  // PlayNow notifications
  static const String gameInviteReceived = 'game_invite_received';
  static const String joinRequestReceived = 'join_request_received';
  static const String joinRequestApproved = 'join_request_approved';
  static const String joinRequestDeclined = 'join_request_declined';
  static const String playerTagged = 'player_tagged';
  static const String ratingReceived = 'rating_received';
  static const String gameResultsSubmitted = 'game_results_submitted';
  static const String gameCancelled = 'game_cancelled';
  static const String paymentReceived = 'payment_received';
  static const String walletCreditEarned = 'wallet_credit_earned';
  static const String playPalAdded = 'play_pal_added';
  static const String referralRewardEarned = 'referral_reward_earned';
  static const String offerActivated = 'offer_activated';

  // FindPlayers notifications
  static const String playerRequestResponse = 'player_request_response';
  static const String playerRequestFulfilled = 'player_request_fulfilled';
  static const String matchFound = 'match_found';
  static const String gameSessionInvite = 'game_session_invite';
  static const String sessionSpotFilled = 'session_spot_filled';
  static const String sessionJoinRequestAccepted = 'session_join_request_accepted';
  static const String sessionJoinRequestRejected = 'session_join_request_rejected';
}
