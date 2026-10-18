# Design Decisions

Living log of why the site is built the way it is. Add a new entry (never silently rewrite old ones) whenever a decision changes.

Status key: **Accepted**, **Superseded**, **Open**.

## D1 – Lean cPanel stack instead of the full platform spec (Accepted)
The original spec (NestJS, Prisma, Postgres, Redis, Docker, K8s, Auth0) is the long-term target. The first release must run on cPanel shared hosting (static files, MySQL, mailbox, file manager). So: **React SPA + tiny PHP API + MySQL**. The API contract (`/api/...` JSON) is deliberately simple so a NestJS backend can replace the PHP one later without touching the React app.

## D2 – React + TypeScript + Vite + Chakra UI v2 + TanStack Query (Accepted)
Chakra UI requested for styling. v2 chosen over v3 for stability and wide documentation. TanStack Query handles fetching/caching. The build is a static `dist/` uploaded to `public_html`. Routing uses BrowserRouter with an `.htaccess` fallback to `index.html`.

## D3 – A thin PHP API between browser and MySQL (Accepted)
A static site cannot talk to MySQL directly (credentials would be public). cPanel supports PHP, so `api/` holds a small framework-free PHP 8 API using PDO prepared statements. Credentials live only in `api/config.php` (git-ignored; `config.example.php` is committed).

## D4 – Self-hosted authentication with admin approval (Accepted)
Keycloak needs its own server (not possible on cPanel); Auth0 free tier adds an external dependency and still needs our own approval flag. Chosen: users table in MySQL, `password_hash`, opaque random session token in an HttpOnly, SameSite=Lax cookie (only a SHA-256 hash is stored), CSRF token header on all writes, login rate limiting (8 failures / 15 min / IP), identical registration response to avoid account enumeration.
Flow: register -> `pending` -> admin approves/rejects in `/admin` -> email via cPanel mail (`mail()`), then login works.
First admin is promoted manually via SQL (see README).
Future: swap to OIDC (Auth0/Keycloak) when the platform moves to real hosting; the `users.status` approval concept remains.

## D5 – Access model (Accepted)
- **Guest**: Home, History, Iziduko, Culture, Contact, public announcements.
- **Approved member**: Family Tree, People, Stories, Events, Places, Gallery, Documents, non-public announcements.
- **Admin**: everything plus approvals and content management.
Rule: anything about identity or actual people requires an approved account; this is enforced in the API (`require_member`), not just hidden in the UI.

## D6 – Multi-clan readiness without multi-clan complexity (Accepted)
Single clan now. Every business table has `clan_id` (the tenant key from the original spec); the API scopes every query by `clan_id()` resolved from `config.php` (`clan_slug`). UI branding sits in `web/src/config/clan.ts`. Going multi-clan later = resolve clan from subdomain/host, load branding from API, and add a clan-scoped role model. No code path assumes a single clan except those two config points.

## D7 – Family tree data model (Accepted)
`people` + `relationships` (`parent_of`, `spouse_of`). The tree is derived on the client: roots are people with no recorded parent; children appear under parents; spouses next to partners. This supports polygynous marriages (common in our history) and avoids fixed "father/mother" columns. Rendered as a nested, mobile-friendly list (no heavy graph library). Unconnected people simply appear as additional roots.

## D8 – Editable text content in the database (Accepted)
History, Iziduko and Culture are rows in `content_pages`, editable from the Admin page, so non-developers can maintain them without redeploying.

## D9 – No file uploads in v1 (Accepted)
Gallery and Documents pages are placeholders. Safe uploads (type validation, private storage, authenticated download) deserve their own design. Planned: a `StorageProvider` interface (local disk on cPanel now; S3/Azure Blob/MinIO later, as in the original spec) with files stored outside `public_html` and served via an authenticated PHP endpoint.

## D10 – Privacy of living people (Open)
Currently all approved members see all people. Consider per-person visibility and hiding living people's details from non-relatives.

## D11 – Suggested additional pages for South African Black heritage (Open backlog)
- **Iziduko** (done, public page) – clan praises and meanings.
- **Ancestral homesteads & graves** (done as Places) – kraal/umuzi locations and grave register with GPS, valuable given forced removals and migration.
- **Ceremonies & rites** – umembeso, lobola/ilobolo process, imbeleko, umhlanga, ukubuyisa idlozi; (partly under Culture/Events).
- **Name meanings & naming traditions** – origin of given names.
- **Migration & land timeline** – origin, movements, forced removals, land claims.
- **Oral history archive** – audio recordings with transcripts (needs D9).
- **Burial society / contributions** – stokvel, funeral committees.
- **Languages toggle** (EN / isiZulu etc.).
- **Documents** – ID books, birth/marriage certificates, title deeds, letters (needs D9, with strict privacy).
- **Clan leadership** – iNkosi/headman lineage and regents.

## D12 – Dropped for now from the original spec
Docker, Redis/BullMQ, Auth0, Swagger, Prisma, Kubernetes, GitHub Actions, search/AI/notifications/audit modules. They return when moving to the full platform. A basic CI workflow can be added later (install, lint, build).

## D13 – Legacy people import (Accepted)
`db/migrations/003_seed_sokhulu_people.sql` imports 127 people from an earlier SQL Server script (Families / Persons / ParentOfFamilies).
- `people.legacy_id` (unique per clan) records the old Id, so the script is idempotent and can be re-run.
- Old "Family" = one partnership. Everyone with a ParentOfFamilies row for a family is a spouse of the others (`spouse_of`) and a parent (`parent_of`) of every person whose ChildOfFamilyId is that family. Men with several families (polygyny) simply get several spouses.
- Mapping: Name→given_name, Surname→family_name, Clan→clan_name, Gender→gender (lowercase). Unnamed people are stored as `Unknown` (edit them in the admin UI).
- People already added by hand are adopted (not duplicated) when name, surname and gender match exactly; three have explicit aliases (Clayton Tandabantu, Ethel Ncediswa, Thato Benedicta). Existing links are not duplicated.
- The three "Sample …" seed people are left alone; disable them in the admin UI if not wanted.