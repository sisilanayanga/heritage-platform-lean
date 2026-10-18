-- RBAC: permissions, roles, user-role and direct user-permission assignments.
-- Idempotent: safe to run more than once. Run after 001-003.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS permissions (
  code VARCHAR(60) PRIMARY KEY,
  label VARCHAR(160) NOT NULL,
  grp VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS roles (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(300) NULL,
  is_system TINYINT(1) NOT NULL DEFAULT 0,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  is_admin TINYINT(1) NOT NULL DEFAULT 0,
  UNIQUE KEY uq_role_name (clan_id, name),
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS role_permissions (
  role_id INT UNSIGNED NOT NULL,
  permission_code VARCHAR(60) NOT NULL,
  PRIMARY KEY (role_id, permission_code),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_code) REFERENCES permissions(code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_roles (
  user_id INT UNSIGNED NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_permissions (
  user_id INT UNSIGNED NOT NULL,
  permission_code VARCHAR(60) NOT NULL,
  PRIMARY KEY (user_id, permission_code),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_code) REFERENCES permissions(code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO permissions (code, label, grp) VALUES
  ('tree.view', 'View the family tree', 'Family'),
  ('people.view', 'View the people list (names only)', 'Family'),
  ('people.view_details', 'View full person details (dates, places, biography)', 'Family'),
  ('people.create', 'Add people', 'Family'),
  ('people.edit', 'Edit people', 'Family'),
  ('people.disable', 'Disable / restore people (and see disabled people)', 'Family'),
  ('relationships.manage', 'Link people (parent / spouse)', 'Family'),
  ('stories.view', 'View stories', 'Stories'),
  ('stories.manage', 'Add, edit and delete stories', 'Stories'),
  ('events.view', 'View events', 'Events'),
  ('events.manage', 'Add, edit and delete events', 'Events'),
  ('places.view', 'View places', 'Places'),
  ('places.manage', 'Add, edit and delete places', 'Places'),
  ('announcements.view_members', 'View members-only announcements', 'Announcements'),
  ('announcements.manage', 'Publish, edit and delete announcements', 'Announcements'),
  ('gallery.view', 'View the gallery', 'Archive'),
  ('documents.view', 'View documents', 'Archive'),
  ('content.edit', 'Edit History / Iziduko / Culture pages', 'Site'),
  ('users.approve', 'Approve or reject registrations', 'Membership');

INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Administrator', 'Full access. Assigned automatically when a user is made admin.', 1, 0, 1 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Member', 'Default for approved users: browse names, the tree, stories, events and places.', 1, 1, 0 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Family Member', 'Verified family: also sees full person details, gallery and documents.', 0, 0, 0 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Communications Officer', 'Adds and edits events and announcements.', 0, 0, 0 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Content Editor', 'Manages stories, places and the History / Iziduko / Culture pages.', 0, 0, 0 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Family Historian', 'Adds and edits people and links them in the tree.', 0, 0, 0 FROM clans c;
INSERT IGNORE INTO roles (clan_id, name, description, is_system, is_default, is_admin)
SELECT c.id, 'Membership Officer', 'Approves or rejects registrations.', 0, 0, 0 FROM clans c;

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p WHERE r.name = 'Administrator';

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Member' AND p.code IN ('tree.view','people.view','stories.view','events.view','places.view','announcements.view_members');

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Family Member' AND p.code IN ('tree.view','people.view','people.view_details','stories.view','events.view','places.view','announcements.view_members','gallery.view','documents.view');

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Communications Officer' AND p.code IN ('events.view','events.manage','announcements.view_members','announcements.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Content Editor' AND p.code IN ('stories.view','stories.manage','places.view','places.manage','content.edit');

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Family Historian' AND p.code IN ('tree.view','people.view','people.view_details','people.create','people.edit','relationships.manage');

INSERT IGNORE INTO role_permissions (role_id, permission_code)
SELECT r.id, p.code FROM roles r JOIN permissions p
WHERE r.name = 'Membership Officer' AND p.code IN ('users.approve');

-- Existing users: admins get the Administrator role, other approved users the default Member role.
INSERT IGNORE INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u JOIN roles r ON r.clan_id = u.clan_id AND r.is_admin = 1
WHERE u.status = 'approved' AND u.role = 'admin';

INSERT IGNORE INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u JOIN roles r ON r.clan_id = u.clan_id AND r.is_default = 1
WHERE u.status = 'approved' AND u.role = 'member';
