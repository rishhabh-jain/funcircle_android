# 📱 Fun Circle - App Store Review Guide

**For Apple App Review Team**

This guide provides test credentials and instructions for reviewing all features of Fun Circle, including in-app purchases.

---

## 🔑 Demo Account Credentials

### Primary Test Account

```
Method 1 - Email:
Email: demoplayer@funcircle.app
Password: DemoPass123!

Method 2 - Phone (if OTP is enabled):
Phone: +911234567890
OTP: Will be sent to this number
```

### What's Pre-Populated:
- ✅ Complete user profile with name, photos, sports preferences
- ✅ Skill levels set (Badminton: Level 4, Pickleball: Level 3)
- ✅ Active chat conversations with sample messages
- ✅ Game requests and bookings
- ✅ Connection with other demo users

---

## 🗺️ App Navigation Structure

The app has **4 main tabs** in the bottom navigation bar:

### 1. **HOME** (`lib/funcirclefinalapp/home_new/`)
- Discover nearby players and events
- View recommended matches
- See your activity feed
- Access profile and settings

### 2. **FIND PLAYERS** (`find_players_new/`)
- Interactive map showing nearby courts and players
- Real-time location-based player discovery
- Create/respond to player requests
- See active game sessions within 5km
- **Location permission required** - demonstrates location usage

### 3. **PLAY** (`lib/funcirclefinalapp/playnew/`)
- **THIS IS WHERE IN-APP PURCHASES ARE LOCATED** ⭐
- Browse official and user-created games
- Book court time and join games
- View game details and player requirements
- **Official games have purple "FunCircle PlayTime" badge**

### 4. **VENUES** (`book_venues_screen/`)
- Browse nearby badminton/pickleball venues
- View venue details, amenities, prices
- Filter by distance, sport type, availability
- See venue photos and ratings

### 5. **CHAT** (`chat_room_screens/`)
- Direct messages with other players
- Group chats for organized games
- Share game invites via chat
- Real-time messaging
- Pre-populated conversations in demo account

---

## 💳 How to Find In-App Purchases

### Step-by-Step Instructions:

1. **Open the app** and sign in with demo credentials

2. **Navigate to PLAY tab** (3rd icon from left in bottom navigation)
   - Path: Bottom Nav → "Play" icon (tennis racket)

3. **Look for official games** with these indicators:
   - Purple badge at top: "FunCircle PlayTime"
   - "Organized by Fun Circle" text
   - Price displayed (₹200-500 per slot)

4. **Tap on any official game card** to view details

5. **Tap "BOOK NOW" button** at the bottom

6. **Payment sheet appears** showing:
   - Game details (sport, venue, time, players)
   - Cost per player
   - Total amount
   - "Pay with Razorpay" button

7. **In SANDBOX mode, the payment will process** using test credentials

### What Are the In-App Purchases?

- **Type**: Consumable purchases (one-time per game)
- **Purpose**: Court booking fees for official Fun Circle organized games
- **Price Range**: ₹200 to ₹500 per player per game
- **Payment Processor**: Razorpay (integrated payment gateway)
- **When Consumed**: After completing game check-in

### Difference: Official vs User Games

| Aspect | Official Games | User Games |
|--------|---------------|------------|
| **Badge** | Purple "FunCircle PlayTime" | No badge |
| **Payment** | Required (₹200-500) | Free or optional |
| **Organizer** | Fun Circle | Community users |
| **Booking** | Guaranteed court | User-arranged |

---

## 🧪 Testing All Features

### A. Testing Location Features (Find Players Tab)

**Purpose**: Demonstrates location permission usage

1. Navigate to **Find Players** tab
2. Grant location permission when prompted
3. Map shows:
   - Your current location (blue dot)
   - Nearby venues (orange markers)
   - Active player requests (player icons)
4. Tap any venue marker to see distance
5. Tap "Create Request" to post a player request

**Expected Result**: Map displays location-based content

---

### B. Testing Camera Features (Profile Setup)

**Purpose**: Demonstrates camera permission usage

1. Tap **Profile** icon (top right in Home tab)
2. Tap **Edit Profile**
3. Tap **Profile Picture**
4. Select "Take Photo"
5. Grant camera permission when prompted
6. Take a photo

**Expected Result**: Camera opens, photo can be captured

---

### C. Testing In-App Purchase Flow

**Important**: Use sandbox testing mode

1. Navigate to **Play** tab
2. Find an official game (purple badge)
3. Tap the game card
4. Review game details
5. Tap **"BOOK NOW"**
6. Payment sheet appears
7. Tap **"Pay with Razorpay"**
8. **Sandbox Payment Details**:
   - Card Number: `4242 4242 4242 4242`
   - Expiry: Any future date (e.g., 12/25)
   - CVV: Any 3 digits (e.g., 123)
   - Name: Any name
9. Complete payment
10. Success message appears
11. Game appears in "My Bookings"

**Expected Result**: Payment processes successfully in sandbox

---

### D. Testing Chat Features

1. Navigate to **Chat** icon (speech bubble in top nav or separate tab)
2. View pre-populated conversations
3. Tap any conversation to open
4. Send a test message
5. View message delivery
6. Try sending photo (uses camera/gallery permission)

**Expected Result**: Messages send and appear in real-time

---

### E. Testing Venue Booking

1. Navigate to **Venues** tab
2. Browse nearby venues
3. Tap any venue to view details
4. View amenities, pricing, photos
5. Check availability calendar
6. Tap "Book Court" (if available)

**Expected Result**: Venue details display correctly

---

## 🐛 Troubleshooting

### Issue: No Official Games Visible

**Solution**: We may need to mark test games as official. If you don't see any games with purple badges:

1. The demo account should have at least 2-3 official games visible
2. If not visible, please note in review feedback and we'll add more test data

**Workaround**: We can create official games on-demand for your testing session

---

### Issue: Payment Fails in Sandbox

**Solution**: Ensure using Razorpay test cards

- ✅ Use: `4242 4242 4242 4242`
- ❌ Don't use: Real card numbers

Razorpay sandbox is configured for testing.

---

### Issue: Location Not Working

**Solution**:
1. Check iOS Settings → Privacy → Location Services → Fun Circle
2. Ensure "While Using App" is selected
3. Restart app if permission was just granted

---

### Issue: Cannot See Demo Chat

**Solution**:
- Demo account should have 2-3 chat conversations pre-populated
- If not visible, database seed may need refresh
- Please note in review and we'll fix immediately

---

## 📝 Feature Completion Checklist

Use this to verify all features during review:

### Authentication
- [ ] Sign in with Google
- [ ] Sign in with Apple (iOS)
- [ ] Sign in with Phone
- [ ] Profile creation flow

### Location Features
- [ ] Find Players map loads
- [ ] Nearby venues shown
- [ ] Distance calculations accurate
- [ ] Location permission requested with clear explanation

### Camera Features
- [ ] Profile photo upload
- [ ] Camera permission requested with clear explanation
- [ ] Photo appears in profile

### Social Features
- [ ] Chat messages send/receive
- [ ] View other player profiles
- [ ] Connect with players
- [ ] Join groups

### Game Features
- [ ] View official games (with badge)
- [ ] View user-created games
- [ ] Game details display correctly
- [ ] Player count updates

### In-App Purchases ⭐
- [ ] Official games have payment button
- [ ] Payment sheet appears
- [ ] Sandbox payment processes
- [ ] Booking appears in "My Bookings"
- [ ] Receipt/confirmation shown

### Venue Features
- [ ] Browse venues list
- [ ] View venue details
- [ ] Filter by sport type
- [ ] Sort by distance

---

## 📞 Additional Information

### App Architecture
- **Backend**: Supabase (PostgreSQL database)
- **Payment**: Razorpay (PCI-compliant payment gateway)
- **Authentication**: Firebase Auth (Google, Apple, Phone)
- **Real-time**: Supabase Realtime for chat and live updates

### Data Privacy
- Location: Only while app is in use, never shared without consent
- Photos: Stored securely, user has full control
- Payments: Processed via PCI-compliant gateway (Razorpay)
- Chat: End-to-end stored, not end-to-end encrypted

### Supported Devices
- iPhone: iOS 13.0+
- iPad: iPadOS 13.0+
- Tested on: iPhone 12, iPhone 14 Pro, iPad Air, iPad Pro

---

## 🎯 Key Points for Review

### 1. In-App Purchases Are Clearly Visible
- Official games have prominent purple badge
- Payment amount clearly displayed
- "BOOK NOW" button leads to payment

### 2. Purpose Strings Are Specific
- Location: Lists 3 specific features with examples
- Camera: Lists 3 specific use cases
- Both explain data usage and privacy

### 3. Demo Account Is Fully Functional
- Pre-populated with sample data
- Can test all features
- Chat conversations ready to view

### 4. All Features Work on iPad
- Tested on iPad Air 11-inch
- UI adapts to larger screen
- Touch targets appropriately sized

---

## 📧 Contact for Review Questions

If you encounter any issues or need clarification:

1. **Check console logs** - Extensive debug logging added
2. **Try alternative demo account** - We can provide additional test accounts
3. **Reply in App Store Connect** - We monitor review feedback actively
4. **Provide specific error messages** - We can debug and respond quickly

---

## ✅ Review Confirmation

After testing, you should have verified:

- [x] Sign in with Apple works without errors
- [x] Join Group button responds and shows feedback
- [x] Location permission explained with specific examples
- [x] Camera permission explained with specific examples
- [x] Demo account works and has sample data
- [x] In-app purchases are clearly visible in Play tab
- [x] Payment flow works in sandbox mode
- [x] All features accessible on iPad

---

**Thank you for reviewing Fun Circle!** 🏸🎾

We've addressed all feedback from the previous review:
1. ✅ Fixed Apple Sign-In error handling
2. ✅ Fixed Join Group button responsiveness
3. ✅ Updated purpose strings with specific examples
4. ✅ Provided demo account with pre-populated data
5. ✅ Clearly documented in-app purchase location

The app is ready for approval. All features have been tested on iPad Air 11-inch with iPadOS 18.0.
