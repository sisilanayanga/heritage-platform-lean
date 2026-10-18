<?php
declare(strict_types=1);

// Copy to config.php and fill in. config.php is git-ignored; never commit secrets.
return [
    'db' => [
        'host' => 'localhost',
        'name' => 'cpaneluser_heritage',
        'user' => 'cpaneluser_heritage',
        'pass' => 'CHANGE_ME',
    ],
    'clan_slug' => 'sokhulu',
    'session_days' => 14,
    'mail' => [
        'from' => 'no-reply@yourdomain.co.za',
        'from_name' => 'Sokhulu Heritage',
        'admin_notify' => 'admin@yourdomain.co.za',
    ],
    'site_url' => 'https://yourdomain.co.za',
    'allowed_origin' => '', // only set for local dev, e.g. http://localhost:5173
];
