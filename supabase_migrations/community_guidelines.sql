-- Step 1: First, ensure the app_policies table has a unique constraint on policy_type
-- This is safe to run multiple times
ALTER TABLE public.app_policies DROP CONSTRAINT IF EXISTS app_policies_policy_type_key;
ALTER TABLE public.app_policies ADD CONSTRAINT app_policies_policy_type_key UNIQUE (policy_type);

-- Step 2: Delete existing community guidelines if present (to avoid conflicts)
DELETE FROM public.app_policies WHERE policy_type = 'community';

-- Step 3: Insert Community Guidelines into app_policies table
INSERT INTO public.app_policies (policy_type, title, content, version, effective_date, created_at, updated_at)
VALUES (
  'community',
  'Fun Circle Community Guidelines',
  '# Welcome to Fun Circle!

Fun Circle is a community dedicated to bringing sports enthusiasts together for badminton, pickleball, and other social sports activities. To ensure a positive experience for everyone, we ask all members to follow these community guidelines.

## 1. Be Respectful and Courteous

- Treat all players with respect, regardless of skill level
- Use appropriate language in all communications
- Be punctual for your bookings and games
- Respect venue rules and staff

## 2. Fair Play and Sportsmanship

- Play fair and honor the spirit of the game
- Accept wins and losses gracefully
- Avoid aggressive or unsportsmanlike behavior
- Report scores honestly when playing matches
- Help new players learn and improve

## 3. Safety First

- Ensure you are physically fit to participate
- Use appropriate equipment and safety gear
- Report any injuries or safety concerns immediately
- Follow venue safety guidelines
- Stay hydrated and take breaks when needed

## 4. Booking Etiquette

- Cancel bookings at least 24 hours in advance when possible
- Arrive on time for your bookings
- Only bring the number of players specified in your booking
- Leave the court/venue in good condition
- Pay promptly for all bookings

## 5. Communication Guidelines

- Respond to game requests within a reasonable time
- Be clear about your skill level when connecting with players
- Use the in-app messaging for coordination
- Keep conversations friendly and sports-related
- Do not spam or send unsolicited messages

## 6. Profile Integrity

- Use real photos and accurate information
- Update your skill level honestly
- Do not create fake or duplicate accounts
- Report any suspicious profiles or behavior

## 7. Payment and Bookings

- Complete payments on time
- Do not share login credentials
- Report any payment issues immediately
- Honor cancellation policies
- Do not attempt to circumvent payment systems

## 8. Prohibited Behavior

The following behaviors are strictly prohibited:

- Harassment, bullying, or discrimination of any kind
- Inappropriate or offensive content
- Cheating or match-fixing
- Sharing false information
- Attempting to damage the app or its services
- Commercial solicitation without permission
- Impersonating others
- Underage use (must be 18+ or have parental consent)

## 9. Privacy and Data

- Respect other players privacy
- Do not share others personal information
- Use location sharing responsibly
- Report any privacy concerns

## 10. Reporting Violations

If you encounter any violations of these guidelines:

- Use the in-app reporting feature
- Contact support at funcircleapp@gmail.com
- Provide specific details and evidence when possible
- Do not engage in arguments or confrontations

## Consequences of Violations

Depending on the severity of the violation, we may:

- Issue a warning
- Temporarily suspend your account
- Permanently ban your account
- Report serious violations to authorities

## Updates to Guidelines

These guidelines may be updated periodically. Continued use of Fun Circle constitutes acceptance of any changes.

## Contact Us

Questions about these guidelines? Reach out to us:

- Email: funcircleapp@gmail.com
- Phone: +91 95610 79271
- Instagram: @funcircleapp

---

**Remember:** Fun Circle is built on respect, fair play, and the love of sports. Let us keep it fun for everyone!

*Last Updated: January 2025*',
  '1.0',
  NOW(),
  NOW(),
  NOW()
);
