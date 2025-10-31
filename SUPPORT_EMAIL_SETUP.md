# Setting Up Automated Support Ticket Emails

All support tickets are automatically saved to the `support_tickets` table in Supabase. To receive email notifications when new tickets are submitted, follow one of these methods:

## Method 1: Supabase Database Webhooks + Zapier (Recommended - No coding)

### Step 1: Create Zapier Account (Free)
1. Go to https://zapier.com and sign up for a free account
2. Create a new Zap

### Step 2: Set Up Trigger
1. **Trigger App**: Choose "Webhooks by Zapier"
2. **Trigger Event**: Select "Catch Hook"
3. Copy the webhook URL provided by Zapier

### Step 3: Configure Supabase Webhook
1. Go to Supabase Dashboard → Database → Webhooks
2. Click "Create a new hook"
3. Configure:
   - **Name**: Support Ticket Email Notification
   - **Table**: public.support_tickets
   - **Events**: Check "Insert"
   - **Type**: HTTP Request
   - **Method**: POST
   - **URL**: Paste the Zapier webhook URL
   - **Headers**:
     ```
     Content-Type: application/json
     ```

### Step 4: Set Up Action in Zapier
1. **Action App**: Choose "Email by Zapier" or "Gmail"
2. **Action Event**: Send Email
3. Configure email:
   - **To**: funcircleapp@gmail.com
   - **Subject**: New Support Ticket: {{record__subject}}
   - **Body**:
     ```
     New Support Ticket Submitted

     User ID: {{record__user_id}}
     Category: {{record__category}}
     Priority: {{record__priority}}
     Status: {{record__status}}

     Subject: {{record__subject}}

     Description:
     {{record__description}}

     Submitted at: {{record__created_at}}

     View in Supabase: [Link to your Supabase dashboard]
     ```

4. Test the Zap
5. Turn on the Zap

## Method 2: Use Resend API (For developers)

### Step 1: Get Resend API Key
1. Sign up at https://resend.com (free tier available)
2. Verify your domain or use their test domain
3. Get your API key

### Step 2: Create Supabase Edge Function
```bash
# In your project root
supabase functions new send-support-email
```

The Edge Function code is already created at:
`/supabase/functions/send-support-email/index.ts`

### Step 3: Deploy the Function
```bash
# Set the Resend API key
supabase secrets set RESEND_API_KEY=your_resend_api_key_here

# Deploy the function
supabase functions deploy send-support-email
```

### Step 4: Update Flutter App
The contact form needs to call this Edge Function after saving to database.

## Method 3: Manual Check (No setup required)

Simply check the Supabase dashboard regularly:
1. Go to Supabase Dashboard → Table Editor
2. Select `support_tickets` table
3. View all submitted tickets
4. You can export as CSV if needed

### Create a View for Easy Access
Run this SQL in Supabase:
```sql
CREATE OR REPLACE VIEW support_tickets_view AS
SELECT
  st.ticket_id,
  st.subject,
  st.description,
  st.category,
  st.status,
  st.priority,
  st.created_at,
  u.first_name,
  u.email as user_email
FROM support_tickets st
LEFT JOIN users u ON st.user_id = u.user_id
ORDER BY st.created_at DESC;
```

Then you can easily query all tickets with user info.

## Recommended Solution

For immediate implementation, I recommend **Method 1 (Zapier)** because:
- ✅ No coding required
- ✅ Free tier available (100 tasks/month)
- ✅ Setup takes 10 minutes
- ✅ Reliable email delivery
- ✅ Can customize email templates
- ✅ Can add SMS notifications later

Alternatively, you can start with **Method 3** and upgrade to Method 1 when you have time to set it up.
