
<!-- SQL Schema Comment Block -->
<!--
====================================================
  BFP LOGBOOK MANAGEMENT SYSTEM — SUPABASE SQL SCHEMA
====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================
-- TABLE: inspection_logbook
-- ========================
CREATE TABLE inspection_logbook (
  id              UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  io_number       VARCHAR(50) NOT NULL,
  owner_name      VARCHAR(255) NOT NULL,
  business_name   VARCHAR(255) NOT NULL,
  address         TEXT NOT NULL,
  date_inspected  DATE NOT NULL,
  fsic_number     VARCHAR(50) NOT NULL,
  inspected_by    VARCHAR(255),
  created_at      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at      TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- If table already exists, add the column with:
-- ALTER TABLE inspection_logbook ADD COLUMN IF NOT EXISTS inspected_by VARCHAR(255);

-- Auto-update updated_at on row change
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inspection_updated_at
  BEFORE UPDATE ON inspection_logbook
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ==============================
-- TABLE: fsec_building_plan_logbook
-- ==============================
CREATE TABLE fsec_building_plan_logbook (
  id               UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  owner_name       VARCHAR(255) NOT NULL,
  proposed_project VARCHAR(255) NOT NULL,
  address          TEXT NOT NULL,
  date             DATE NOT NULL,
  contact_number   VARCHAR(30) NOT NULL,
  created_at       TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at       TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TRIGGER trg_fsec_updated_at
  BEFORE UPDATE ON fsec_building_plan_logbook
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ========================
-- ROW LEVEL SECURITY
-- ========================
-- If your data is not saving: run the two CREATE POLICY lines below in
-- Supabase Dashboard → SQL Editor (your tables may already have RLS with
-- only "authenticated" allowed; anon key needs "anon" policies).
ALTER TABLE inspection_logbook ENABLE ROW LEVEL SECURITY;
ALTER TABLE fsec_building_plan_logbook ENABLE ROW LEVEL SECURITY;

-- Allow anonymous (anon key) full access so the app can save/load without sign-in
CREATE POLICY "Allow anon all inspection_logbook" ON inspection_logbook
  FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "Allow anon all fsec_building_plan_logbook" ON fsec_building_plan_logbook
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- Optional: allow authenticated users too (if you add login later)
-- CREATE POLICY "Allow authenticated full access" ON inspection_logbook
--   FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- CREATE POLICY "Allow authenticated full access" ON fsec_building_plan_logbook
--   FOR ALL TO authenticated USING (true) WITH CHECK (true);

====================================================
-->
