<?php
declare(strict_types=1);

// Shared helpers: config, DB, JSON IO, sessions, auth guards, mail.

function config(): array
{
    static $cfg = null;
    if ($cfg === null) {
        $path = __DIR__ . '/../config.php';
        if (!file_exists($path)) {
            fail(500, 'Server not configured');
        }
        $cfg = require $path;
    }
    return $cfg;
}

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $c = config()['db'];
        $pdo = new PDO(
            "mysql:host={$c['host']};dbname={$c['name']};charset=utf8mb4",
            $c['user'],
            $c['pass'],
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]
        );
    }
    return $pdo;
}

function clan_id(): int
{
    static $id = null;
    if ($id === null) {
        $st = db()->prepare('SELECT id FROM clans WHERE slug = ?');
        $st->execute([config()['clan_slug']]);
        $id = (int) $st->fetchColumn();
        if ($id === 0) {
            fail(500, 'Clan not found');
        }
    }
    return $id;
}

function respond($data, int $code = 200): void
{
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function fail(int $code, string $message): void
{
    respond(['error' => $message], $code);
}

function body(): array
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw ?: '[]', true);
    return is_array($data) ? $data : [];
}

function str_field(array $data, string $key, int $max = 255, bool $required = false): ?string
{
    $v = isset($data[$key]) && is_string($data[$key]) ? trim($data[$key]) : '';
    if ($v === '') {
        if ($required) {
            fail(422, "$key is required");
        }
        return null;
    }
    if (mb_strlen($v) > $max) {
        fail(422, "$key is too long");
    }
    return $v;
}

function date_field(array $data, string $key): ?string
{
    $v = str_field($data, $key, 10);
    if ($v !== null && !preg_match('/^\d{4}-\d{2}-\d{2}$/', $v)) {
        fail(422, "$key must be YYYY-MM-DD");
    }
    return $v;
}

// ---- sessions -------------------------------------------------------------

function start_session(int $userId): void
{
    $token = bin2hex(random_bytes(32));
    $csrf = bin2hex(random_bytes(32));
    $days = (int) config()['session_days'];
    $st = db()->prepare('INSERT INTO sessions (token_hash, user_id, csrf_token, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? DAY))');
    $st->execute([hash('sha256', $token), $userId, $csrf, $days]);
    setcookie('hp_session', $token, [
        'expires' => time() + $days * 86400,
        'path' => '/',
        'secure' => !empty($_SERVER['HTTPS']),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
}

function end_session(): void
{
    if (!empty($_COOKIE['hp_session'])) {
        db()->prepare('DELETE FROM sessions WHERE token_hash = ?')->execute([hash('sha256', $_COOKIE['hp_session'])]);
    }
    setcookie('hp_session', '', ['expires' => time() - 3600, 'path' => '/']);
}

/** Returns the logged-in approved user (with csrf_token) or null. */
function current_user(): ?array
{
    static $loaded = false, $user = null;
    if ($loaded) {
        return $user;
    }
    $loaded = true;
    if (empty($_COOKIE['hp_session']) || !is_string($_COOKIE['hp_session'])) {
        return null;
    }
    $st = db()->prepare(
        'SELECT u.id, u.email, u.full_name, u.role, u.status, s.csrf_token
         FROM sessions s JOIN users u ON u.id = s.user_id
         WHERE s.token_hash = ? AND s.expires_at > NOW() AND u.clan_id = ?'
    );
    $st->execute([hash('sha256', $_COOKIE['hp_session']), clan_id()]);
    $row = $st->fetch();
    $user = ($row && $row['status'] === 'approved') ? $row : null;
    return $user;
}

function require_member(): array
{
    $u = current_user();
    if (!$u) {
        fail(401, 'Login required');
    }
    return $u;
}

function require_admin(): array
{
    $u = require_member();
    if ($u['role'] !== 'admin') {
        fail(403, 'Admin only');
    }
    return $u;
}

function check_csrf(): void
{
    $u = current_user();
    if (!$u) {
        return; // unauthenticated writes (login/register) carry no session to forge
    }
    $sent = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
    if (!hash_equals($u['csrf_token'], $sent)) {
        fail(403, 'Invalid CSRF token');
    }
}

// ---- mail (cPanel mailbox / PHP mail) ------------------------------------

function send_mail(string $to, string $subject, string $text): void
{
    $m = config()['mail'];
    $headers = [
        'From: ' . $m['from_name'] . ' <' . $m['from'] . '>',
        'Content-Type: text/plain; charset=utf-8',
    ];
    // Header injection guard
    if (preg_match('/[\r\n]/', $to . $subject)) {
        return;
    }
    @mail($to, '=?UTF-8?B?' . base64_encode($subject) . '?=', $text, implode("\r\n", $headers));
}
