-- Soft-disable support for people. Run once in phpMyAdmin on an existing database
-- (new installs already get these columns from schema.sql).
ALTER TABLE people
  ADD COLUMN removed TINYINT(1) NOT NULL DEFAULT 0,
  ADD COLUMN removed_at DATETIME NULL;

ALTER TABLE relationships
  ADD COLUMN disabled TINYINT(1) NOT NULL DEFAULT 0;
