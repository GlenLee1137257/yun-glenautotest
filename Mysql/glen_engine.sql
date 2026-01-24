/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_engine

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 24/01/2026 13:09:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for environment
-- ----------------------------
DROP TABLE IF EXISTS `environment`;
CREATE TABLE `environment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境名称',
  `protocol` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '协议',
  `domain` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境域名',
  `port` int UNSIGNED NOT NULL COMMENT '端口',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of environment
-- ----------------------------
INSERT INTO `environment` VALUES (1, 5, '贝好学测试环境(PC用户端)', 'HTTP', 'test-study.ke.com', 80, 'PC用户端用于课程学习、考试、证书等用户端功能测试', '2026-01-18 12:21:05', '2026-01-18 12:25:46');
INSERT INTO `environment` VALUES (2, 5, '贝好学测试环境(管理后台)', 'HTTP', 'test-admin-study.ke.com', 80, '管理后台接口，用于课程管理、考试管理、学员管理等管理端功能测试', '2026-01-18 12:25:20', '2026-01-18 12:25:36');
INSERT INTO `environment` VALUES (3, 5, '贝好学生产环境(PC用户端)', 'HTTPS', 'study.ke.com', 443, '贝好学生产环境 - PC用户端，仅用于生产环境验证测试', '2026-01-18 12:29:02', '2026-01-18 12:29:02');
INSERT INTO `environment` VALUES (4, 6, '贝壳公益测试环境(H5移动端)', 'HTTP', 'test-gongyi-mobile.ke.com', 80, 'H5移动端接口，用于公益活动、成长体系、PK功能等移动端测试', '2026-01-18 14:37:13', '2026-01-18 14:37:13');
INSERT INTO `environment` VALUES (5, 6, '贝壳公益测试环境(PC管理端)', 'HTTP', 'test-gongyi-admin.ke.com', 80, 'PC管理端接口，用于活动管理、数据统计等后台管理功能测试', '2026-01-18 14:37:39', '2026-01-18 14:37:39');
INSERT INTO `environment` VALUES (6, 6, '贝壳公益测试环境(善贝GO小程序)', 'HTTP', 'test-shanbeigo.ke.com', 80, '贝壳公益测试环境 - 善贝GO小程序接口，用于C端用户公益分/公益币、PK功能等测试', '2026-01-18 14:38:12', '2026-01-18 14:38:12');
INSERT INTO `environment` VALUES (7, 6, '贝壳公益生产环境(H5移动端)', 'HTTPS', 'gongyi-mobile.ke.com', 443, '贝壳公益生产环境 - H5移动端接口，仅用于生产环境验证测试', '2026-01-18 14:38:48', '2026-01-18 14:38:48');
INSERT INTO `environment` VALUES (10, 17, '花桥学堂测试环境', 'HTTP', 'localhost', 3000, '在线教育平台的完整测试场景，包含课程、考试、证书等核心业务模块', '2026-01-18 19:30:30', '2026-01-18 19:30:30');
INSERT INTO `environment` VALUES (11, 17, '花桥学堂生产测试', 'HTTP', 'localhost', 3001, '用于生产环境验证测试', '2026-01-18 19:30:55', '2026-01-18 19:31:07');
INSERT INTO `environment` VALUES (12, 18, 'Swag Labs', 'HTTPS', 'www.saucedemo.com', 443, '0000', '2026-01-21 22:56:46', '2026-01-21 23:15:55');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plan_job
-- ----------------------------
INSERT INTO `plan_job` VALUES (1, 17, '花桥自动化', 38, 'API', 0, '2026-01-21 18:56:00', '2026-01-21 18:54:38', '2026-01-21 18:54:52');

-- ----------------------------
-- Table structure for plan_job_log
-- ----------------------------
DROP TABLE IF EXISTS `plan_job_log`;
CREATE TABLE `plan_job_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_job_id` bigint NULL DEFAULT NULL COMMENT '任务id',
  `plan_job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `execute_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行时间',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uni_job_id_time`(`plan_job_id` ASC, `execute_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2013928558744965123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plan_job_log
-- ----------------------------
INSERT INTO `plan_job_log` VALUES (2013928558744965122, 1, '花桥自动化', '2026-01-21 18:56:00', '2026-01-21 18:56:00', '2026-01-21 18:56:00');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_admin` bigint UNSIGNED NULL DEFAULT NULL COMMENT '项目管理员ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (5, 3, '贝好学培训', '在线教育培训平台，包含课程学习、考试系统、证书管理等核心功能。', '2026-01-18 03:19:12', '2026-01-18 12:15:31');
INSERT INTO `project` VALUES (6, 3, '贝壳公益', '社区公益平台，包含公益活动管理、成长体系(公益分/公益币)、徽章系统、PK功能等。', '2026-01-18 12:15:43', '2026-01-18 12:16:19');
INSERT INTO `project` VALUES (17, 3, '花桥学堂', '在线教育平台的完整测试场景，包含课程、考试、证书等核心业务模块', '2026-01-18 19:17:34', '2026-01-18 19:17:34');
INSERT INTO `project` VALUES (18, 3, 'Swag Labs', '测试UI自动化-电商购物完整流程测试', '2026-01-21 15:27:46', '2026-01-21 15:27:46');

-- ----------------------------
-- Table structure for stress_case_module
-- ----------------------------
DROP TABLE IF EXISTS `stress_case_module`;
CREATE TABLE `stress_case_module`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '压测用例模块名称',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stress_case_module
-- ----------------------------
INSERT INTO `stress_case_module` VALUES (1, 17, '课程接口压测', '2026-01-21 19:18:41', '2026-01-21 19:37:50');
INSERT INTO `stress_case_module` VALUES (3, 18, '商品列表页面压测', '2026-01-21 22:50:53', '2026-01-21 23:30:49');

SET FOREIGN_KEY_CHECKS = 1;
