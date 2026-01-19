-- ============================================
-- 接口自动化字典数据补充（修正版）
-- 数据库: glen_dict
-- 表: sys_dict
-- 说明: 字典值必须与后端枚举值完全匹配（大写+下划线）
-- ============================================

USE glen_dict;

-- ----------------------------
-- 接口自动化 - 关联来源 (api_relation_from)
-- 后端枚举: ApiRelateFieldFromEnum
-- ----------------------------
INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_from', '关联来源', '请求头', 'REQUEST_HEADER', NULL, '从请求头中提取数据');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_from', '关联来源', '请求体', 'REQUEST_BODY', NULL, '从请求体中提取数据');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_from', '关联来源', '请求查询参数', 'REQUEST_QUERY', NULL, '从请求查询参数中提取数据');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_from', '关联来源', '响应头', 'RESPONSE_HEADER', NULL, '从响应头中提取数据');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_from', '关联来源', '响应体', 'RESPONSE_DATA', NULL, '从响应体中提取数据');

-- ----------------------------
-- 接口自动化 - 关联类型 (api_relation_type)
-- 后端枚举: ApiRelateTypeEnum
-- ----------------------------
INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_type', '关联类型', 'JSON路径', 'JSONPATH', NULL, '使用JSONPath表达式提取数据，例如：$.data.id');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_relation_type', '关联类型', '正则表达式', 'REGEXP', NULL, '使用正则表达式提取数据');

-- ----------------------------
-- 接口自动化 - 断言来源 (api_assertion_from)
-- 后端枚举: ApiAssertFieldFromEnum
-- ----------------------------
INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_from', '断言来源', '响应状态码', 'RESPONSE_CODE', NULL, '对响应状态码进行断言');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_from', '断言来源', '响应头', 'RESPONSE_HEADER', NULL, '对响应头进行断言');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_from', '断言来源', '响应体', 'RESPONSE_DATA', NULL, '对响应体进行断言');

-- ----------------------------
-- 接口自动化 - 断言类型 (api_assertion_type)
-- 后端枚举: ApiAssertTypeEnum
-- ----------------------------
INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_type', '断言类型', 'JSON路径', 'JSONPATH', NULL, '使用JSONPath表达式断言，例如：$.data.code');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_type', '断言类型', '正则表达式', 'REGEXP', NULL, '使用正则表达式断言');

-- ----------------------------
-- 接口自动化 - 断言动作 (api_assertion_action)
-- 后端枚举: ApiAssertActionEnum
-- 注意: 后端使用 GREAT_THEN 和 LESS_THEN（不是标准拼写）
-- ----------------------------
INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '等于', 'EQUAL', NULL, '断言实际值等于预期值');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '不等于', 'NOT_EQUAL', NULL, '断言实际值不等于预期值');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '包含', 'CONTAIN', NULL, '断言实际值包含预期值');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '不包含', 'NOT_CONTAIN', NULL, '断言实际值不包含预期值');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '大于', 'GREAT_THEN', NULL, '断言实际值大于预期值（数值比较）');

INSERT INTO `sys_dict` (`category`, `category_name`, `name`, `value`, `extend`, `remark`) 
VALUES ('api_assertion_action', '断言动作', '小于', 'LESS_THEN', NULL, '断言实际值小于预期值（数值比较）');

-- ----------------------------
-- 查询验证
-- ----------------------------
SELECT '=== 关联来源 (api_relation_from) ===' AS '';
SELECT category, category_name, name, value, remark 
FROM sys_dict 
WHERE category = 'api_relation_from'
ORDER BY id;

SELECT '=== 关联类型 (api_relation_type) ===' AS '';
SELECT category, category_name, name, value, remark 
FROM sys_dict 
WHERE category = 'api_relation_type'
ORDER BY id;

SELECT '=== 断言来源 (api_assertion_from) ===' AS '';
SELECT category, category_name, name, value, remark 
FROM sys_dict 
WHERE category = 'api_assertion_from'
ORDER BY id;

SELECT '=== 断言类型 (api_assertion_type) ===' AS '';
SELECT category, category_name, name, value, remark 
FROM sys_dict 
WHERE category = 'api_assertion_type'
ORDER BY id;

SELECT '=== 断言动作 (api_assertion_action) ===' AS '';
SELECT category, category_name, name, value, remark 
FROM sys_dict 
WHERE category = 'api_assertion_action'
ORDER BY id;
