# Test Deleted Account Feature

## 🔍 Step 1: Verify Database Setup

First, let's check if the `deleted_at` column exists:

### Run this in Supabase SQL Editor:

```sql
-- Check if deleted_at column exists
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'users'
  AND column_name = 'deleted_at';
```

**Expected Result:**
```
column_name | data_type                     | is_nullable
------------|-------------------------------|-------------
deleted_at  | timestamp with time zone      | YES
```

**If you see NO rows**: The column doesn't exist! Run the SQL migration first:

```sql
-- Add deleted_at column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = 'users'
    AND column_name = 'deleted_at'
  ) THEN
    ALTER TABLE public.users ADD COLUMN deleted_at TIMESTAMPTZ NULL;
  END IF;
END $$;
```

---

## 🔍 Step 2: Check Your Test User

Find your test user ID and check their deleted status:

```sql
-- Replace 'your-email@example.com' with your actual email
SELECT
  user_id,
  first_name,
  email,
  deleted_at
FROM public.users
WHERE email = 'your-email@example.com';  -- Change this!
```

**Expected for DELETED user:**
```
user_id              | first_name | email                    | deleted_at
---------------------|------------|--------------------------|-------------------------
EO1dB6dH6hVN...      | fun circle | test@example.com         | 2025-01-03 10:30:00+00
```

**Expected for ACTIVE user:**
```
user_id              | first_name | email                    | deleted_at
---------------------|------------|--------------------------|-------------------------
EO1dB6dH6hVN...      | fun circle | test@example.com         | null
```

---

## 🧪 Step 3: Test the Feature

### A. Test with Flutter App

```bash
flutter run
```

1. **Login** with your account
2. Go to **Settings**
3. Scroll down, tap **"Delete Account"**
4. Type your email/phone to confirm
5. Tap **"Delete Account"**

**Expected**:
- ✅ Account marked as deleted
- ✅ Signs out
- ✅ Goes to Welcome screen

### B. Verify in Database

```sql
-- Check if deletion worked (use your user_id)
SELECT user_id, deleted_at
FROM public.users
WHERE user_id = 'YOUR-USER-ID-HERE';  -- Change this!
```

**Expected**: `deleted_at` should have a timestamp, not null.

### C. Try to Login Again

1. On Welcome screen, tap **"Continue with Google"** (or Phone)
2. Login with the DELETED account

**Watch the console for these DEBUG logs:**

```
DEBUG: User signed in: YOUR-USER-ID
DEBUG: Checking deleted status for user: YOUR-USER-ID
DEBUG: User profile query result: {user_id: ..., deleted_at: 2025-01-03...}
DEBUG: Account is deleted! deleted_at = 2025-01-03...
```

**Expected Result:**
- ✅ Loading dialog closes
- ✅ "Account Deleted" dialog appears
- ✅ Dialog has red icon and clear message
- ✅ Click OK returns to Welcome screen

**If you see:**
```
DEBUG: Account is NOT deleted. Proceeding normally.
```
Then `deleted_at` is NULL in database - the account wasn't actually deleted!

---

## 🐛 Troubleshooting

### Issue 1: "Keeps loading forever"

**Possible causes:**
1. ❌ Loading dialog not closing
2. ❌ Error in deleted check
3. ❌ Navigation conflict

**Check console for:**
- `DEBUG:` logs (should see them if code is running)
- `ERROR` logs (shows what went wrong)

### Issue 2: "Account is NOT deleted" but I deleted it

**Solution:**
```sql
-- Manually set deleted_at for testing
UPDATE public.users
SET deleted_at = NOW()
WHERE user_id = 'YOUR-USER-ID';  -- Change this!

-- Verify it worked
SELECT user_id, deleted_at FROM public.users WHERE user_id = 'YOUR-USER-ID';
```

### Issue 3: No DEBUG logs appear

**Possible causes:**
1. Console not showing print statements
2. Code not running (hot reload issue)

**Solution:**
```bash
# Stop app and restart
flutter run
```

### Issue 4: "Column deleted_at does not exist"

**Solution:**
Run the SQL migration from Step 1 above!

---

## 📊 Complete Test Checklist

- [ ] `deleted_at` column exists in database
- [ ] Can delete account from Settings
- [ ] `deleted_at` is set when account deleted
- [ ] Loading dialog appears when trying to login
- [ ] Loading dialog closes after login
- [ ] "Account Deleted" dialog appears for deleted users
- [ ] Dialog has red icon and message
- [ ] Can click OK to close dialog
- [ ] Returns to Welcome screen
- [ ] Console shows DEBUG logs
- [ ] No errors in console

---

## 🎯 Quick Verification

Run this single query to check everything:

```sql
-- All-in-one check
SELECT
  user_id,
  first_name,
  email,
  deleted_at,
  CASE
    WHEN deleted_at IS NULL THEN 'ACTIVE ✅'
    ELSE 'DELETED ❌'
  END as status
FROM public.users
WHERE email LIKE '%your-email%'  -- Change this!
ORDER BY deleted_at DESC NULLS LAST;
```

---

## 🆘 Still Not Working?

### Copy and send me:

1. **Console logs:**
```
DEBUG: User signed in: ...
DEBUG: Checking deleted status: ...
DEBUG: User profile query result: ...
```

2. **Database query result:**
```sql
SELECT user_id, email, deleted_at
FROM public.users
WHERE user_id = 'YOUR-ID';
```

3. **Column check:**
```sql
SELECT column_name FROM information_schema.columns
WHERE table_name = 'users' AND column_name = 'deleted_at';
```

Then I can tell you exactly what's wrong!

---

## ✅ Expected Behavior Summary

### Deleting Account:
1. Settings → Delete Account
2. Type email/phone
3. Confirm
4. `deleted_at` set in DB
5. Signs out
6. Welcome screen

### Trying to Login After Deletion:
1. Tap "Continue with Google"
2. Google login succeeds
3. **Console shows**: "Account is deleted!"
4. **Loading closes**
5. **Dialog appears**: "Account Deleted"
6. Click OK
7. Back to Welcome screen

**Current issue**: Loading not closing or dialog not showing.
**Solution**: Check DEBUG logs to see where it's stuck!

---

**Run the test and share the console logs!**
