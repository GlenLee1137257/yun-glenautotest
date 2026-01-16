CREATE TABLE `stress_case` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint DEFAULT NULL COMMENT '项目id',
  `module_id` bigint unsigned DEFAULT NULL COMMENT '所属接口模块ID',
  `environment_id` bigint DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口描述',
  `assertion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '响应断言',
  `relation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '可变参数',
  `stress_source_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '压测类型 [simple jmx]',
  `thread_group_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '压测参数',
  `jmx_url` varchar(524) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'jmx文件地址',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口路径',
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求方法 [GET POST PUT PATCH DELETE HEAD OPTIONS]',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '查询参数',
  `header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求头',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求体',
  `body_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求体格式 [raw form-data json]',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;




CREATE TABLE `report` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned DEFAULT NULL COMMENT '所属项目ID',
  `case_id` bigint DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告类型',
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告名称',
  `execute_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行状态',
  `summary` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_time` bigint unsigned DEFAULT NULL COMMENT '开始时间',
  `end_time` bigint unsigned DEFAULT NULL COMMENT '结束时间',
  `expand_time` bigint unsigned DEFAULT NULL COMMENT '消耗时间',
  `quantity` bigint DEFAULT '0' COMMENT '步骤数量',
  `pass_quantity` bigint DEFAULT '0' COMMENT '通过数量',
  `fail_quantity` bigint DEFAULT '0' COMMENT '失败数量',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `report_detail_stress` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `report_id` bigint unsigned DEFAULT NULL COMMENT '所属报告ID',
  `assert_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '断言信息',
  `error_count` bigint unsigned DEFAULT NULL COMMENT '错误请求数',
  `error_percentage` float unsigned DEFAULT NULL COMMENT '错误百分比',
  `max_time` int unsigned DEFAULT NULL COMMENT '最大响应时间',
  `mean_time` float unsigned DEFAULT NULL COMMENT '平均响应时间',
  `min_time` int unsigned DEFAULT NULL COMMENT '最小响应时间',
  `receive_k_b_per_second` float DEFAULT NULL COMMENT '每秒接收KB',
  `sent_k_b_per_second` float DEFAULT NULL COMMENT '每秒发送KB',
  `request_location` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求路径和参数',
  `request_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求头',
  `request_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求体',
  `request_rate` float unsigned DEFAULT NULL COMMENT '每秒请求速率',
  `response_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '响应码',
  `response_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '响应体',
  `response_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '响应头',
  `sampler_count` bigint unsigned DEFAULT NULL COMMENT '采样次数编号',
  `sampler_label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求名称',
  `sample_time` bigint DEFAULT NULL COMMENT '请求时间戳',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;