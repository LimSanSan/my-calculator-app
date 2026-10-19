-- Run this in the Supabase SQL Editor.
-- It creates a Before User Created hook that only permits @ri.edu.sg accounts.

create or replace function public.hook_allow_ri_email_only(event jsonb)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  candidate_email text := lower(coalesce(event->'user'->>'email', ''));
begin
  if candidate_email ~ '^[^@[:space:]]+@ri\.edu\.sg$' then
    return '{}'::jsonb;
  end if;

  return jsonb_build_object(
    'error', jsonb_build_object(
      'http_code', 403,
      'message', 'Only @ri.edu.sg email addresses are allowed.'
    )
  );
end;
$$;

grant execute on function public.hook_allow_ri_email_only(jsonb) to supabase_auth_admin;
revoke execute on function public.hook_allow_ri_email_only(jsonb) from authenticated, anon, public;
