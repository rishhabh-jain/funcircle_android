# Test Account Preparation Checklist

## Before Submitting to App Review

### 1. Create/Prepare Test Account
- [ ] Create a Firebase account with email/phone: `_______________`
- [ ] Set a simple password: `_______________`
- [ ] Disable OTP verification for this account (or provide working OTP method)
- [ ] Document credentials in App Store Connect under "App Review Information"

### 2. Complete Profile Setup
- [ ] Upload a profile picture
- [ ] Fill in first name and bio
- [ ] Set date of birth
- [ ] Add sport preferences (Badminton, Pickleball)
- [ ] Set skill level
- [ ] Add interests/prompts

### 3. Create Player Requests (Find Players)
- [ ] Create at least 2-3 player requests for different dates/times
- [ ] Include descriptions in the requests
- [ ] Set different skill levels
- [ ] Use different sports (Badminton, Pickleball)

### 4. Show Interest in Other Requests
- [ ] Find existing player requests from other users
- [ ] Click "I'm Interested" on 2-3 requests
- [ ] This will populate the "My Games" screen

### 5. Set Up Chat Conversations
This is CRITICAL - Apple specifically mentioned they need to test chat features.

**Option A: Have a second test account ready**
- [ ] Create a second test account
- [ ] Use account 1 to create a player request
- [ ] Use account 2 to show interest
- [ ] Account 1 clicks chat button on the interested user
- [ ] Send 3-4 messages back and forth
- [ ] Repeat for 2-3 different conversations

**Option B: Pre-populate via database**
- [ ] Manually insert chat messages in Supabase for the test account
- [ ] Ensure at least 3-4 active conversations exist
- [ ] Messages should have different timestamps
- [ ] Include both read and unread messages

### 6. Venue Interactions
- [ ] Browse venues list
- [ ] Click on venue details
- [ ] Add some venues to favorites (if feature exists)

### 7. Location Data
- [ ] Ensure test account has a valid location set
- [ ] Create player requests near this location
- [ ] Test the "Find Players" map view with nearby requests

### 8. Test All Features Work
Login with test account and verify:
- [ ] Can see 3+ active chats with messages
- [ ] Can see player requests in "Find Players"
- [ ] Can see games in "My Games" (both created and interested)
- [ ] Can view and book venues
- [ ] Profile is complete with photo and details
- [ ] Location permission works
- [ ] Camera access works for profile updates

### 9. Important Settings for Test Account

**Firebase Console:**
- [ ] Disable email verification requirement for test account
- [ ] Set up phone auth to bypass OTP or use a test number

**App Store Connect:**
- [ ] Add credentials in "App Review Information" section
- [ ] Include note: "This account has pre-populated chat messages and game requests for testing"

### 10. Screenshot Evidence (Optional but Recommended)
Take screenshots of:
- [ ] Active chat conversations
- [ ] Player requests in Find Players
- [ ] My Games screen with games
- [ ] Complete profile
- [ ] Venues list

Upload these to App Review Information as "App Review Attachments"

---

## Critical Points

### Chat Feature (Most Important!)
Apple specifically mentioned they need to see the chat feature working. Make sure:
- ✅ At least 3-4 active conversations exist
- ✅ Each conversation has 5+ messages
- ✅ Messages have different timestamps (not all created at once)
- ✅ At least one conversation has unread messages
- ✅ Chat shows user profile pictures and names correctly

### Demo Account Location
- The account should be set to a location where there are:
  - Nearby venues (within 5-10km)
  - Active player requests on the map
  - Other users visible in Quick Match

### Working Features
Everything must work without any setup:
- Login should be immediate (no OTP delays)
- All data should already be loaded
- No empty states should be visible
- Chat should have content ready

---

## Sample App Store Connect Review Notes

**Username:** testuser@funcircle.com (or your test account)
**Password:** Test@123 (or your password)

**Review Notes:**
```
This test account has been pre-populated with:
- Complete user profile with photos and preferences
- 4 active chat conversations with message history
- 3 player requests in "Find Players"
- 2 games in "My Games" where user has shown interest
- Access to nearby venues for badminton and pickleball

All features are fully functional and ready for testing.

Location: The account is set to [Your Test Location, e.g., "Gurgaon, India"]
This location has active venues and player requests nearby.

Note: There are NO in-app purchases in this version. All features are free.
```

---

## Quick Test Before Submission

**Final 5-Minute Check:**
1. Open app
2. Login with test account (should work immediately)
3. Go to Chats tab → See 3+ conversations with messages ✓
4. Go to Find Players → See player requests on map ✓
5. Go to My Games → See games where you showed interest ✓
6. Go to Venues → See list of venues ✓
7. Open Settings → See complete profile with photo ✓

If all ✓ pass, you're ready to submit!
