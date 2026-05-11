-- ============================================================
-- Multi-org / SaaS foundation migration
-- Run once in Supabase SQL Editor. Safe to re-run.
-- ============================================================
-- Adds an `organizations` layer above hotels so the same database
-- can serve many customer orgs (today: SOS Property; tomorrow:
-- Mears, UNHCR Greece, Refugee Action, …) with full RLS isolation.
--
-- Data model layering (top → bottom):
--   organizations   1 row per customer org (code, name, plan)
--   hotels (sites)  belong to ONE org via org_id
--   user_profiles   belong to ONE org via org_id + ONE hotel
--   items / transactions / deliveries / stock_counts
--                   already hotel-scoped → org scoping is inherited
--                   because hotels are now org-scoped via RLS.
--
-- Backfill: every existing row → "SOS Property" org.
-- ============================================================

-- 1. organizations -------------------------------------------------
create table if not exists public.organizations (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  name        text not null,
  plan        text not null default 'free'
              check (plan in ('free','starter','pro','enterprise')),
  country     text default 'GB',
  -- Stripe customer id, subscription id (populated when billing wired up)
  stripe_customer_id     text,
  stripe_subscription_id text,
  -- Soft-limit on number of sites this org can run (enforced in UI)
  max_sites   integer default 1,
  -- Visible product branding inside the app once signed in
  brand_color text default '#6366f1',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Seed the founding org so existing data has somewhere to live
insert into public.organizations (code, name, plan, max_sites)
values ('SOS', 'SOS Property', 'enterprise', 100)
on conflict (code) do nothing;

-- 2. org_id on hotels ----------------------------------------------
alter table public.hotels
  add column if not exists org_id uuid references public.organizations(id);

update public.hotels
  set org_id = (select id from public.organizations where code = 'SOS')
  where org_id is null;

alter table public.hotels alter column org_id set not null;

create index if not exists hotels_org_idx on public.hotels(org_id);

-- 3. org_id on user_profiles ---------------------------------------
alter table public.user_profiles
  add column if not exists org_id uuid references public.organizations(id);

update public.user_profiles
  set org_id = (select id from public.organizations where code = 'SOS')
  where org_id is null;

alter table public.user_profiles alter column org_id set not null;

create index if not exists user_profiles_org_idx on public.user_profiles(org_id);

-- 4. Helpers -------------------------------------------------------
create or replace function public.current_user_org()
returns uuid language sql stable security definer as $$
  select org_id from public.user_profiles where user_id = auth.uid();
$$;

-- 5. RLS — hotels: visible only within the user's org --------------
-- Warehouse role keeps its own logic via is_warehouse() but is still
-- bounded by org (a warehouse user from Mears never sees SOS hotels).
drop policy if exists "auth_read_hotels"     on public.hotels;
drop policy if exists "hotel_scoped_hotels"  on public.hotels;
drop policy if exists "org_scoped_hotels"    on public.hotels;
create policy "org_scoped_hotels" on public.hotels
  for all to authenticated
  using       (org_id = public.current_user_org())
  with check  (org_id = public.current_user_org());

-- 6. RLS — user_profiles: each user reads only profiles in own org -
drop policy if exists "self_read_user_profiles" on public.user_profiles;
drop policy if exists "org_scoped_user_profiles" on public.user_profiles;
create policy "org_scoped_user_profiles" on public.user_profiles
  for select to authenticated
  using (org_id = public.current_user_org());

-- 7. RLS — organizations: a user can read ONLY their own org row ---
alter table public.organizations enable row level security;
drop policy if exists "self_read_organization" on public.organizations;
create policy "self_read_organization" on public.organizations
  for select to authenticated
  using (id = public.current_user_org());

-- 8. Update signup trigger to also assign org ----------------------
-- Existing trigger maps email prefix → hotel. Now also maps the new
-- user to the SOS org by default. Self-serve signup (new orgs) will
-- override this in a later migration.
create or replace function public.assign_hotel_to_new_user()
returns trigger language plpgsql security definer as $$
declare
  hcode text;
  hid   uuid;
  oid   uuid;
begin
  -- Default org until self-serve signup is wired up
  select id into oid from public.organizations where code = 'SOS';

  -- Map email prefix → hotel
  if    lower(coalesce(new.email,'')) like 'bwwembley%' then hcode := 'BWWEMBLEY';
  elsif lower(coalesce(new.email,'')) like 'hiwembley%' then hcode := 'HIWEMBLEY';
  else  hcode := 'HIWEMBLEY';
  end if;
  select id into hid from public.hotels where code = hcode;

  insert into public.user_profiles (user_id, hotel_id, org_id)
  values (new.id, hid, oid)
  on conflict (user_id) do update set org_id = excluded.org_id;
  return new;
end $$;

-- 9. Verify ---------------------------------------------------------
-- Expected: SOS row with 3 sites (HI Wembley, BW Wembley, WAREHOUSE)
-- and however many users you have in user_profiles today.
select
  o.code,
  o.name,
  o.plan,
  o.max_sites,
  count(distinct h.id)        as sites,
  count(distinct u.user_id)   as users
from public.organizations o
left join public.hotels        h on h.org_id  = o.id
left join public.user_profiles u on u.org_id  = o.id
group by o.code, o.name, o.plan, o.max_sites;
