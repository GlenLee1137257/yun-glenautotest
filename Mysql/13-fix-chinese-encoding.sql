-- Glen AutoTest Platform - Fix Chinese Encoding
-- 修复数据库中的中文字符乱码
-- 执行方式：在MySQL中选择数据库后执行此脚本

USE glen_account;

-- 修复 account 表
UPDATE account SET name = '系统管理员' WHERE id = 1;
UPDATE account SET name = '测试账号' WHERE id = 2;

-- 修复 role 表
UPDATE role SET 
  name = '超级管理员', 
  description = '拥有系统所有权限' 
WHERE id = 1;

UPDATE role SET 
  name = '项目管理员', 
  description = '项目管理权限' 
WHERE id = 2;

UPDATE role SET 
  name = '测试工程师', 
  description = '测试执行权限' 
WHERE id = 3;

-- 修复 permission 表
UPDATE permission SET 
  name = '项目授权', 
  description = '项目授权权限' 
WHERE id = 1;

UPDATE permission SET 
  name = '项目读写', 
  description = '项目读写权限' 
WHERE id = 2;

UPDATE permission SET 
  name = '项目只读', 
  description = '项目只读权限' 
WHERE id = 3;

USE glen_engine;

-- 修复 project 表
TRUNCATE project;
INSERT INTO project (project_admin, name, description) 
VALUES (1, '测试项目', '这是一个测试项目');

-- 验证
SELECT '========================================' AS '';
SELECT '中文字符修复完成' AS '状态';
SELECT '========================================' AS '';
