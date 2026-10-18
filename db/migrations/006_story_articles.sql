-- Stories become an article repository (dated, evidence-tagged, ranked by reads), and places get
-- an evidence status. Also seeds research articles and places. Idempotent.
SET @clan := (SELECT id FROM clans WHERE slug = 'sokhulu' LIMIT 1);

SET @has := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stories' AND COLUMN_NAME = 'view_count');
SET @ddl := IF(@has = 0,
  'ALTER TABLE stories
     ADD COLUMN summary VARCHAR(190) NULL,
     ADD COLUMN category VARCHAR(60) NULL,
     ADD COLUMN event_date DATE NULL,
     ADD COLUMN date_label VARCHAR(60) NULL,
     ADD COLUMN evidence_status VARCHAR(20) NOT NULL DEFAULT ''unconfirmed'',
     ADD COLUMN sources TEXT NULL,
     ADD COLUMN view_count INT UNSIGNED NOT NULL DEFAULT 0,
     ADD KEY idx_stories_rank (clan_id, view_count)',
  'SELECT 1');
PREPARE s FROM @ddl; EXECUTE s; DEALLOCATE PREPARE s;

-- One counted read per person per day, so the ranking cannot be inflated by refreshing.
CREATE TABLE IF NOT EXISTS story_views (
  story_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  view_date DATE NOT NULL,
  PRIMARY KEY (story_id, user_id, view_date),
  FOREIGN KEY (story_id) REFERENCES stories(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET @has := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'places' AND COLUMN_NAME = 'evidence_status');
SET @ddl := IF(@has = 0,
  'ALTER TABLE places
     MODIFY COLUMN kind ENUM(''homestead'',''grave'',''origin'',''town'',''village'',''other'') NOT NULL DEFAULT ''other'',
     ADD COLUMN evidence_status VARCHAR(20) NOT NULL DEFAULT ''unconfirmed''',
  'SELECT 1');
PREPARE s FROM @ddl; EXECUTE s; DEALLOCATE PREPARE s;

-- ---- Places ---------------------------------------------------------------
INSERT INTO places (clan_id, name, kind, description, latitude, longitude, evidence_status)
SELECT @clan, 'Mount Frere (KwaBhaca)', 'town',
 'Town in the Umzimvubu Local Municipality, Alfred Nzo District, Eastern Cape. Founded in 1876 and named after Sir Bartle Frere; officially renamed KwaBhaca in February 2016. Coordinates are the town centre as given by OpenStreetMap.',
 -30.900300, 28.993300, 'verified'
WHERE @clan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM places WHERE clan_id = @clan AND name = 'Mount Frere (KwaBhaca)');

INSERT INTO places (clan_id, name, kind, description, latitude, longitude, evidence_status)
SELECT @clan, 'Ambrose (eMbrose)', 'homestead',
 'Our family land near Mount Frere. TO BE CONFIRMED: no independent source or map entry for this name was found, so no coordinates are shown. Please add the ward, traditional council and nearest landmarks from family knowledge or the Umzimvubu ward list.',
 NULL, NULL, 'unconfirmed'
WHERE @clan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM places WHERE clan_id = @clan AND name = 'Ambrose (eMbrose)');

INSERT INTO places (clan_id, name, kind, description, latitude, longitude, evidence_status)
SELECT @clan, 'KwaNyamana village', 'village',
 'Village within the Ambrose area, near Mount Frere. TO BE CONFIRMED: OpenStreetMap has no entry for this name and no other written source was found. Location, spelling and administrative area need confirmation from the family or the local council.',
 NULL, NULL, 'unconfirmed'
WHERE @clan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM places WHERE clan_id = @clan AND name = 'KwaNyamana village');

-- ---- Research articles ------------------------------------------------------
INSERT INTO stories (clan_id, title, summary, category, event_date, date_label, evidence_status, narrator, body, sources)
SELECT @clan, t.title, t.summary, t.category, t.event_date, t.date_label, t.status, 'Research compilation', t.body, t.sources
FROM (
 SELECT 'The amaHlubi enter Natal under Langalibalele' AS title,
  'Langalibalele leads the amaHlubi from their northern Natal homeland into the Colony of Natal.' AS summary,
  'Hlubi history' AS category, '1848-01-01' AS event_date, '1848' AS date_label, 'verified' AS status,
  'Langalibalele (c. 1814-1889) was king of the amaHlubi, a Nguni people who speak a Tekela dialect and who lived between the Buffalo and Blood Rivers in northern Natal before the rise of the Zulu kingdom. After conflict with the Zulu king Mpande, he led his people into the Colony of Natal in 1848.

What is not yet confirmed: how this Natal Hlubi kingdom connects to Hlubi families who settled around Mount Frere and East Griqualand. No local source was found for that link.' AS body,
  'Wikipedia: Langalibalele | https://en.wikipedia.org/wiki/Langalibalele' AS sources
 UNION ALL
 SELECT 'The 1873 Langalibalele affair', 'A dispute over guns bought on the diamond mines ends with the Hlubi king exiled to Robben Island.', 'Hlubi history', '1873-01-01', '1873', 'verified',
  'In 1873 a dispute over the registration of firearms, which Hlubi men had acquired while working on the Kimberley diamond fields, escalated into a confrontation with colonial forces. Langalibalele fled towards Basutoland, was captured, tried and exiled to Robben Island, and later returned under restrictions. He died in 1889.',
  'Wikipedia: Langalibalele | https://en.wikipedia.org/wiki/Langalibalele'
 UNION ALL
 SELECT 'The Bhaca settle the Mount Frere area', 'The Bhaca, under the line of Madzikane and Ncapayi, settle the land they call KwaBhaca.', 'Mount Frere history', '1825-01-01', 'from about 1825', 'verified',
  'According to the sources found, the Bhaca (formerly the Zelemu) descend from a merger of the Wushe and Zelemu lineages and migrated south under Madzikane ka Khalimeshe. His son King Ncapayi repelled a Zulu incursion at Ntsizwa Mountain. The Bhaca settled the Mount Frere area from about 1825 and called it KwaBhaca, "the place of the Bhaca".

Note: this rests mainly on encyclopedia-level sources that cite older works (such as A. T. Bryant and Rev. Tiyo Soga). The dates are approximate; verify them against academic sources before treating them as settled.',
  'Wikipedia: Bhaca people | https://en.wikipedia.org/wiki/Bhaca_people
Wikipedia: Mount Frere | https://en.wikipedia.org/wiki/Mount_Frere'
 UNION ALL
 SELECT 'Ncapayi and the stand at Ntsizwa Mountain', 'A Zulu-era incursion is repelled at Ntsizwa. The exact year is not confirmed.', 'Mount Frere history', NULL, 'Shaka era - year to be confirmed', 'unconfirmed',
  'King Ncapayi of the Bhaca is said to have repelled a Zulu incursion at Ntsizwa Mountain before settling in the region. The sources found place this in the Shaka era but give no firm date, so no year is shown here.

TO BE CONFIRMED: the year, the size of the force, and the sources that first recorded the event.',
  'Wikipedia: Bhaca people | https://en.wikipedia.org/wiki/Bhaca_people'
 UNION ALL
 SELECT 'Mount Frere is founded and named after Sir Bartle Frere', 'The town is established and named after the British High Commissioner.', 'Mount Frere history', '1876-01-01', '1876', 'verified',
  'Mount Frere was founded in 1876 and named after Sir Henry Bartle Edward Frere, the British High Commissioner. The Bhaca name for the area, KwaBhaca, is older than the town.',
  'Wikipedia: Mount Frere | https://en.wikipedia.org/wiki/Mount_Frere'
 UNION ALL
 SELECT 'Mount Frere is officially renamed KwaBhaca', 'In February 2016 the town takes back its Bhaca name.', 'Mount Frere history', '2016-02-01', 'February 2016', 'verified',
  'The town of Mount Frere was officially renamed KwaBhaca in February 2016. It lies in the Umzimvubu Local Municipality of the Alfred Nzo District in the Eastern Cape.',
  'Wikipedia: Mount Frere | https://en.wikipedia.org/wiki/Mount_Frere'
 UNION ALL
 SELECT 'Mpondo, Mpondomise and Xesibe: shared descent', 'Tradition links the Xesibe, Mpondomise and Mpondo to one ancestor, and the Xesibe are neighbours of the Bhaca.', 'Neighbours and kin', NULL, 'Traditional - undated', 'oral',
  'Tradition holds that the amaXesibe descend from a brother line of the Mpondomise and Mpondo royal houses, whose common ancestor is named in the sources as Khubazi/Njanya. The Xesibe have historically lived in the country near Mount Ayliff and Tabankulu, next to the Bhaca.

This is traditional genealogy rather than dated history. Only a partial source was found, so treat it as indicative.',
  'Wikipedia: AmaMpondomise | https://en.wikipedia.org/wiki/AmaMpondomise'
 UNION ALL
 SELECT 'Hlubi, Basotho and Xhosa communities in the border districts', 'A 2021 academic article describes mixed communities in the districts next to Mount Frere.', 'Hlubi history', NULL, '19th-20th century', 'verified',
  'A peer-reviewed article on stock theft across the Lesotho-South Africa border describes the Transkei border districts of Matatiele, Mount Fletcher and Kokstad, all next to Mount Frere, as having mixed Basotho, Hlubi and Xhosa populations. This supports a Hlubi presence in the wider area, but it does not document a specific Hlubi chieftainship at Mount Frere.

TO BE CONFIRMED: the exact Hlubi settlements and lineages around Mount Frere. Local sources such as magisterial records and university theses should be searched.',
  'Aerni-Flessner et al., South African Historical Journal (2021) | https://www.tandfonline.com/doi/abs/10.1080/02582473.2022.2052171'
 UNION ALL
 SELECT 'The Sokhulu name: what the evidence says', 'Sokhulu is also a Zulu surname. We found no written source for our praise names.', 'Our name', NULL, 'Open question', 'unconfirmed',
  'Sokhulu is a well-documented Zulu surname (isibongo). Surnames crossed language and group lines across the Nguni world, so a Sokhulu family in an isiXhosa-speaking area of Mount Frere is not a contradiction, but this is inference, not a documented fact.

No written source was found for the izithakazelo/iziduko of our Sokhulu line, and nothing that links us to Hlubi, Bhaca, Xesibe or Mpondomise clan names.

TO BE CONFIRMED: our own praise names and origin story, from the elders. If you remember them, please tell the family historian so they can be recorded here as oral history.',
  'Wikipedia: Sokhulu | https://en.wikipedia.org/wiki/Sokhulu'
 UNION ALL
 SELECT 'Ambrose and KwaNyamana: what we still need to confirm', 'No written source or map entry has been found for our home area yet.', 'Our name', NULL, 'Open question', 'unconfirmed',
  'Searches of Wikipedia, South African History Online, general web search and OpenStreetMap found no entry for "Ambrose" or "KwaNyamana" near Mount Frere. That is a limit of the sources searched, not proof the places do not exist.

To confirm: the ward and traditional council, the correct spelling, and the position on a map (for example from the Umzimvubu Local Municipality ward list or Statistics South Africa place names). Please see the Places page; coordinates will be added only once confirmed.',
  'OpenStreetMap | https://www.openstreetmap.org/'
 UNION ALL
 SELECT 'Further reading: academic sources', 'Papers and books to read next about the Hlubi, Bhaca and iziduko.', 'Sources', NULL, 'Reading list', 'verified',
  'Only abstracts or summaries of the last two items were read. Full texts are mostly behind paywalls.

Still to search: South African History Online (sahistory.org.za), and the UNISA, Wits and UCT thesis repositories for "Hlubi", "Bhaca", "izithakazelo" and "Mount Frere".',
  'Aerni-Flessner et al., stock theft on the Lesotho-South Africa border | https://www.tandfonline.com/doi/abs/10.1080/02582473.2022.2052171
N. J. van Warmelo, The Bantu-Speaking Peoples of Southern Africa (2024 reprint) | https://api.taylorfrancis.com/content/chapters/edit/download?identifierName=doi&identifierValue=10.4324/9781032709499-4&type=chapterpdf
Mkhize, The Oral Archive as First Author (iziduko and izibongo as sources) | https://api.taylorfrancis.com/content/chapters/edit/download?identifierName=doi&identifierValue=10.4324/9781003393597-16'
) t
WHERE @clan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM stories s WHERE s.clan_id = @clan AND s.title = t.title);
