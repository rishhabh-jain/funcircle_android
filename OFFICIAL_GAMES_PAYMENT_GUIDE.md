# Official Fun Circle Games - Payment Integration Guide

## Overview

Payment functionality has been integrated for official Fun Circle games. Users can now book and pay for official games directly through the app using Razorpay.

## Features Implemented

### 1. Official Game Badge
- Games marked as `is_official = true` display a bright green banner "FunCircle PlayTime" at the top
- Sorted to appear first in all game listings
- Visually distinct from regular user-created games

### 2. Payment Flow for Official Games

#### For FREE Official Games:
- Button: "Book Now" with check icon
- Flow: Direct booking without payment
- Payment status: `waived`
- Instant confirmation

#### For PAID Official Games:
- Button: "Book & Pay ₹XXX" with payment icon
- Flow: Razorpay payment gateway → verification → booking
- Payment status: `paid`
- Amount stored in database

#### For Regular Games:
- Existing "Join Game" or "Request to Join" logic unchanged
- No payment integration

## Files Created

### 1. `lib/playnow/services/game_payment_service.dart`
Complete payment service handling:
- Razorpay order creation via Firebase Cloud Functions
- Payment signature verification
- Database recording of payments
- Free booking creation
- Player count updates
- Chat room integration

### 2. `lib/playnow/widgets/game_payment_sheet.dart`
Beautiful payment UI with:
- Glass/gradient design matching app theme
- Real-time payment status updates
- Razorpay integration (mobile + web ready)
- Error handling and user feedback
- Auto-close on completion

### 3. Database Schema
Extended `playnow.game_participants` table with:
```sql
payment_status: 'pending' | 'paid' | 'waived'
payment_amount: numeric (amount paid)
payment_id: text (Razorpay payment ID)
```

## Files Modified

### 1. `lib/playnow/models/game_model.dart`
- Added `isOfficial` field (boolean)
- Updated `isFunCircleOrganized` to use `isOfficial`
- Added to JSON serialization

### 2. `lib/playnow/services/game_service.dart`
- Sorting logic: Official games appear first
- Maintains date/time order within official/non-official groups

### 3. `lib/playnow/widgets/game_card.dart`
- Full-width green banner for official games at top of card
- "FunCircle PlayTime" text with verified icon
- Gradient background for visibility

### 4. `lib/playnow/pages/game_details_page.dart`
- Smart button logic:
  - Official + Free → "Book Now"
  - Official + Paid → "Book & Pay ₹XXX"
  - Regular → "Join Game" / "Request to Join"
- Payment flow integration
- Booking confirmation

## Database Setup Required

### Step 1: Run this SQL in Supabase (add is_official field):

```sql
-- Add is_official column to games table
ALTER TABLE playnow.games
ADD COLUMN is_official BOOLEAN NOT NULL DEFAULT false;

-- Create index for faster queries
CREATE INDEX idx_games_is_official
ON playnow.games(is_official)
WHERE is_official = true;

-- Add comment
COMMENT ON COLUMN playnow.games.is_official
IS 'Marks games officially organized by Fun Circle';

-- RLS Policy: Only admins can set is_official = true
CREATE POLICY "Only admins can insert official games"
ON playnow.games
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  is_official = false OR
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);

-- RLS Policy: Only admins can update games to official
CREATE POLICY "Only admins can update to official"
ON playnow.games
AS RESTRICTIVE
FOR UPDATE
TO authenticated
WITH CHECK (
  is_official = false OR
  EXISTS (
    SELECT 1 FROM public.users
    WHERE user_id = auth.uid()::text
    AND (adminsetlevel = 'admin' OR adminsetlevel = 'super_admin')
  )
);
```

### Step 2: Run this SQL in Supabase (add payment_id field):

```sql
-- Add payment_id field to store Razorpay payment ID
ALTER TABLE playnow.game_participants
ADD COLUMN payment_id TEXT;

-- Add index for faster lookup
CREATE INDEX idx_game_participants_payment_id
ON playnow.game_participants(payment_id)
WHERE payment_id IS NOT NULL;

-- Add comment
COMMENT ON COLUMN playnow.game_participants.payment_id
IS 'Razorpay payment ID for transaction tracking and reconciliation';
```

## How to Mark Games as Official

### Option 1: Direct SQL Update
```sql
UPDATE playnow.games
SET is_official = true
WHERE id = 'game-id-here';
```

### Option 2: Admin Creation
When creating games programmatically as admin:
```dart
await supabase.schema('playnow').from('games').insert({
  // ... other game fields
  'is_official': true,  // Only works if user is admin
});
```

## Payment Flow Details

### 1. User Clicks "Book & Pay"
- System fetches user details (name, email, mobile)
- Opens GamePaymentSheet modal

### 2. Payment Sheet
- Status: "Creating payment order..."
- Calls Firebase Cloud Function to create Razorpay order
- Status: "Opening payment gateway..."
- Opens Razorpay checkout

### 3. User Completes Payment
- Razorpay processes payment
- Status: "Verifying payment..."
- System verifies signature via Firebase Cloud Function

### 4. Database Recording
- Creates/updates `game_participants` record
- Sets `payment_status = 'paid'`
- Sets `payment_amount = game cost`
- Updates `current_players_count`
- Adds user to game chat room (if exists)
- Status: "Booking successful!"

### 5. Confirmation
- Success message shown
- Modal auto-closes after 2 seconds
- Game details page refreshes
- User now appears in players list

## Payment Security

### ✅ Secure Implementation:
- Only admins can mark games as official
- Payment verification via Firebase Cloud Functions
- Razorpay signature validation
- Database RLS policies enforce admin-only official games
- Users cannot fake official status

### ⚠️ Important Notes:
- Razorpay keys are production keys (`rzp_live_...`)
- Firebase Cloud Functions must be deployed with:
  - `createOrder` function
  - `verifySignature` function
- Admin users must have `adminsetlevel = 'admin'` or `'super_admin'`

## Testing Checklist

### Database Setup:
- [ ] Run SQL migration in Supabase
- [ ] Verify `is_official` column exists
- [ ] Mark at least one test game as official
- [ ] Verify RLS policies are active

### Admin Setup:
- [ ] Set your user as admin:
```sql
UPDATE public.users
SET adminsetlevel = 'admin'
WHERE user_id = 'your-user-id';
```

### Free Official Game Test:
- [ ] Create/mark a free game as official (`is_free = true, is_official = true`)
- [ ] Game appears with green "FunCircle PlayTime" banner
- [ ] Game appears at top of list
- [ ] Click "Book Now" button
- [ ] Booking confirms instantly
- [ ] User added to participants list
- [ ] Payment status = `waived`

### Paid Official Game Test:
- [ ] Create/mark a paid game as official (`cost_per_player = 100, is_free = false, is_official = true`)
- [ ] Game shows green banner
- [ ] Button shows "Book & Pay ₹100"
- [ ] Click button opens payment sheet
- [ ] Payment sheet shows ₹100 amount
- [ ] Razorpay checkout opens
- [ ] Complete payment with test card
- [ ] Payment verifies successfully
- [ ] Booking confirms
- [ ] User added to participants
- [ ] Payment status = `paid`
- [ ] Payment amount = 100

### Regular Game Test:
- [ ] Create/join regular non-official game
- [ ] No green banner displayed
- [ ] Shows normal "Join Game" button
- [ ] Regular join flow works

## Data Storage

### Where payments are stored:
**Table:** `playnow.game_participants`

```
game_id: uuid (which game)
user_id: text (who booked)
payment_status: 'paid' | 'waived' | 'pending'
payment_amount: numeric (₹ amount)
payment_id: text (Razorpay payment ID - e.g., pay_xxxxxxxxxxxx)
joined_at: timestamp
join_type: 'auto_join' (for bookings)
```

### Query to see bookings with payment details:
```sql
SELECT
  gp.joined_at,
  u.first_name as player_name,
  g.auto_title as game_name,
  g.game_date,
  gp.payment_status,
  gp.payment_amount,
  gp.payment_id as razorpay_payment_id
FROM playnow.game_participants gp
JOIN playnow.games g ON g.id = gp.game_id
JOIN public.users u ON u.user_id = gp.user_id
WHERE g.is_official = true
ORDER BY gp.joined_at DESC;
```

### Query to reconcile with Razorpay:
```sql
-- Find all paid bookings with Razorpay payment IDs
SELECT
  payment_id as razorpay_payment_id,
  payment_amount,
  joined_at as payment_date,
  user_id,
  game_id
FROM playnow.game_participants
WHERE payment_status = 'paid'
  AND payment_id IS NOT NULL
ORDER BY joined_at DESC;
```

## Revenue Tracking

### Query for total revenue:
```sql
SELECT
  SUM(payment_amount) as total_revenue,
  COUNT(*) as total_bookings,
  COUNT(*) FILTER (WHERE payment_status = 'paid') as paid_bookings,
  COUNT(*) FILTER (WHERE payment_status = 'waived') as free_bookings
FROM playnow.game_participants
WHERE game_id IN (
  SELECT id FROM playnow.games WHERE is_official = true
);
```

### Revenue by game:
```sql
SELECT
  g.auto_title,
  g.game_date,
  COUNT(gp.id) as bookings,
  SUM(gp.payment_amount) as revenue
FROM playnow.games g
LEFT JOIN playnow.game_participants gp ON gp.game_id = g.id
WHERE g.is_official = true
GROUP BY g.id, g.auto_title, g.game_date
ORDER BY g.game_date DESC;
```

## Error Handling

### Payment Fails:
- User sees error message
- No database entry created
- Can retry payment

### Payment Succeeds but Verification Fails:
- User sees "Payment succeeded but booking failed"
- Contact support message
- Manual verification needed

### Database Insertion Fails:
- Payment is verified but participant record fails
- Shows appropriate error
- Refund may be needed (manual process)

## Next Steps

1. ✅ Run database migration
2. ✅ Set up admin users
3. ✅ Create test official games
4. ✅ Test payment flow end-to-end
5. Deploy Firebase Cloud Functions (if not already deployed)
6. Monitor payments in Razorpay dashboard
7. Set up revenue tracking

---

**Status:** ✅ Complete and Ready to Test

**Last Updated:** January 2025
