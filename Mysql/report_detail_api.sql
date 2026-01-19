/*
 Glen AutoTest Platform - Report Detail API Table
 Database: glen_stress
*/

USE glen_stress;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for report_detail_api
-- ----------------------------
DROP TABLE IF EXISTS `report_detail_api`;
CREATE TABLE `report_detail_api`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `report_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属报告ID',
  `execute_state` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '执行状态',
  `assertion_state` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '断言状态',
  `exception_msg` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '异常信息',
  `expend_time` bigint UNSIGNED NULL DEFAULT NULL COMMENT '消耗时间',
  `request_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `request_query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数',
  `request_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `response_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应头数据',
  `response_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应体数据',
  `environment_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属环境ID',
  `case_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属API用例ID',
  `num` bigint UNSIGNED NULL DEFAULT NULL COMMENT '序号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API用例步骤名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API用例步骤描述',
  `assertion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应断言',
  `relation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '关联参数',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求路径',
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法 [GET POST PUT PATCH DELETE HEAD OPTIONS]',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查询参数',
  `header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `body_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求体格式 [form-data x-www-form-urlencoded json raw file]',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_report_id`(`report_id`) USING BTREE COMMENT '报告ID索引',
  INDEX `idx_case_id`(`case_id`) USING BTREE COMMENT '用例ID索引'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API测试报告明细表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
