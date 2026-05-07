-- ============================================================
-- Welfare count step in the warehouse → site delivery flow
-- Run once in Supabase SQL Editor. Safe to re-run.
-- ============================================================
-- New flow:
--   1. Warehouse (James) sends → status = 'pending', source = 'warehouse'
--   2. Welfare counts received items → status = 'welfare_counted'
--   3. ASM reviews welfare count & confirms → status = 'applied'
--
-- Supplier deliveries (recorded by welfare) stay unchanged:
--   source = 'supplier', pending → applied directly by ASM
-- ============================================================

-- 1. Allow 'welfare_counted' as a valid status
alter table public.deliveries drop constraint if exists deliveries_status_check;
alter table public.deliveries add constraint deliveries_status_check
  check (status in ('pending', 'welfare_counted', 'applied', 'dismissed'));

-- 2. source column — 'warehouse' for James's dispatches, 'supplier' for inbound deliveries
alter table public.deliveries
  add column if not exists source text not null default 'supplier';

alter table public.deliveries drop constraint if exists deliveries_source_check;
alter table public.deliveries add constraint deliveries_source_check
  check (source in ('supplier', 'warehouse'));

-- 3. Welfare count fields
alter table public.deliveries add column if not exists received_items jsonb;   -- what welfare actually counted
alter table public.deliveries add column if not exists counted_by    text;     -- welfare email
alter table public.deliveries add column if not exists counted_at    timestamptz;

-- 4. Ensure RLS allows welfare to UPDATE deliveries
--    (needed for welfare to submit their count: status → welfare_counted)
drop policy if exists "hotel_scoped_deliveries" on public.deliveries;
create policy "hotel_scoped_deliveries" on public.deliveries
  for all to authenticated
  using  (public.is_warehouse() or hotel_id = public.current_user_hotel())
  with check (public.is_warehouse() or hotel_id = public.current_user_hotel());

-- 5. Verify
select
  status,
  source,
  count(*) as rows
from public.deliveries
group by status, source
order by status, source;
