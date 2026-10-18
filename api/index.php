<?php
declare(strict_types=1);

require __DIR__ . '/lib/bootstrap.php';

set_exception_handler(function (Throwable $e) {
    error_log($e->getMessage());
    fail(500, 'Server error');
});

$origin = config()['allowed_origin'] ?? '';
if ($origin !== '') {
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Headers: Content-Type, X-CSRF-Token');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
}
header('X-Content-Type-Options: nosniff');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$path = trim((string) parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
$path = preg_replace('#^api(/|$)#', '', $path) ?? '';
$parts = $path === '' ? [] : explode('/', $path);
$route = ($parts[0] ?? '');
$cid = clan_id();

if ($method !== 'GET') {
    check_csrf();
}

// Whitelisted editable content tables for admin CRUD: table => [field => type]
$content = [
    'stories' => ['title' => 's', 'summary' => 's', 'category' => 's', 'event_date' => 'd', 'date_label' => 's', 'evidence_status' => 'e', 'narrator' => 's', 'body' => 't', 'sources' => 't'],
    'events' => ['title' => 's', 'kind' => 's', 'event_date' => 'd', 'location' => 's', 'details' => 't'],
    'places' => ['name' => 's', 'kind' => 's', 'evidence_status' => 'e', 'description' => 't', 'latitude' => 'n', 'longitude' => 'n'],
    'announcements' => ['title' => 's', 'body' => 't', 'is_public' => 'b'],
    'people' => ['given_name' => 's', 'family_name' => 's', 'clan_name' => 's', 'gender' => 's', 'birth_date' => 'd', 'death_date' => 'd', 'is_living' => 'b', 'birth_place' => 's', 'bio' => 't'],
];
$requiredField = ['stories' => 'title', 'events' => 'title', 'places' => 'name', 'announcements' => 'title', 'people' => 'given_name'];
$memberLists = [
    'stories' => 'SELECT id, title, summary, category, event_date, date_label, evidence_status, narrator, view_count, created_at FROM stories WHERE clan_id = ? ORDER BY COALESCE(event_date, DATE(created_at)) DESC, id DESC',
    'events' => 'SELECT id, title, kind, event_date, location, details FROM events WHERE clan_id = ? ORDER BY event_date DESC',
    'places' => 'SELECT id, name, kind, evidence_status, description, latitude, longitude FROM places WHERE clan_id = ? ORDER BY name',
];
$listPerm = ['stories' => 'stories.view', 'events' => 'events.view', 'places' => 'places.view'];
$writePerm = [
    'stories' => ['stories.manage', 'stories.manage'],
    'events' => ['events.manage', 'events.manage'],
    'places' => ['places.manage', 'places.manage'],
    'announcements' => ['announcements.manage', 'announcements.manage'],
    'people' => ['people.create', 'people.edit'], // [create, edit]
];

/** Without people.view_details only identity (names, gender) is exposed. */
function limit_person(array $row, bool $details): array
{
    if ($details) {
        return $row;
    }
    $keep = ['id', 'given_name', 'family_name', 'gender', 'removed'];
    return ['restricted' => true] + array_intersect_key($row, array_flip($keep));
}

function collect_fields(array $spec, array $data): array
{
    $out = [];
    foreach ($spec as $f => $t) {
        switch ($t) {
            case 'd': $out[$f] = date_field($data, $f); break;
            case 'b': $out[$f] = empty($data[$f]) ? 0 : 1; break;
            case 'n':
                $out[$f] = isset($data[$f]) && is_numeric($data[$f]) ? (float) $data[$f] : null;
                break;
            case 't': $out[$f] = str_field($data, $f, 20000); break;
            case 'e': $out[$f] = in_array($data[$f] ?? '', ['verified', 'unconfirmed', 'oral'], true) ? $data[$f] : 'unconfirmed'; break;
            default: $out[$f] = str_field($data, $f, 190);
        }
    }
    return $out;
}

switch (true) {
    // ---- public -----------------------------------------------------------
    case $route === 'health':
        respond(['ok' => true]);

    case $route === 'announcements' && $method === 'GET':
        $sql = 'SELECT id, title, body, published_at FROM announcements WHERE clan_id = ?'
            . (can('announcements.view_members') ? '' : ' AND is_public = 1') . ' ORDER BY published_at DESC LIMIT 20';
        $st = db()->prepare($sql);
        $st->execute([$cid]);
        respond($st->fetchAll());

    case $route === 'pages' && $method === 'GET' && isset($parts[1]):
        $st = db()->prepare('SELECT slug, title, body FROM content_pages WHERE clan_id = ? AND slug = ?');
        $st->execute([$cid, $parts[1]]);
        $row = $st->fetch();
        $row ? respond($row) : fail(404, 'Not found');

    // ---- auth ---------------------------------------------------------------
    case $route === 'auth' && ($parts[1] ?? '') === 'me':
        $u = current_user();
        respond($u ? ['user' => [
            'id' => (int) $u['id'], 'email' => $u['email'], 'fullName' => $u['full_name'], 'role' => $u['role'],
            'permissions' => user_permissions($u),
        ], 'csrfToken' => $u['csrf_token']] : ['user' => null]);

    case $route === 'auth' && ($parts[1] ?? '') === 'register' && $method === 'POST':
        $d = body();
        $email = strtolower(str_field($d, 'email', 190, true));
        $name = str_field($d, 'fullName', 160, true);
        $note = str_field($d, 'relationshipNote', 500);
        $pw = (string) ($d['password'] ?? '');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            fail(422, 'Invalid email');
        }
        if (strlen($pw) < 10) {
            fail(422, 'Password must be at least 10 characters');
        }
        $st = db()->prepare('SELECT id FROM users WHERE clan_id = ? AND email = ?');
        $st->execute([$cid, $email]);
        if (!$st->fetch()) {
            db()->prepare('INSERT INTO users (clan_id, email, password_hash, full_name, relationship_note) VALUES (?,?,?,?,?)')
                ->execute([$cid, $email, password_hash($pw, PASSWORD_DEFAULT), $name, $note]);
            send_mail(config()['mail']['admin_notify'], 'New heritage registration', "$name ($email) is awaiting approval.\n" . config()['site_url'] . '/admin');
        }
        // Same response whether or not the email existed (no account enumeration)
        respond(['message' => 'Registration received. An administrator will review it.'], 202);

    case $route === 'auth' && ($parts[1] ?? '') === 'login' && $method === 'POST':
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0';
        $st = db()->prepare('SELECT COUNT(*) FROM login_attempts WHERE ip = ? AND attempted_at > DATE_SUB(NOW(), INTERVAL 15 MINUTE)');
        $st->execute([$ip]);
        if ((int) $st->fetchColumn() >= 8) {
            fail(429, 'Too many attempts. Try again later.');
        }
        $d = body();
        $email = strtolower((string) ($d['email'] ?? ''));
        $st = db()->prepare('SELECT * FROM users WHERE clan_id = ? AND email = ?');
        $st->execute([$cid, $email]);
        $u = $st->fetch();
        if (!$u || !password_verify((string) ($d['password'] ?? ''), $u['password_hash'])) {
            db()->prepare('INSERT INTO login_attempts (ip) VALUES (?)')->execute([$ip]);
            fail(401, 'Invalid email or password');
        }
        if ($u['status'] === 'pending') {
            fail(403, 'Your registration is still awaiting approval.');
        }
        if ($u['status'] === 'rejected') {
            fail(403, 'Your registration was not approved.');
        }
        db()->prepare('DELETE FROM login_attempts WHERE ip = ?')->execute([$ip]);
        start_session((int) $u['id']);
        respond(['ok' => true]);

    case $route === 'auth' && ($parts[1] ?? '') === 'logout' && $method === 'POST':
        end_session();
        respond(['ok' => true]);

    // ---- members ------------------------------------------------------------
    case $route === 'tree' && $method === 'GET':
        require_perm('tree.view');
        $details = can('people.view_details');
        $p = db()->prepare('SELECT id, given_name, family_name, clan_name, gender, birth_date, death_date, is_living FROM people WHERE clan_id = ? AND removed = 0 ORDER BY birth_date');
        $p->execute([$cid]);
        $r = db()->prepare('SELECT person_id, related_person_id, type FROM relationships WHERE clan_id = ? AND disabled = 0');
        $r->execute([$cid]);
        respond(['people' => array_map(fn ($row) => limit_person($row, $details), $p->fetchAll()), 'relationships' => $r->fetchAll()]);

    case $route === 'people' && $method === 'GET' && isset($parts[1]):
        require_perm('people.view');
        $st = db()->prepare('SELECT * FROM people WHERE clan_id = ? AND id = ?' . (can('people.disable') ? '' : ' AND removed = 0'));
        $st->execute([$cid, (int) $parts[1]]);
        $row = $st->fetch();
        $row ? respond(limit_person($row, can('people.view_details'))) : fail(404, 'Not found');

    case $route === 'people' && $method === 'GET':
        require_perm('people.view');
        $details = can('people.view_details');
        $st = db()->prepare('SELECT id, given_name, family_name, clan_name, gender, birth_date, death_date, is_living, removed FROM people WHERE clan_id = ?' . (can('people.disable') ? '' : ' AND removed = 0') . ' ORDER BY removed, family_name, given_name');
        $st->execute([$cid]);
        respond(array_map(fn ($row) => limit_person($row, $details), $st->fetchAll()));

    case $route === 'stories' && ($parts[1] ?? '') === 'highlights' && $method === 'GET':
        require_perm('stories.view');
        // Most-read first; until anything has been read, fall back to the newest articles.
        $st = db()->prepare('SELECT id, title, summary, category, date_label, evidence_status, view_count FROM stories WHERE clan_id = ? ORDER BY view_count DESC, COALESCE(event_date, DATE(created_at)) DESC, id DESC LIMIT 3');
        $st->execute([$cid]);
        respond($st->fetchAll());

    case $route === 'stories' && isset($parts[1]) && $method === 'GET':
        require_perm('stories.view');
        $st = db()->prepare('SELECT id, title, summary, category, event_date, date_label, evidence_status, narrator, body, sources, view_count, created_at FROM stories WHERE clan_id = ? AND id = ?');
        $st->execute([$cid, (int) $parts[1]]);
        $row = $st->fetch();
        if (!$row) {
            fail(404, 'Not found');
        }
        $u = current_user();
        // One counted read per person per day so the ranking cannot be inflated by refreshing.
        $ins = db()->prepare('INSERT IGNORE INTO story_views (story_id, user_id, view_date) VALUES (?, ?, CURDATE())');
        $ins->execute([(int) $row['id'], (int) $u['id']]);
        if ($ins->rowCount() > 0) {
            db()->prepare('UPDATE stories SET view_count = view_count + 1 WHERE id = ?')->execute([(int) $row['id']]);
            $row['view_count'] = (int) $row['view_count'] + 1;
        }
        respond($row);

    case isset($memberLists[$route]) && $method === 'GET':
        require_perm($listPerm[$route]);
        $st = db()->prepare($memberLists[$route]);
        $st->execute([$cid]);
        respond($st->fetchAll());

    // ---- access control (admin only) ----------------------------------------
    case $route === 'admin' && ($parts[1] ?? '') === 'rbac' && $method === 'GET':
        require_admin();
        $perms = db()->query('SELECT code, label, grp FROM permissions ORDER BY grp, code')->fetchAll();
        $rs = db()->prepare('SELECT id, name, description, is_system, is_default, is_admin FROM roles WHERE clan_id = ? ORDER BY is_admin DESC, is_default DESC, name');
        $rs->execute([$cid]);
        $roles = $rs->fetchAll();
        $rp = db()->prepare('SELECT rp.role_id, rp.permission_code FROM role_permissions rp JOIN roles r ON r.id = rp.role_id WHERE r.clan_id = ?');
        $rp->execute([$cid]);
        $byRole = [];
        foreach ($rp->fetchAll() as $x) {
            $byRole[(int) $x['role_id']][] = $x['permission_code'];
        }
        foreach ($roles as &$r) {
            $r['id'] = (int) $r['id'];
            $r['permissions'] = $byRole[$r['id']] ?? [];
        }
        unset($r);
        $us = db()->prepare("SELECT id, full_name, email, role FROM users WHERE clan_id = ? AND status = 'approved' ORDER BY full_name");
        $us->execute([$cid]);
        $users = $us->fetchAll();
        $ur = db()->prepare('SELECT ur.user_id, ur.role_id FROM user_roles ur JOIN users u ON u.id = ur.user_id WHERE u.clan_id = ?');
        $ur->execute([$cid]);
        $roleIds = [];
        foreach ($ur->fetchAll() as $x) {
            $roleIds[(int) $x['user_id']][] = (int) $x['role_id'];
        }
        $up = db()->prepare('SELECT up.user_id, up.permission_code FROM user_permissions up JOIN users u ON u.id = up.user_id WHERE u.clan_id = ?');
        $up->execute([$cid]);
        $direct = [];
        foreach ($up->fetchAll() as $x) {
            $direct[(int) $x['user_id']][] = $x['permission_code'];
        }
        foreach ($users as &$u) {
            $u['id'] = (int) $u['id'];
            $u['roleIds'] = $roleIds[$u['id']] ?? [];
            $u['permissions'] = $direct[$u['id']] ?? [];
        }
        unset($u);
        respond(['permissions' => $perms, 'roles' => $roles, 'users' => $users]);

    case $route === 'admin' && ($parts[1] ?? '') === 'roles' && in_array($method, ['POST', 'PUT'], true):
        require_admin();
        $d = body();
        $name = str_field($d, 'name', 80, true);
        $desc = str_field($d, 'description', 300);
        $codes = array_values(array_unique(array_map('strval', (array) ($d['permissions'] ?? []))));
        $valid = db()->query('SELECT code FROM permissions')->fetchAll(PDO::FETCH_COLUMN);
        if (array_diff($codes, $valid)) {
            fail(422, 'Unknown permission');
        }
        $pdo = db();
        $pdo->beginTransaction();
        try {
            if ($method === 'POST') {
                $pdo->prepare('INSERT INTO roles (clan_id, name, description) VALUES (?,?,?)')->execute([$cid, $name, $desc]);
                $rid = (int) $pdo->lastInsertId();
            } else {
                $rid = (int) ($parts[2] ?? 0);
                $st = $pdo->prepare('SELECT is_system, is_admin FROM roles WHERE id = ? AND clan_id = ?');
                $st->execute([$rid, $cid]);
                $role = $st->fetch();
                if (!$role) {
                    fail(404, 'Role not found');
                }
                if ((int) $role['is_admin'] === 1) {
                    fail(422, 'The Administrator role always has every permission and cannot be edited');
                }
                // System roles keep their name so the app can still find them
                if ((int) $role['is_system'] === 1) {
                    $pdo->prepare('UPDATE roles SET description = ? WHERE id = ?')->execute([$desc, $rid]);
                } else {
                    $pdo->prepare('UPDATE roles SET name = ?, description = ? WHERE id = ?')->execute([$name, $desc, $rid]);
                }
                $pdo->prepare('DELETE FROM role_permissions WHERE role_id = ?')->execute([$rid]);
            }
            $ins = $pdo->prepare('INSERT INTO role_permissions (role_id, permission_code) VALUES (?,?)');
            foreach ($codes as $c) {
                $ins->execute([$rid, $c]);
            }
            $pdo->commit();
        } catch (PDOException $e) {
            $pdo->rollBack();
            if ($e->getCode() === '23000') {
                fail(409, 'A role with that name already exists');
            }
            throw $e;
        }
        respond(['id' => $rid], $method === 'POST' ? 201 : 200);

    case $route === 'admin' && ($parts[1] ?? '') === 'roles' && isset($parts[2]) && $method === 'DELETE':
        require_admin();
        $st = db()->prepare('DELETE FROM roles WHERE id = ? AND clan_id = ? AND is_system = 0');
        $st->execute([(int) $parts[2], $cid]);
        $st->rowCount() ? respond(['ok' => true]) : fail(422, 'Built-in roles cannot be deleted');

    case $route === 'admin' && ($parts[1] ?? '') === 'users' && isset($parts[2], $parts[3]) && $parts[3] === 'access' && $method === 'PUT':
        require_admin();
        $uid = (int) $parts[2];
        $st = db()->prepare("SELECT role FROM users WHERE id = ? AND clan_id = ? AND status = 'approved'");
        $st->execute([$uid, $cid]);
        $target = $st->fetch();
        if (!$target) {
            fail(404, 'User not found');
        }
        if ($target['role'] === 'admin') {
            fail(422, 'Admins have every permission. Remove admin first to manage their access.');
        }
        $d = body();
        $roleIds = array_values(array_unique(array_map('intval', (array) ($d['roleIds'] ?? []))));
        $codes = array_values(array_unique(array_map('strval', (array) ($d['permissions'] ?? []))));
        $okRoles = db()->prepare('SELECT id FROM roles WHERE clan_id = ? AND is_admin = 0');
        $okRoles->execute([$cid]);
        $validRoles = array_map('intval', $okRoles->fetchAll(PDO::FETCH_COLUMN));
        $validPerms = db()->query('SELECT code FROM permissions')->fetchAll(PDO::FETCH_COLUMN);
        if (array_diff($roleIds, $validRoles) || array_diff($codes, $validPerms)) {
            fail(422, 'Unknown role or permission');
        }
        $pdo = db();
        $pdo->beginTransaction();
        $pdo->prepare('DELETE FROM user_roles WHERE user_id = ?')->execute([$uid]);
        $pdo->prepare('DELETE FROM user_permissions WHERE user_id = ?')->execute([$uid]);
        $ir = $pdo->prepare('INSERT INTO user_roles (user_id, role_id) VALUES (?,?)');
        foreach ($roleIds as $rid) {
            $ir->execute([$uid, $rid]);
        }
        $ip = $pdo->prepare('INSERT INTO user_permissions (user_id, permission_code) VALUES (?,?)');
        foreach ($codes as $c) {
            $ip->execute([$uid, $c]);
        }
        $pdo->commit();
        respond(['ok' => true]);

    case $route === 'admin' && ($parts[1] ?? '') === 'users' && isset($parts[2], $parts[3]) && in_array($parts[3], ['make-admin', 'remove-admin'], true) && $method === 'POST':
        $me = require_admin();
        $uid = (int) $parts[2];
        $st = db()->prepare("SELECT id FROM users WHERE id = ? AND clan_id = ? AND status = 'approved'");
        $st->execute([$uid, $cid]);
        if (!$st->fetch()) {
            fail(404, 'User not found');
        }
        $pdo = db();
        $pdo->beginTransaction();
        if ($parts[3] === 'make-admin') {
            $pdo->prepare("UPDATE users SET role = 'admin' WHERE id = ?")->execute([$uid]);
            $pdo->prepare('INSERT IGNORE INTO user_roles (user_id, role_id) SELECT ?, id FROM roles WHERE clan_id = ? AND is_admin = 1')->execute([$uid, $cid]);
        } else {
            if ($uid === (int) $me['id']) {
                $pdo->rollBack();
                fail(422, 'You cannot remove your own admin access');
            }
            // Strip everything granted so far, then fall back to the default Member role
            $pdo->prepare("UPDATE users SET role = 'member' WHERE id = ?")->execute([$uid]);
            $pdo->prepare('DELETE FROM user_roles WHERE user_id = ?')->execute([$uid]);
            $pdo->prepare('DELETE FROM user_permissions WHERE user_id = ?')->execute([$uid]);
            assign_default_role($uid, $cid);
        }
        $pdo->commit();
        respond(['ok' => true]);

    // ---- admin --------------------------------------------------------------
    case $route === 'admin' && ($parts[1] ?? '') === 'users' && $method === 'GET':
        require_admin();
        $st = db()->prepare("SELECT id, email, full_name, relationship_note, role, status, created_at FROM users WHERE clan_id = ? ORDER BY (status <> 'pending'), created_at DESC");
        $st->execute([$cid]);
        respond($st->fetchAll());

    case $route === 'admin' && ($parts[1] ?? '') === 'users' && isset($parts[2], $parts[3]) && $method === 'POST':
        require_admin();
        $action = $parts[3];
        if (!in_array($action, ['approve', 'reject'], true)) {
            fail(404, 'Unknown action');
        }
        $status = $action === 'approve' ? 'approved' : 'rejected';
        $st = db()->prepare('UPDATE users SET status = ?, approved_at = ? WHERE id = ? AND clan_id = ?');
        $st->execute([$status, $status === 'approved' ? date('Y-m-d H:i:s') : null, (int) $parts[2], $cid]);
        if ($status === 'approved') {
            assign_default_role((int) $parts[2], $cid);
        }
        $q = db()->prepare('SELECT email, full_name FROM users WHERE id = ? AND clan_id = ?');
        $q->execute([(int) $parts[2], $cid]);
        if ($u = $q->fetch()) {
            send_mail($u['email'], 'Your heritage site registration', $status === 'approved'
                ? "Hello {$u['full_name']}, your registration was approved. Log in at " . config()['site_url'] . '/login'
                : "Hello {$u['full_name']}, unfortunately your registration was not approved.");
        }
        respond(['ok' => true]);

    case $route === 'admin' && ($parts[1] ?? '') === 'pages' && isset($parts[2]) && $method === 'PUT':
        require_perm('content.edit');
        $d = body();
        $st = db()->prepare('INSERT INTO content_pages (clan_id, slug, title, body) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE title = VALUES(title), body = VALUES(body)');
        $st->execute([$cid, $parts[2], str_field($d, 'title', 190, true), str_field($d, 'body', 100000, true)]);
        respond(['ok' => true]);

    case $route === 'admin' && ($parts[1] ?? '') === 'relationships' && $method === 'POST':
        require_perm('relationships.manage');
        $d = body();
        $type = $d['type'] ?? '';
        if (!in_array($type, ['parent_of', 'spouse_of'], true)) {
            fail(422, 'Invalid type');
        }
        $a = (int) ($d['personId'] ?? 0);
        $b = (int) ($d['relatedPersonId'] ?? 0);
        $chk = db()->prepare('SELECT COUNT(*) FROM people WHERE clan_id = ? AND removed = 0 AND id IN (?, ?)');
        $chk->execute([$cid, $a, $b]);
        if ($a === $b || (int) $chk->fetchColumn() !== 2) {
            fail(422, 'Invalid people');
        }
        db()->prepare('INSERT INTO relationships (clan_id, person_id, related_person_id, type) VALUES (?,?,?,?)')->execute([$cid, $a, $b, $type]);
        respond(['ok' => true], 201);

    case $route === 'admin' && isset($parts[1], $content[$parts[1]]) && $method === 'POST':
        $table = $parts[1];
        require_perm($writePerm[$table][0]);
        $fields = collect_fields($content[$table], body());
        if ($fields[$requiredField[$table]] === null) {
            fail(422, $requiredField[$table] . ' is required');
        }
        $cols = implode(',', array_keys($fields));
        $ph = implode(',', array_fill(0, count($fields), '?'));
        db()->prepare("INSERT INTO $table (clan_id, $cols) VALUES (?, $ph)")->execute([$cid, ...array_values($fields)]);
        respond(['id' => (int) db()->lastInsertId()], 201);

    case $route === 'admin' && isset($parts[1], $parts[2], $content[$parts[1]]) && $method === 'PUT':
        $table = $parts[1];
        require_perm($writePerm[$table][1]);
        $fields = collect_fields($content[$table], body());
        if ($fields[$requiredField[$table]] === null) {
            fail(422, $requiredField[$table] . ' is required');
        }
        $set = implode(', ', array_map(fn ($c) => "$c = ?", array_keys($fields)));
        db()->prepare("UPDATE $table SET $set WHERE id = ? AND clan_id = ?")->execute([...array_values($fields), (int) $parts[2], $cid]);
        respond(['ok' => true]);

    case $route === 'admin' && isset($parts[1], $parts[2], $parts[3]) && $parts[1] === 'people' && in_array($parts[3], ['disable', 'restore'], true) && $method === 'POST':
        require_perm('people.disable');
        $pid = (int) $parts[2];
        $disable = $parts[3] === 'disable';
        $pdo = db();
        $pdo->beginTransaction();
        $st = $pdo->prepare('UPDATE people SET removed = ?, removed_at = ? WHERE id = ? AND clan_id = ?');
        $st->execute([$disable ? 1 : 0, $disable ? date('Y-m-d H:i:s') : null, $pid, $cid]);
        if ($disable) {
            // Links are kept (so they can be restored) but switched off; the linked people stay untouched.
            $pdo->prepare('UPDATE relationships SET disabled = 1 WHERE clan_id = ? AND (person_id = ? OR related_person_id = ?)')->execute([$cid, $pid, $pid]);
        } else {
            $pdo->prepare(
                'UPDATE relationships r
                 JOIN people a ON a.id = r.person_id JOIN people b ON b.id = r.related_person_id
                 SET r.disabled = 0
                 WHERE r.clan_id = ? AND (r.person_id = ? OR r.related_person_id = ?) AND a.removed = 0 AND b.removed = 0'
            )->execute([$cid, $pid, $pid]);
        }
        $pdo->commit();
        respond(['ok' => true]);

    case $route === 'admin' && isset($parts[1], $parts[2], $content[$parts[1]]) && $method === 'DELETE':
        if ($parts[1] === 'people') {
            fail(405, 'People are never deleted; disable them instead');
        }
        require_perm($writePerm[$parts[1]][0]);
        db()->prepare("DELETE FROM {$parts[1]} WHERE id = ? AND clan_id = ?")->execute([(int) $parts[2], $cid]);
        respond(['ok' => true]);

    default:
        fail(404, 'Not found');
}
