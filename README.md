# Heritage Platform Lean – Sokhulu clan

React (Chakra UI) front end + small PHP API + MySQL, built for cPanel hosting. See [docs/DESIGN_DECISIONS.md](docs/DESIGN_DECISIONS.md) for the why.

```
web/   React + Vite SPA  -> build to web/dist
api/   PHP 8 JSON API    -> upload to public_html/api
db/    schema.sql        -> import with phpMyAdmin
docs/  design decisions
```

## Deploy to cPanel
1. **Database**: cPanel > MySQL Databases: create a database + user (all privileges). In phpMyAdmin import `db/schema.sql`.
2. **API**: upload the `api/` folder to `public_html/api/`. Copy `config.example.php` to `config.php` and fill in DB credentials, `site_url`, and the mail addresses (create a mailbox such as `no-reply@yourdomain` in cPanel > Email Accounts).
3. **Web**: `cd web && npm install && npm run build`, then upload the *contents* of `web/dist/` (including `.htaccess`) to `public_html/`.
4. **First admin**: register on the site, then in phpMyAdmin run  
   `UPDATE users SET role='admin', status='approved' WHERE email='you@example.com';`
5. Use HTTPS (cPanel AutoSSL) – session cookies are marked Secure on HTTPS.

The site and API must be on the same domain (`/api`).

## Local development
**New to PHP/MySQL? Follow the step-by-step Windows guide: [docs/LOCAL_DEVELOPMENT.md](docs/LOCAL_DEVELOPMENT.md).**

Quick version: requires Node 20+, PHP 8+ with `pdo_mysql`, and a local MySQL/MariaDB.
```
# 1. import db/schema.sql into a local database
# 2. cp api/config.example.php api/config.php   (set local DB credentials)
php -S localhost:8080 -t api api/index.php      # API
cd web && npm install && npm run dev            # site on http://localhost:5173 (proxies /api)
```

## Customising
- Clan name/branding: `web/src/config/clan.ts`, `api/config.php` (`clan_slug`).
- History / Iziduko / Culture text: edit from the Admin page.
- Replace the sample people in `db/schema.sql` (or delete them) with real data.
