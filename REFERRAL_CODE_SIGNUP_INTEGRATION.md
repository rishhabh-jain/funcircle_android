# 🎁 Referral Code - New User Signup Integration

## Overview
Added an optional referral code field to the new user signup flow (Step 1 - Basic Info screen). When new users enter a valid referral code, they automatically receive a 50% discount on their first game.

---

## Implementation Details

### 1. Basic Info Screen Updates
**File:** `/lib/profile_setup/basic_info_screen.dart`

#### Changes Made:

**A. Added Referral Code Controller**
```dart
final _referralCodeController = TextEditingController();

@override
void dispose() {
  _nameController.dispose();
  _referralCodeController.dispose();  // Clean up
  super.dispose();
}
```

**B. Pass Referral Code to Next Screen**
```dart
void _continue() {
  if (_formKey.currentState!.validate() && _selectedGender != null) {
    context.pushNamed(
      SportsSelectionScreen.routeName,
      queryParameters: {
        'name': serializeParam(_nameController.text, ParamType.String),
        'gender': serializeParam(_selectedGender, ParamType.String),
        'referralCode': serializeParam(
          _referralCodeController.text.isNotEmpty
            ? _referralCodeController.text
            : null,
          ParamType.String
        ),
      }.withoutNulls,
    );
  }
}
```

**C. Added Referral Code Input Field (UI)**

Features:
- **Gift icon** - Makes it visually appealing
- **"OPTIONAL" badge** - Green badge clearly marks it as optional
- **Benefit message** - "Get 50% OFF your first game!"
- **Auto-capitalization** - Converts input to uppercase automatically
- **Icon prefix** - Ticket icon in the input field
- **Glassmorphism design** - Matches app's overall aesthetic

```dart
// Referral Code input (Optional)
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard_rounded, color: Color(0xFF6C63FF)),
              SizedBox(width: 8),
              Text('Referral Code'),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
                ),
                child: Text('OPTIONAL',
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Have a referral code? Get 50% OFF your first game!'),
          SizedBox(height: 12),
          TextFormField(
            controller: _referralCodeController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Enter code (e.g., ABC1234)',
              prefixIcon: Icon(Icons.confirmation_number_outlined),
              // ... styling
            ),
          ),
        ],
      ),
    ),
  ),
),
```

**Visual Hierarchy:**
```
┌─────────────────────────────────────────┐
│  🎁 Referral Code  [OPTIONAL]           │
│                                         │
│  Have a referral code? Get 50% OFF     │
│  your first game!                       │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ 🎟️  Enter code (e.g., ABC1234)  │  │
│  └──────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

### 2. Sports Selection Screen Updates
**File:** `/lib/profile_setup/sports_selection_screen.dart`

#### Changes Made:

**A. Import OffersService**
```dart
import '/playnow/services/offers_service.dart';
```

**B. Accept Referral Code Parameter**
```dart
class SportsSelectionScreen extends StatefulWidget {
  const SportsSelectionScreen({
    super.key,
    required this.name,
    required this.gender,
    this.referralCode,  // NEW: Optional parameter
  });

  final String name;
  final String gender;
  final String? referralCode;  // NEW
}
```

**C. Apply Referral Code in Setup**
```dart
Future<void> _completeSetup() async {
  // ... existing profile creation code ...

  // Update skill levels
  for (final entry in _skillLevels.entries) {
    await service.updateSkillLevel(
      userId: currentUserUid,
      sport: entry.key,
      level: entry.value,
    );
  }

  // Apply referral code if provided
  if (widget.referralCode != null && widget.referralCode!.isNotEmpty) {
    try {
      final success = await OffersService.applyReferralCode(
        newUserId: currentUserUid,
        referralCode: widget.referralCode!.toUpperCase().trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Referral code applied! You got 50% OFF your first game!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid referral code'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error applying referral code: $e');
      // Don't block signup if referral fails
    }
  }

  // Navigate to home screen
  context.goNamed('HomeNew');
}
```

---

## User Flow

### Step 1: Basic Info (with Referral Code)
```
┌──────────────────────────────┐
│  Tell us about yourself      │
│                              │
│  ┌────────────────────────┐  │
│  │ Your Name              │  │
│  │ [Enter your name]      │  │
│  └────────────────────────┘  │
│                              │
│  ┌────────────────────────┐  │
│  │ Gender                 │  │
│  │  [Male]     [Female]   │  │
│  └────────────────────────┘  │
│                              │
│  ┌────────────────────────┐  │
│  │ 🎁 Referral Code       │  │
│  │    [OPTIONAL]          │  │
│  │ Get 50% OFF first game!│  │
│  │ [Enter code]           │  │
│  └────────────────────────┘  │
│                              │
│         [Continue →]         │
└──────────────────────────────┘
```

### Step 2: Sports Selection
```
┌──────────────────────────────┐
│  Choose your sports          │
│                              │
│  🏸 Badminton  ✓             │
│     Skill: [Intermediate]    │
│                              │
│  🎾 Pickleball               │
│                              │
│      [Get Started →]         │
└──────────────────────────────┘
```

### Result: Success Message
If valid code entered:
```
┌──────────────────────────────────────┐
│ 🎉 Referral code applied!            │
│    You got 50% OFF your first game!  │
└──────────────────────────────────────┘
```

If invalid code:
```
┌──────────────────────────────────────┐
│ ⚠️  Invalid referral code            │
└──────────────────────────────────────┘
```

---

## What Happens When Code is Applied

### Database Changes:
1. **New referral record created** in `playnow.referrals`:
```sql
INSERT INTO playnow.referrals (
  referrer_id,      -- User who owns the code
  referred_id,      -- New user (this signup)
  referral_code,    -- The code entered
  status            -- 'pending'
);
```

2. **Welcome offer created** in `playnow.user_offers`:
```sql
INSERT INTO playnow.user_offers (
  user_id,              -- New user
  offer_type,           -- 'first_game_free'
  title,                -- 'Welcome Bonus!'
  description,          -- 'Your first game is on us!'
  discount_percentage,  -- 50
  status,               -- 'active'
  expires_at            -- 30 days from now
);
```

### User Benefits:
- ✅ New user gets **50% OFF** their first game
- ✅ Offer valid for **30 days**
- ✅ Auto-applies at payment for first game
- ✅ Works only on **FunCircle organized games**

### Referrer Benefits (Later):
- When new user completes their first game:
  - Referral status → `completed`
  - Referrer gets **₹50 credit**
  - Credit valid for **90 days**

---

## Code Validation

### Two-Phase Lookup:
1. **Phase 1** - Fast lookup in existing referrals
2. **Phase 2** - Generate codes for all users and match

### Validation Rules:
- ✅ Code must match a valid user's code
- ✅ Case-insensitive (auto-converts to uppercase)
- ✅ Trims whitespace
- ❌ Self-referrals not allowed
- ❌ User can only be referred once

---

## Error Handling

### Graceful Failures:
```dart
try {
  final success = await OffersService.applyReferralCode(...);
} catch (e) {
  print('Error applying referral code: $e');
  // Don't block signup if referral fails
}
```

**Important:** Even if referral code validation fails, the signup process continues. The user is never blocked from completing registration.

---

## UI/UX Features

### Visual Design:
- **Glassmorphism** - Frosted glass effect matching app theme
- **Green "OPTIONAL" badge** - Clear indication it's not required
- **Gift icon** - Visually associates with rewards
- **Benefit text** - "Get 50% OFF" creates urgency
- **Auto-capitalization** - User-friendly input
- **Ticket icon** - Reinforces discount concept

### User Experience:
- ✅ Clearly marked as optional - no pressure
- ✅ Benefit explained upfront - motivation to use it
- ✅ Validation happens silently - no blocking dialogs
- ✅ Success feedback - confirmation of benefit
- ✅ Continues on error - never blocks signup

---

## Testing Checklist

- [ ] Field appears in Basic Info screen (Step 1)
- [ ] "OPTIONAL" badge displays correctly
- [ ] Can submit form with empty referral code
- [ ] Can submit form with referral code
- [ ] Code auto-converts to uppercase
- [ ] Valid code shows success message
- [ ] Invalid code shows error message
- [ ] Self-referral is prevented
- [ ] User receives 50% offer when valid code applied
- [ ] Offer appears in payment screen
- [ ] Signup completes even if referral fails
- [ ] UI matches glassmorphism theme

---

## Files Modified

1. **basic_info_screen.dart**
   - Added `_referralCodeController`
   - Added referral code input field (UI)
   - Pass referral code to next screen

2. **sports_selection_screen.dart**
   - Import `OffersService`
   - Accept `referralCode` parameter
   - Apply referral code in `_completeSetup()`
   - Show success/error feedback

---

## Summary

**What Changed:**
- Added optional referral code field to Step 1 of signup
- Beautiful UI with gift icon and "OPTIONAL" badge
- Automatic validation and offer creation
- Never blocks signup process

**User Benefits:**
- Easy to enter referral codes
- Clear indication it's optional
- Immediate feedback on validity
- 50% discount auto-applies

**Business Benefits:**
- Encourages viral growth
- Tracks referral sources
- Rewards both referrer and new user
- Seamless integration with existing flow

---

**Status:** ✅ **COMPLETE**

New users can now enter referral codes during signup and receive 50% OFF their first game!
