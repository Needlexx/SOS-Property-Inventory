-- ============================================================
-- Add base_pack column + backfill from ProductList CSV
-- Run once in Supabase SQL Editor. Safe to re-run.
-- ============================================================
-- base_pack = the number of individual units that come in one
-- supplier case/box (e.g. 6 means the supplier ships in boxes
-- of 6). Only stored/shown in the warehouse view.
-- ============================================================

alter table public.items
  add column if not exists base_pack integer default null;

-- Backfill existing warehouse items by product_code (case-insensitive)
-- Only rows that have a base_pack value in the CSV are updated;
-- rows with an empty Base Pack in the CSV are left as null.

do $$
declare
  wh_id uuid := (select id from public.hotels where code = 'WAREHOUSE');
begin

  -- Baby Provisions — HiPP / Ella's / Baby Likes / for Aisha
  update public.items set base_pack = 6  where upper(product_code) = '1002'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1003'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1004'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1005'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1006'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1007'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1008'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1009'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1010'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1011'  and hotel_id = wh_id;
  update public.items set base_pack = 12 where upper(product_code) = '1012'  and hotel_id = wh_id;
  update public.items set base_pack = 5  where upper(product_code) = '1013'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1014'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1015'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1016'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1017'  and hotel_id = wh_id;
  update public.items set base_pack = 5  where upper(product_code) = '1018'  and hotel_id = wh_id;
  update public.items set base_pack = 5  where upper(product_code) = '1019'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1020'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1021'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1022'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1023'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1024'  and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = '1027'  and hotel_id = wh_id;

  -- Sanitation & Hygiene / Medical
  update public.items set base_pack = 12  where upper(product_code) = 'A1001' and hotel_id = wh_id;
  update public.items set base_pack = 12  where upper(product_code) = 'A1002' and hotel_id = wh_id;
  update public.items set base_pack = 12  where upper(product_code) = 'A1003' and hotel_id = wh_id;
  -- A1004: no base pack in CSV
  update public.items set base_pack = 6   where upper(product_code) = 'A1005' and hotel_id = wh_id;
  update public.items set base_pack = 12  where upper(product_code) = 'A1006' and hotel_id = wh_id;
  update public.items set base_pack = 5   where upper(product_code) = 'A1007' and hotel_id = wh_id;
  update public.items set base_pack = 12  where upper(product_code) = 'A1008' and hotel_id = wh_id;
  update public.items set base_pack = 6   where upper(product_code) = 'A1009' and hotel_id = wh_id;
  update public.items set base_pack = 6   where upper(product_code) = 'A1010' and hotel_id = wh_id;
  update public.items set base_pack = 20  where upper(product_code) = 'A1011' and hotel_id = wh_id;
  update public.items set base_pack = 50  where upper(product_code) = 'A1012' and hotel_id = wh_id;
  update public.items set base_pack = 1   where upper(product_code) = 'A1013' and hotel_id = wh_id;
  -- A1014: no base pack
  update public.items set base_pack = 1   where upper(product_code) = 'A1015' and hotel_id = wh_id;
  update public.items set base_pack = 250 where upper(product_code) = 'A1016' and hotel_id = wh_id;
  -- A1017–A1021: no base pack in CSV

  -- Sanitary / Tampons
  update public.items set base_pack = 8  where upper(product_code) = 'B1001' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1002' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1003' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1004' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1005' and hotel_id = wh_id;
  update public.items set base_pack = 16 where upper(product_code) = 'B1006' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1007' and hotel_id = wh_id;
  update public.items set base_pack = 8  where upper(product_code) = 'B1008' and hotel_id = wh_id;

  -- Baby equipment / Cots / Feeding
  update public.items set base_pack = 1  where upper(product_code) = 'C1001' and hotel_id = wh_id;
  -- C1002: no base pack
  update public.items set base_pack = 1  where upper(product_code) = 'C1003' and hotel_id = wh_id;
  update public.items set base_pack = 12 where upper(product_code) = 'C1004' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1005' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1006' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1007' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1008' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1009' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'C1010' and hotel_id = wh_id;
  -- C1011–C1013: no base pack

  -- Formula
  update public.items set base_pack = 1 where upper(product_code) = 'C2001' and hotel_id = wh_id;
  update public.items set base_pack = 1 where upper(product_code) = 'C2002' and hotel_id = wh_id;
  update public.items set base_pack = 1 where upper(product_code) = 'C2003' and hotel_id = wh_id;
  -- C2004: no base pack
  update public.items set base_pack = 4 where upper(product_code) = 'C2005' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'C2006' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'C2007' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'C2008' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'C2009' and hotel_id = wh_id;
  update public.items set base_pack = 1 where upper(product_code) = 'C2010' and hotel_id = wh_id;
  update public.items set base_pack = 1 where upper(product_code) = 'C2011' and hotel_id = wh_id;
  -- C3001: no base pack

  -- Baby toiletries / Laundry
  -- D1001: no base pack
  update public.items set base_pack = 6  where upper(product_code) = 'D1002' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'D1003' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'D1004' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'D1005' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'D1006' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'D1007' and hotel_id = wh_id;
  update public.items set base_pack = 12 where upper(product_code) = 'D1008' and hotel_id = wh_id;
  -- D1010: no base pack
  update public.items set base_pack = 50 where upper(product_code) = 'D1011' and hotel_id = wh_id;
  update public.items set base_pack = 50 where upper(product_code) = 'D1012' and hotel_id = wh_id;

  -- Aptamil / Kendamil
  update public.items set base_pack = 4 where upper(product_code) = 'D2004' and hotel_id = wh_id;
  update public.items set base_pack = 2 where upper(product_code) = 'D2005' and hotel_id = wh_id;
  -- D2006–D2008: no base pack
  update public.items set base_pack = 4 where upper(product_code) = 'D2009' and hotel_id = wh_id;
  update public.items set base_pack = 6 where upper(product_code) = 'D2010' and hotel_id = wh_id;
  update public.items set base_pack = 6 where upper(product_code) = 'D2011' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'D2012' and hotel_id = wh_id;
  -- D2013–D2015: no base pack

  -- Sterilising / Bottles / Feeding accessories
  update public.items set base_pack = 1  where upper(product_code) = 'E1001' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1002' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1003' and hotel_id = wh_id;
  -- E1004: no base pack
  update public.items set base_pack = 6  where upper(product_code) = 'E1005' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'E1006' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'E1007' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1008' and hotel_id = wh_id;
  update public.items set base_pack = 12 where upper(product_code) = 'E1009' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1010' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'E1011' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1012' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1013' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1014' and hotel_id = wh_id;
  update public.items set base_pack = 10 where upper(product_code) = 'E1015' and hotel_id = wh_id;
  update public.items set base_pack = 1  where upper(product_code) = 'E1016' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'E1017' and hotel_id = wh_id;
  update public.items set base_pack = 6  where upper(product_code) = 'E1018' and hotel_id = wh_id;

  -- Pull-ups / Nappies
  update public.items set base_pack = 4 where upper(product_code) = 'F1001' and hotel_id = wh_id;
  update public.items set base_pack = 2 where upper(product_code) = 'F1002' and hotel_id = wh_id;
  update public.items set base_pack = 2 where upper(product_code) = 'F1003' and hotel_id = wh_id;
  -- F1004–F1005: no base pack
  update public.items set base_pack = 4 where upper(product_code) = 'F1006' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'F2001' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'F2002' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'F2003' and hotel_id = wh_id;
  update public.items set base_pack = 2 where upper(product_code) = 'F2004' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'G2001' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'G2002' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'G2003' and hotel_id = wh_id;
  update public.items set base_pack = 4 where upper(product_code) = 'G2004' and hotel_id = wh_id;

end $$;
