# Flutter App - 9 New Features Implementation Guide

## 🎯 Overview
Implement 9 interconnected features for a sports app (Badminton & Pickleball) using Flutter + Supabase.

## 📋 Prerequisites
1. Run `new_features_migration.sql` on your Supabase database first
2. All new tables are in `playnow` schema
3. Skill levels: 1=Beginner, 2=Beginner+, 3=Intermediate, 4=Upper Intermediate, 5=Advanced

---

## ✨ FEATURE 1: CREATE GAME (Priority: HIGH)

### User Story
"As a player, I want to create a game so others can join me"

### UI/UX Requirements
**Design Philosophy:** Simple, not overwhelming
- Progressive disclosure (essential fields first)
- Smart defaults (today's date, current time + 1 hour)
- Live preview as user fills form
- One-step creation (no multi-step wizard)

### Form Fields (Order of Importance):

#### Essential (Always Visible):
1. **Sport**: Badminton | Pickleball (segmented control)
2. **Date & Time**: Date picker + Time picker
3. **Location**: Choose Venue (dropdown) OR Custom Location (text)
4. **Players Needed**: Stepper (2-8)
5. **Game Type**: Singles | Doubles | Mixed Doubles (chips)

#### Pricing:
6. **Cost**: Free toggle OR ₹ amount per player
7. **Join Type**: Auto Join | Request to Join (radio)

#### Advanced (Collapsible "More Options"):
8. **Skill Level**: Any | 1 | 2 | 3 | 4 | 5 (dropdown)
9. **Checkboxes**: 
   - [ ] Venue Already Booked
   - [ ] Women Only  
   - [ ] Mixed Game Only
10. **Description**: Text area (optional, 200 chars max)

### Auto-Generated Title Format:
`{game_type} {sport} - {level/open} - {date_time}`

Examples:
- "Doubles Badminton - Level 3-4 - Sat 7 PM"
- "Singles Pickleball - Open - Today 6 PM"

### Implementation Structure:
```
lib/screens/play_new/
├── play_new_screen.dart
├── widgets/
│   ├── create_game_bottom_sheet.dart
│   ├── game_form_section.dart
│   ├── venue_selector_widget.dart
│   ├── date_time_picker_widget.dart
│   └── game_preview_card.dart
└── play_new_controller.dart (Riverpod/Provider)
```

### Data Flow:
```dart
1. User taps FAB "Create Game"
2. Show bottom sheet with form
3. As user fills → Update preview card
4. On "Create":
   - Validate all fields
   - Insert into playnow.games
   - Auto-add creator to game_participants (trigger handles chat)
   - Show success toast
   - Navigate to game details

// Create Game Model
class Game {
  final String id;
  final String createdBy;
  final String sportType; // 'badminton', 'pickleball'
  final DateTime gameDate;
  final TimeOfDay startTime;
  final int? venueId;
  final String? customLocation;
  final int playersNeeded;
  final String gameType; // 'singles', 'doubles', 'mixed_doubles'
  final int? skillLevel; // 1-5 or null
  final double? costPerPlayer;
  final bool isFree;
  final String joinType; // 'auto', 'request'
  final bool isVenueBooked;
  final bool isWomenOnly;
  final bool isMixedOnly;
  final String? description;
  final String status; // 'open', 'full', 'in_progress', 'completed'
  final String? chatRoomId;
  
  String get autoTitle => _generateTitle();
}

// Service
class GameService {
  Future<Game> createGame(CreateGameRequest request) async {
    final game = await supabase.from('playnow.games').insert({
      'created_by': request.userId,
      'sport_type': request.sportType,
      'game_date': request.gameDate.toIso8601String(),
      'start_time': request.startTime.format24Hour(),
      // ... all other fields
    }).select().single();
    
    return Game.fromJson(game);
  }
}
```

### Key Points:
- Creator is automatically added as first participant
- Chat room auto-created via database trigger
- Status starts as 'open'
- Current_players_count = 1 initially

---

## ✨ FEATURE 2: JOIN GAME (Priority: HIGH)

### Two Join Flows:

#### A. Auto Join (Instant)
```
User → Taps "Join Game"
  ↓
Confirmation Dialog:
  "Join Badminton Doubles?"
  "₹500 per player"
  [Cancel] [Confirm Join]
  ↓
If Confirmed:
  - Check if game not full
  - Insert into game_participants
  - Add to chat room (trigger handles)
  - Show success toast
  - Navigate to game details
  - Notify creator
```

#### B. Request to Join
```
User → Taps "Request to Join"
  ↓
Request Dialog:
  "Request to join?"
  [Optional message input]
  [Send Request]
  ↓
If Sent:
  - Insert into game_join_requests (status: 'pending')
  - Show "Request sent" toast
  - Notify creator
  ↓
Creator → Sees notification
  ↓
Creator → Opens game details → "Join Requests" section
  ↓
Creator → Taps Accept or Reject
  ↓
If Accepted:
  - Update request status to 'accepted'
  - Insert into game_participants
  - Add to chat
  - Notify requester "You're in!"
If Rejected:
  - Update request status to 'rejected'
  - Notify requester "Request declined"
```

### Implementation:

**Join Button (Smart):**
```dart
Widget build() {
  if (game.isFull) return Text('Game Full');
  if (hasUserJoined) return Text('Joined ✓');
  if (hasPendingRequest) return Text('Request Pending...');
  
  return ElevatedButton(
    onPressed: () => game.joinType == 'auto' 
      ? _showAutoJoinDialog() 
      : _showRequestJoinDialog(),
    child: Text(game.joinType == 'auto' ? 'Join Game' : 'Request to Join'),
  );
}
```

**Join Request Card (for Creator):**
```dart
class JoinRequestCard extends StatelessWidget {
  Widget build() {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(user.profilePicture)),
        title: Text('${user.name} wants to join'),
        subtitle: Text(request.message ?? ''),
        trailing: Row(
          children: [
            IconButton(icon: Icon(Icons.close), onPressed: _reject),
            IconButton(icon: Icon(Icons.check), onPressed: _accept),
          ],
        ),
      ),
    );
  }
}
```

---

## ✨ FEATURE 3: GAME CHAT IN CHATS SCREEN (Priority: MEDIUM)

### Requirements:
- Game chats appear in existing chat list
- Add filter tabs: All | Personal | Games | Past Games
- Show game context (date, venue, player count)
- Auto-move to "Past Games" when game.status = 'completed'

### Chat List Item for Game Chat:
```dart
class GameChatTile extends StatelessWidget {
  Widget build() {
    return ListTile(
      leading: Icon(game.sportType == 'badminton' ? Icons.sports_tennis : Icons.sports),
      title: Row(
        children: [
          Text(game.autoTitle),
          if (game.status == 'completed') Chip(label: Text('Past')),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📍 ${game.venueName} · ${game.formattedDate}'),
          Text('👥 ${game.currentPlayersCount}/${game.playersNeeded} players'),
          Text(lastMessage.content), // Last chat message
        ],
      ),
      trailing: Text(lastMessage.formattedTime),
      onTap: () => Navigator.push(...),
    );
  }
}
```

### Filter Implementation:
```dart
// Query for game chats
final gameChats = await supabase
  .from('chat.rooms')
  .select('*, games:meta_data->>game_id(*)')
  .eq('type', 'group')
  .not('meta_data->>game_id', 'is', null)
  .order('updated_at', ascending: false);

// Filter by game status
final upcomingGameChats = gameChats.where((chat) => 
  chat.games?.status != 'completed'
);

final pastGameChats = gameChats.where((chat) => 
  chat.games?.status == 'completed'
);
```

---

## ✨ FEATURE 4: BOOK COURTS SCREEN (Priority: MEDIUM)

### Requirements:
- Grid view of venues
- Filter by sport (top chips)
- Filter by location (dropdown)
- Tap venue → Navigate to existing SingleVenueNew screen

### UI Layout:
```dart
Scaffold(
  appBar: AppBar(title: Text('Book Courts')),
  body: Column(
    children: [
      // Sport filter
      Row(
        children: [
          FilterChip(label: Text('Badminton'), selected: sportFilter == 'badminton'),
          FilterChip(label: Text('Pickleball'), selected: sportFilter == 'pickleball'),
        ],
      ),
      
      // Location dropdown
      DropdownButton<String>(
        value: selectedCity,
        items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
        onChanged: (city) => setState(() => selectedCity = city),
      ),
      
      // Venues grid
      Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: venues.length,
          itemBuilder: (context, index) => VenueCard(
            venue: venues[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SingleVenueNewScreen(venueId: venues[index].id),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
)
```

**Venue Card:**
```dart
class VenueCard extends StatelessWidget {
  Widget build() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(venue.imageUrl, height: 120, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venue.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(venue.location, style: TextStyle(fontSize: 12)),
                if (venue.pricePerHour != null)
                  Text('₹${venue.pricePerHour}/hr', style: TextStyle(color: Colors.green)),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text('${venue.rating ?? 'New'}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## ✨ FEATURE 5: OFFERS & REFERRALS (Priority: MEDIUM)

### 5A: 50% Off for New Users

**Logic:**
```dart
class OfferService {
  Future<Offer?> checkNewUserOffer(String userId) async {
    // Check if user has any previous orders
    final orders = await supabase
      .from('orders')
      .select('id')
      .eq('user_id', userId)
      .limit(1);
    
    if (orders.isEmpty) {
      // First time user - create 50% off offer
      return await _createNewUserOffer(userId);
    }
    
    return null;
  }
  
  Future<Offer> _createNewUserOffer(String userId) async {
    final offer = await supabase.from('playnow.user_offers').insert({
      'user_id': userId,
      'offer_type': 'new_user_50',
      'discount_percentage': 50,
      'expires_at': DateTime.now().add(Duration(days: 30)).toIso8601String(),
    }).select().single();
    
    return Offer.fromJson(offer);
  }
  
  Future<void> applyOffer(String offerId, String orderId) async {
    await supabase.from('playnow.user_offers').update({
      'is_used': true,
      'used_at': DateTime.now().toIso8601String(),
      'order_id': orderId,
    }).eq('id', offerId);
  }
}
```

**Show Offer Banner on Checkout:**
```dart
if (availableOffer != null) {
  Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text('🎉 SPECIAL OFFER!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text('50% OFF Your First Game', style: TextStyle(color: Colors.white)),
        Text('Save ₹${discount}', style: TextStyle(color: Colors.yellow, fontSize: 20)),
        ElevatedButton(
          onPressed: () => _applyOffer(availableOffer.id),
          child: Text('Apply Offer'),
        ),
      ],
    ),
  )
}
```

### 5B: Referral Program

**Referral Screen:**
```dart
class ReferralScreen extends StatelessWidget {
  Widget build() {
    return Scaffold(
      appBar: AppBar(title: Text('Refer & Earn')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Your Referral Code', style: heading),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(referralCode, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              IconButton(icon: Icon(Icons.copy), onPressed: _copyCode),
                              IconButton(icon: Icon(Icons.share), onPressed: _shareCode),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            Text('Earn ₹50 for every friend who plays their first game', textAlign: TextAlign.center),
            
            SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(title: 'Referrals', value: stats.referralCount.toString()),
                _StatCard(title: 'Earnings', value: '₹${stats.totalEarnings}'),
              ],
            ),
            
            SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () => Navigator.push(...),
              child: Text('View Referral History'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _shareCode() {
    final message = '''
🏸 Join me on PlaySports!
Use my code: $referralCode
Get ₹50 off your first game!

Download: https://yourapp.com/r/$referralCode
    ''';
    Share.share(message);
  }
}
```

**Referral Logic:**
```dart
class ReferralService {
  Future<String> generateReferralCode(String userId) async {
    final code = _generateUniqueCode(userId);
    
    await supabase.from('playnow.referrals').insert({
      'referrer_id': userId,
      'referral_code': code,
      'status': 'active',
    });
    
    return code;
  }
  
  Future<void> applyReferralOnSignup(String newUserId, String referralCode) async {
    final referral = await supabase
      .from('playnow.referrals')
      .select('referrer_id')
      .eq('referral_code', referralCode)
      .single();
    
    if (referral != null) {
      await supabase.from('playnow.referrals').insert({
        'referrer_id': referral['referrer_id'],
        'referred_id': newUserId,
        'referral_code': referralCode,
        'status': 'pending', // Will be 'completed' after first game
      });
    }
  }
  
  Future<void> completeReferral(String referredUserId) async {
    // Called when referred user completes first game
    final referral = await supabase
      .from('playnow.referrals')
      .update({'status': 'completed', 'reward_claimed': true})
      .eq('referred_id', referredUserId)
      .eq('status', 'pending')
      .select()
      .single();
    
    if (referral != null) {
      // Credit ₹50 to referrer's wallet
      await _walletService.creditWallet(
        referral['referrer_id'],
        50.00,
        'referral',
        'Referral reward for ${referredUserId}',
      );
    }
  }
}
```

---

## ✨ FEATURE 6: APP NOTIFICATIONS (Priority: HIGH)

### Notification Types & Templates:

```dart
enum NotificationType {
  chatMessage,
  postGame,
  gameReminder,
  friendJoinedGame,
  bookingConfirmation,
  spotLeft,
  gameUpdate,
  joinRequest,
  joinAccepted,
  joinRejected,
}

class NotificationTemplate {
  static Map<NotificationType, String Function(Map<String, dynamic>)> templates = {
    NotificationType.chatMessage: (data) => 
      '${data['sender_name']} sent a message',
    
    NotificationType.postGame: (data) => 
      'Game Completed! 🎉 Rate your game partners',
    
    NotificationType.gameReminder: (data) => 
      'Game starting in 1 hour at ${data['venue_name']}',
    
    NotificationType.friendJoinedGame: (data) => 
      '${data['friend_name']} joined your game! Want to join too?',
    
    NotificationType.bookingConfirmation: (data) => 
      'Booking Confirmed ✅ ${data['date']} at ${data['venue']}',
    
    NotificationType.spotLeft: (data) => 
      '1 spot left in your group! ${data['game_title']}',
    
    NotificationType.joinRequest: (data) => 
      '${data['user_name']} wants to join your game',
    
    NotificationType.joinAccepted: (data) => 
      'You\'re in! See you at ${data['venue']}',
    
    NotificationType.joinRejected: (data) => 
      'Your join request was declined',
  };
}
```

### Notification Service:
```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _local;
  final FirebaseMessaging _fcm;
  final SupabaseClient _supabase;
  
  Future<void> initialize() async {
    // Initialize local notifications
    await _local.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    
    // Initialize FCM
    await _fcm.requestPermission();
    final token = await _fcm.getToken();
    await _saveTokenToDatabase(token);
    
    // Listen to FCM messages
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }
  
  Future<void> sendLocalNotification(AppNotification notification) async {
    await _local.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'default',
          'Default',
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(notification.data),
    );
  }
  
  Future<void> scheduleNotification(AppNotification notification, DateTime scheduledTime) async {
    await _local.zonedSchedule(
      notification.id.hashCode,
      notification.title,
      notification.body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(...),
      payload: jsonEncode(notification.data),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _navigateToScreen(data);
    }
  }
  
  void _navigateToScreen(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'game':
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => GameDetailsScreen(gameId: data['game_id'])),
        );
        break;
      case 'chat':
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => ChatScreen(roomId: data['room_id'])),
        );
        break;
      // ... other cases
    }
  }
}
```

### Schedule Game Reminders (Automatic):
```sql
-- Trigger in database handles this:
CREATE TRIGGER schedule_reminders_on_participant_join
  AFTER INSERT ON playnow.game_participants
  FOR EACH ROW
  EXECUTE FUNCTION playnow.schedule_game_reminders();
```

But also handle in app:
```dart
// Background task to send scheduled notifications
class NotificationScheduler {
  Future<void> processScheduledNotifications() async {
    final pending = await supabase
      .from('playnow.notifications')
      .select()
      .eq('is_sent', false)
      .lte('scheduled_for', DateTime.now().toIso8601String());
    
    for (final notif in pending) {
      await _notificationService.sendLocalNotification(
        AppNotification.fromJson(notif),
      );
      
      await supabase.from('playnow.notifications').update({
        'is_sent': true,
        'sent_at': DateTime.now().toIso8601String(),
      }).eq('id', notif['id']);
    }
  }
}
```

### Notification Preferences Screen:
```dart
class NotificationPreferencesScreen extends StatefulWidget {
  @override
  Widget build() {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Chat Messages'),
            value: prefs.chatMessages,
            onChanged: (val) => _updatePref('chat_messages', val),
          ),
          SwitchListTile(
            title: Text('Post-Game Reminders'),
            value: prefs.postGame,
            onChanged: (val) => _updatePref('post_game', val),
          ),
          SwitchListTile(
            title: Text('Game Reminders'),
            subtitle: Text('1 hour before game'),
            value: prefs.gameReminders,
            onChanged: (val) => _updatePref('game_reminders', val),
          ),
          // ... all other preferences
        ],
      ),
    );
  }
}
```

---

## ✨ FEATURE 7: AFTER GAME SCREEN (Priority: MEDIUM)

### Trigger Points:
1. Automatic when game.status → 'completed'
2. Manual: "Add Results" button in game details

### Full Screen Layout:
```dart
class AfterGameScreen extends StatefulWidget {
  Widget build() {
    return Scaffold(
      appBar: AppBar(title: Text('Game Results')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreSection(),
            SizedBox(height: 24),
            _buildTagPlayersSection(),
            SizedBox(height: 24),
            _buildRatingsSection(),
            SizedBox(height: 24),
            _buildPlayPalsSection(),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitResults,
              child: Text('Submit Results'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScoreSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Match Score', style: heading),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Team 1', style: subheading),
                Text('Team 2', style: subheading),
              ],
            ),
            _buildSetScore(1),
            _buildSetScore(2),
            _buildSetScore(3),
            SizedBox(height: 16),
            Text('Winner: ${_selectedWinner}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSetScore(int setNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Set $setNumber:'),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: '0'),
            onChanged: (val) => _updateScore(setNumber, 1, val),
          ),
        ),
        Text('-'),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: '0'),
            onChanged: (val) => _updateScore(setNumber, 2, val),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTagPlayersSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tag Players', style: heading),
            SizedBox(height: 16),
            ...game.participants.map((player) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(player.profilePicture)),
                    SizedBox(width: 8),
                    Text(player.name, style: subheading),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: availableTags.map((tag) => FilterChip(
                    label: Text(tag),
                    selected: _playerTags[player.id]?.contains(tag) ?? false,
                    onSelected: (selected) => _toggleTag(player.id, tag, selected),
                  )).toList(),
                ),
                Divider(),
              ],
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRatingsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate Players', style: heading),
            SizedBox(height: 16),
            ...game.participants.map((player) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: subheading),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Overall: '),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 30,
                      onRatingUpdate: (rating) => _updateRating(player.id, 'overall', rating),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Skill: '),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 30,
                      onRatingUpdate: (rating) => _updateRating(player.id, 'skill', rating),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Sportsmanship: '),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 30,
                      onRatingUpdate: (rating) => _updateRating(player.id, 'sportsmanship', rating),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Comment (optional)'),
                  onChanged: (val) => _updateComment(player.id, val),
                ),
                Divider(),
              ],
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlayPalsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add to Play Pals', style: heading),
            SizedBox(height: 16),
            ...game.participants.map((player) => ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(player.profilePicture)),
              title: Text(player.name),
              subtitle: Text('Games together: ${_getGamesPlayed(player.id)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _isFavorite[player.id] ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => _toggleFavorite(player.id),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.person_add),
                    label: Text('Add Friend'),
                    onPressed: () => _sendFriendRequest(player.id),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  Future<void> _submitResults() async {
    try {
      // Submit scores
      if (_hasScores) {
        await _gameResultsService.submitResults(GameResult(
          gameId: game.id,
          submittedBy: currentUserId,
          set1Team1: _scores[1][1],
          set1Team2: _scores[1][2],
          // ... all scores
          winningTeam: _selectedWinner,
        ));
      }
      
      // Submit tags
      for (final entry in _playerTags.entries) {
        await _ratingsService.tagPlayer(
          gameId: game.id,
          taggedUserId: entry.key,
          tags: entry.value,
        );
      }
      
      // Submit ratings
      for (final entry in _ratings.entries) {
        await _ratingsService.ratePlayer(PlayerRating(
          gameId: game.id,
          ratedUserId: entry.key,
          ratedByUserId: currentUserId,
          rating: entry.value['overall'],
          skillRating: entry.value['skill'],
          sportsmanshipRating: entry.value['sportsmanship'],
          comment: _comments[entry.key],
        ));
      }
      
      // Update favorites
      for (final userId in _isFavorite.entries.where((e) => e.value).map((e) => e.key)) {
        await _playPalsService.addToFavorites(currentUserId, userId, game.sportType);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Results submitted successfully!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ErrorHandler.handle(e, context);
    }
  }
}
```

**Available Tags:**
- Aggressive
- Strategic
- Team Player
- Good Sport
- Consistent
- Powerful
- Quick
- Defensive
- Creative

---

## ✨ FEATURE 8: INVITE VIA LINK (Priority: LOW)

### Generate Invite:
```dart
class GameInviteService {
  Future<String> createInvite(String gameId, {int? maxUses}) async {
    final inviteCode = _generateCode();
    
    final invite = await supabase.from('playnow.game_invites').insert({
      'game_id': gameId,
      'created_by': currentUserId,
      'invite_code': inviteCode,
      'max_uses': maxUses,
      'expires_at': DateTime.now().add(Duration(days: 7)).toIso8601String(),
    }).select().single();
    
    final link = await _deepLinkService.createGameInviteLink(gameId, inviteCode);
    
    await supabase.from('playnow.game_invites').update({
      'invite_link': link,
    }).eq('id', invite['id']);
    
    return link;
  }
}

class DeepLinkService {
  Future<String> createGameInviteLink(String gameId, String inviteCode) async {
    final link = await FirebaseDynamicLinks.instance.buildShortLink(
      DynamicLinkParameters(
        link: Uri.parse('https://yourapp.com/game/join/$inviteCode'),
        uriPrefix: 'https://yourapp.page.link',
        androidParameters: AndroidParameters(packageName: 'com.yourapp'),
        iosParameters: IOSParameters(bundleId: 'com.yourapp'),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join my game!',
          description: 'Tap to join',
        ),
      ),
    );
    
    return link.shortUrl.toString();
  }
  
  void handleDynamicLink() {
    FirebaseDynamicLinks.instance.onLink.listen((link) {
      final uri = link.link;
      if (uri.pathSegments.contains('join')) {
        final inviteCode = uri.pathSegments.last;
        _handleGameInvite(inviteCode);
      }
    });
  }
  
  Future<void> _handleGameInvite(String inviteCode) async {
    final invite = await supabase
      .from('playnow.game_invites')
      .select('*, game:game_id(*)')
      .eq('invite_code', inviteCode)
      .eq('is_active', true)
      .single();
    
    if (invite != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => GameDetailsScreen(
            gameId: invite['game_id'],
            inviteCode: inviteCode,
          ),
        ),
      );
    }
  }
}
```

### Invite Dialog:
```dart
void _showInviteDialog(Game game) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Invite Players'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _linkController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Invite Link',
              suffixIcon: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _linkController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link copied!')),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.share),
            label: Text('Share Link'),
            onPressed: () => _shareInviteLink(game),
          ),
        ],
      ),
    ),
  );
}

void _shareInviteLink(Game game) {
  final message = '''
🏸 Join my ${game.sportType} game!

${game.autoTitle}
📅 ${game.formattedDate}
📍 ${game.venueName ?? game.customLocation}

Tap to join: $_inviteLink
  ''';
  
  Share.share(message);
}
```

---

## ✨ FEATURE 9: GAME PARTNERS IN BOOKTICKETS (Priority: LOW)

### Add Section in Game Details:
```dart
// In game_details_screen.dart or book_tickets_screen.dart
Widget _buildGamePartnersSection() {
  return Card(
    margin: EdgeInsets.all(16),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Game Partners (${participants.length})', style: heading),
          SizedBox(height: 16),
          ...participants.map((partner) => _buildPartnerTile(partner)),
        ],
      ),
    ),
  );
}

Widget _buildPartnerTile(GamePartner partner) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(partner.profilePicture),
    ),
    title: Text(partner.name),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level ${partner.skillLevel}'),
        if (partner.gamesPlayedTogether > 0)
          Text('Played together ${partner.gamesPlayedTogether}x', 
               style: TextStyle(color: Colors.green)),
        if (partner.gamesPlayedTogether == 0)
          Text('First time playing', 
               style: TextStyle(color: Colors.blue)),
      ],
    ),
    trailing: partner.userId != currentUserId
      ? IconButton(
          icon: Icon(Icons.person),
          onPressed: () => _navigateToProfile(partner.userId),
        )
      : Chip(label: Text(partner.isCreator ? 'Creator' : 'You')),
  );
}
```

### Fetch Game Partners with Play Pal Info:
```dart
class GameService {
  Future<List<GamePartner>> getGamePartners(String gameId, String currentUserId) async {
    final participants = await supabase
      .from('playnow.game_participants')
      .select('''
        user_id,
        joined_at,
        users:user_id(
          first_name,
          profile_picture,
          skill_level_badminton,
          skill_level_pickleball
        )
      ''')
      .eq('game_id', gameId)
      .order('joined_at');
    
    final game = await getGameById(gameId);
    
    final partners = <GamePartner>[];
    for (final p in participants) {
      final playPal = await supabase
        .from('playnow.play_pals')
        .select('games_played_together, is_favorite')
        .eq('user_id', currentUserId)
        .eq('partner_id', p['user_id'])
        .eq('sport_type', game.sportType)
        .maybeSingle();
      
      partners.add(GamePartner(
        userId: p['user_id'],
        name: p['users']['first_name'],
        profilePicture: p['users']['profile_picture'],
        skillLevel: game.sportType == 'badminton' 
          ? p['users']['skill_level_badminton']
          : p['users']['skill_level_pickleball'],
        gamesPlayedTogether: playPal?['games_played_together'] ?? 0,
        isFavorite: playPal?['is_favorite'] ?? false,
        isCreator: p['user_id'] == game.createdBy,
      ));
    }
    
    return partners;
  }
}
```

---

## 📦 DEPENDENCIES

```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  
  # State Management
  flutter_riverpod: ^2.4.9  # or provider: ^6.1.1
  
  # UI
  intl: ^0.18.1
  cached_network_image: ^3.3.0
  flutter_rating_bar: ^4.0.1
  shimmer: ^3.0.0
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  firebase_messaging: ^14.7.9
  timezone: ^0.9.2
  
  # Deep Linking
  firebase_dynamic_links: ^5.4.9
  app_links: ^3.5.0
  
  # Utils
  share_plus: ^7.2.1
  url_launcher: ^6.2.2
  uuid: ^4.2.2
  
  # Firebase
  firebase_core: ^2.24.2
```

---

## 🚀 IMPLEMENTATION ORDER

1. **Week 1**: Feature 1 (Create Game) + Feature 2 (Join Game)
2. **Week 2**: Feature 6 (Notifications) + Feature 3 (Game Chat)
3. **Week 3**: Feature 4 (Book Courts) + Feature 5 (Offers)
4. **Week 4**: Feature 7 (After Game) + Feature 9 (Game Partners)
5. **Week 5**: Feature 8 (Invites) + Polish + Testing

---

## 🧪 TESTING CHECKLIST

- [ ] Can create game with all options
- [ ] Auto join works instantly
- [ ] Request to join → Creator accepts → User added
- [ ] Game chat appears in chat list
- [ ] Book courts shows filtered venues
- [ ] New user offer applies on first booking
- [ ] Referral code generates and shares
- [ ] All notification types fire correctly
- [ ] Game reminder sent 1 hour before
- [ ] After game screen shows after completion
- [ ] Scores, tags, ratings submitted
- [ ] Play pals updated correctly
- [ ] Invite link generates and works
- [ ] Game partners section shows in details
- [ ] RLS policies work (users can only see allowed data)

---

Start with Feature 1 & 2 (highest priority), then work through systematically. Test each feature thoroughly before moving to the next!

**Good luck! 🎯🏸**
