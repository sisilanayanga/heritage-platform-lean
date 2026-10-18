-- Rename the Izithakazelo page to Iziduko on an existing database (new installs use schema.sql).
UPDATE content_pages
SET slug = 'iziduko',
    title = IF(title = 'Izithakazelo (Clan Praises)', 'Iziduko (Clan Praises)', title)
WHERE slug = 'izithakazelo';
