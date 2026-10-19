# Supabase OTP setup

The browser app is already configured with the project URL and publishable key. Complete these dashboard steps before testing sign-in.

## 1. Enable six-digit email codes

1. Open **Authentication > Email Templates** in Supabase.
2. Select the **Magic Link** template.
3. Replace the sign-in link with the token variable `{{ .Token }}`.
4. Use wording such as: `Your RI Calculator verification code is {{ .Token }}`.
5. Save the template.

Supabase uses the same passwordless email flow for magic links and email OTPs. Including `{{ .Token }}` makes the email show the six-digit code expected by the app.

## 2. Restrict new users to RI email addresses

1. Open **SQL Editor** in Supabase.
2. Run [`supabase/setup.sql`](supabase/setup.sql).
3. Open **Authentication > Hooks**.
4. Enable **Before User Created**.
5. Choose the Postgres function `public.hook_allow_ri_email_only`.
6. Save the hook configuration.

The hook rejects new accounts unless their normalized email matches exactly `name@ri.edu.sg`.

## 3. Configure URLs

In **Authentication > URL Configuration** set:

- Site URL: `https://limsansan.github.io/my-calculator-app/`
- Additional redirect URL for local testing: `http://127.0.0.1:4173/**`

## 4. Configure custom SMTP

Supabase's built-in email service only sends to addresses belonging to members of the Supabase project team and is limited to two emails per hour. To let every `@ri.edu.sg` user receive an OTP:

1. Choose an SMTP provider such as Resend, AWS SES, Postmark, SendGrid, ZeptoMail, or Brevo.
2. Open **Authentication > Emails > SMTP Settings** in Supabase.
3. Enable custom SMTP and enter the provider's host, port, username, password, sender email, and sender name.
4. Save the settings and send a test OTP.
5. Review **Authentication > Rate Limits** before a larger rollout.

Do not put SMTP credentials in this repository or in browser JavaScript.

## 5. Important limitation

The calculator is a static GitHub Pages app. Authentication gates the interface and Supabase data access, but it does not make the public HTML and JavaScript source private. Protect any future database tables with Row Level Security policies.
