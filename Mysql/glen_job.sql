/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_job

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 24/01/2026 13:09:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for plan_job
-- ----------------------------
DROP TABLE IF EXISTS `plan_job`;
CREATE TABLE `plan_job`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属计划ID',
  `case_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '用例ID',
  `test_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用例类型 [ui api stress]',
  `is_disabled` int NULL DEFAULT 0 COMMENT '是否启用',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '定时任务表达式，支持到分钟基本',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plan_job
-- ----------------------------

-- ----------------------------
-- Table structure for plan_job_log
-- ----------------------------
DROP TABLE IF EXISTS `plan_job_log`;
CREATE TABLE `plan_job_log`  (
  `id` bigint NOT NULL,
  `plan_job_id` bigint NULL DEFAULT NULL COMMENT '任务id',
  `plan_job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行时间',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uni_job_id_time`(`plan_job_id` ASC, `execute_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plan_job_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
