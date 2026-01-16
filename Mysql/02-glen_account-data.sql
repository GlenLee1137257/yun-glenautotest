-- Glen AutoTest Platform - Initial Admin Account Data
-- 初始管理员账号数据
-- 执行前提：glen_account 数据库已创建
-- 执行方式：在Navicat中选择glen_account数据库后执行此脚本

USE glen_account;

-- ============================================
-- 1. 系统角色数据
-- ============================================
INSERT INTO `role` (`id`, `name`, `description`, `gmt_create`, `gmt_modified`)
VALUES
  (1, '超级管理员', '拥有系统所有权限', NOW(), NOW()),
  (2, '项目管理员', '项目管理权限', NOW(), NOW()),
  (3, '测试工程师', '测试执行权限', NOW(), NOW())
ON DUPLICATE KEY UPDATE name=name;

-- ============================================
-- 2. 管理员账号
-- 默认账号: admin
-- 默认密码: admin123 (BCrypt加密后的值)
-- ============================================
INSERT INTO `account` (`id`, `username`, `password`, `email`, `phone`, `name`, `head_img`, `state`, `gmt_create`, `gmt_modified`)
VALUES
  (1, 'admin', '$2a$10$XKqZJwU8YmVkZhXGfZ5Xj.Xb6h8fV8nZJv5rYkZQ5rH0nH0nH0nH0', 'admin@glenautotest.com', '13800138000', '系统管理员', NULL, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE username=username;

-- 注意：上面的密码哈希值是示例，实际使用时需要用BCrypt加密 'admin123'
-- BCrypt加密示例：在Java中使用 BCryptPasswordEncoder().encode("admin123")

-- ============================================
-- 3. 账号角色关联
-- ============================================
INSERT INTO `account_role` (`id`, `account_id`, `role_id`, `gmt_create`, `gmt_modified`)
VALUES
  (1, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE account_id=account_id;

-- ============================================
-- 4. 权限菜单数据
-- ============================================
INSERT INTO `permission` (`id`, `parent_id`, `name`, `path`, `component`, `icon`, `type`, `sort`, `state`, `gmt_create`, `gmt_modified`)
VALUES
  -- 项目管理
  (1, 0, '项目管理', '/project', 'project/index', 'project', 'menu', 1, 1, NOW(), NOW()),
  (2, 1, '项目列表', '/project/list', 'project/list', NULL, 'menu', 1, 1, NOW(), NOW()),
  (3, 1, '创建项目', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (4, 1, '编辑项目', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (5, 1, '删除项目', NULL, NULL, NULL, 'button', 4, 1, NOW(), NOW()),

  -- 接口自动化
  (10, 0, '接口测试', '/api', 'api/index', 'api', 'menu', 2, 1, NOW(), NOW()),
  (11, 10, '接口列表', '/api/list', 'api/list', NULL, 'menu', 1, 1, NOW(), NOW()),
  (12, 10, '创建接口', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (13, 10, '编辑接口', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (14, 10, '删除接口', NULL, NULL, NULL, 'button', 4, 1, NOW(), NOW()),
  (15, 10, '执行接口', NULL, NULL, NULL, 'button', 5, 1, NOW(), NOW()),

  -- UI自动化
  (20, 0, 'UI测试', '/ui', 'ui/index', 'ui', 'menu', 3, 1, NOW(), NOW()),
  (21, 20, 'UI用例列表', '/ui/list', 'ui/list', NULL, 'menu', 1, 1, NOW(), NOW()),
  (22, 20, '创建UI用例', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (23, 20, '编辑UI用例', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (24, 20, '删除UI用例', NULL, NULL, NULL, 'button', 4, 1, NOW(), NOW()),
  (25, 20, '执行UI用例', NULL, NULL, NULL, 'button', 5, 1, NOW(), NOW()),

  -- 压力测试
  (30, 0, '压力测试', '/stress', 'stress/index', 'stress', 'menu', 4, 1, NOW(), NOW()),
  (31, 30, '压测用例列表', '/stress/list', 'stress/list', NULL, 'menu', 1, 1, NOW(), NOW()),
  (32, 30, '创建压测用例', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (33, 30, '编辑压测用例', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (34, 30, '删除压测用例', NULL, NULL, NULL, 'button', 4, 1, NOW(), NOW()),
  (35, 30, '执行压测', NULL, NULL, NULL, 'button', 5, 1, NOW(), NOW()),

  -- 定时任务
  (40, 0, '定时任务', '/job', 'job/index', 'job', 'menu', 5, 1, NOW(), NOW()),
  (41, 40, '任务列表', '/job/list', 'job/list', NULL, 'menu', 1, 1, NOW(), NOW()),
  (42, 40, '创建任务', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (43, 40, '编辑任务', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (44, 40, '删除任务', NULL, NULL, NULL, 'button', 4, 1, NOW(), NOW()),
  (45, 40, '启用/禁用任务', NULL, NULL, NULL, 'button', 5, 1, NOW(), NOW()),

  -- 系统管理
  (50, 0, '系统管理', '/system', 'system/index', 'system', 'menu', 6, 1, NOW(), NOW()),
  (51, 50, '账号管理', '/system/account', 'system/account', NULL, 'menu', 1, 1, NOW(), NOW()),
  (52, 50, '角色管理', '/system/role', 'system/role', NULL, 'menu', 2, 1, NOW(), NOW()),
  (53, 50, '权限管理', '/system/permission', 'system/permission', NULL, 'menu', 3, 1, NOW(), NOW()),
  (54, 51, '创建账号', NULL, NULL, NULL, 'button', 1, 1, NOW(), NOW()),
  (55, 51, '编辑账号', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (56, 51, '删除账号', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW()),
  (57, 52, '创建角色', NULL, NULL, NULL, 'button', 1, 1, NOW(), NOW()),
  (58, 52, '编辑角色', NULL, NULL, NULL, 'button', 2, 1, NOW(), NOW()),
  (59, 52, '删除角色', NULL, NULL, NULL, 'button', 3, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE name=name;

-- ============================================
-- 5. 角色权限关联（超级管理员拥有所有权限）
-- ============================================
INSERT INTO `role_permission` (`id`, `role_id`, `permission_id`, `gmt_create`, `gmt_modified`)
SELECT NULL, 1, `id`, NOW(), NOW() FROM `permission`
ON DUPLICATE KEY UPDATE role_id=role_id;

-- ============================================
-- 验证数据
-- ============================================
SELECT '========================================' AS '';
SELECT '初始数据创建完成' AS '状态';
SELECT '========================================' AS '';
SELECT COUNT(*) AS '角色数量' FROM `role`;
SELECT COUNT(*) AS '账号数量' FROM `account`;
SELECT COUNT(*) AS '权限数量' FROM `permission`;
SELECT COUNT(*) AS '角色权限数量' FROM `role_permission`;
SELECT '========================================' AS '';
SELECT '默认管理员账号: admin' AS '登录信息';
SELECT '默认管理员密码: admin123' AS '登录信息';
SELECT '========================================' AS '';
