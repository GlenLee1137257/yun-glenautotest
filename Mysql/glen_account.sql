/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_account

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 28/01/2026 22:14:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号',
  `is_disabled` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '是否禁用 0:否 1:是',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE COMMENT '账号唯一索引',
  INDEX `idx_is_disabled`(`is_disabled` ASC) USING BTREE COMMENT '启用状态索引'
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '账号表：存储用户账号基本信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES (1, 'admin', 0, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `account` VALUES (2, 'test', 0, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `account` VALUES (3, '李冠标', 0, '2026-01-18 03:05:33', '2026-01-18 03:05:33');

-- ----------------------------
-- Table structure for account_role
-- ----------------------------
DROP TABLE IF EXISTS `account_role`;
CREATE TABLE `account_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL COMMENT '角色ID',
  `account_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_account_role`(`account_id` ASC, `role_id` ASC) USING BTREE COMMENT '账号-角色唯一索引',
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE COMMENT '角色ID索引',
  INDEX `idx_account_id`(`account_id` ASC) USING BTREE COMMENT '账号ID索引'
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '账号角色关联表：用户与角色的多对多关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of account_role
-- ----------------------------
INSERT INTO `account_role` VALUES (1, 1, 1, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `account_role` VALUES (2, 1, 2, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `account_role` VALUES (3, 1, 3, '2026-01-18 03:05:33', '2026-01-18 03:05:33');

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限编码',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限描述',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_code`(`code` ASC) USING BTREE COMMENT '权限编码唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限表：系统权限定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES (1, '项目管理', 'project:view', '项目管理菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (2, '项目列表', 'project:list', '查看项目列表', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (3, '创建项目', 'project:create', '创建新项目', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (4, '编辑项目', 'project:edit', '编辑项目信息', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (5, '删除项目', 'project:delete', '删除项目', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (10, '接口测试', 'api:view', '接口测试菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (11, '接口列表', 'api:list', '查看接口列表', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (12, '创建接口', 'api:create', '创建接口用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (13, '编辑接口', 'api:edit', '编辑接口用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (14, '删除接口', 'api:delete', '删除接口用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (15, '执行接口', 'api:execute', '执行接口测试', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (20, 'UI测试', 'ui:view', 'UI测试菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (21, 'UI用例列表', 'ui:list', '查看UI用例列表', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (22, '创建UI用例', 'ui:create', '创建UI用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (23, '编辑UI用例', 'ui:edit', '编辑UI用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (24, '删除UI用例', 'ui:delete', '删除UI用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (25, '执行UI用例', 'ui:execute', '执行UI测试', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (30, '压力测试', 'stress:view', '压力测试菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (31, '压测用例列表', 'stress:list', '查看压测用例列表', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (32, '创建压测用例', 'stress:create', '创建压测用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (33, '编辑压测用例', 'stress:edit', '编辑压测用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (34, '删除压测用例', 'stress:delete', '删除压测用例', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (35, '执行压测', 'stress:execute', '执行压力测试', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (40, '定时任务', 'job:view', '定时任务菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (41, '任务列表', 'job:list', '查看任务列表', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (42, '创建任务', 'job:create', '创建定时任务', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (43, '编辑任务', 'job:edit', '编辑任务信息', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (44, '删除任务', 'job:delete', '删除任务', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (45, '启用/禁用任务', 'job:toggle', '启用或禁用任务', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (50, '系统管理', 'system:view', '系统管理菜单', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (51, '账号管理', 'system:account', '账号管理', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (52, '角色管理', 'system:role', '角色管理', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (53, '权限管理', 'system:permission', '权限管理', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (54, '创建账号', 'system:account:create', '创建新账号', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (55, '编辑账号', 'system:account:edit', '编辑账号信息', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (56, '删除账号', 'system:account:delete', '删除账号', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (57, '创建角色', 'system:role:create', '创建新角色', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (58, '编辑角色', 'system:role:edit', '编辑角色信息', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (59, '删除角色', 'system:role:delete', '删除角色', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `permission` VALUES (100, '项目授权', 'PROJECT_AUTH', '项目授权权限', '2026-01-18 01:39:13', '2026-01-18 01:39:13');
INSERT INTO `permission` VALUES (101, '项目读写', 'PROJECT_READ_WRITE', '项目读写权限', '2026-01-18 01:39:13', '2026-01-18 01:39:13');
INSERT INTO `permission` VALUES (102, '项目只读', 'PROJECT_READ_ONLY', '项目只读权限', '2026-01-18 01:39:13', '2026-01-18 01:39:13');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_code`(`code` ASC) USING BTREE COMMENT '角色编码唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表：系统角色定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, '超级管理员', 'ROLE_SUPER_ADMIN', '拥有系统所有权限', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role` VALUES (2, '项目管理员', 'ROLE_PROJECT_ADMIN', '项目管理权限', '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role` VALUES (3, '测试工程师', 'ROLE_TESTER', '测试执行权限', '2026-01-18 00:03:27', '2026-01-18 00:03:27');

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL COMMENT '角色ID',
  `permission_id` bigint UNSIGNED NOT NULL COMMENT '权限ID',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE COMMENT '角色ID索引',
  INDEX `idx_permission_id`(`permission_id` ASC) USING BTREE COMMENT '权限ID索引'
) ENGINE = InnoDB AUTO_INCREMENT = 311 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色权限关联表：角色与权限的多对多关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (8, 1, 1, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (9, 1, 2, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (10, 1, 3, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (11, 1, 4, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (12, 1, 5, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (13, 1, 10, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (14, 1, 11, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (15, 1, 12, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (16, 1, 13, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (17, 1, 14, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (18, 1, 15, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (19, 1, 20, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (20, 1, 21, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (21, 1, 22, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (22, 1, 23, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (23, 1, 24, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (24, 1, 25, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (25, 1, 30, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (26, 1, 31, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (27, 1, 32, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (28, 1, 33, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (29, 1, 34, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (30, 1, 35, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (31, 1, 40, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (32, 1, 41, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (33, 1, 42, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (34, 1, 43, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (35, 1, 44, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (36, 1, 45, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (37, 1, 50, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (38, 1, 51, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (39, 1, 52, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (40, 1, 53, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (41, 1, 54, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (42, 1, 55, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (43, 1, 56, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (44, 1, 57, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (45, 1, 58, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (46, 1, 59, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (71, 1, 1, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (72, 1, 2, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (73, 1, 3, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (74, 1, 4, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (75, 1, 5, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (76, 1, 10, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (77, 1, 11, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (78, 1, 12, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (79, 1, 13, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (80, 1, 14, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (81, 1, 15, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (82, 1, 20, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (83, 1, 21, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (84, 1, 22, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (85, 1, 23, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (86, 1, 24, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (87, 1, 25, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (88, 1, 30, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (89, 1, 31, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (90, 1, 32, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (91, 1, 33, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (92, 1, 34, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (93, 1, 35, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (94, 1, 40, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (95, 1, 41, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (96, 1, 42, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (97, 1, 43, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (98, 1, 44, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (99, 1, 45, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (100, 1, 50, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (101, 1, 51, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (102, 1, 52, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (103, 1, 53, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (104, 1, 54, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (105, 1, 55, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (106, 1, 56, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (107, 1, 57, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (108, 1, 58, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (109, 1, 59, '2026-01-18 00:03:27', '2026-01-18 00:03:27');
INSERT INTO `role_permission` VALUES (134, 1, 1, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (135, 1, 2, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (136, 1, 3, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (137, 1, 4, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (138, 1, 5, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (139, 1, 10, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (140, 1, 11, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (141, 1, 12, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (142, 1, 13, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (143, 1, 14, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (144, 1, 15, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (145, 1, 20, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (146, 1, 21, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (147, 1, 22, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (148, 1, 23, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (149, 1, 24, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (150, 1, 25, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (151, 1, 30, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (152, 1, 31, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (153, 1, 32, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (154, 1, 33, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (155, 1, 34, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (156, 1, 35, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (157, 1, 40, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (158, 1, 41, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (159, 1, 42, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (160, 1, 43, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (161, 1, 44, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (162, 1, 45, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (163, 1, 50, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (164, 1, 51, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (165, 1, 52, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (166, 1, 53, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (167, 1, 54, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (168, 1, 55, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (169, 1, 56, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (170, 1, 57, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (171, 1, 58, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (172, 1, 59, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `role_permission` VALUES (197, 1, 1, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (198, 1, 2, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (199, 1, 3, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (200, 1, 4, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (201, 1, 5, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (202, 1, 10, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (203, 1, 11, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (204, 1, 12, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (205, 1, 13, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (206, 1, 14, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (207, 1, 15, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (208, 1, 20, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (209, 1, 21, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (210, 1, 22, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (211, 1, 23, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (212, 1, 24, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (213, 1, 25, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (214, 1, 30, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (215, 1, 31, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (216, 1, 32, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (217, 1, 33, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (218, 1, 34, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (219, 1, 35, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (220, 1, 40, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (221, 1, 41, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (222, 1, 42, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (223, 1, 43, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (224, 1, 44, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (225, 1, 45, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (226, 1, 50, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (227, 1, 51, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (228, 1, 52, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (229, 1, 53, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (230, 1, 54, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (231, 1, 55, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (232, 1, 56, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (233, 1, 57, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (234, 1, 58, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (235, 1, 59, '2026-01-18 01:39:03', '2026-01-18 01:39:03');
INSERT INTO `role_permission` VALUES (260, 1, 100, '2026-01-18 01:39:17', '2026-01-18 01:39:17');
INSERT INTO `role_permission` VALUES (261, 1, 101, '2026-01-18 01:39:17', '2026-01-18 01:39:17');
INSERT INTO `role_permission` VALUES (262, 1, 102, '2026-01-18 01:39:17', '2026-01-18 01:39:17');
INSERT INTO `role_permission` VALUES (263, 2, 1, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (264, 2, 2, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (265, 2, 3, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (266, 2, 4, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (267, 2, 5, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (268, 2, 10, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (269, 2, 11, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (270, 2, 12, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (271, 2, 13, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (272, 2, 14, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (273, 2, 15, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (274, 2, 20, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (275, 2, 21, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (276, 2, 22, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (277, 2, 23, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (278, 2, 24, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (279, 2, 25, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (280, 2, 30, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (281, 2, 31, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (282, 2, 32, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (283, 2, 33, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (284, 2, 34, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (285, 2, 35, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (286, 2, 40, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (287, 2, 41, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (288, 2, 42, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (289, 2, 43, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (290, 2, 44, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (291, 2, 45, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (292, 2, 50, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (293, 2, 51, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (294, 2, 52, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (295, 2, 53, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (296, 2, 101, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (297, 3, 1, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (298, 3, 2, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (299, 3, 10, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (300, 3, 11, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (301, 3, 15, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (302, 3, 20, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (303, 3, 21, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (304, 3, 25, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (305, 3, 30, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (306, 3, 31, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (307, 3, 35, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (308, 3, 40, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (309, 3, 41, '2026-01-28 18:50:28', '2026-01-28 18:50:28');
INSERT INTO `role_permission` VALUES (310, 3, 102, '2026-01-28 18:50:28', '2026-01-28 18:50:28');

-- ----------------------------
-- Table structure for social_account
-- ----------------------------
DROP TABLE IF EXISTS `social_account`;
CREATE TABLE `social_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `account_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `identity_type` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '登录类型：phone,mail,weixin,qq',
  `identifier` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '登录账号唯一标识',
  `credential` varchar(524) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '登录凭证，比如密码，token',
  `union_id` varchar(524) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 234547 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '社交账号表：用户登录凭证信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of social_account
-- ----------------------------
INSERT INTO `social_account` VALUES (234545, 2, 'mail', 'test', '47ec2dd791e31e2ef2076caf64ed9b3d', NULL, '2026-01-18 01:20:07', '2026-01-18 01:20:07');
INSERT INTO `social_account` VALUES (234546, 3, 'phone', '13432898570', '8ae3732b466210fcff1942c39050bf61', NULL, '2026-01-18 03:05:33', '2026-01-18 03:18:46');

SET FOREIGN_KEY_CHECKS = 1;
