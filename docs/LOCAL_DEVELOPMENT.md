# Local development (Windows, beginner-friendly)

This guide gets the site running on your machine. You already have Node; you also need **PHP 8+** and **MariaDB/MySQL**. The easiest way is **XAMPP**, which installs PHP, MariaDB and phpMyAdmin together.

Back to the [README](../README.md) · Why things are built this way: [DESIGN_DECISIONS.md](./DESIGN_DECISIONS.md)

## How the pieces fit locally

```
Browser -> http://localhost:5173  (Vite dev server, serves the React site)
              |  requests to /api/...  are proxied to
              v
           http://localhost:8080  (PHP built-in server, runs api/index.php)
              |
              v
           MariaDB on 127.0.0.1:3306  (database "heritage")
```

## 1. Install XAMPP

1. Download XAMPP (PHP 8.x build) from https://www.apachefriends.org and install it to `C:\xampp`.
2. Open the **XAMPP Control Panel** and click **Start** next to **MySQL** (this is MariaDB). You do **not** need Apache.
3. Check PHP works (new PowerShell window):
   ```powershell
   C:\xampp\php\php.exe -v
   ```
   It should print `PHP 8.x`. To type just `php` instead, add `C:\xampp\php` to your PATH (Windows Settings > search "environment variables" > Path > New), then reopen PowerShell.
4. Confirm the MySQL extension is on: `php -m | Select-String pdo_mysql` should print `pdo_mysql` (XAMPP enables it by default).

## 2. Create the database

1. With MySQL running, open http://localhost/phpmyadmin (XAMPP's Apache must be running for this) **or** use the command line below (no Apache needed).
2. Command line option (from the repo root):
   ```powershell
   C:\xampp\mysql\bin\mysql.exe -u root -e "CREATE DATABASE heritage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
   Get-Content db\schema.sql -Raw | C:\xampp\mysql\bin\mysql.exe -u root heritage
   ```
   phpMyAdmin option: click **New**, name it `heritage`, pick `utf8mb4_unicode_ci`, Create; then select it > **Import** > choose `db/schema.sql` > Go.

XAMPP's default is user `root` with an **empty password**. That is fine for local development only.

## 3. Configure the API

Copy the example config and edit it:

```powershell
Copy-Item api\config.example.php api\config.php
```

In `api/config.php` set:

```php
'db' => [
    'host' => '127.0.0.1',
    'name' => 'heritage',
    'user' => 'root',
    'pass' => '',
],
'site_url' => 'http://localhost:5173',
```

Leave `allowed_origin` empty (the Vite proxy makes the browser think everything is one site). `config.php` is git-ignored and never uploaded by accident to source control.

## 4. Start the API

From the repo root, in its own PowerShell window (leave it running):

```powershell
php -S localhost:8080 -t api api/index.php
```

Test it: open http://localhost:8080/health. You should see `{"ok":true}`. If you see `{"error":"Server error"}`, check the PHP window for the real message (usually wrong DB credentials or MySQL not started).

## 5. Start the website

In a second PowerShell window:

```powershell
cd web
npm install
npm run dev
```

Open http://localhost:5173. The Home page should show the sample announcement.

## 6. Create your admin account

1. On the site click **Register**, use a password of at least 10 characters.
2. Promote yourself (new registrations are `pending` and cannot log in):
   ```powershell
   C:\xampp\mysql\bin\mysql.exe -u root heritage -e "UPDATE users SET role='admin', status='approved' WHERE email='you@example.com'"
   ```
   (or run the same `UPDATE` in phpMyAdmin > heritage > SQL).
3. Log in. You now see **Family Tree**, **People**, and **Admin** in the menu. Register a second test account to try the approval flow in Admin > Registrations.

## Everyday workflow

1. Start MySQL in the XAMPP Control Panel.
2. Run the API window (step 4) and the web window (step 5).
3. Edit files under `web/src` (hot-reloads) or `api/` (PHP reloads on every request).

## Emails locally

Approval and "new registration" emails use PHP's `mail()`, which is not set up on a local Windows machine. The failure is silent, so everything still works; you just won't receive emails. On cPanel it works with your mailbox. For local testing you can approve users from the Admin page directly.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| MySQL starts then crashes with `InnoDB: Failing assertion: slot` (`os0file.cc`) | Known XAMPP/MariaDB 10.4 issue on some Windows setups. Open `C:\xampp\mysql\bin\my.ini` and add `innodb_use_native_aio=0` on the line right after `[mysqld]`, save, then Start MySQL again. |
| `php` is not recognized | Use `C:\xampp\php\php.exe`, or add `C:\xampp\php` to PATH and reopen PowerShell. |
| MySQL won't start in XAMPP (port 3306 in use) | Another MySQL is already running. Stop it in the Windows Services app, then start XAMPP's MySQL again. |
| `could not find driver` | Enable `extension=pdo_mysql` in `C:\xampp\php\php.ini`, restart the API. |
| `Access denied for user` | Credentials in `api/config.php` don't match MySQL. |
| `Unknown database 'heritage'` | Run step 2 again. |
| Site loads but data errors / 500 | Open http://localhost:8080/announcements directly to see the API response; check the PHP window log. |
| Login says awaiting approval | Run the admin `UPDATE` in step 6. |
| Reset all data | `mysql -u root -e "DROP DATABASE heritage"` then repeat step 2. |

## Alternatives to XAMPP

- **Laragon** (https://laragon.org): similar all-in-one with PHP and MariaDB.
- **winget** (separate installs): `winget install PHP.PHP.8.3` and `winget install MariaDB.Server`; then follow the same steps, using the `mysql` command from MariaDB's `bin` folder.
