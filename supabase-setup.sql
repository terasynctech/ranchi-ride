-- Ranchi Ride: Supabase setup for bookings + live driver tracking
-- Run in Supabase Dashboard > SQL Editor. Review policies before production use.
create extension if not exists pgcrypto;

create table if not exists public.rides (
  id uuid primary key default gen_random_uuid(),
  tracking_code text unique not null default upper(substr(encode(gen_random_bytes(6),'hex'),1,8)),
  customer_name text,
  customer_phone text,
  pickup_text text not null,
  drop_text text not null,
  service_type text not null default 'Economy Car',
  estimated_fare numeric(10,2),
  status text not null default 'requested' check (status in ('requested','accepted','driver_assigned','arriving','in_progress','completed','cancelled')),
  driver_id uuid,
  driver_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.ride_locations (
  id bigint generated always as identity primary key,
  ride_id uuid not null references public.rides(id) on delete cascade,
  driver_id uuid,
  latitude double precision not null,
  longitude double precision not null,
  heading double precision,
  speed_mps double precision,
  recorded_at timestamptz not null default now()
);
create index if not exists ride_locations_ride_recorded_idx on public.ride_locations(ride_id, recorded_at desc);

alter table public.rides enable row level security;
alter table public.ride_locations enable row level security;

-- Development-only policies to allow anon client to create rides and read ride status/location.
-- For production, replace with authenticated, role-scoped policies and server-side driver verification.
drop policy if exists "dev create rides" on public.rides;
create policy "dev create rides" on public.rides for insert to anon, authenticated with check (true);
drop policy if exists "dev read rides by tracking code" on public.rides;
create policy "dev read rides by tracking code" on public.rides for select to anon, authenticated using (true);
drop policy if exists "dev update ride status" on public.rides;
create policy "dev update ride status" on public.rides for update to authenticated using (true) with check (true);
drop policy if exists "dev add live location" on public.ride_locations;
create policy "dev add live location" on public.ride_locations for insert to anon, authenticated with check (true);
drop policy if exists "dev read live location" on public.ride_locations;
create policy "dev read live location" on public.ride_locations for select to anon, authenticated using (true);

-- Enable realtime for live map updates (ignore duplicate publication membership errors if already enabled).
do $$ begin
  alter publication supabase_realtime add table public.ride_locations;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
