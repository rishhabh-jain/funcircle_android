# Flutter Map Screen - Player Finding Feature

## Context
I'm building a sports player finding app with Flutter and Supabase. I need a map screen that helps users find other players for badminton and pickleball games.

## Database Schema
I have the following relevant tables in Supabase:

### Existing Tables:
- `users` (public schema) - user profiles with fields: user_id, first_name, profile_picture, skill_level_badminton (integer 1-5), skill_level_pickleball (integer 1-5)
- `venues` (public schema) - sports venues with fields: id, name, address, latitude, longitude, sport_type
- `tickets` - existing booking system

### Skill Level System:
All skill levels are stored as integers (1-5):
- **1** = Beginner
- **2** = Beginner+
- **3** = Intermediate
- **4** = Upper Intermediate
- **5** = Advanced

### New Tables to Create (findplayers schema):
```sql
-- Player availability requests
create table findplayers.player_requests (
  id uuid not null default gen_random_uuid(),
  user_id text not null,
  sport_type text not null,
  venue_id bigint null,
  custom_location text null,
  latitude numeric(10, 8) null,
  longitude numeric(11, 8) null,
  players_needed integer not null default 1,
  scheduled_time timestamp with time zone not null,
  skill_level integer null, -- 1-5
  description text null,
  status text not null default 'active',
  created_at timestamp with time zone not null default now(),
  expires_at timestamp with time zone not null,
  constraint player_requests_pkey primary key (id),
  constraint player_requests_user_id_fkey foreign key (user_id) references public.users (user_id) on delete cascade,
  constraint player_requests_venue_id_fkey foreign key (venue_id) references public.venues (id) on delete set null
);

-- User real-time locations
create table findplayers.user_locations (
  id uuid not null default gen_random_uuid(),
  user_id text not null,
  latitude numeric(10, 8) not null,
  longitude numeric(11, 8) not null,
  is_available boolean not null default false,
  sport_type text null,
  skill_level integer null, -- 1-5
  updated_at timestamp with time zone not null default now(),
  constraint user_locations_pkey primary key (id),
  constraint user_locations_user_id_key unique (user_id),
  constraint user_locations_user_id_fkey foreign key (user_id) references public.users (user_id) on delete cascade
);

-- Request responses
create table findplayers.player_request_responses (
  id uuid not null default gen_random_uuid(),
  request_id uuid not null,
  responder_id text not null,
  status text not null default 'pending',
  message text null,
  created_at timestamp with time zone not null default now(),
  constraint player_request_responses_pkey primary key (id),
  constraint player_request_responses_request_fkey foreign key (request_id) references findplayers.player_requests (id) on delete cascade,
  constraint player_request_responses_responder_fkey foreign key (responder_id) references public.users (user_id) on delete cascade,
  constraint unique_request_response unique (request_id, responder_id)
);
```

## Requirements

### Screen Features:
1. **Sport Toggle** at the top to switch between Badminton and Pickleball
2. **Google Maps Integration** showing:
   - Available players (from user_locations table where is_available = true)
   - Venue locations (from venues table)
   - Player requests (from player_requests table where status = 'active')
3. **User Location**: Request and track user's location on screen load
4. **Custom Map Markers**:
   - **Player Pins**: Show user profile picture, name, availability time, and skill level. Color-coded by skill level:
     - **Level 1 (Beginner)**: Light Green (#81C784)
     - **Level 2 (Beginner+)**: Green (#4CAF50)
     - **Level 3 (Intermediate)**: Blue (#2196F3)
     - **Level 4 (Upper Intermediate)**: Orange (#FF9800)
     - **Level 5 (Advanced)**: Red (#F44336)
   - **Venue Pins**: Show venue name and icon
   - **Request Pins**: Show "Need X players" with time and location
5. **Interactive Elements**:
   - Tap on player pin → Show bottom sheet with player details and "Connect" button
   - Tap on venue pin → Show venue details
   - Tap on request pin → Show request details with "I'm Interested" button
6. **Floating Action Button**: "Create Request" to post a new player finding request
7. **Filter Options**: 
   - Skill level filter
   - Time range filter (now, today, this week)
   - Distance radius filter

### Technical Implementation:
1. Use `google_maps_flutter` package for map display
2. Use `geolocator` for location services
3. Use `supabase_flutter` for database operations with real-time subscriptions
4. Implement real-time updates using Supabase Realtime for:
   - New player requests
   - User availability changes
   - Request status changes
5. Use `flutter_bloc` or `provider` for state management
6. Implement custom map markers using `BitmapDescriptor` with user profile pictures
7. Add loading states and error handling
8. Implement permission handling for location access

### State Management Flow:
```
MapScreen
├── MapBloc/Controller
│   ├── Fetch venues for selected sport
│   ├── Fetch available players for selected sport
│   ├── Fetch active player requests for selected sport
│   ├── Subscribe to real-time updates
│   └── Handle location updates
└── UI Components
    ├── Sport Toggle
    ├── Google Map Widget
    ├── Floating Action Button
    └── Bottom Sheets (Player Info, Venue Info, Request Info, Create Request)
```

### Create Request Flow:
When user taps the FAB, show a bottom sheet with:
- Sport type (pre-selected based on current map)
- Number of players needed
- Date and time picker
- Location picker (use venue dropdown or "Use my location")
- Skill level preference
- Optional description
- "Post Request" button

### Data Models Needed:
```dart
// Skill level enum/helper
enum SkillLevel {
  beginner(1, 'Beginner'),
  beginnerPlus(2, 'Beginner+'),
  intermediate(3, 'Intermediate'),
  upperIntermediate(4, 'Upper Intermediate'),
  advanced(5, 'Advanced');

  final int value;
  final String label;
  const SkillLevel(this.value, this.label);

  static SkillLevel fromValue(int value) {
    return SkillLevel.values.firstWhere((e) => e.value == value);
  }
}

class PlayerRequest {
  final String id;
  final String userId;
  final String sportType;
  final int? venueId;
  final String? customLocation;
  final double? latitude;
  final double? longitude;
  final int playersNeeded;
  final DateTime scheduledTime;
  final int? skillLevel; // 1-5
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime expiresAt;
  // Include user data from join
  final String userName;
  final String? userProfilePicture;
}

class UserLocation {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final String? sportType;
  final int? skillLevel; // 1-5
  final DateTime updatedAt;
  // Include user data from join
  final String userName;
  final String? userProfilePicture;
}

class VenueMarker {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String sportType;
}
```

### API Service Methods Needed:
```dart
class MapService {
  // Fetch venues by sport type
  Future<List<VenueMarker>> getVenuesBySport(String sportType);
  
  // Fetch available players by sport type
  Future<List<UserLocation>> getAvailablePlayersBySport(String sportType);
  
  // Fetch active player requests by sport type
  Future<List<PlayerRequest>> getActiveRequestsBySport(String sportType);
  
  // Create a new player request
  Future<void> createPlayerRequest(PlayerRequest request);
  
  // Update user location and availability
  Future<void> updateUserLocation(String userId, double lat, double lng, bool isAvailable, String sportType);
  
  // Respond to a player request
  Future<void> respondToRequest(String requestId, String responderId, String message);
  
  // Subscribe to real-time updates
  Stream<List<PlayerRequest>> subscribeToRequests(String sportType);
  Stream<List<UserLocation>> subscribeToPlayerLocations(String sportType);
}
```

### UI/UX Requirements:
- Smooth animations when switching sports
- Clear visual hierarchy with the sport toggle pinned at top
- Custom styled bottom sheets with rounded corners
- Loading shimmer effects while data loads
- Empty state when no players/requests found
- Handle permission denied states gracefully
- Show distance from user's location on markers
- Cluster markers when zoomed out to prevent clutter

### Dependencies to Add:
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  supabase_flutter: (existing)
  flutter_bloc: ^8.1.3 (or provider: ^6.1.1)
  intl: ^0.18.1 (for date formatting)
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
```

## Expected Deliverables:
1. Complete `map_screen.dart` with all UI components
2. State management implementation (Bloc or Provider)
3. `map_service.dart` with all Supabase queries and real-time subscriptions
4. All widget files for bottom sheets and custom components
5. Model classes with JSON serialization
6. Error handling and loading states
7. Location permission handling
8. Comments explaining complex logic

## 🎯 ENHANCED FEATURES (Premium Additions)

### Feature 1: Scheduled Game Sessions (Group Play)
Instead of just "need 1 player", allow users to create actual game sessions that multiple people can join.

**Benefits:**
- Creates a social gaming atmosphere
- Allows for tournaments or round-robin play
- Better for venue coordination
- Reduces multiple 1-on-1 coordination overhead

**Implementation:**
- Add a new pin type: "Game Session" (e.g., "Doubles Match - 2/4 players joined")
- Shows current participants with profile pictures
- Real-time updates as people join/leave
- Session creator can accept/reject join requests
- Automatic notifications when session is full
- Integration with your existing tickets/booking system for venue reservations

**New Database Table:**
```sql
create table findplayers.game_sessions (
  id uuid not null default gen_random_uuid(),
  creator_id text not null,
  sport_type text not null,
  venue_id bigint null,
  session_type text not null, -- 'singles', 'doubles', 'group'
  max_players integer not null,
  current_players jsonb not null default '[]'::jsonb,
  scheduled_time timestamp with time zone not null,
  duration_minutes integer not null default 60,
  skill_level_required integer null, -- 1-5 (null means any level)
  is_private boolean default false,
  session_code text null, -- for private sessions
  status text not null default 'open', -- 'open', 'full', 'in_progress', 'completed', 'cancelled'
  latitude numeric(10, 8) null,
  longitude numeric(11, 8) null,
  cost_per_player numeric(10, 2) null,
  notes text null,
  created_at timestamp with time zone not null default now(),
  constraint game_sessions_pkey primary key (id),
  constraint game_sessions_creator_fkey foreign key (creator_id) references public.users (user_id) on delete cascade,
  constraint game_sessions_venue_fkey foreign key (venue_id) references public.venues (id) on delete set null
);
```

**UI Components:**
- New map marker with participant avatars in a circle
- Bottom sheet showing:
  - Session details (time, venue, skill level)
  - List of joined players with their ratings
  - "Join Session" button (or "Request to Join" for private sessions)
  - Chat button to coordinate with other players
  - Share session link functionality

### Feature 2: Quick Match with Smart Recommendations
AI-powered instant matching based on location, skill level, and availability.

**Benefits:**
- Reduces decision paralysis (too many options on map)
- Faster player finding experience
- Personalized recommendations
- Works even when map is crowded

**Implementation:**
- Floating "Quick Match" button (alternative to browsing map)
- Algorithm considers:
  - Proximity (within configurable radius)
  - Skill level compatibility (±1 level)
  - Similar availability times
  - Past positive interactions (from reviews table)
  - Mutual connections (from connections table)
- Show top 3-5 recommended matches in a card carousel
- Swipe right to connect, left to skip (Tinder-style UX)
- Fallback to requests if no immediate matches

**New Database Table:**
```sql
create table findplayers.match_preferences (
  user_id text not null,
  sport_type text not null,
  max_distance_km numeric(5, 2) default 10.0,
  preferred_times jsonb null, -- array of time slots like [{"day": "monday", "start": "18:00", "end": "21:00"}]
  skill_level_range integer[] null, -- e.g., ARRAY[2,3,4] for Beginner+ to Upper Intermediate
  preferred_venues bigint[] null,
  auto_match_enabled boolean default false,
  notification_enabled boolean default true,
  updated_at timestamp with time zone default now(),
  constraint match_preferences_pkey primary key (user_id, sport_type),
  constraint match_preferences_user_fkey foreign key (user_id) references public.users (user_id) on delete cascade
);

create table findplayers.match_history (
  id uuid not null default gen_random_uuid(),
  user1_id text not null,
  user2_id text not null,
  sport_type text not null,
  match_quality_score numeric(3, 2), -- ML-based score 0-1
  user1_feedback text, -- 'positive', 'neutral', 'negative', null
  user2_feedback text,
  played_together boolean default false,
  created_at timestamp with time zone default now(),
  constraint match_history_pkey primary key (id),
  constraint match_history_user1_fkey foreign key (user1_id) references public.users (user_id) on delete cascade,
  constraint match_history_user2_fkey foreign key (user2_id) references public.users (user_id) on delete cascade
);
```

**UI Components:**
- Slide-up panel from bottom with match cards
- Each card shows:
  - Player photo, name, skill level
  - Distance from you
  - Mutual connections (if any)
  - Available time slots
  - Match compatibility score (%)
- Actions: "Connect", "Maybe Later", "Not Interested"
- After matching, auto-create chat room or game session

### Feature 3: Heat Map Layer (Bonus)
Show activity density on the map.

**Benefits:**
- Discover popular playing areas
- Find where players congregate
- Identify peak playing times for locations

**Implementation:**
- Toggle button to switch between "Markers" and "Heat Map" view
- Use historical data from player_requests and game_sessions
- Show color gradient: Blue (low activity) → Red (high activity)
- Filter by time of day (morning, afternoon, evening)
- Use google_maps_flutter heatmap layer

**Data Source:**
- Aggregate location data from player_requests and game_sessions
- Consider time-based weighting (recent activity = more weight)
- Privacy-preserving (no individual user tracking)

## Updated Dependencies:
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  supabase_flutter: (existing)
  flutter_bloc: ^8.1.3 (or provider: ^6.1.1)
  intl: ^0.18.1
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  # New additions:
  flutter_card_swiper: ^6.0.0  # For quick match swiping
  shimmer: ^3.0.0  # Loading effects
  flutter_animate: ^4.3.0  # Smooth animations
  share_plus: ^7.2.1  # Share game sessions
```

## Implementation Priority:
**Phase 1 (Core):** Basic map with players, venues, and requests ✅
**Phase 2 (Enhanced):** Game Sessions feature 🎮
**Phase 3 (Smart):** Quick Match with recommendations 🤖
**Phase 4 (Optional):** Heat Map visualization 🗺️

## Additional Notes:
- Follow Flutter best practices and clean architecture
- Use const constructors where possible
- Implement proper error handling with user-friendly messages
- Add analytics events for key actions (view request, create request, respond to request, join session, quick match)
- Ensure the screen works well on both iOS and Android
- Test with different screen sizes and orientations
- Consider offline mode with cached data
- Implement rate limiting for real-time subscriptions to avoid excessive API calls
- Add haptic feedback for important actions
- Implement deep linking for sharing game sessions
- Consider adding gamification (badges for "most active player in area", "helpful teammate", etc.)

Please implement this feature step by step, ensuring each component works before moving to the next. Start with the basic map display, then add markers, then add interactivity, then add the real-time features, and finally implement the enhanced features (game sessions and quick match) if time permits.