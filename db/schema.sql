-- Heritage Platform Lean schema (MySQL 5.7+/MariaDB 10.3+). Import via phpMyAdmin.
-- Every business table carries clan_id so the platform can host many clans later.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS clans (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(60) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  email VARCHAR(190) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(160) NOT NULL,
  relationship_note VARCHAR(500) NULL,
  role ENUM('member','admin') NOT NULL DEFAULT 'member',
  status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  approved_at DATETIME NULL,
  UNIQUE KEY uq_user_email (clan_id, email),
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sessions (
  token_hash CHAR(64) PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  csrf_token CHAR(64) NOT NULL,
  expires_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS login_attempts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ip VARCHAR(45) NOT NULL,
  attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ip_time (ip, attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS people (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  given_name VARCHAR(120) NOT NULL,
  family_name VARCHAR(120) NULL,
  clan_name VARCHAR(120) NULL,
  gender ENUM('male','female','other') NULL,
  birth_date DATE NULL,
  death_date DATE NULL,
  is_living TINYINT(1) NOT NULL DEFAULT 0,
  birth_place VARCHAR(190) NULL,
  bio TEXT NULL,
  removed TINYINT(1) NOT NULL DEFAULT 0,
  removed_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS relationships (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  person_id INT UNSIGNED NOT NULL,
  related_person_id INT UNSIGNED NOT NULL,
  type ENUM('parent_of','spouse_of') NOT NULL,
  disabled TINYINT(1) NOT NULL DEFAULT 0,
  FOREIGN KEY (clan_id) REFERENCES clans(id),
  FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE CASCADE,
  FOREIGN KEY (related_person_id) REFERENCES people(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS announcements (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  title VARCHAR(190) NOT NULL,
  body TEXT NOT NULL,
  is_public TINYINT(1) NOT NULL DEFAULT 1,
  published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  title VARCHAR(190) NOT NULL,
  body TEXT NOT NULL,
  narrator VARCHAR(160) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS events (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  title VARCHAR(190) NOT NULL,
  kind VARCHAR(60) NULL,
  event_date DATE NULL,
  location VARCHAR(190) NULL,
  details TEXT NULL,
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS places (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  name VARCHAR(190) NOT NULL,
  kind ENUM('homestead','grave','origin','other') NOT NULL DEFAULT 'other',
  description TEXT NULL,
  latitude DECIMAL(9,6) NULL,
  longitude DECIMAL(9,6) NULL,
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS content_pages (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clan_id INT UNSIGNED NOT NULL,
  slug VARCHAR(60) NOT NULL,
  title VARCHAR(190) NOT NULL,
  body MEDIUMTEXT NOT NULL,
  UNIQUE KEY uq_page (clan_id, slug),
  FOREIGN KEY (clan_id) REFERENCES clans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed ------------------------------------------------------------------
INSERT IGNORE INTO clans (id, slug, name) VALUES (1, 'sokhulu', 'Sokhulu');

INSERT INTO announcements (clan_id, title, body, is_public) VALUES
 (1, 'Welcome to the Sokhulu heritage site', 'This is our home for documenting the history, people and traditions of the Sokhulu clan. Register to join the family space.', 1);

INSERT INTO people (id, clan_id, given_name, family_name, clan_name, gender, birth_date, death_date, is_living, bio) VALUES
 (1, 1, 'Sample Ancestor', 'Sokhulu', 'Sokhulu', 'male', '1890-01-01', '1960-01-01', 0, 'Placeholder - replace with real family data.'),
 (2, 1, 'Sample Spouse', 'Sokhulu', NULL, 'female', '1895-01-01', '1965-01-01', 0, 'Placeholder.'),
 (3, 1, 'Sample Child', 'Sokhulu', 'Sokhulu', 'male', '1920-01-01', '1990-01-01', 0, 'Placeholder.');

INSERT INTO relationships (clan_id, person_id, related_person_id, type) VALUES
 (1, 1, 2, 'spouse_of'),
 (1, 1, 3, 'parent_of'),
 (1, 2, 3, 'parent_of');

INSERT INTO content_pages (clan_id, slug, title, body) VALUES
 (1, 'history', 'Our History', 'Write the Sokhulu origin story and lineage here.'),
 (1, 'iziduko', 'Iziduko (Clan Praises)', 'Add the clan praise names and their meanings here.'),
 (1, 'culture', 'Culture & Customs', 'Document ceremonies such as umembeso, imbeleko and ukubuyisa here.');

-- Create the first admin: register on the site, then run in phpMyAdmin:
--   UPDATE users SET role='admin', status='approved' WHERE email='you@example.com';

-- RBAC (roles/permissions) lives in db/migrations/004_rbac.sql. For a fresh install run this file, then 001..006 in order (006 = story articles/evidence).

