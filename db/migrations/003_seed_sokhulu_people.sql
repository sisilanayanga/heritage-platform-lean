-- Seed the Sokhulu people from the legacy SQL Server script.
-- Idempotent: safe to run more than once. Adds people.legacy_id, adopts
-- already-added people when the name+surname+gender match is unambiguous,
-- inserts the rest, then links parents/spouses (skipping existing links).
-- Source: 127 people, 211 relationships. Unnamed people get the name 'Unknown'.

SET @clan := (SELECT id FROM clans WHERE slug = 'sokhulu' LIMIT 1);

SET @has := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'people' AND COLUMN_NAME = 'legacy_id');
SET @ddl := IF(@has = 0, 'ALTER TABLE people ADD COLUMN legacy_id INT UNSIGNED NULL, ADD UNIQUE KEY uq_people_legacy (clan_id, legacy_id)', 'SELECT 1');
PREPARE s FROM @ddl; EXECUTE s; DEALLOCATE PREPARE s;

-- 1. Adopt people already added by hand
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Sisilana' AND family_name <=> NULL AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=2 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=2) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mlobeli' AND family_name <=> NULL AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=4 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=4) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Siphika' AND family_name <=> NULL AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=5 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=5) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mtyagobo' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=7 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=7) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Rulwana' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=8 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=8) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='1st Wife' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=9 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=9) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='2nd Wife' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=10 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=10) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='3rd Wife' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=11 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=11) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='4th Wife?' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=12 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=12) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mnukwa' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=13 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=13) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Leyisi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=14 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=14) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nozintaba' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=15 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=15) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Jan' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=16 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=16) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mdube' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=17 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=17) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Elliot Pelepele' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=18 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=18) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ndawo' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=19 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=19) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ngagu' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=20 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=20) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Skhuku' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=21 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=21) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Sdoyi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=22 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=22) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Hoyana' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=25 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=25) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nyinyi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=26 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=26) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mthwesi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=27 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=27) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mkhuzo' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=28 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=28) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Jowel' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=29 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=29) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gontsi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=31 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=31) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gevasi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=33 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=33) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mantsele' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=34 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=34) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mkhonto' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=35 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=35) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Yohane' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=36 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=36) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mdudwana' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=37 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=37) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Reshed' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=38 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=38) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nono' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=39 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=39) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Zolile' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=40 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=40) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomakwezi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=41 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=41) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Beliot' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=42 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=42) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mandla' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=43 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=43) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Donald' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=44 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=44) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Hamilton' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=45 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=45) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Sandile' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=46 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=46) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gibson' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=47 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=47) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomarwebi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=48 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=48) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tiza' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=49 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=49) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ntombokwendzani' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=50 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=50) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Natu' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=51 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=51) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mbekeni' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=52 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=52) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Malungisa' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=53 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=53) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomabali' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=55 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=55) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gida' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=56 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=56) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mpendulo' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=57 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=57) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Zwelinzima' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=58 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=58) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Lulama' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=59 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=59) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Sipho' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=60 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=60) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomanono' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=61 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=61) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nokwanda' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=62 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=62) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Auston' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=64 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=64) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mawonga' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=65 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=65) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Vayina' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=67 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=67) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Alvina' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=68 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=68) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mebhi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=69 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=69) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomatshangana' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=70 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=70) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Vusumzi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=73 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=73) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gcinamakhosi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=75 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=75) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nombulelo' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=77 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=77) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ntomnonina' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=78 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=78) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mgidwase' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=79 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=79) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Betty' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=80 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=80) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tokozani' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=81 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=81) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Zamuxolo' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=82 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=82) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Siyabonga' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=83 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=83) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomsa' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=84 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=84) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tembisile' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=85 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=85) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Noluvo' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=86 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=86) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Yonela' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=87 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=87) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Sinazo' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=88 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=88) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Zilungile' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=89 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=89) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nkosana' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=90 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=90) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mzwamadoda' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=91 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=91) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Kwanele' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=92 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=92) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tembakazi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=94 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=94) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nonthuthuzelo' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=95 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=95) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Vuyokazi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=96 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=96) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Buyiswa' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=97 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=97) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nosipho' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=98 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=98) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Jamba' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=99 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=99) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ndumiso David' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=101 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=101) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Clayton Tandabantu' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=103 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=103) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomangesi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=104 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=104) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nombeko' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=105 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=105) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Xolile' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=106 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=106) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mfezeko' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=107 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=107) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Mzuvumile' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=108 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=108) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Manelisi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=109 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=109) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gcinani' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=110 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=110) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nomachule' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=111 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=111) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Andiswa' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=112 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=112) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Peliwe' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=113 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=113) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tabani' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=114 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=114) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tebou' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=115 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=115) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tshepo' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=116 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=116) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Tumelo Zolani' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=117 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=117) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ethel Ncediswa' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=118 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=118) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Yanga' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=119 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=119) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nwabisa' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=120 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=120) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Gidakazi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=121 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=121) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Zikhona' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=122 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=122) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ondela' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=123 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=123) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ziphokazi' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=124 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=124) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Nathi' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=125 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=125) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Thato Benedicta' AND family_name <=> 'Ralake' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=126 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=126) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Ahluma' AND family_name <=> 'Sisilana' AND gender <=> 'male') m ON m.id=p.id SET p.legacy_id=127 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=127) x);
UPDATE people p JOIN (SELECT MIN(id) id, COUNT(*) c FROM people WHERE clan_id=@clan AND legacy_id IS NULL AND removed=0 AND given_name='Onalerona' AND family_name <=> 'Sisilana' AND gender <=> 'female') m ON m.id=p.id SET p.legacy_id=128 WHERE m.c=1 AND NOT EXISTS (SELECT 1 FROM (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=128) x);

-- 2. Insert missing people
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', NULL, NULL, 'male', NULL, NULL, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=1);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Sisilana', NULL, 'Sokhulu', 'male', NULL, NULL, NULL, 2
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=2);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', NULL, 'Matshabalala', 'female', NULL, NULL, NULL, 3
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=3);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mlobeli', NULL, 'Sokhulu', 'male', NULL, NULL, NULL, 4
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=4);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Siphika', NULL, 'Sokhulu', 'male', NULL, NULL, NULL, 5
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=5);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mtyagobo', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 7
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=7);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Rulwana', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 8
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=8);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, '1st Wife', 'Sisilana', NULL, 'female', NULL, NULL, NULL, 9
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=9);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, '2nd Wife', 'Sisilana', NULL, 'female', NULL, NULL, NULL, 10
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=10);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, '3rd Wife', 'Sisilana', NULL, 'female', NULL, NULL, NULL, 11
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=11);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, '4th Wife?', 'Sisilana', 'Madontsa', 'female', NULL, NULL, NULL, 12
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=12);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mnukwa', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 13
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=13);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Leyisi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 14
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=14);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nozintaba', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 15
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=15);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Jan', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 16
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=16);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mdube', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 17
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=17);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Elliot Pelepele', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 18
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=18);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ndawo', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 19
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=19);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ngagu', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 20
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=20);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Skhuku', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 21
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=21);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Sdoyi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 22
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=22);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Mamsimanga', 'male', NULL, NULL, NULL, 23
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=23);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Magaduka', 'male', NULL, NULL, NULL, 24
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=24);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Hoyana', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 25
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=25);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nyinyi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 26
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=26);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mthwesi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 27
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=27);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mkhuzo', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 28
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=28);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Jowel', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 29
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=29);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Mandlela', 'female', NULL, NULL, NULL, 30
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=30);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gontsi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 31
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=31);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Mamsimanga', 'female', NULL, NULL, NULL, 32
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=32);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gevasi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 33
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=33);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mantsele', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 34
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=34);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mkhonto', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 35
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=35);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Yohane', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 36
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=36);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mdudwana', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 37
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=37);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Reshed', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 38
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=38);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nono', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 39
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=39);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Zolile', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 40
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=40);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomakwezi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 41
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=41);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Beliot', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 42
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=42);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mandla', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 43
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=43);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Donald', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 44
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=44);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Hamilton', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 45
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=45);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Sandile', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 46
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=46);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gibson', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 47
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=47);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomarwebi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 48
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=48);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tiza', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 49
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=49);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ntombokwendzani', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 50
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=50);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Natu', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 51
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=51);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mbekeni', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 52
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=52);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Malungisa', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 53
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=53);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Maxaba', 'male', NULL, NULL, NULL, 54
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=54);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomabali', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 55
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=55);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gida', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 56
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=56);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mpendulo', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 57
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=57);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Zwelinzima', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 58
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=58);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Lulama', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 59
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=59);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Sipho', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 60
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=60);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomanono', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 61
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=61);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nokwanda', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 62
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=62);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nosifungo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 63
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=63);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Auston', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 64
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=64);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mawonga', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 65
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=65);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Maradebe', 'female', NULL, NULL, NULL, 66
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=66);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Vayina', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 67
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=67);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Alvina', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 68
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=68);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mebhi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 69
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=69);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomatshangana', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 70
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=70);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nosifungo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 71
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=71);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Madlomo', 'female', NULL, NULL, NULL, 72
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=72);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Vusumzi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 73
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=73);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Mandlazi', 'female', NULL, NULL, NULL, 74
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=74);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gcinamakhosi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 75
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=75);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Mamjoli', 'female', NULL, NULL, NULL, 76
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=76);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nombulelo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 77
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=77);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ntomnonina', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 78
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=78);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mgidwase', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 79
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=79);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Betty', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 80
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=80);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tokozani', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 81
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=81);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Zamuxolo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 82
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=82);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Siyabonga', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 83
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=83);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomsa', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 84
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=84);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tembisile', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 85
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=85);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Noluvo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 86
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=86);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Yonela', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 87
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=87);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Sinazo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 88
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=88);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Zilungile', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 89
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=89);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nkosana', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 90
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=90);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mzwamadoda', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 91
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=91);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Kwanele', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 92
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=92);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Matshabalala', 'female', NULL, NULL, NULL, 93
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=93);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tembakazi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 94
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=94);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nonthuthuzelo', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 95
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=95);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Vuyokazi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 96
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=96);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Buyiswa', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 97
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=97);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nosipho', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 98
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=98);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Jamba', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 99
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=99);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Madlamini', 'female', NULL, NULL, NULL, 100
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=100);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ndumiso David', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 101
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=101);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Unknown', 'Sisilana', 'Masgubudo', 'female', NULL, NULL, NULL, 102
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=102);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tandabantu Clayton', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 103
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=103);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomangesi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 104
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=104);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nombeko', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 105
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=105);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Xolile', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 106
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=106);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mfezeko', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 107
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=107);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Mzuvumile', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 108
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=108);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Manelisi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 109
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=109);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gcinani', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 110
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=110);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nomachule', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 111
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=111);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Andiswa', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 112
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=112);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Peliwe', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 113
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=113);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tabani', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 114
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=114);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tebou', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 115
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=115);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tshepo', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 116
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=116);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Tumelo Zolani', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 117
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=117);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ncediswa Ethel', 'Sisilana', 'Mamxesibe', 'female', NULL, NULL, NULL, 118
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=118);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Yanga', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 119
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=119);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nwabisa', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 120
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=120);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Gidakazi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 121
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=121);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Zikhona', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 122
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=122);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ondela', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 123
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=123);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ziphokazi', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 124
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=124);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Nathi', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 125
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=125);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Thato', 'Ralake', 'Mamhlakwana', 'female', NULL, NULL, NULL, 126
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=126);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Ahluma', 'Sisilana', 'Sokhulu', 'male', NULL, NULL, NULL, 127
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=127);
INSERT INTO people (clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, birth_place, legacy_id)
SELECT @clan, 'Onalerona', 'Sisilana', 'Sokhulu', 'female', NULL, NULL, NULL, 128
WHERE NOT EXISTS (SELECT 1 FROM people WHERE clan_id=@clan AND legacy_id=128);

-- 3. Relationships
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=106 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=107 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=108 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=109 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=110 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=111 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=112 WHERE a.clan_id=@clan AND a.legacy_id=100
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=114 WHERE a.clan_id=@clan AND a.legacy_id=101
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=115 WHERE a.clan_id=@clan AND a.legacy_id=101
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=116 WHERE a.clan_id=@clan AND a.legacy_id=101
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=114 WHERE a.clan_id=@clan AND a.legacy_id=102
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=115 WHERE a.clan_id=@clan AND a.legacy_id=102
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=116 WHERE a.clan_id=@clan AND a.legacy_id=102
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=119 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=120 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=121 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=122 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=123 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=124 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=28 WHERE a.clan_id=@clan AND a.legacy_id=10
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=29 WHERE a.clan_id=@clan AND a.legacy_id=10
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=117 WHERE a.clan_id=@clan AND a.legacy_id=114
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=119 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=120 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=121 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=122 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=123 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=124 WHERE a.clan_id=@clan AND a.legacy_id=118
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=127 WHERE a.clan_id=@clan AND a.legacy_id=119
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=128 WHERE a.clan_id=@clan AND a.legacy_id=119
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=31 WHERE a.clan_id=@clan AND a.legacy_id=11
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=33 WHERE a.clan_id=@clan AND a.legacy_id=11
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=125 WHERE a.clan_id=@clan AND a.legacy_id=120
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=127 WHERE a.clan_id=@clan AND a.legacy_id=126
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=128 WHERE a.clan_id=@clan AND a.legacy_id=126
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=34 WHERE a.clan_id=@clan AND a.legacy_id=12
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=35 WHERE a.clan_id=@clan AND a.legacy_id=12
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=36 WHERE a.clan_id=@clan AND a.legacy_id=12
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=2 WHERE a.clan_id=@clan AND a.legacy_id=1
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=4 WHERE a.clan_id=@clan AND a.legacy_id=1
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=5 WHERE a.clan_id=@clan AND a.legacy_id=1
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=101 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=103 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=104 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=105 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=113 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=64 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=65 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=67 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=68 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=69 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=70 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=71 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=99 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=64 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=65 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=67 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=68 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=69 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=70 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=71 WHERE a.clan_id=@clan AND a.legacy_id=23
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=101 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=103 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=104 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=105 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=113 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=99 WHERE a.clan_id=@clan AND a.legacy_id=24
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=44 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=45 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=46 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=47 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=48 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=49 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=50 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=51 WHERE a.clan_id=@clan AND a.legacy_id=28
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=52 WHERE a.clan_id=@clan AND a.legacy_id=29
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=53 WHERE a.clan_id=@clan AND a.legacy_id=29
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=55 WHERE a.clan_id=@clan AND a.legacy_id=29
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=13 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=14 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=15 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=7 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=8 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=52 WHERE a.clan_id=@clan AND a.legacy_id=30
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=53 WHERE a.clan_id=@clan AND a.legacy_id=30
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=55 WHERE a.clan_id=@clan AND a.legacy_id=30
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=42 WHERE a.clan_id=@clan AND a.legacy_id=31
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=43 WHERE a.clan_id=@clan AND a.legacy_id=31
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=42 WHERE a.clan_id=@clan AND a.legacy_id=32
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=43 WHERE a.clan_id=@clan AND a.legacy_id=32
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=37 WHERE a.clan_id=@clan AND a.legacy_id=33
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=38 WHERE a.clan_id=@clan AND a.legacy_id=33
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=39 WHERE a.clan_id=@clan AND a.legacy_id=33
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=40 WHERE a.clan_id=@clan AND a.legacy_id=33
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=41 WHERE a.clan_id=@clan AND a.legacy_id=33
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=13 WHERE a.clan_id=@clan AND a.legacy_id=3
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=14 WHERE a.clan_id=@clan AND a.legacy_id=3
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=15 WHERE a.clan_id=@clan AND a.legacy_id=3
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=7 WHERE a.clan_id=@clan AND a.legacy_id=3
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=8 WHERE a.clan_id=@clan AND a.legacy_id=3
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=56 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=57 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=58 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=59 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=60 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=61 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=62 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=63 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=56 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=57 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=58 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=59 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=60 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=61 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=62 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=63 WHERE a.clan_id=@clan AND a.legacy_id=54
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=73 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=75 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=77 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=78 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=79 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=80 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=85 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=86 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=87 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=88 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=89 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=90 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=91 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=92 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=94 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=95 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=96 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=97 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=98 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=90 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=91 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=92 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=94 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=95 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=96 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=97 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=98 WHERE a.clan_id=@clan AND a.legacy_id=66
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=73 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=75 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=77 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=78 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=79 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=80 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=85 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=86 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=87 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=88 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=89 WHERE a.clan_id=@clan AND a.legacy_id=72
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=81 WHERE a.clan_id=@clan AND a.legacy_id=73
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=82 WHERE a.clan_id=@clan AND a.legacy_id=73
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=83 WHERE a.clan_id=@clan AND a.legacy_id=73
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=84 WHERE a.clan_id=@clan AND a.legacy_id=73
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=81 WHERE a.clan_id=@clan AND a.legacy_id=74
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=82 WHERE a.clan_id=@clan AND a.legacy_id=74
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=83 WHERE a.clan_id=@clan AND a.legacy_id=74
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=84 WHERE a.clan_id=@clan AND a.legacy_id=74
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=16 WHERE a.clan_id=@clan AND a.legacy_id=7
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=17 WHERE a.clan_id=@clan AND a.legacy_id=7
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=18 WHERE a.clan_id=@clan AND a.legacy_id=7
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=19 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=20 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=21 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=22 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=25 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=26 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=27 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=28 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=29 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=31 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=33 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=34 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=35 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=36 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=106 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=107 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=108 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=109 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=110 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=111 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=112 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=19 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=20 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=21 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=22 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=25 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=26 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'parent_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=27 WHERE a.clan_id=@clan AND a.legacy_id=9
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='parent_of' AND (r.person_id=a.id AND r.related_person_id=b.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=102 WHERE a.clan_id=@clan AND a.legacy_id=101
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=118 WHERE a.clan_id=@clan AND a.legacy_id=103
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=126 WHERE a.clan_id=@clan AND a.legacy_id=119
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=23 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=24 WHERE a.clan_id=@clan AND a.legacy_id=22
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=30 WHERE a.clan_id=@clan AND a.legacy_id=29
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=3 WHERE a.clan_id=@clan AND a.legacy_id=2
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=32 WHERE a.clan_id=@clan AND a.legacy_id=31
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=54 WHERE a.clan_id=@clan AND a.legacy_id=53
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=72 WHERE a.clan_id=@clan AND a.legacy_id=64
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=66 WHERE a.clan_id=@clan AND a.legacy_id=65
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=74 WHERE a.clan_id=@clan AND a.legacy_id=73
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=76 WHERE a.clan_id=@clan AND a.legacy_id=75
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=10 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=11 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=12 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=9 WHERE a.clan_id=@clan AND a.legacy_id=8
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
INSERT INTO relationships (clan_id, person_id, related_person_id, type)
SELECT @clan, a.id, b.id, 'spouse_of' FROM people a JOIN people b ON b.clan_id=@clan AND b.legacy_id=100 WHERE a.clan_id=@clan AND a.legacy_id=99
AND NOT EXISTS (SELECT 1 FROM relationships r WHERE r.type='spouse_of' AND (r.person_id=a.id AND r.related_person_id=b.id OR r.person_id=b.id AND r.related_person_id=a.id));
