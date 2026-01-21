-- 修复 UI 用例步骤的 project_id 不一致问题
-- 问题：ui_case_step 表中的 project_id 与其所属用例的 project_id 不一致
-- 解决：将步骤的 project_id 更新为其所属用例的 project_id

USE glen_ui;

-- 1. 先查看有问题的数据
SELECT 
    s.id AS step_id,
    s.project_id AS step_project_id,
    s.case_id,
    c.project_id AS case_project_id,
    s.name AS step_name
FROM ui_case_step s
LEFT JOIN ui_case c ON s.case_id = c.id
WHERE s.project_id != c.project_id
ORDER BY s.case_id, s.num;

-- 2. 修复数据：将步骤的 project_id 更新为其所属用例的 project_id
UPDATE ui_case_step s
INNER JOIN ui_case c ON s.case_id = c.id
SET s.project_id = c.project_id
WHERE s.project_id != c.project_id;

-- 3. 验证修复结果（应该返回 0 条记录）
SELECT 
    s.id AS step_id,
    s.project_id AS step_project_id,
    s.case_id,
    c.project_id AS case_project_id,
    s.name AS step_name
FROM ui_case_step s
LEFT JOIN ui_case c ON s.case_id = c.id
WHERE s.project_id != c.project_id
ORDER BY s.case_id, s.num;

-- 4. 清理 num 重复的问题（可选）
-- 如果同一个用例下有多个步骤的 num 相同，需要重新排序
-- 注意：这个操作会重新分配所有步骤的 num，请谨慎执行！

-- 查看 num 重复的情况
SELECT case_id, num, COUNT(*) as count
FROM ui_case_step
GROUP BY case_id, num
HAVING COUNT(*) > 1;

-- 如果需要修复 num 重复问题，可以手动执行以下步骤：
-- 1) 先备份数据
-- 2) 对每个 case_id，重新分配 num（从 0 开始递增）
-- 由于 MySQL 不支持窗口函数的 UPDATE，需要使用临时表或存储过程
-- 这里提供一个手动修复的示例（需要根据实际情况调整）

-- 示例：修复 case_id=19 的步骤编号
SET @row_number = -1;
UPDATE ui_case_step
SET num = (@row_number := @row_number + 1)
WHERE case_id = 19
ORDER BY id;
