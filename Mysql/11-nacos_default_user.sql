-- Create default Nacos user
USE nacos_config;

-- Password is 'nacos' encoded with BCrypt
-- The password hash for 'nacos' is: $2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu
INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', 1);

-- Assign role to user
INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
