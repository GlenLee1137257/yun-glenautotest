-- 为 ui_case_step 表添加 use_element_library 和 use_target_element_library 字段
-- 用于控制是否使用元素库同步定位信息

USE glen_ui;

-- 添加 use_element_library 字段（主元素）
ALTER TABLE `ui_case_step` 
ADD COLUMN `use_element_library` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '是否使用元素库（0=手动输入，1=从元素库选择）' 
AFTER `element_id`;

-- 添加 use_target_element_library 字段（目标元素）
ALTER TABLE `ui_case_step` 
ADD COLUMN `use_target_element_library` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '目标元素是否使用元素库（0=手动输入，1=从元素库选择）' 
AFTER `target_element_id`;

-- 对于已有数据，如果 element_id 不为空，则设置为使用元素库
UPDATE `ui_case_step` 
SET `use_element_library` = 1 
WHERE `element_id` IS NOT NULL;

UPDATE `ui_case_step` 
SET `use_target_element_library` = 1 
WHERE `target_element_id` IS NOT NULL;

SELECT '字段添加完成' AS result;
