-- User management (approve/reject registrations, roles, permissions, make/remove admin) is admin-only.
-- Remove the now-unused users.approve permission and the Membership Officer role.
DELETE FROM user_permissions WHERE permission_code = 'users.approve';
DELETE FROM role_permissions WHERE permission_code = 'users.approve';
DELETE ur FROM user_roles ur JOIN roles r ON r.id = ur.role_id WHERE r.name = 'Membership Officer';
DELETE FROM roles WHERE name = 'Membership Officer';
DELETE FROM permissions WHERE code = 'users.approve';
