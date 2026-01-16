-- 在 glen_engine 数据库中创建 plan_job 和 plan_job_log 表
-- 使用 Navicat 执行此 SQL

USE glen_engine;

-- 创建 plan_job 表
CREATE TABLE IF NOT EXISTS `plan_job` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint DEFAULT NULL COMMENT 'project id',
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'plan name',
  `case_id` bigint unsigned DEFAULT NULL COMMENT 'case id',
  `test_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'test type [ui api stress]',
  `is_disabled` int DEFAULT '0' COMMENT 'is disabled',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'execute time',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 创建 plan_job_log 表（如果不存在）
CREATE TABLE IF NOT EXISTS `plan_job_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plan_job_id` bigint unsigned NOT NULL COMMENT 'plan job id',
  `execute_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'execute time',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'status',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'result',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
