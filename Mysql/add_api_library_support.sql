-- =============================================
-- 为接口自动化用例步骤增加接口库支持
-- 日期: 2026-01-28
-- 说明: 参考UI自动化元素库的设计模式
-- =============================================

USE glen_api;

-- 为 api_case_step 表增加接口库相关字段
ALTER TABLE `api_case_step`
ADD COLUMN `api_id` bigint NULL DEFAULT NULL COMMENT '关联的接口ID（来自接口管理）' 
AFTER `case_id`;

ALTER TABLE `api_case_step`
ADD COLUMN `use_api_library` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '是否使用接口库（0=手动配置，1=从接口库选择）'
AFTER `api_id`;

-- 为已存在的步骤设置默认值（手动配置）
UPDATE `api_case_step` SET `use_api_library` = 0 WHERE `use_api_library` IS NULL;

-- 添加索引，提升查询性能
ALTER TABLE `api_case_step` ADD INDEX `idx_api_id` (`api_id`);

-- 显示表结构
DESC `api_case_step`;

-- 提示信息
SELECT '接口库支持字段添加完成！' AS message;
SELECT '- api_id: 关联的接口ID' AS field_info;
SELECT '- use_api_library: 是否使用接口库 (0=手动配置, 1=从接口库选择)' AS field_info;
