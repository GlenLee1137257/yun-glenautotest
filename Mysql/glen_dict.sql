/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_dict

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 27/01/2026 21:16:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典分类',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典分类名称',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典名称',
  `value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典值',
  `extend` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '扩展字段',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 224 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (12, 'ui_location_type', 'UI元素定位', 'id定位', 'ID', NULL, NULL, '2024-02-26 10:31:16', '2024-02-28 09:25:09');
INSERT INTO `sys_dict` VALUES (13, 'ui_location_type', 'UI元素定位', '链接文本内容定位', 'LINK_TEXT', NULL, NULL, '2024-02-26 10:32:01', '2024-02-28 09:25:13');
INSERT INTO `sys_dict` VALUES (14, 'ui_location_type', 'UI元素定位', '全部链接文本内容定位', 'PARTIAL_LINK_TEXT', NULL, NULL, '2024-02-26 10:32:12', '2024-02-28 09:25:18');
INSERT INTO `sys_dict` VALUES (15, 'ui_location_type', 'UI元素定位', '名称定位', 'NAME', NULL, NULL, '2024-02-26 10:32:28', '2024-02-28 09:25:23');
INSERT INTO `sys_dict` VALUES (16, 'ui_location_type', 'UI元素定位', '标签名称定位', 'TAG_NAME', NULL, NULL, '2024-02-26 10:32:35', '2024-02-28 09:25:28');
INSERT INTO `sys_dict` VALUES (17, 'ui_location_type', 'UI元素定位', 'xpath定位', 'XPATH', NULL, NULL, '2024-02-26 10:32:51', '2024-02-28 09:25:32');
INSERT INTO `sys_dict` VALUES (18, 'ui_location_type', 'UI元素定位', '类名定位', 'CLASS_NAME', NULL, NULL, '2024-02-26 10:33:06', '2024-02-28 09:25:36');
INSERT INTO `sys_dict` VALUES (19, 'ui_location_type', 'UI元素定位', 'CSS选择器定位', 'CSS_SELECTOR', NULL, NULL, '2024-02-26 10:33:15', '2024-02-28 09:25:38');
INSERT INTO `sys_dict` VALUES (20, 'browser', '浏览器', '打开窗口', 'BROWSER_OPEN', '[{\"name\":\"值\",\"field\":\"value\"}]', NULL, '2024-02-27 02:51:03', '2024-02-28 14:25:55');
INSERT INTO `sys_dict` VALUES (21, 'browser', '浏览器', '关闭窗口', 'BROWSER_CLOSE', NULL, NULL, '2024-02-27 05:51:39', '2024-02-28 14:25:59');
INSERT INTO `sys_dict` VALUES (22, 'browser', '浏览器', '通过句柄切换窗口', 'BROWSER_SWITCH_BY_HANDLER', '[{\"name\":\"窗口句炳\",\"field\":\"value\"}]', NULL, '2024-02-27 05:52:13', '2024-02-28 14:26:03');
INSERT INTO `sys_dict` VALUES (23, 'browser', '浏览器', '通过索引切换窗口', 'BROWSER_SWITCH_BY_INDEX', '[{\"name\":\"窗口索引\",\"field\":\"value\"}]', NULL, '2024-02-27 05:52:53', '2024-02-28 14:26:07');
INSERT INTO `sys_dict` VALUES (24, 'browser', '浏览器', '最大化窗口', 'BROWSER_MAXIMIZE', NULL, NULL, '2024-02-27 05:53:34', '2024-02-28 14:26:12');
INSERT INTO `sys_dict` VALUES (25, 'browser', '浏览器', '设置窗口大小', 'BROWSER_RESIZE', '[{\"name\":\"窗口宽高格式：width,height\",\"field\":\"value\"}]', NULL, '2024-02-27 05:53:38', '2024-02-28 14:26:16');
INSERT INTO `sys_dict` VALUES (26, 'browser', '浏览器', '浏览器前进', 'BROWSER_FORWARD', NULL, NULL, '2024-02-27 08:14:14', '2024-02-28 14:26:32');
INSERT INTO `sys_dict` VALUES (27, 'browser', '浏览器', '浏览器后退', 'BROWSER_BACK', NULL, NULL, '2024-02-27 08:14:58', '2024-02-28 14:26:27');
INSERT INTO `sys_dict` VALUES (28, 'browser', '浏览器', '浏览器刷新', 'BROWSER_REFRESH', NULL, NULL, '2024-02-27 08:15:35', '2024-02-28 14:26:23');
INSERT INTO `sys_dict` VALUES (35, 'mouse', '鼠标', '鼠标左键点击', 'MOUSE_LEFT_CLICK', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 05:56:51', '2024-02-28 14:26:37');
INSERT INTO `sys_dict` VALUES (36, 'mouse', '鼠标', '鼠标右键点击', 'MOUSE_RIGHT_CLICK', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 05:56:55', '2024-02-28 14:26:42');
INSERT INTO `sys_dict` VALUES (37, 'mouse', '鼠标', '鼠标左键双击', 'MOUSE_DOUBLE_CLICK', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 05:56:57', '2024-02-28 14:26:46');
INSERT INTO `sys_dict` VALUES (38, 'mouse', '鼠标', '鼠标移入元素', 'MOUSE_MOVE_TO_ELEMENT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 05:56:59', '2024-02-28 14:26:50');
INSERT INTO `sys_dict` VALUES (39, 'mouse', '鼠标', '鼠标拖拽元素到目标元素', 'MOUSE_DRAG_ELEMENT_TO_ELEMENT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"},{\"name\":\"目标元素定位表达式\",\"field\":\"targetLocationType\"},{\"name\":\"目标元素定位表达式\",\"field\":\"targetLocationExpress\"},{\"name\":\"目标元素显示等待(毫秒)\",\"field\":\"targetElementWait\"}]', NULL, '2024-02-27 05:57:01', '2024-02-28 14:26:55');
INSERT INTO `sys_dict` VALUES (41, 'keyboard', '键盘', '键盘输入', 'KEYBOARD_INPUT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"值\",\"field\":\"value\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 06:05:50', '2024-02-28 14:27:00');
INSERT INTO `sys_dict` VALUES (42, 'keyboard', '键盘', '表单提交', 'KEYBOARD_SUBMIT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 06:05:52', '2024-02-28 14:27:05');
INSERT INTO `sys_dict` VALUES (43, 'keyboard', '键盘', '清空输入框', 'KEYBOARD_CLEAR', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"显示等待(毫秒)\",\"field\":\"elementWait\"}]', NULL, '2024-02-27 08:19:57', '2024-02-28 14:27:09');
INSERT INTO `sys_dict` VALUES (50, 'wait', '等待', '强制等待', 'WAIT_FORCE', '[{\"name\":\"强制等待\",\"field\":\"value\"}]', NULL, '2024-02-27 06:09:54', '2024-02-28 14:27:24');
INSERT INTO `sys_dict` VALUES (52, 'wait', '等待', '隐式等待', 'WAIT_HIDE', '[{\"name\":\"隐式等待\",\"field\":\"value\"}]', NULL, '2024-02-27 06:09:46', '2024-02-28 14:27:14');
INSERT INTO `sys_dict` VALUES (69, 'assertion', '断言', '网页标题相等', 'ASSERTION_BROWSER_TITLE_EQUAL', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 06:13:36', '2024-02-28 14:27:31');
INSERT INTO `sys_dict` VALUES (70, 'assertion', '断言', '网页标题不相等', 'ASSERTION_BROWSER_TITLE_NOT_EQUAL', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:32:35', '2024-02-28 14:27:36');
INSERT INTO `sys_dict` VALUES (71, 'assertion', '断言', '网页标题包含', 'ASSERTION_BROWSER_TITLE_CONTAIN', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:32:39', '2024-02-28 14:27:42');
INSERT INTO `sys_dict` VALUES (72, 'assertion', '断言', '网页标题不包含', 'ASSERTION_BROWSER_TITLE_NOT_CONTAIN', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:34:03', '2024-02-28 14:27:48');
INSERT INTO `sys_dict` VALUES (73, 'assertion', '断言', '网页URL相等', 'ASSERTION_BROWSER_URL_EQUAL', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:34:04', '2024-02-28 14:27:53');
INSERT INTO `sys_dict` VALUES (74, 'assertion', '断言', '网页URL不相等', 'ASSERTION_BROWSER_URL_NOT_EQUAL', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:34:06', '2024-02-28 14:27:57');
INSERT INTO `sys_dict` VALUES (75, 'assertion', '断言', '网页URL包含', 'ASSERTION_BROWSER_URL_CONTAIN', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:36:18', '2024-02-28 14:28:03');
INSERT INTO `sys_dict` VALUES (76, 'assertion', '断言', '网页URL不包含', 'ASSERTION_BROWSER_URL_NOT_CONTAIN', '[{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:36:20', '2024-02-28 14:28:09');
INSERT INTO `sys_dict` VALUES (77, 'assertion', '断言', '元素文本大于', 'ASSERTION_ELEMENT_TEXT_GREAT_THEN', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:36:21', '2024-02-28 14:28:14');
INSERT INTO `sys_dict` VALUES (78, 'assertion', '断言', '元素文本小于', 'ASSERTION_ELEMENT_TEXT_LESS_THEN', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:36:23', '2024-02-28 14:28:19');
INSERT INTO `sys_dict` VALUES (79, 'assertion', '断言', '元素文本相等', 'ASSERTION_ELEMENT_TEXT_EQUAL', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:36:24', '2024-02-28 14:28:23');
INSERT INTO `sys_dict` VALUES (80, 'assertion', '断言', '元素文本不相等', 'ASSERTION_ELEMENT_TEXT_NOT_EQUAL', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:39:21', '2024-02-28 14:28:28');
INSERT INTO `sys_dict` VALUES (81, 'assertion', '断言', '元素文本包含', 'ASSERTION_ELEMENT_TEXT_CONTAIN', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:39:23', '2024-02-28 14:28:32');
INSERT INTO `sys_dict` VALUES (82, 'assertion', '断言', '元素文本不包含', 'ASSERTION_ELEMENT_TEXT_NOT_CONTAIN', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"},{\"name\":\"预期值\",\"field\":\"expectValue\"}]', NULL, '2024-02-27 10:39:25', '2024-02-28 14:28:39');
INSERT INTO `sys_dict` VALUES (83, 'assertion', '断言', '元素存在', 'ASSERTION_ELEMENT_EXIST', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:39:26', '2024-02-28 14:28:43');
INSERT INTO `sys_dict` VALUES (84, 'assertion', '断言', '元素不存在', 'ASSERTION_ELEMENT_NOT_EXIST', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:39:28', '2024-02-28 14:28:48');
INSERT INTO `sys_dict` VALUES (85, 'assertion', '断言', '元素启用', 'ASSERTION_ELEMENT_ENABLE', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:39:30', '2024-02-28 14:28:53');
INSERT INTO `sys_dict` VALUES (86, 'assertion', '断言', '元素禁用', 'ASSERTION_ELEMENT_DISABLE', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:39:32', '2024-02-28 14:28:59');
INSERT INTO `sys_dict` VALUES (87, 'assertion', '断言', '元素可见', 'ASSERTION_ELEMENT_VISIBLE', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:49:23', '2024-02-28 14:29:04');
INSERT INTO `sys_dict` VALUES (88, 'assertion', '断言', '元素不可见', 'ASSERTION_ELEMENT_INVISIBLE', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:49:24', '2024-02-28 14:29:09');
INSERT INTO `sys_dict` VALUES (89, 'assertion', '断言', '元素被选中', 'ASSERTION_ELEMENT_SELECT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:49:26', '2024-02-28 14:29:15');
INSERT INTO `sys_dict` VALUES (90, 'assertion', '断言', '元素未被选中', 'ASSERTION_ELEMENT_UNSELECT', '[{\"name\":\"元素定位类型\",\"field\":\"locationType\"},{\"name\":\"元素定位表达式\",\"field\":\"locationExpress\"}]', NULL, '2024-02-27 10:49:27', '2024-02-28 14:29:17');
INSERT INTO `sys_dict` VALUES (106, 'browser_type', '浏览器类型', '谷歌浏览器', 'CHROME', NULL, NULL, '2024-02-28 09:20:14', '2024-02-28 09:20:14');
INSERT INTO `sys_dict` VALUES (107, 'browser_type', '浏览器类型', '苹果浏览器', 'SAFARI', NULL, NULL, '2024-02-28 09:20:20', '2024-02-28 09:20:37');
INSERT INTO `sys_dict` VALUES (164, 'api_relation_from', '关联来源', '请求头', 'REQUEST_HEADER', NULL, '从请求头中提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (165, 'api_relation_from', '关联来源', '请求体', 'REQUEST_BODY', NULL, '从请求体中提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (166, 'api_relation_from', '关联来源', '请求查询参数', 'REQUEST_QUERY', NULL, '从请求查询参数中提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (167, 'api_relation_from', '关联来源', '响应头', 'RESPONSE_HEADER', NULL, '从响应头中提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (168, 'api_relation_from', '关联来源', '响应体', 'RESPONSE_DATA', NULL, '从响应体中提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (169, 'api_relation_type', '关联类型', 'JSON路径', 'JSONPATH', NULL, '使用JSONPath表达式提取数据，例如：$.data.id', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (170, 'api_relation_type', '关联类型', '正则表达式', 'REGEXP', NULL, '使用正则表达式提取数据', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (171, 'api_assertion_from', '断言来源', '响应状态码', 'RESPONSE_CODE', NULL, '对响应状态码进行断言', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (172, 'api_assertion_from', '断言来源', '响应头', 'RESPONSE_HEADER', NULL, '对响应头进行断言', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (173, 'api_assertion_from', '断言来源', '响应体', 'RESPONSE_DATA', NULL, '对响应体进行断言', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (174, 'api_assertion_type', '断言类型', 'JSON路径', 'JSONPATH', NULL, '使用JSONPath表达式断言，例如：$.data.code', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (175, 'api_assertion_type', '断言类型', '正则表达式', 'REGEXP', NULL, '使用正则表达式断言', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (176, 'api_assertion_action', '断言动作', '等于', 'EQUAL', NULL, '断言实际值等于预期值', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (177, 'api_assertion_action', '断言动作', '不等于', 'NOT_EQUAL', NULL, '断言实际值不等于预期值', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (178, 'api_assertion_action', '断言动作', '包含', 'CONTAIN', NULL, '断言实际值包含预期值', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (179, 'api_assertion_action', '断言动作', '不包含', 'NOT_CONTAIN', NULL, '断言实际值不包含预期值', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (180, 'api_assertion_action', '断言动作', '大于', 'GREAT_THEN', NULL, '断言实际值大于预期值（数值比较）', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (181, 'api_assertion_action', '断言动作', '小于', 'LESS_THEN', NULL, '断言实际值小于预期值（数值比较）', '2026-01-19 01:13:42', '2026-01-19 01:13:42');
INSERT INTO `sys_dict` VALUES (200, 'stress_source_type', '压测来源类型', '简单压测', 'SIMPLE', NULL, 'HTTP接口简单压测，支持GET/POST等常见请求方式', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (201, 'stress_source_type', '压测来源类型', 'JMX脚本压测', 'JMX', NULL, '使用JMeter JMX脚本进行压测，支持复杂场景', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (210, 'stress_assert_action', '压测断言动作', '等于', 'EQUAL', NULL, '断言实际值等于预期值', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (212, 'stress_assert_action', '压测断言动作', '包含', 'CONTAIN', NULL, '断言实际值包含预期值', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (220, 'stress_assert_from', '压测断言来源', '响应状态码', 'RESPONSE_CODE', NULL, '对响应状态码进行断言', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (221, 'stress_assert_from', '压测断言来源', '响应头', 'RESPONSE_HEADER', NULL, '对响应头进行断言', '2026-01-21 19:16:19', '2026-01-21 19:16:19');
INSERT INTO `sys_dict` VALUES (222, 'stress_assert_from', '压测断言来源', '响应体', 'RESPONSE_DATA', NULL, '对响应体进行断言', '2026-01-21 19:16:19', '2026-01-21 19:16:19');

SET FOREIGN_KEY_CHECKS = 1;
