/*
 数据库性能优化脚本
 
 优化目标：
 1. 为常查字段添加索引
 2. 优化关联查询性能
 3. 提升分页查询效率
 4. 避免N+1查询问题
 
 Date: 27/01/2026
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- glen_engine 数据库优化
-- ========================================
USE glen_engine;

-- 1. environment 表优化
-- 添加 project_id 索引，优化按项目查询环境的性能
ALTER TABLE `environment` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引，优化按项目查询环境';

-- 添加组合索引，优化按项目和域名查询
ALTER TABLE `environment` 
ADD INDEX `idx_project_domain`(`project_id` ASC, `domain` ASC) USING BTREE COMMENT '项目-域名组合索引';

-- 2. project 表优化
-- 添加 project_admin 索引，优化查询管理员负责的项目
ALTER TABLE `project` 
ADD INDEX `idx_project_admin`(`project_admin` ASC) USING BTREE COMMENT '项目管理员索引';

-- 添加创建时间索引，优化按时间排序查询
ALTER TABLE `project` 
ADD INDEX `idx_gmt_create`(`gmt_create` DESC) USING BTREE COMMENT '创建时间索引';

-- 3. plan_job 表优化
-- 添加 project_id 索引
ALTER TABLE `plan_job` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 case_id 索引
ALTER TABLE `plan_job` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加组合索引，优化按项目和测试类型查询
ALTER TABLE `plan_job` 
ADD INDEX `idx_project_type`(`project_id` ASC, `test_type` ASC) USING BTREE COMMENT '项目-测试类型组合索引';

-- 添加启用状态索引，优化查询启用的任务
ALTER TABLE `plan_job` 
ADD INDEX `idx_is_disabled`(`is_disabled` ASC) USING BTREE COMMENT '启用状态索引';

-- 4. plan_job_log 表优化
-- 添加创建时间索引，优化日志查询
ALTER TABLE `plan_job_log` 
ADD INDEX `idx_gmt_create`(`gmt_create` DESC) USING BTREE COMMENT '创建时间索引';

-- 5. stress_case_module 表优化
-- 添加 project_id 索引
ALTER TABLE `stress_case_module` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';


-- ========================================
-- glen_api 数据库优化
-- ========================================
USE glen_api;

-- 1. api 表优化
-- 添加 project_id 索引
ALTER TABLE `api` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 module_id 索引
ALTER TABLE `api` 
ADD INDEX `idx_module_id`(`module_id` ASC) USING BTREE COMMENT '模块ID索引';

-- 添加 environment_id 索引
ALTER TABLE `api` 
ADD INDEX `idx_environment_id`(`environment_id` ASC) USING BTREE COMMENT '环境ID索引';

-- 添加组合索引，优化按项目和模块查询
ALTER TABLE `api` 
ADD INDEX `idx_project_module`(`project_id` ASC, `module_id` ASC) USING BTREE COMMENT '项目-模块组合索引';

-- 添加等级索引，优化按优先级查询
ALTER TABLE `api` 
ADD INDEX `idx_level`(`level` ASC) USING BTREE COMMENT '执行等级索引';

-- 2. api_case 表优化
-- 添加 project_id 索引
ALTER TABLE `api_case` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 module_id 索引
ALTER TABLE `api_case` 
ADD INDEX `idx_module_id`(`module_id` ASC) USING BTREE COMMENT '模块ID索引';

-- 添加组合索引
ALTER TABLE `api_case` 
ADD INDEX `idx_project_module`(`project_id` ASC, `module_id` ASC) USING BTREE COMMENT '项目-模块组合索引';

-- 添加等级索引
ALTER TABLE `api_case` 
ADD INDEX `idx_level`(`level` ASC) USING BTREE COMMENT '执行等级索引';

-- 3. api_case_step 表优化
-- 添加 project_id 索引
ALTER TABLE `api_case_step` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 case_id 索引
ALTER TABLE `api_case_step` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加 environment_id 索引
ALTER TABLE `api_case_step` 
ADD INDEX `idx_environment_id`(`environment_id` ASC) USING BTREE COMMENT '环境ID索引';

-- 添加组合索引，优化按用例和序号查询
ALTER TABLE `api_case_step` 
ADD INDEX `idx_case_num`(`case_id` ASC, `num` ASC) USING BTREE COMMENT '用例-序号组合索引';

-- 4. api_case_module 表优化
-- 添加 project_id 索引
ALTER TABLE `api_case_module` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 5. api_module 表优化
-- 添加 project_id 索引
ALTER TABLE `api_module` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';


-- ========================================
-- glen_ui 数据库优化
-- ========================================
USE glen_ui;

-- 1. ui_case 表优化（已有 idx_project_id 索引）
-- 添加 module_id 索引
ALTER TABLE `ui_case` 
ADD INDEX `idx_module_id`(`module_id` ASC) USING BTREE COMMENT '模块ID索引';

-- 添加组合索引
ALTER TABLE `ui_case` 
ADD INDEX `idx_project_module`(`project_id` ASC, `module_id` ASC) USING BTREE COMMENT '项目-模块组合索引';

-- 添加等级索引
ALTER TABLE `ui_case` 
ADD INDEX `idx_level`(`level` ASC) USING BTREE COMMENT '执行等级索引';

-- 添加浏览器索引
ALTER TABLE `ui_case` 
ADD INDEX `idx_browser`(`browser` ASC) USING BTREE COMMENT '浏览器索引';

-- 2. ui_case_module 表优化
-- 添加 project_id 索引
ALTER TABLE `ui_case_module` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 3. ui_case_step 表优化
-- 添加 project_id 索引
ALTER TABLE `ui_case_step` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 case_id 索引
ALTER TABLE `ui_case_step` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加组合索引，优化按用例和序号查询
ALTER TABLE `ui_case_step` 
ADD INDEX `idx_case_num`(`case_id` ASC, `num` ASC) USING BTREE COMMENT '用例-序号组合索引';

-- 添加元素ID索引，优化元素库关联查询
CREATE INDEX IF NOT EXISTS `idx_element_id` 
ON `ui_case_step`(`element_id` ASC)
COMMENT '元素ID索引';

CREATE INDEX IF NOT EXISTS `idx_target_element_id` 
ON `ui_case_step`(`target_element_id` ASC)
COMMENT '目标元素ID索引';

-- 4. report_detail_ui 表优化
-- 添加 report_id 索引
ALTER TABLE `report_detail_ui` 
ADD INDEX `idx_report_id`(`report_id` ASC) USING BTREE COMMENT '报告ID索引';

-- 添加 case_id 索引
ALTER TABLE `report_detail_ui` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加执行状态索引
ALTER TABLE `report_detail_ui` 
ADD INDEX `idx_execute_state`(`execute_state` ASC) USING BTREE COMMENT '执行状态索引';

-- 5. sys_dict 表优化（已有 idx 为 dict_key 的索引）
-- 添加分类索引
ALTER TABLE `sys_dict` 
ADD INDEX `idx_category`(`category` ASC) USING BTREE COMMENT '分类索引';

-- 添加组合索引，优化按分类和名称查询
ALTER TABLE `sys_dict` 
ADD INDEX `idx_category_name`(`category` ASC, `name` ASC) USING BTREE COMMENT '分类-名称组合索引';


-- ========================================
-- glen_stress 数据库优化
-- ========================================
USE glen_stress;

-- 1. report 表优化
-- 添加 project_id 索引
ALTER TABLE `report` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 case_id 索引
ALTER TABLE `report` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加 type 索引
ALTER TABLE `report` 
ADD INDEX `idx_type`(`type` ASC) USING BTREE COMMENT '报告类型索引';

-- 添加组合索引
ALTER TABLE `report` 
ADD INDEX `idx_project_type`(`project_id` ASC, `type` ASC) USING BTREE COMMENT '项目-类型组合索引';

-- 添加执行状态索引
ALTER TABLE `report` 
ADD INDEX `idx_execute_state`(`execute_state` ASC) USING BTREE COMMENT '执行状态索引';

-- 添加创建时间索引，优化按时间排序
ALTER TABLE `report` 
ADD INDEX `idx_gmt_create`(`gmt_create` DESC) USING BTREE COMMENT '创建时间索引';

-- 2. report_detail_api 表优化
-- 添加 report_id 索引
ALTER TABLE `report_detail_api` 
ADD INDEX `idx_report_id`(`report_id` ASC) USING BTREE COMMENT '报告ID索引';

-- 添加 case_id 索引
ALTER TABLE `report_detail_api` 
ADD INDEX `idx_case_id`(`case_id` ASC) USING BTREE COMMENT '用例ID索引';

-- 添加 environment_id 索引
ALTER TABLE `report_detail_api` 
ADD INDEX `idx_environment_id`(`environment_id` ASC) USING BTREE COMMENT '环境ID索引';

-- 添加执行状态索引
ALTER TABLE `report_detail_api` 
ADD INDEX `idx_execute_state`(`execute_state` ASC) USING BTREE COMMENT '执行状态索引';

-- 添加断言状态索引
ALTER TABLE `report_detail_api` 
ADD INDEX `idx_assertion_state`(`assertion_state` ASC) USING BTREE COMMENT '断言状态索引';

-- 3. report_detail_stress 表优化
-- 添加 report_id 索引
ALTER TABLE `report_detail_stress` 
ADD INDEX `idx_report_id`(`report_id` ASC) USING BTREE COMMENT '报告ID索引';

-- 添加采样次数索引
ALTER TABLE `report_detail_stress` 
ADD INDEX `idx_sampler_count`(`sampler_count` ASC) USING BTREE COMMENT '采样次数索引';

-- 添加响应码索引
ALTER TABLE `report_detail_stress` 
ADD INDEX `idx_response_code`(`response_code` ASC) USING BTREE COMMENT '响应码索引';

-- 4. stress_case 表优化
-- 添加 project_id 索引
ALTER TABLE `stress_case` 
ADD INDEX `idx_project_id`(`project_id` ASC) USING BTREE COMMENT '项目ID索引';

-- 添加 module_id 索引
ALTER TABLE `stress_case` 
ADD INDEX `idx_module_id`(`module_id` ASC) USING BTREE COMMENT '模块ID索引';

-- 添加 environment_id 索引
ALTER TABLE `stress_case` 
ADD INDEX `idx_environment_id`(`environment_id` ASC) USING BTREE COMMENT '环境ID索引';

-- 添加组合索引
ALTER TABLE `stress_case` 
ADD INDEX `idx_project_module`(`project_id` ASC, `module_id` ASC) USING BTREE COMMENT '项目-模块组合索引';

-- 添加压测类型索引
ALTER TABLE `stress_case` 
ADD INDEX `idx_stress_source_type`(`stress_source_type` ASC) USING BTREE COMMENT '压测类型索引';


-- ========================================
-- glen_account 数据库优化
-- ========================================
USE glen_account;

-- 1. account 表优化
-- 添加 username 唯一索引
ALTER TABLE `account` 
ADD UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE COMMENT '账号唯一索引';

-- 添加启用状态索引
ALTER TABLE `account` 
ADD INDEX `idx_is_disabled`(`is_disabled` ASC) USING BTREE COMMENT '启用状态索引';

-- 2. account_role 表优化
-- 添加 role_id 索引
ALTER TABLE `account_role` 
ADD INDEX `idx_role_id`(`role_id` ASC) USING BTREE COMMENT '角色ID索引';

-- 添加 account_id 索引
ALTER TABLE `account_role` 
ADD INDEX `idx_account_id`(`account_id` ASC) USING BTREE COMMENT '账号ID索引';

-- 添加联合唯一索引，防止重复关联
ALTER TABLE `account_role` 
ADD UNIQUE INDEX `idx_account_role`(`account_id` ASC, `role_id` ASC) USING BTREE COMMENT '账号-角色唯一索引';

-- 3. role 表优化
-- 添加 code 唯一索引
ALTER TABLE `role` 
ADD UNIQUE INDEX `idx_code`(`code` ASC) USING BTREE COMMENT '角色编码唯一索引';

-- 4. role_permission 表优化
-- 添加 role_id 索引
ALTER TABLE `role_permission` 
ADD INDEX `idx_role_id`(`role_id` ASC) USING BTREE COMMENT '角色ID索引';

-- 添加 permission_id 索引
ALTER TABLE `role_permission` 
ADD INDEX `idx_permission_id`(`permission_id` ASC) USING BTREE COMMENT '权限ID索引';

-- 添加联合唯一索引，防止重复关联
ALTER TABLE `role_permission` 
ADD UNIQUE INDEX `idx_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE COMMENT '角色-权限唯一索引';

-- 5. permission 表优化
-- 添加 code 唯一索引
ALTER TABLE `permission` 
ADD UNIQUE INDEX `idx_code`(`code` ASC) USING BTREE COMMENT '权限编码唯一索引';


-- ========================================
-- glen_dict 数据库优化
-- ========================================
USE glen_dict;

-- sys_dict 表优化（如果在单独的数据库中）
-- 添加分类索引
ALTER TABLE `sys_dict` 
ADD INDEX `idx_category`(`category` ASC) USING BTREE COMMENT '分类索引';

-- 添加组合索引
ALTER TABLE `sys_dict` 
ADD INDEX `idx_category_name`(`category` ASC, `name` ASC) USING BTREE COMMENT '分类-名称组合索引';

-- 添加创建时间索引
ALTER TABLE `sys_dict` 
ADD INDEX `idx_gmt_create`(`gmt_create` DESC) USING BTREE COMMENT '创建时间索引';


SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- 性能优化建议
-- ========================================

/*
索引优化说明：

1. 单列索引：
   - 为所有外键字段添加索引（project_id, module_id, environment_id, case_id 等）
   - 为常用查询条件字段添加索引（type, level, execute_state 等）
   - 为时间字段添加索引，支持按时间排序查询

2. 组合索引：
   - 项目-模块组合索引：优化按项目查询模块下的数据
   - 用例-序号组合索引：优化步骤的顺序查询
   - 账号-角色、角色-权限组合唯一索引：防止重复关联，提升查询性能

3. 唯一索引：
   - username 唯一索引：确保账号唯一性
   - code 唯一索引：确保角色和权限编码唯一性
   - 关联表组合唯一索引：防止重复关联

查询优化建议：

1. 使用分页查询：
   SELECT * FROM table_name 
   WHERE project_id = ? 
   ORDER BY gmt_create DESC 
   LIMIT ?, ?;

2. 避免 N+1 查询：
   - 使用 JOIN 一次性获取关联数据
   - 使用 IN 查询批量获取关联数据
   - 示例：
     SELECT c.*, m.name as module_name 
     FROM api_case c 
     LEFT JOIN api_case_module m ON c.module_id = m.id 
     WHERE c.project_id = ?;

3. 缓存优化：
   - 缓存项目配置（project 表）
   - 缓存环境配置（environment 表）
   - 缓存字典数据（sys_dict 表）
   - 缓存用户权限信息（account, role, permission 关联数据）

4. 查询优化技巧：
   - 只查询需要的字段，避免 SELECT *
   - 合理使用 EXPLAIN 分析查询计划
   - 避免在 WHERE 子句中使用函数
   - 使用覆盖索引减少回表查询

5. 大表优化：
   - report_detail_api、report_detail_ui、report_detail_stress 等明细表
   - 建议定期归档历史数据
   - 考虑按月分表存储
*/
