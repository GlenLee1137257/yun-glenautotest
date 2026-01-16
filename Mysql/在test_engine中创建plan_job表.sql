-- 在 test_engine 数据库中创建 plan_job 和 plan_job_log 表
-- 使用 Navicat 执行此 SQL

USE test_engine;

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
  `id` bigint NOT NULL,
  `plan_job_id` bigint DEFAULT NULL COMMENT 'job id',
  `plan_job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'job name',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'execute time',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_job_id_time` (`plan_job_id`,`execute_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
