/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_stress

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 18/01/2026 18:09:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属项目ID',
  `case_id` bigint NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报告类型',
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报告名称',
  `execute_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '执行状态',
  `summary` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_time` bigint UNSIGNED NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` bigint UNSIGNED NULL DEFAULT NULL COMMENT '结束时间',
  `expand_time` bigint UNSIGNED NULL DEFAULT NULL COMMENT '消耗时间',
  `quantity` bigint NULL DEFAULT 0 COMMENT '步骤数量',
  `pass_quantity` bigint NULL DEFAULT 0 COMMENT '通过数量',
  `fail_quantity` bigint NULL DEFAULT 0 COMMENT '失败数量',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report
-- ----------------------------

-- ----------------------------
-- Table structure for report_detail_stress
-- ----------------------------
DROP TABLE IF EXISTS `report_detail_stress`;
CREATE TABLE `report_detail_stress`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `report_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属报告ID',
  `assert_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '断言信息',
  `error_count` bigint UNSIGNED NULL DEFAULT NULL COMMENT '错误请求数',
  `error_percentage` float UNSIGNED NULL DEFAULT NULL COMMENT '错误百分比',
  `max_time` int UNSIGNED NULL DEFAULT NULL COMMENT '最大响应时间',
  `mean_time` float UNSIGNED NULL DEFAULT NULL COMMENT '平均响应时间',
  `min_time` int UNSIGNED NULL DEFAULT NULL COMMENT '最小响应时间',
  `receive_k_b_per_second` float NULL DEFAULT NULL COMMENT '每秒接收KB',
  `sent_k_b_per_second` float NULL DEFAULT NULL COMMENT '每秒发送KB',
  `request_location` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求路径和参数',
  `request_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `request_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `request_rate` float UNSIGNED NULL DEFAULT NULL COMMENT '每秒请求速率',
  `response_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '响应码',
  `response_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应体',
  `response_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应头',
  `sampler_count` bigint UNSIGNED NULL DEFAULT NULL COMMENT '采样次数编号',
  `sampler_label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求名称',
  `sample_time` bigint NULL DEFAULT NULL COMMENT '请求时间戳',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report_detail_stress
-- ----------------------------

-- ----------------------------
-- Table structure for stress_case
-- ----------------------------
DROP TABLE IF EXISTS `stress_case`;
CREATE TABLE `stress_case`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目id',
  `module_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属接口模块ID',
  `environment_id` bigint NULL DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口描述',
  `assertion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应断言',
  `relation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '可变参数',
  `stress_source_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '压测类型 [simple jmx]',
  `thread_group_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '压测参数',
  `jmx_url` varchar(524) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'jmx文件地址',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口路径',
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法 [GET POST PUT PATCH DELETE HEAD OPTIONS]',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查询参数',
  `header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `body_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求体格式 [raw form-data json]',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stress_case
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
