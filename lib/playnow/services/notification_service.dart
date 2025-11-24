import '/backend/supabase/supabase.dart';
import '../models/notification_model.dart';

/// Service for managing app notifications
class NotificationService {
  static SupabaseClient get _client => SupaFlow.client;

  /// Create a notification
  static Future<bool> createNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _client.schema('playnow').from('notifications').insert({
        'user_id': userId,
        'type': type.value,
        'title': title,
        'message': message,
        'data': data,
        'is_read': false,
      });
      return true;
    } catch (e) {
      print('Error creating notification: $e');
      return false;
    }
  }

  /// Get notifications for a user
  static Future<List<AppNotification>> getUserNotifications({
    required String userId,
    bool unreadOnly = false,
    int limit = 50,
  }) async {
    try {
      var query = _client
          .schema('playnow').from('notifications')
          .select()
          .eq('user_id', userId);

      if (unreadOnly) {
        query = query.eq('is_read', false);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit) as List;

      return response
          .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  static Future<bool> markAsRead(String notificationId) async {
    try {
      await _client
          .schema('playnow').from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read for a user
  static Future<bool> markAllAsRead(String userId) async {
    try {
      await _client
          .schema('playnow').from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Get unread count
  static Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _client
          .schema('playnow').from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false) as List;

      return response.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Delete notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _client
          .schema('playnow').from('notifications')
          .delete()
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  // Notification creators for specific events

  /// Notify when a friend creates a game
  static Future<void> notifyGameCreatedByFriend({
    required String userId,
    required String friendName,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: userId,
      type: NotificationType.gameCreatedByFriend,
      title: 'New Game Created',
      message: '$friendName created a game: $gameTitle',
      data: {
        'game_id': gameId,
        'friend_name': friendName,
      },
    );
  }

  /// Notify game creator when someone joins
  static Future<void> notifyPlayerJoinedGame({
    required String creatorId,
    required String playerName,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: creatorId,
      type: NotificationType.playerJoinedGame,
      title: 'Player Joined',
      message: '$playerName joined your game: $gameTitle',
      data: {
        'game_id': gameId,
        'player_name': playerName,
      },
    );
  }

  /// Notify game creator of join request
  static Future<void> notifyJoinRequestReceived({
    required String creatorId,
    required String playerName,
    required String gameId,
    required String requestId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: creatorId,
      type: NotificationType.joinRequestReceived,
      title: 'Join Request',
      message: '$playerName wants to join your game: $gameTitle',
      data: {
        'game_id': gameId,
        'request_id': requestId,
        'player_name': playerName,
      },
    );
  }

  /// Notify player their request was approved
  static Future<void> notifyJoinRequestApproved({
    required String playerId,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: playerId,
      type: NotificationType.joinRequestApproved,
      title: 'Request Approved',
      message: 'You can now join: $gameTitle',
      data: {
        'game_id': gameId,
      },
    );
  }

  /// Notify player their request was declined
  static Future<void> notifyJoinRequestDeclined({
    required String playerId,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: playerId,
      type: NotificationType.joinRequestDeclined,
      title: 'Request Declined',
      message: 'Your request to join "$gameTitle" was declined',
      data: {
        'game_id': gameId,
      },
    );
  }

  /// Notify participants game is starting soon
  static Future<void> notifyGameStartingSoon({
    required List<String> participantIds,
    required String gameId,
    required String gameTitle,
    required DateTime gameTime,
  }) async {
    final hoursUntil = gameTime.difference(DateTime.now()).inHours;
    final message = hoursUntil <= 1
        ? '$gameTitle starts in less than an hour!'
        : '$gameTitle starts in $hoursUntil hours';

    for (final userId in participantIds) {
      await createNotification(
        userId: userId,
        type: NotificationType.gameStartingSoon,
        title: 'Game Starting Soon',
        message: message,
        data: {
          'game_id': gameId,
        },
      );
    }
  }

  /// Notify participants game was cancelled
  static Future<void> notifyGameCancelled({
    required List<String> participantIds,
    required String gameId,
    required String gameTitle,
    required String reason,
  }) async {
    for (final userId in participantIds) {
      await createNotification(
        userId: userId,
        type: NotificationType.gameCancelled,
        title: 'Game Cancelled',
        message: '$gameTitle has been cancelled. $reason',
        data: {
          'game_id': gameId,
        },
      );
    }
  }

  /// Notify about new message in game chat
  static Future<void> notifyNewMessageInGameChat({
    required List<String> participantIds,
    required String senderId,
    required String senderName,
    required String gameId,
    required String chatRoomId,
    required String messagePreview,
  }) async {
    // Don't notify the sender
    final recipientIds = participantIds.where((id) => id != senderId).toList();

    for (final userId in recipientIds) {
      await createNotification(
        userId: userId,
        type: NotificationType.newMessageInGameChat,
        title: 'New Message',
        message: '$senderName: $messagePreview',
        data: {
          'game_id': gameId,
          'chat_room_id': chatRoomId,
        },
      );
    }
  }

  /// Notify user they earned a referral reward
  static Future<void> notifyReferralRewardEarned({
    required String userId,
    required double amount,
    required String referredUserName,
  }) async {
    await createNotification(
      userId: userId,
      type: NotificationType.referralRewardEarned,
      title: 'Referral Reward',
      message: 'You earned ₹$amount for referring $referredUserName!',
      data: {
        'amount': amount,
        'referred_user': referredUserName,
      },
    );
  }

  /// Notify user an offer was activated
  static Future<void> notifyOfferActivated({
    required String userId,
    required String offerTitle,
    required String offerId,
  }) async {
    await createNotification(
      userId: userId,
      type: NotificationType.offerActivated,
      title: 'Offer Activated',
      message: 'Your offer "$offerTitle" is now active!',
      data: {
        'offer_id': offerId,
      },
    );
  }

  /// Notify user about new message in personal chat
  static Future<void> notifyNewMessageInPersonalChat({
    required String recipientId,
    required String senderId,
    required String senderName,
    required String chatRoomId,
    required String messagePreview,
  }) async {
    await createNotification(
      userId: recipientId,
      type: NotificationType.newMessageInPersonalChat,
      title: senderName,
      message: messagePreview,
      data: {
        'chat_room_id': chatRoomId,
        'sender_id': senderId,
      },
    );
  }
}
