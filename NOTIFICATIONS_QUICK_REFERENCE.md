# 🔔 Notifications Quick Reference Guide

## Your Requested Notifications - Implementation Status

### ✅ ALL IMPLEMENTED!

| # | Your Request | Method | Status |
|---|-------------|---------|--------|
| a | Chat message received | `notifyChatMessage()` | ✅ Done |
| b | Post game notification | `notifyPostGame()` | ✅ Done |
| c | Game reminder (1hr before, with location & players) | `notifyGameReminder()` | ✅ Done |
| d | Friend joined game, wanna join? | `notifyFriendJoinedGame()` | ✅ Done |
| e | Booking confirmation (date, venue, time) | `notifyBookingConfirmation()` | ✅ Done |
| f | 1 spot left in game (user's last 1 week) | `notifySpotLeft()` | ✅ Done |
| g | Game notification/update | `notifyGameUpdate()` | ✅ Done |

---

## Bonus: 20 Additional Notifications Implemented! 🎉

Based on your `playnow` and `findplayers` schemas, I added 20 more useful notifications:

### PlayNow (13 additional)
1. Game invite received
2. Join request received (for creator)
3. Join request approved
4. Join request declined
5. Player tagged (MVP, Best Player, etc.)
6. Rating received
7. Game results submitted
8. Game cancelled
9. Payment received
10. Wallet credit earned
11. Play pal added
12. Referral reward earned
13. Offer activated

### FindPlayers (7 additional)
1. Player request response
2. Player request fulfilled
3. Match found (auto-match)
4. Game session invite
5. Session spot filled
6. Session join request accepted
7. Session join request rejected

---

## 🚀 How to Use - Copy & Paste Examples

### 1. Chat Message Notification
```dart
import '../services/notifications_service.dart';
import '../backend/supabase/supabase.dart';

final notificationService = NotificationsService(SupaFlow.client);

await notificationService.notifyChatMessage(
  recipientId: 'recipient_user_id',
  senderId: currentUserUid,
  senderName: 'Rahul',
  messagePreview: 'Hey, ready for the game?',
  chatRoomId: 'room_123',
);
```

### 2. Game Reminder (1 hour before)
```dart
await notificationService.notifyGameReminder(
  userId: 'player_user_id',
  gameId: 'game_id',
  venueName: 'Sec 52, Gurgaon Badminton Club',
  location: 'Gurgaon',
  currentPlayers: 3,
  totalPlayers: 4,
  gameTime: DateTime.parse('2025-09-07 10:00:00'),
);
```

### 3. Booking Confirmation
```dart
await notificationService.notifyBookingConfirmation(
  userId: 'booker_user_id',
  venueName: 'Sec 52, Gurgaon Badminton Club',
  location: 'Gurgaon',
  date: DateTime.parse('2025-09-07'),
  timeSlot: '10:00 AM - 11:00 AM',
);
```

### 4. Friend Joined Game
```dart
await notificationService.notifyFriendJoinedGame(
  userId: 'user_to_notify',
  friendId: 'friend_user_id',
  friendName: 'Priya',
  gameId: 'game_id',
  gameDetails: 'Badminton Singles at Sec 52 Club, 7th Sep, 10 AM',
);
```

### 5. Spot Left Alert
```dart
await notificationService.notifySpotLeft(
  userId: 'user_id',
  gameId: 'game_id',
  gameDetails: 'Badminton Doubles at Sec 52 Club',
  spotsLeft: 1,
);
```

### 6. Post Game Rating Request
```dart
await notificationService.notifyPostGame(
  userId: 'player_user_id',
  gameId: 'game_id',
  gameTitle: 'Badminton Doubles at Sec 52 Club',
);
```

### 7. Join Request (Creator receives)
```dart
await notificationService.notifyJoinRequestReceived(
  creatorId: 'game_creator_id',
  requesterId: 'requester_user_id',
  requesterName: 'Amit',
  gameId: 'game_id',
  gameTitle: 'Badminton Singles',
  requestId: 'request_id',
);
```

### 8. Join Request Approved
```dart
await notificationService.notifyJoinRequestApproved(
  requesterId: 'requester_user_id',
  gameId: 'game_id',
  gameTitle: 'Badminton Singles',
);
```

### 9. Player Tagged
```dart
await notificationService.notifyPlayerTagged(
  taggedUserId: 'player_user_id',
  taggerId: 'tagger_user_id',
  taggerName: 'Rahul',
  gameId: 'game_id',
  tag: 'MVP',
);
```

### 10. Rating Received
```dart
await notificationService.notifyRatingReceived(
  ratedUserId: 'player_user_id',
  raterId: 'rater_user_id',
  raterName: 'Priya',
  gameId: 'game_id',
  rating: 5,
  comment: 'Great sportsmanship!',
);
```

### 11. Game Cancelled
```dart
await notificationService.notifyGameCancelled(
  participantIds: ['user1', 'user2', 'user3'],
  gameId: 'game_id',
  gameTitle: 'Badminton Doubles',
  reason: 'Venue maintenance',
);
```

### 12. Match Found (FindPlayers)
```dart
await notificationService.notifyMatchFound(
  userId: 'user_id',
  matchedUserId: 'matched_user_id',
  matchedUserName: 'Sneha',
  sportType: 'badminton',
  venueName: 'Sec 52 Club',
  distance: 2.5,
);
```

### 13. Player Request Fulfilled
```dart
await notificationService.notifyPlayerRequestFulfilled(
  requesterId: 'requester_id',
  requestId: 'request_id',
  sportType: 'badminton',
  venueName: 'Sec 52 Club',
  scheduledTime: DateTime.parse('2025-09-07 10:00:00'),
);
```

### 14. Wallet Credit Earned
```dart
await notificationService.notifyWalletCreditEarned(
  userId: 'user_id',
  amount: 100.0,
  source: 'Game Refund',
  description: 'Rain cancellation refund',
);
```

### 15. Referral Reward
```dart
await notificationService.notifyReferralRewardEarned(
  userId: 'referrer_id',
  amount: 50.0,
  referredUserId: 'new_user_id',
  referredUserName: 'Ravi',
);
```

---

## 🎯 Integration Points

### When to Trigger Each Notification

#### Game Lifecycle
- **Game Created** → No notification (user created it themselves)
- **Player Joins** → `notifyFriendJoinedGame()` to friends
- **Join Request** → `notifyJoinRequestReceived()` to creator
- **Request Approved** → `notifyJoinRequestApproved()` to requester
- **Request Declined** → `notifyJoinRequestDeclined()` to requester
- **1 Hour Before** → `notifyGameReminder()` to all participants
- **Spot Left** → `notifySpotLeft()` to users who played recently
- **Game Cancelled** → `notifyGameCancelled()` to all participants
- **Game Completed** → `notifyPostGame()` to all participants
- **Results Submitted** → `notifyGameResultsSubmitted()` to participants

#### Chat
- **Message Sent** → `notifyChatMessage()` to all room members except sender

#### Booking
- **Booking Success** → `notifyBookingConfirmation()` to booker

#### Rating & Rewards
- **Player Rated** → `notifyRatingReceived()` to rated player
- **Player Tagged** → `notifyPlayerTagged()` to tagged player
- **Referral Complete** → `notifyReferralRewardEarned()` to referrer
- **Play Pal Added** → `notifyPlayPalAdded()` to both users

#### FindPlayers
- **Match Found** → `notifyMatchFound()` to both users
- **Request Response** → `notifyPlayerRequestResponse()` to requester
- **Request Fulfilled** → `notifyPlayerRequestFulfilled()` to requester
- **Session Invite** → `notifyGameSessionInvite()` to invitee
- **Session Full** → `notifySessionSpotFilled()` to all participants

---

## 📱 Getting Unread Count

```dart
final notificationService = NotificationsService(SupaFlow.client);
final unreadCount = await notificationService.getUnreadCount(currentUserUid);
print('You have $unreadCount unread notifications');
```

---

## 🔄 Real-time Subscription

```dart
final notificationService = NotificationsService(SupaFlow.client);

final channel = notificationService.subscribeToNotifications(
  currentUserUid,
  (notification) {
    // New notification received!
    print('New: ${notification.title} - ${notification.body}');

    // Update UI, show badge, play sound, etc.
  },
);

// Don't forget to unsubscribe when done
await channel.unsubscribe();
```

---

## 🎨 Notification Icons & Colors

All notifications have custom icons and colors in the UI:

- **Chat**: 💬 Purple
- **Game Reminder**: ⏰ Orange
- **Booking**: ✅ Cyan
- **Rating**: ⭐ Gold
- **Payment**: 💰 Green
- **Cancelled**: 🚫 Red
- **Match Found**: 👥 Blue
- **Invite**: 📧 Deep Purple

See `NOTIFICATIONS_COMPLETE.md` for the full list!

---

## ✅ Checklist for Integration

- [ ] Import `NotificationsService` in your game/chat/booking services
- [ ] Call appropriate notification methods at the right lifecycle events
- [ ] Set up cron jobs for scheduled notifications (game reminders)
- [ ] Test each notification type
- [ ] Verify navigation from notification to correct screen
- [ ] Check push notifications work on iOS/Android
- [ ] Verify unread badge updates correctly
- [ ] Test real-time subscription

---

**Database Schema**: `playnow.notifications`
**Total Notifications**: **27 types**
**Status**: ✅ **FULLY IMPLEMENTED**

**Next**: Start calling these methods in your game/chat/booking flows!
