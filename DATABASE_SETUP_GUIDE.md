# 📊 Database Setup Guide

## Overview

This guide shows you how to add all necessary database updates to make your Fun Circle app work perfectly!

---

## 📋 What's Included

The `database_updates.sql` file contains **10 updates** that add:
- ✅ Profile card fields (city, age, skill level)
- ✅ User settings table (preferences)
- ✅ Support tickets table (help & support)
- ✅ App policies table (privacy, terms, etc.)
- ✅ Additional profile fields
- ✅ Automatic timestamp updates
- ✅ Auto-initialization triggers
- ✅ Performance indexes
- ✅ Helpful views
- ✅ Security policies

---

## 🚀 How to Apply Updates

### Method 1: Supabase Dashboard (Recommended)

**Step 1: Open SQL Editor**
1. Go to your Supabase project
2. Click "SQL Editor" in the left sidebar
3. Click "New Query"

**Step 2: Copy Update #1**
```sql
-- Copy the entire #1 section from database_updates.sql
ALTER TABLE users
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS age INTEGER,
ADD COLUMN IF NOT EXISTS skill_level TEXT;
-- ... (rest of #1)
```

**Step 3: Run It**
1. Paste into SQL Editor
2. Click "Run" button
3. Wait for success message

**Step 4: Repeat for Each Update**
- Copy #2, run it
- Copy #3, run it
- Continue through #10

**Step 5: Verify**
```sql
-- Run this to check:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('city', 'age', 'skill_level');
```

---

### Method 2: Supabase CLI

```bash
# Make sure you're logged in
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run the migration
supabase db push

# Or apply directly
psql -h your-host -U postgres -d postgres < database_updates.sql
```

---

## 📝 Update Checklist

Copy this and check off as you add each update:

```
□ #1  - Profile card fields (city, skill_level)
□ #2  - User settings table
□ #3  - Support tickets table
□ #4  - App policies table
□ #5  - Additional user fields (display_name, lat/lng)
□ #6  - Auto-update timestamps trigger
□ #7  - Auto-initialize settings trigger
□ #8  - Performance indexes
□ #9  - User profile summary view
□ #10 - Grant permissions
```

---

## 🔍 What Each Update Does

### #1: Profile Card Fields
**Why:** Shows location and skill on profile menu card
**Fields:**
- `city` - User's city/location
- `age` - User's age (13-100)
- `skill_level` - Beginner/Intermediate/Advanced/Professional

**Example:**
```sql
-- After running this, you can:
UPDATE users SET city = 'Mumbai', age = 25, skill_level = 'Advanced'
WHERE user_id = 'your-user-id';
```

---

### #2: User Settings Table
**Why:** Stores app preferences and privacy settings
**Fields:**
- Notifications (push, email, SMS)
- Privacy (profile visibility, show location, show age)
- Preferences (language, theme)

**Auto-created:** When user signs up (after #7)

---

### #3: Support Tickets Table
**Why:** Help & Support contact form
**Fields:**
- Category (Account/Booking/Payment/Technical/Other)
- Subject, Description
- Status (open/in_progress/resolved/closed)

**Usage:** Automatically used by Contact Support screen

---

### #4: App Policies Table
**Why:** Store privacy policy, terms, community guidelines
**Pre-populated:** Comes with default policies

**Usage:** Automatically displayed in Policy screen

---

### #5: Additional User Fields
**Why:** Enhanced profile display
**Fields:**
- `display_name` - Public display name
- `location_latitude/longitude` - For matching
**Note:** bio field already exists in your database

---

### #6: Auto-Update Timestamps
**Why:** Automatically updates `updated_at` when records change
**Applied to:**
- user_settings
- support_tickets
- app_policies

**Benefit:** Never forget to update timestamps!

---

### #7: Auto-Initialize Settings
**Why:** Automatically creates settings when user signs up
**Trigger:** Fires after INSERT on users table

**Benefit:** Every user gets default settings automatically!

---

### #8: Performance Indexes
**Why:** Makes queries faster
**Indexes on:**
- users.city
- users.skill_level
- users.age

**Benefit:** Profile card loads faster!

---

### #9: User Profile Summary View
**Why:** Easy access to user + settings data
**Usage:**
```sql
SELECT * FROM user_profile_summary WHERE user_id = 'your-id';
```

**Benefit:** One query instead of joining tables!

---

### #10: Grant Permissions
**Why:** Ensures users can access their data
**Grants:**
- authenticated users → their own data
- anon users → public policies

**Benefit:** Security + functionality!

---

## ✅ Verification

### After Each Update:

**Check for Errors:**
```sql
-- If you see "ERROR", read the message
-- If you see "SUCCESS" or no error, it worked!
```

**Verify Tables Exist:**
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_name IN ('user_settings', 'support_tickets', 'app_policies');
```

**Should return 3 rows** ✅

**Verify User Columns:**
```sql
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('city', 'age', 'skill_level');
```

**Should return 3 rows** ✅

**Test Settings:**
```sql
SELECT * FROM user_settings LIMIT 1;
```

**Should show settings record** ✅

**Test Policies:**
```sql
SELECT policy_type, title FROM app_policies WHERE is_active = true;
```

**Should show 3 policies** (privacy, terms, community) ✅

---

## 🧪 Test Data

### Add Test Data to Your Profile:

```sql
-- Update your user profile
UPDATE users
SET
    city = 'Mumbai',
    age = 25,
    skill_level = 'Advanced',
    display_name = 'Your Name',
    bio = 'Love playing badminton!'
WHERE user_id = 'your-user-id';
```

### Create Test Support Ticket:

```sql
INSERT INTO support_tickets (user_id, category, subject, description)
VALUES (
    'your-user-id',
    'Technical',
    'Test ticket',
    'This is a test support ticket'
);
```

---

## 🔄 After Adding All Updates

### Step 1: Update Profile Menu Code

Uncomment these lines in `lib/screens/profile_menu/profile_menu_widget.dart`:

**Line 116:** Change query to include new fields
```dart
// FROM:
.select('first_name, images')

// TO:
.select('first_name, images, city, age, skill_level')
```

**Lines 284-310:** Uncomment the bottom section to show location/skill

### Step 2: Full App Restart

```bash
flutter run
```

### Step 3: Test Profile Card

1. Open HomeNew
2. Tap profile icon
3. **Should see:**
   - Your name
   - Your age
   - Your location (if set)
   - Your skill level (if set)

---

## 📱 Expected Results

### Profile Menu Card:
```
┌─────────────────────────────────────┐
│  ╔═══════════════════════════════╗ │
│  ║  🎨 Gradient Header           ║ │
│  ║  ┌────┐  John Doe             ║ │
│  ║  │Pic │  25 years old         ║ │
│  ║  └────┘  [Tap to view]        ║ │
│  ╚═══════════════════════════════╝ │
│  ┌───────────────────────────────┐ │
│  │  📍 Mumbai   │   ⭐ Advanced  │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Settings Screen:
- Shows notification toggles
- Shows privacy options
- All working and saving!

### Support Screen:
- Can create tickets
- Tickets saved to database
- Can be viewed/managed

### Policy Screen:
- Shows privacy policy
- Shows terms of service
- Shows community guidelines

---

## 🐛 Troubleshooting

### Error: "column already exists"
**Solution:** That column is already added! Skip to next update.

### Error: "table already exists"
**Solution:** That table is already created! Skip to next update.

### Error: "permission denied"
**Solution:** Make sure you're running as database owner/postgres user.

### Error: "relation does not exist"
**Solution:** Make sure users table exists first.

### Profile card still shows "My Profile" placeholder
**Solution:**
1. Check if columns were added: `SELECT city FROM users LIMIT 1;`
2. Make sure you updated the query (line 116)
3. Did full restart (not hot reload)

---

## 🎯 Summary

**Total Updates:** 10
**Estimated Time:** 10-15 minutes
**Difficulty:** Easy (copy & paste)

**Order:**
1. Copy each #1, #2, #3... section
2. Paste into Supabase SQL Editor
3. Click Run
4. Verify success
5. Move to next

**After all 10:**
- Update profile menu code
- Restart app
- Test profile card
- Enjoy! 🎉

---

## 📚 Files

- `database_updates.sql` - All SQL updates
- `DATABASE_SETUP_GUIDE.md` - This guide
- `lib/screens/profile_menu/profile_menu_widget.dart` - Update after adding fields

---

**Created:** October 30, 2025
**Updates:** 10 total
**Status:** Ready to apply!
