-- 补充压测相关字典数据
-- 执行方式: docker exec -i glen-mysql mysql -uroot -pglen123456 glen_dict < sql/add_stress_dict_data.sql

-- 压测来源类型
INSERT INTO `sys_dict` (`id`, `category`, `category_name`, `name`, `value`, `extend`, `remark`, `gmt_create`, `gmt_modified`) VALUES
(200, 'stress_source_type', '压测来源类型', '简单压测', 'SIMPLE', NULL, 'HTTP接口简单压测，支持GET/POST等常见请求方式', NOW(), NOW()),
(201, 'stress_source_type', '压测来源类型', 'JMX脚本压测', 'JMX', NULL, '使用JMeter JMX脚本进行压测，支持复杂场景', NOW(), NOW());

-- 压测断言动作
INSERT INTO `sys_dict` (`id`, `category`, `category_name`, `name`, `value`, `extend`, `remark`, `gmt_create`, `gmt_modified`) VALUES
(210, 'stress_assert_action', '压测断言动作', '等于', 'EQUAL', NULL, '断言实际值等于预期值', NOW(), NOW()),
(211, 'stress_assert_action', '压测断言动作', '不等于', 'NOT_EQUAL', NULL, '断言实际值不等于预期值', NOW(), NOW()),
(212, 'stress_assert_action', '压测断言动作', '包含', 'CONTAIN', NULL, '断言实际值包含预期值', NOW(), NOW()),
(213, 'stress_assert_action', '压测断言动作', '不包含', 'NOT_CONTAIN', NULL, '断言实际值不包含预期值', NOW(), NOW()),
(214, 'stress_assert_action', '压测断言动作', '大于', 'GREAT_THEN', NULL, '断言实际值大于预期值（数值比较）', NOW(), NOW()),
(215, 'stress_assert_action', '压测断言动作', '小于', 'LESS_THEN', NULL, '断言实际值小于预期值（数值比较）', NOW(), NOW());

-- 压测断言来源
INSERT INTO `sys_dict` (`id`, `category`, `category_name`, `name`, `value`, `extend`, `remark`, `gmt_create`, `gmt_modified`) VALUES
(220, 'stress_assert_from', '压测断言来源', '响应状态码', 'RESPONSE_CODE', NULL, '对响应状态码进行断言', NOW(), NOW()),
(221, 'stress_assert_from', '压测断言来源', '响应头', 'RESPONSE_HEADER', NULL, '对响应头进行断言', NOW(), NOW()),
(222, 'stress_assert_from', '压测断言来源', '响应体', 'RESPONSE_DATA', NULL, '对响应体进行断言', NOW(), NOW()),
(223, 'stress_assert_from', '压测断言来源', '响应时间', 'RESPONSE_TIME', NULL, '对响应时间进行断言（毫秒）', NOW(), NOW());
