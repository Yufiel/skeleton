\set ON_ERROR_STOP true

START TRANSACTION;

-- Users // admin/admin
INSERT INTO users.users (id, username, password, email, first_name, last_name, enabled) VALUES (1, 'admin', '{bcrypt,12}$2y$12$OHYggULc4izO6.HKUA4Z6O7sUailmbOu.BA7jNMc4KBSFdgI.PxnK', 'admin@admin.com', 'first name', 'last name', true);

-- Roles
INSERT INTO users.roles (id, role_name) VALUES (1, 'ADMIN');
INSERT INTO users.roles (id, role_name) VALUES (2, 'CUSTOMER');

-- User to role
INSERT INTO users.user_role (user_id, role_id) VALUES (1, 1);

-- Set sequences values to the max id
SELECT setval('users.user_id_seq', (SELECT MAX(id) FROM users.users));
SELECT setval('users.role_id_seq', (SELECT MAX(id) FROM users.roles));

COMMIT;
