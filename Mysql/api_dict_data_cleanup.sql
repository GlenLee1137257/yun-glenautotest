-- ============================================
-- 清理第一版错误导入的接口自动化字典数据
-- 数据库: glen_dict
-- 说明: 删除第一版导入的错误的字典数据（值是小写，不符合后端枚举）
-- ============================================

USE glen_dict;

-- 删除 api_relation_from 分类中 value 为小写的记录
DELETE FROM `sys_dict` 
WHERE category = 'api_relation_from' 
  AND value IN ('request_header', 'request_body', 'response_header', 'response_body', 'response_code');

-- 删除 api_relation_type 分类中 value 为小写的记录
DELETE FROM `sys_dict` 
WHERE category = 'api_relation_type' 
  AND value IN ('jsonpath', 'regexp');

-- 删除 api_assertion_from 分类中 value 为小写的记录
DELETE FROM `sys_dict` 
WHERE category = 'api_assertion_from' 
  AND value IN ('response_code', 'response_header', 'response_body');

-- 删除 api_assertion_type 分类中 value 为小写的记录
DELETE FROM `sys_dict` 
WHERE category = 'api_assertion_type' 
  AND value IN ('jsonpath', 'regexp');

-- 删除 api_assertion_action 分类中 value 为小写或不支持的记录
DELETE FROM `sys_dict` 
WHERE category = 'api_assertion_action' 
  AND value IN ('equal', 'not_equal', 'contain', 'not_contain', 'greater_than', 'less_than', 'exists', 'not_exists');

-- 验证清理结果
SELECT '清理完成，接口自动化字典数据应已清空' AS '';

SELECT category, COUNT(*) AS count 
FROM sys_dict 
WHERE category IN ('api_relation_from', 'api_relation_type', 'api_assertion_from', 'api_assertion_type', 'api_assertion_action')
GROUP BY category;
