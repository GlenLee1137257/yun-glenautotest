CREATE TABLE `plan_job` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint DEFAULT NULL COMMENT '项目id',
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属计划ID',
  `case_id` bigint unsigned DEFAULT NULL COMMENT '用例ID',
  `test_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例类型 [ui api stress]',
  `is_disabled` int DEFAULT '0' COMMENT '是否启用',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '定时任务表达式，支持到分钟基本',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;





CREATE TABLE `plan_job_log` (
  `id` bigint NOT NULL,
  `plan_job_id` bigint DEFAULT NULL COMMENT '任务id',
  `plan_job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务名称',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '执行时间',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_job_id_time` (`plan_job_id`,`execute_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;