-- Glen AutoTest Platform - Permission Data
-- 权限数据
-- 执行前提：glen_account 数据库已创建
-- 执行方式：在MySQL中选择glen_account数据库后执行此脚本

USE glen_account;

-- ============================================
-- 1. 清空现有权限数据（可选，慎用！）
-- ============================================
-- TRUNCATE TABLE role_permission;
-- TRUNCATE TABLE permission;

-- ============================================
-- 2. 插入权限数据
-- ============================================
INSERT INTO `permission` (`id`, `name`, `code`, `description`, `gmt_create`, `gmt_modified`)
VALUES
  (1, '项目授权', 'PROJECT_AUTH', '项目授权权限', NOW(), NOW()),
  (2, '项目读写', 'PROJECT_READ_WRITE', '项目读写权限', NOW(), NOW()),
  (3, '项目只读', 'PROJECT_READ_ONLY', '项目只读权限', NOW(), NOW())
ON DUPLICATE KEY UPDATE code=code;

-- ============================================
-- 3. 给超级管理员角色分配所有权限
-- ============================================
INSERT INTO `role_permission` (`id`, `role_id`, `permission_id`, `gmt_create`, `gmt_modified`)
SELECT NULL, 1, `id`, NOW(), NOW() FROM `permission`
ON DUPLICATE KEY UPDATE role_id=role_id;

-- ============================================
-- 验证数据
-- ============================================
SELECT '========================================' AS '';
SELECT '权限数据创建完成' AS '状态';
SELECT '========================================' AS '';
SELECT * FROM permission;
SELECT '========================================' AS '';
SELECT * FROM role_permission;
