import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_notification.dart';
import '../backend/push_notifications/push_notifications_util.dart';
import '../backend/backend.dart';

class NotificationsService {
  final SupabaseClient _supabase;

  NotificationsService(this._supabase);

  // Fetch notifications for a user
  Future<List<AppNotification>> getUserNotifications(
    String userId, {
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    try {
      var query = _supabase
          .schema('playnow')
          .from('notifications')
          .select()
          .eq('user_id', userId);

      if (unreadOnly) {
        query = query.eq('is_read', false);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _supabase
          .schema('playnow')
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase.schema('playnow').from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) async {
    try {
      await _supabase.schema('playnow').from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId).eq('is_read', false);
    } catch (e) {
      print('Error marking all as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .schema('playnow')
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Create notification (with push notification)
  Future<void> createNotification({
    required String userId,
    required String notificationType,
    required String title,
    required String body,
    String? gameId,
    String? chatRoomId,
    String? fromUserId,
    Map<String, dynamic>? data,
    bool sendPush = true,
    String? targetPageName,
  }) async {
    try {
      // Insert into database
      await _supabase.schema('playnow').from('notifications').insert({
        'user_id': userId,
        'notification_type': notificationType,
        'title': title,
        'body': body,
        'game_id': gameId,
        'chat_room_id': chatRoomId,
        'from_user_id': fromUserId,
        'data': data,
        'is_sent': sendPush,
        'sent_at': sendPush ? DateTime.now().toIso8601String() : null,
      });

      // Send push notification if enabled
      if (sendPush) {
        await _sendPushNotification(
          userId: userId,
          title: title,
          body: body,
          data: data ?? {},
          notificationType: notificationType,
          targetPageName: targetPageName,
        );
      }
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  // Send push notification via Firebase
  Future<void> _sendPushNotification({
    required String userId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required String notificationType,
    String? targetPageName,
  }) async {
    try {
      // Get user's Firebase document reference
      final userQuery = await UsersRecord.collection
          .where('uid', isEqualTo: userId)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) return;

      final userRef = userQuery.docs.first.reference;

      // Determine target page based on notification type
      String pageName = targetPageName ?? 'notifications';
      Map<String, dynamic> pageParams = {};

      switch (notificationType) {
        case NotificationType.chatMessage:
          pageName = 'chatsnew';
          break;
        case NotificationType.postGame:
        case NotificationType.gameReminder:
        case NotificationType.friendJoinedGame:
        case NotificationType.gameUpdate:
          pageName = 'playnew';
          if (data['game_id'] != null) {
            pageParams['gameId'] = data['game_id'];
          }
          break;
        case NotificationType.bookingConfirmation:
          pageName = 'VenuesNew';
          break;
      }

      // Use Firebase push notification system
      triggerPushNotification(
        notificationTitle: title,
        notificationText: body,
        userRefs: [userRef],
        initialPageName: pageName,
        parameterData: pageParams,
      );
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  // Chat message notification
  Future<void> notifyChatMessage({
    required String recipientId,
    required String senderId,
    required String senderName,
    required String messagePreview,
    required String chatRoomId,
  }) async {
    await createNotification(
      userId: recipientId,
      notificationType: NotificationType.chatMessage,
      title: senderName,
      body: messagePreview,
      chatRoomId: chatRoomId,
      fromUserId: senderId,
    );
  }

  // Post game notification
  Future<void> notifyPostGame({
    required String userId,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.postGame,
      title: 'Rate Your Game',
      body: 'How was your experience in $gameTitle? Rate your co-players!',
      gameId: gameId,
    );
  }

  // Game reminder (1 hour before)
  Future<void> notifyGameReminder({
    required String userId,
    required String gameId,
    required String venueName,
    required String location,
    required int currentPlayers,
    required int totalPlayers,
    required DateTime gameTime,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.gameReminder,
      title: 'Game Starting Soon!',
      body: 'Your game at $venueName starts in 1 hour. $currentPlayers/$totalPlayers players confirmed.',
      gameId: gameId,
      data: {
        'venue': venueName,
        'location': location,
        'current_players': currentPlayers,
        'total_players': totalPlayers,
        'game_time': gameTime.toIso8601String(),
      },
    );
  }

  // Friend joined game
  Future<void> notifyFriendJoinedGame({
    required String userId,
    required String friendId,
    required String friendName,
    required String gameId,
    required String gameDetails,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.friendJoinedGame,
      title: '$friendName joined a game',
      body: 'Want to join? $gameDetails',
      gameId: gameId,
      fromUserId: friendId,
    );
  }

  // Booking confirmation
  Future<void> notifyBookingConfirmation({
    required String userId,
    required String venueName,
    required String location,
    required DateTime date,
    required String timeSlot,
  }) async {
    final dateStr = '${date.day}/${date.month}/${date.year}';
    await createNotification(
      userId: userId,
      notificationType: NotificationType.bookingConfirmation,
      title: 'Booking Confirmed!',
      body: 'You have booked $venueName, $location on $dateStr at $timeSlot',
      data: {
        'venue': venueName,
        'location': location,
        'date': date.toIso8601String(),
        'time_slot': timeSlot,
      },
    );
  }

  // Spot left in game
  Future<void> notifySpotLeft({
    required String userId,
    required String gameId,
    required String gameDetails,
    required int spotsLeft,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.spotLeft,
      title: '$spotsLeft spot${spotsLeft > 1 ? 's' : ''} left!',
      body: 'Quick! $gameDetails has only $spotsLeft spot${spotsLeft > 1 ? 's' : ''} remaining.',
      gameId: gameId,
      data: {'spots_left': spotsLeft},
    );
  }

  // Game update notification
  Future<void> notifyGameUpdate({
    required String userId,
    required String gameId,
    required String updateTitle,
    required String updateMessage,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.gameUpdate,
      title: updateTitle,
      body: updateMessage,
      gameId: gameId,
    );
  }

  // ========== PLAYNOW NOTIFICATIONS ==========

  // Game invite received
  Future<void> notifyGameInviteReceived({
    required String recipientId,
    required String senderId,
    required String senderName,
    required String gameId,
    required String gameTitle,
    required String inviteCode,
  }) async {
    await createNotification(
      userId: recipientId,
      notificationType: NotificationType.gameInviteReceived,
      title: 'Game Invite',
      body: '$senderName invited you to join: $gameTitle',
      gameId: gameId,
      fromUserId: senderId,
      data: {'invite_code': inviteCode},
    );
  }

  // Join request received (for game creator)
  Future<void> notifyJoinRequestReceived({
    required String creatorId,
    required String requesterId,
    required String requesterName,
    required String gameId,
    required String gameTitle,
    required String requestId,
  }) async {
    await createNotification(
      userId: creatorId,
      notificationType: NotificationType.joinRequestReceived,
      title: 'Join Request',
      body: '$requesterName wants to join your game: $gameTitle',
      gameId: gameId,
      fromUserId: requesterId,
      data: {'request_id': requestId},
    );
  }

  // Join request approved
  Future<void> notifyJoinRequestApproved({
    required String requesterId,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.joinRequestApproved,
      title: 'Request Approved!',
      body: 'Your request to join "$gameTitle" was approved',
      gameId: gameId,
    );
  }

  // Join request declined
  Future<void> notifyJoinRequestDeclined({
    required String requesterId,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.joinRequestDeclined,
      title: 'Request Declined',
      body: 'Your request to join "$gameTitle" was declined',
      gameId: gameId,
    );
  }

  // Player tagged in game
  Future<void> notifyPlayerTagged({
    required String taggedUserId,
    required String taggerId,
    required String taggerName,
    required String gameId,
    required String tag,
  }) async {
    await createNotification(
      userId: taggedUserId,
      notificationType: NotificationType.playerTagged,
      title: 'You were tagged!',
      body: '$taggerName tagged you as "$tag" in the game',
      gameId: gameId,
      fromUserId: taggerId,
      data: {'tag': tag},
    );
  }

  // Rating received
  Future<void> notifyRatingReceived({
    required String ratedUserId,
    required String raterId,
    required String raterName,
    required String gameId,
    required int rating,
    String? comment,
  }) async {
    await createNotification(
      userId: ratedUserId,
      notificationType: NotificationType.ratingReceived,
      title: 'New Rating',
      body: '$raterName rated you $rating⭐${comment != null ? ': "$comment"' : ''}',
      gameId: gameId,
      fromUserId: raterId,
      data: {'rating': rating, 'comment': comment},
    );
  }

  // Game results submitted
  Future<void> notifyGameResultsSubmitted({
    required List<String> participantIds,
    required String submitterId,
    required String submitterName,
    required String gameId,
    required String gameTitle,
  }) async {
    for (final userId in participantIds) {
      if (userId == submitterId) continue; // Don't notify submitter
      await createNotification(
        userId: userId,
        notificationType: NotificationType.gameResultsSubmitted,
        title: 'Game Results',
        body: '$submitterName submitted results for $gameTitle',
        gameId: gameId,
        fromUserId: submitterId,
      );
    }
  }

  // Game cancelled
  Future<void> notifyGameCancelled({
    required List<String> participantIds,
    required String gameId,
    required String gameTitle,
    required String reason,
  }) async {
    for (final userId in participantIds) {
      await createNotification(
        userId: userId,
        notificationType: NotificationType.gameCancelled,
        title: 'Game Cancelled',
        body: '$gameTitle has been cancelled. $reason',
        gameId: gameId,
        data: {'reason': reason},
      );
    }
  }

  // Payment received
  Future<void> notifyPaymentReceived({
    required String userId,
    required double amount,
    required String gameId,
    required String gameTitle,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.paymentReceived,
      title: 'Payment Received',
      body: 'You received ₹$amount for $gameTitle',
      gameId: gameId,
      data: {'amount': amount},
    );
  }

  // Wallet credit earned
  Future<void> notifyWalletCreditEarned({
    required String userId,
    required double amount,
    required String source,
    String? description,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.walletCreditEarned,
      title: 'Wallet Credit Earned',
      body: 'You earned ₹$amount from $source${description != null ? ': $description' : ''}',
      data: {'amount': amount, 'source': source},
    );
  }

  // Play pal added
  Future<void> notifyPlayPalAdded({
    required String userId,
    required String partnerId,
    required String partnerName,
    required int gamesPlayedTogether,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.playPalAdded,
      title: 'New Play Pal!',
      body: '$partnerName is now your Play Pal! You\'ve played $gamesPlayedTogether ${gamesPlayedTogether == 1 ? 'game' : 'games'} together',
      fromUserId: partnerId,
      data: {'games_played': gamesPlayedTogether},
    );
  }

  // Referral reward earned
  Future<void> notifyReferralRewardEarned({
    required String userId,
    required double amount,
    required String referredUserId,
    required String referredUserName,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.referralRewardEarned,
      title: 'Referral Reward!',
      body: 'You earned ₹$amount for referring $referredUserName',
      fromUserId: referredUserId,
      data: {'amount': amount},
    );
  }

  // Offer activated
  Future<void> notifyOfferActivated({
    required String userId,
    required String offerType,
    required String offerCode,
    double? discountAmount,
    int? discountPercentage,
  }) async {
    final discount = discountAmount != null
        ? '₹$discountAmount off'
        : '$discountPercentage% off';
    await createNotification(
      userId: userId,
      notificationType: NotificationType.offerActivated,
      title: 'Offer Activated!',
      body: 'Your offer "$offerType" is now active! Get $discount',
      data: {
        'offer_code': offerCode,
        'discount_amount': discountAmount,
        'discount_percentage': discountPercentage,
      },
    );
  }

  // ========== FINDPLAYERS NOTIFICATIONS ==========

  // Player request response
  Future<void> notifyPlayerRequestResponse({
    required String requesterId,
    required String responderId,
    required String responderName,
    required String requestId,
    required String status,
    String? message,
  }) async {
    final statusText = status == 'accepted' ? 'is interested' : 'responded';
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.playerRequestResponse,
      title: 'Request Response',
      body: '$responderName $statusText in your player request${message != null ? ': "$message"' : ''}',
      fromUserId: responderId,
      data: {'request_id': requestId, 'status': status, 'message': message},
    );
  }

  // Player request fulfilled
  Future<void> notifyPlayerRequestFulfilled({
    required String requesterId,
    required String requestId,
    required String sportType,
    required String venueName,
    required DateTime scheduledTime,
  }) async {
    final dateStr = '${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year}';
    final timeStr = '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}';
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.playerRequestFulfilled,
      title: 'Request Fulfilled!',
      body: 'Enough players found for your $sportType request at $venueName on $dateStr at $timeStr',
      data: {
        'request_id': requestId,
        'venue': venueName,
        'scheduled_time': scheduledTime.toIso8601String(),
      },
    );
  }

  // Match found
  Future<void> notifyMatchFound({
    required String userId,
    required String matchedUserId,
    required String matchedUserName,
    required String sportType,
    required String venueName,
    required double distance,
  }) async {
    await createNotification(
      userId: userId,
      notificationType: NotificationType.matchFound,
      title: 'Match Found!',
      body: '$matchedUserName wants to play $sportType at $venueName (${distance.toStringAsFixed(1)} km away)',
      fromUserId: matchedUserId,
      data: {
        'sport_type': sportType,
        'venue': venueName,
        'distance': distance,
      },
    );
  }

  // Game session invite
  Future<void> notifyGameSessionInvite({
    required String recipientId,
    required String senderId,
    required String senderName,
    required String sessionId,
    required String sportType,
    required String venueName,
    required DateTime scheduledTime,
  }) async {
    final dateStr = '${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year}';
    final timeStr = '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}';
    await createNotification(
      userId: recipientId,
      notificationType: NotificationType.gameSessionInvite,
      title: 'Session Invite',
      body: '$senderName invited you to a $sportType session at $venueName on $dateStr at $timeStr',
      fromUserId: senderId,
      data: {
        'session_id': sessionId,
        'venue': venueName,
        'scheduled_time': scheduledTime.toIso8601String(),
      },
    );
  }

  // Session spot filled
  Future<void> notifySessionSpotFilled({
    required List<String> participantIds,
    required String sessionId,
    required String sportType,
    required String venueName,
    required DateTime scheduledTime,
  }) async {
    final dateStr = '${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year}';
    final timeStr = '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}';
    for (final userId in participantIds) {
      await createNotification(
        userId: userId,
        notificationType: NotificationType.sessionSpotFilled,
        title: 'Session Full!',
        body: 'Your $sportType session at $venueName on $dateStr at $timeStr is now full',
        data: {
          'session_id': sessionId,
          'venue': venueName,
          'scheduled_time': scheduledTime.toIso8601String(),
        },
      );
    }
  }

  // Session join request accepted
  Future<void> notifySessionJoinRequestAccepted({
    required String requesterId,
    required String sessionId,
    required String sportType,
    required String venueName,
  }) async {
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.sessionJoinRequestAccepted,
      title: 'Request Accepted!',
      body: 'You can now join the $sportType session at $venueName',
      data: {'session_id': sessionId, 'venue': venueName},
    );
  }

  // Session join request rejected
  Future<void> notifySessionJoinRequestRejected({
    required String requesterId,
    required String sessionId,
    required String sportType,
    required String venueName,
  }) async {
    await createNotification(
      userId: requesterId,
      notificationType: NotificationType.sessionJoinRequestRejected,
      title: 'Request Declined',
      body: 'Your request to join the $sportType session at $venueName was declined',
      data: {'session_id': sessionId, 'venue': venueName},
    );
  }

  // Subscribe to real-time notifications
  RealtimeChannel subscribeToNotifications(
    String userId,
    Function(AppNotification) onNotification,
  ) {
    final channel = _supabase
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'playnow',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final notification = AppNotification.fromJson(payload.newRecord);
            onNotification(notification);
          },
        )
        .subscribe();

    return channel;
  }
}
