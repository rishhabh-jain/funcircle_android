// Supabase Edge Function to send support ticket emails
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      }
    })
  }

  try {
    const { userId, subject, description, category, createdAt } = await req.json()

    // Send email using Resend API
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: 'Fun Circle Support <support@funcircle.app>',
        to: ['funcircleapp@gmail.com'],
        subject: `Support Ticket: ${subject}`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #FF6B35;">New Support Ticket Submitted</h2>

            <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; margin: 20px 0;">
              <p><strong>User ID:</strong> ${userId}</p>
              <p><strong>Category:</strong> ${category}</p>
              <p><strong>Submitted:</strong> ${new Date(createdAt).toLocaleString()}</p>
            </div>

            <h3 style="color: #333;">Subject</h3>
            <p style="color: #555;">${subject}</p>

            <h3 style="color: #333;">Description</h3>
            <p style="color: #555; white-space: pre-wrap;">${description}</p>

            <hr style="border: 1px solid #eee; margin: 30px 0;">

            <p style="color: #999; font-size: 12px;">
              This is an automated message from Fun Circle Support System.
            </p>
          </div>
        `,
      }),
    })

    const data = await res.json()

    if (!res.ok) {
      throw new Error(data.message || 'Failed to send email')
    }

    return new Response(
      JSON.stringify({ success: true, emailId: data.id }),
      {
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        status: 400,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      }
    )
  }
})
