-- 修复 ui_case_step 表的 num 字段，从 0 开始改为从 1 开始
-- 执行时间：2026-01-21

USE glen_ui;

-- 1. 将所有现有步骤的 num 值 +1（从 0 开始改为从 1 开始）
UPDATE ui_case_step 
SET num = num + 1 
WHERE num >= 0;

-- 2. 修改表结构，将 num 字段的默认值从 0 改为 1
ALTER TABLE ui_case_step 
MODIFY COLUMN `num` bigint UNSIGNED NULL DEFAULT 1 COMMENT '序号';

-- 3. 验证更新结果
SELECT 
    case_id,
    COUNT(*) as step_count,
    MIN(num) as min_num,
    MAX(num) as max_num
FROM ui_case_step
GROUP BY case_id
ORDER BY case_id;
