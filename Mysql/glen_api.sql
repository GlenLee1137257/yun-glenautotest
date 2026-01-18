/*
 Navicat Premium Dump SQL

 Source Server         : T14WSL
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3307
 Source Schema         : glen_api

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 18/01/2026 18:08:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for api
-- ----------------------------
DROP TABLE IF EXISTS `api`;
CREATE TABLE `api`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目id',
  `module_id` bigint UNSIGNED NOT NULL COMMENT '所属API模块ID',
  `environment_id` bigint UNSIGNED NOT NULL COMMENT '所属环境ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'p0' COMMENT '执行等级 [p0 p1 p2 p3]',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求路径',
  `method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'GET' COMMENT '请求方法 [GET POST PUT PATCH DELETE HEAD OPTIONS]',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查询参数',
  `header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `body_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求体格式 [form-data x-www-form-urlencoded json raw file]',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API接口表：存储接口定义信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api
-- ----------------------------
INSERT INTO `api` VALUES (31, 5, 26, 1, 'PC端查询课程列表', '查询课程分页列表，支持关键词搜索和分类筛选 (V2.3.13.1课程分类优化)', 'p0', '/p/online-course/v2/course/page', 'GET', '[{\"key\":\"current\",\"value\":\"1\"},{\"key\":\"size\",\"value\":\"18\"},{\"key\":\"keyword\",\"value\":\" \"},{\"key\":\"typeConfigId\",\"value\":\" \"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:22:20', '2026-01-18 15:22:20');
INSERT INTO `api` VALUES (34, 5, 26, 1, '查询课程分类列表', '查询课程分类，支持分类可见性控制 (V2.3.13.1版本优化)', 'p0', '/p/online-course/v1/course/typeList', 'GET', '', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:38:34', '2026-01-18 15:50:26');
INSERT INTO `api` VALUES (35, 5, 26, 1, '查询课程详情', '根据课程ID查询课程完整信息，包含SCORM课程标识', 'p0', '/p/online-course/v2/course/info', 'GET', '[{\"key\":\"id\",\"value\":\"课程ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 15:38:34', '2026-01-18 15:38:34');
INSERT INTO `api` VALUES (36, 5, 30, 2, '查询独立考试分页列表', '后台管理端查询独立考试列表 (V2.9.21独立考试)', 'p0', '/alone-exam/v1/getAloneExamPage', 'POST', '', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '{\"current\":1,\"size\":10,\"keyword\":\"\",\"status\":\"\"}', 'JSON', '2026-01-18 15:43:19', '2026-01-18 16:01:22');
INSERT INTO `api` VALUES (37, 5, 30, 2, '查询独立考试详情', '根据考试ID查询考试完整信息', 'p0', '/alone-exam/v1/getAlongExam', 'GET', '[{\"key\":\"id\",\"value\":\"考试ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:43:19', '2026-01-18 16:01:46');
INSERT INTO `api` VALUES (38, 5, 30, 2, '查询独立考试配置', '查询考试的题目配置和评分规则', 'p0', '/alone-exam/v1/getAloneExamConf', 'GET', '[{\"key\":\"id\",\"value\":\"考试ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:43:19', '2026-01-18 16:02:10');
INSERT INTO `api` VALUES (39, 5, 30, 1, '移动端获取我的所有考试', '用户端查询当前用户的所有考试信息', 'p0', '/my-mobile/v1/allMyAloneExamInfo', 'GET', '', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:43:19', '2026-01-18 16:02:25');
INSERT INTO `api` VALUES (44, 5, 31, 1, '查询个人证书列表', '用户端查询个人所有证书 (V2.9.23独立证书管理)', 'p0', '/free-certificate/v1/certificate/list', 'GET', '[{\"key\":\"userCode\",\"value\":\"用户编码\"},{\"key\":\"trainId\",\"value\":\"\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 15:51:38', '2026-01-18 15:51:38');
INSERT INTO `api` VALUES (45, 5, 31, 1, '获取证书图片/PDF', '根据证书ID获取证书图片或PDF文件', 'p0', '/free-certificate/v1/certificate/picture', 'GET', '[{\"key\":\"certificateId\",\"value\":\"证书ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '[]', 'JSON', '2026-01-18 15:51:38', '2026-01-18 16:03:06');
INSERT INTO `api` VALUES (46, 5, 31, 2, '添加考试证书配置', '后台管理端为考试配置证书信息', 'p1', '/alone-exam/v1/addAloneExamCertificateConf', 'POST', '', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_uuid=94d933e0-e34e-424b-a596-8b0293a15c36; crosSdkDT2019DeviceId=9lmz05-8lw8p3-bexbpc0lmo6nrr7-gk6nzz0c4; Hm_lvt_b160d5571570fd63c347b9d4ab5ca610=1765508265; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22%24device_id%22%3A%2219b107e36aa466-0214b17eb2e366-26061c51-2073600-19b107e36ab7cf%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E8%87%AA%E7%84%B6%E6%90%9C%E7%B4%A2%E6%B5%81%E9%87%8F%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fwww.baidu.com%2Flink%22%2C%22%24latest_referrer_host%22%3A%22www.baidu.com%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%7D%7D; login_ucid=1000000031501213; security_ticket=kBPzL+zM0En8lsXaljtSrw8XD6Mv+DgF3ROoqomLv8gywF3vyiofdlWInPmbW4YjadGhsQtCZAAcblmNYzudl/Mn4mwP6nA7gcAX9JaV0lMVgsueQH6wMynia1WryYzHl4/V9QYC63rkNAOSJKbt/U8HTtI2arJV9nkEHAQXZUo=; lianjia_ssid=8f5c3546-8703-4266-bf90-dac99992b599; security_ticket_test=nSfRx9amarX8LMZLUsmRxpE55+vcen4nKFTnn5qqksuKeKokqfvRq5liUKqoVHSondl3D2SnfvO3kPTTDncCQAKzOZQA5NngClGipPzhy+PqBhx/SrutlQb7O0ds/8XGbRFvSKxS6YObyr4tnolwWgr+9APyQQyAz1r0XCp5NXA=; renovation-token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a; lianjia_token=2.0111a9beb2841c6f400001cb5408aaa28b50cfe84a\"}]', '{\"examId\":\"考试ID\",\"certificateTemplate\":\"证书模板URL\",\"certificateBackground\":\"证书背景URL\",\"certificateName\":\"证书名称\",\"passScore\":60}', 'JSON', '2026-01-18 15:51:38', '2026-01-18 16:02:44');
INSERT INTO `api` VALUES (47, 5, 32, 4, '查询用户成长信息', '查询用户的公益分、公益币、成长等级等信息', 'p0', '/growth-system/v1/getUserGrowthInfo', 'GET', '[{\"key\":\"userCode\",\"value\":\"用户编码\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:09:21', '2026-01-18 16:09:21');
INSERT INTO `api` VALUES (48, 5, 32, 4, '查询公益币流水明细', '查询用户公益币获取和消费明细', 'p0', '/growth-system/v1/getPointsFlow', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"用户编码\",\"current\":1,\"size\":20}', 'JSON', '2026-01-18 16:09:21', '2026-01-18 16:09:21');
INSERT INTO `api` VALUES (49, 5, 32, 5, '查询成长规则配置', '查询公益分/公益币获取规则配置', 'p1', '/growth-system/v1/getRuleConfig', 'GET', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:09:21', '2026-01-18 16:09:21');
INSERT INTO `api` VALUES (50, 5, 33, 6, '发起PK挑战', '用户发起PK挑战，选择PK对手', 'p0', '/pk/v1/startPK', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"发起人用户编码\",\"targetUserCode\":\"对手用户编码\",\"pkType\":1,\"duration\":7}', 'JSON', '2026-01-18 16:16:34', '2026-01-18 16:16:34');
INSERT INTO `api` VALUES (51, 5, 33, 6, '查询PK结果', '查询PK的实时结果和排名', 'p0', '/pk/v1/getPKResult', 'GET', '[{\"key\":\"pkId\",\"value\":\"PK记录ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:16:34', '2026-01-18 16:16:34');
INSERT INTO `api` VALUES (52, 5, 33, 6, '查询我的PK记录', '查询用户的所有PK记录(进行中、已结束)', 'p0', '/pk/v1/getMyPKList', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"用户编码\",\"current\":1,\"size\":10,\"status\":\"\"}', 'JSON', '2026-01-18 16:16:34', '2026-01-18 16:16:34');
INSERT INTO `api` VALUES (53, 5, 34, 4, '查询用户获得的徽章', '查询用户已获得的徽章列表', 'p1', '/badge/v1/getUserBadges', 'GET', '[{\"key\":\"userCode\",\"value\":\"用户编码\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:16:34', '2026-01-18 16:16:34');
INSERT INTO `api` VALUES (54, 5, 34, 5, '查询徽章配置信息', '查询徽章的获取规则和可见人群配置 (V6.21.1版本)', 'p1', '/badge/v1/getBadgeConfig', 'GET', '[{\"key\":\"badgeId\",\"value\":\"徽章ID\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:16:34', '2026-01-18 16:16:34');

-- ----------------------------
-- Table structure for api_case
-- ----------------------------
DROP TABLE IF EXISTS `api_case`;
CREATE TABLE `api_case`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '项目id',
  `module_id` bigint UNSIGNED NOT NULL COMMENT '所属API用例模块ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API用例名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API用例描述',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'p0' COMMENT '执行等级 [p0 p1 p2 p3]',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API用例表：存储接口测试用例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api_case
-- ----------------------------
INSERT INTO `api_case` VALUES (26, 5, 20, '课程查询完整流程', '测试课程分类查询→课程列表查询→课程详情查询的完整流程', 'p0', '2026-01-18 16:41:16', '2026-01-18 16:41:16');
INSERT INTO `api_case` VALUES (27, 5, 21, '考试信息查询流程', '测试考试列表查询→考试详情查询→考试配置查询的完整流程', 'p0', '2026-01-18 16:48:50', '2026-01-18 16:48:50');
INSERT INTO `api_case` VALUES (28, 5, 22, '用户证书查询流程', '测试证书列表查询→证书图片获取的完整流程', 'p0', '2026-01-18 16:53:20', '2026-01-18 16:53:20');
INSERT INTO `api_case` VALUES (30, 5, 23, '查询用户成长信息', '测试用户成长信息查询，验证数据准确性', 'p0', '2026-01-18 17:01:31', '2026-01-18 17:01:31');
INSERT INTO `api_case` VALUES (31, 5, 24, 'PK发起和查询流程', '测试PK发起→PK结果查询→PK记录查询的完整流程', 'p0', '2026-01-18 17:02:09', '2026-01-18 17:02:09');

-- ----------------------------
-- Table structure for api_case_module
-- ----------------------------
DROP TABLE IF EXISTS `api_case_module`;
CREATE TABLE `api_case_module`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API用例模块名称',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API用例模块表：用于组织和管理测试用例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api_case_module
-- ----------------------------
INSERT INTO `api_case_module` VALUES (20, 5, '课程业务流程测试', '2026-01-18 16:17:55', '2026-01-18 16:18:28');
INSERT INTO `api_case_module` VALUES (21, 5, '考试业务流程测试', '2026-01-18 16:44:33', '2026-01-18 16:44:44');
INSERT INTO `api_case_module` VALUES (22, 5, '证书业务流程测试', '2026-01-18 16:50:54', '2026-01-18 16:50:58');
INSERT INTO `api_case_module` VALUES (23, 5, '成长体系测试', '2026-01-18 16:58:35', '2026-01-18 16:58:39');
INSERT INTO `api_case_module` VALUES (24, 5, 'PK功能测试', '2026-01-18 16:59:50', '2026-01-18 16:59:57');

-- ----------------------------
-- Table structure for api_case_step
-- ----------------------------
DROP TABLE IF EXISTS `api_case_step`;
CREATE TABLE `api_case_step`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL,
  `environment_id` bigint UNSIGNED NOT NULL COMMENT '所属环境ID',
  `case_id` bigint UNSIGNED NOT NULL COMMENT '所属API用例ID',
  `num` bigint UNSIGNED NULL DEFAULT 0 COMMENT '序号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API用例步骤名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API用例步骤描述',
  `assertion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应断言',
  `relation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '关联参数',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求路径',
  `method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'GET' COMMENT '请求方法 [GET POST PUT PATCH DELETE HEAD OPTIONS]',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查询参数',
  `header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求头',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `body_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求体格式 [form-data x-www-form-urlencoded json  file]',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API用例步骤表：存储用例的执行步骤' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api_case_step
-- ----------------------------
INSERT INTO `api_case_step` VALUES (45, 5, 1, 26, 1, '步骤1-查询课程分类', '获取课程分类列表，提取分类ID用于后续筛选', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data[0].id\",\"name\":\"category_id\"},{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data[0].name\",\"name\":\"category_name\"}]', '/p/online-course/v1/course/typeList', 'GET', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 16:42:44', '2026-01-18 16:42:44');
INSERT INTO `api_case_step` VALUES (46, 5, 1, 26, 2, '步骤2-按分类筛选课程', '使用提取的分类ID查询课程列表', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data.records\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.records[0].id\",\"name\":\"course_id\"},{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.records[0].name\",\"name\":\"course_name\"}]', '/p/online-course/v2/course/page', 'GET', '[{\"key\":\"current\",\"value\":\"1\"},{\"key\":\"size\",\"value\":\"10\"},{\"key\":\"keyword\",\"value\":\"\"},{\"key\":\"typeConfigId\",\"value\":\"{{category_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 16:42:44', '2026-01-18 16:42:44');
INSERT INTO `api_case_step` VALUES (47, 5, 1, 26, 3, '步骤3-查询课程详情', '使用提取的课程ID查询课程完整信息', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data.id\",\"operator\":\"equals\",\"value\":\"{{course_id}}\"},{\"path\":\"$.data.name\",\"operator\":\"notNull\"},{\"path\":\"$.data.courseDuration\",\"operator\":\"notNull\"}]}', NULL, '/p/online-course/v2/course/info', 'GET', '[{\"key\":\"id\",\"value\":\"{{course_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 16:42:44', '2026-01-18 16:42:44');
INSERT INTO `api_case_step` VALUES (48, 5, 2, 27, 1, '步骤1-查询考试列表', '获取独立考试分页列表', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data.list\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.list[0].id\",\"name\":\"exam_id\"},{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.list[0].examName\",\"name\":\"exam_name\"}]', '/alone-exam/v1/getAloneExamPage', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '{\"current\":1,\"size\":10,\"keyword\":\"\",\"status\":\"\"}', 'JSON', '2026-01-18 16:49:52', '2026-01-18 16:49:52');
INSERT INTO `api_case_step` VALUES (49, 5, 2, 27, 2, '步骤2-查询考试详情', '使用提取的考试ID查询考试详细信息', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data.id\",\"operator\":\"equals\",\"value\":\"{{exam_id}}\"},{\"path\":\"$.data.examName\",\"operator\":\"notNull\"}]}', NULL, '/alone-exam/v1/getAlongExam', 'GET', '[{\"key\":\"id\",\"value\":\"{{exam_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 16:49:52', '2026-01-18 16:49:52');
INSERT INTO `api_case_step` VALUES (50, 5, 2, 27, 3, '步骤3-查询考试配置', '查询考试的题目配置和评分规则', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data\",\"operator\":\"notNull\"}]}', NULL, '/alone-exam/v1/getAloneExamConf', 'GET', '[{\"key\":\"id\",\"value\":\"{{exam_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Cookie\",\"value\":\"lianjia_token=xxx; renovation-token=xxx\"}]', '[]', 'JSON', '2026-01-18 16:49:52', '2026-01-18 16:49:52');
INSERT INTO `api_case_step` VALUES (51, 5, 1, 28, 1, '步骤1-查询用户证书列表', '获取用户所有证书', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data[0].certificateId\",\"name\":\"certificate_id\"},{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data[0].certificateName\",\"name\":\"certificate_name\"}]', '/free-certificate/v1/certificate/list', 'GET', '[{\"key\":\"userCode\",\"value\":\"TEST_USER_CODE\"},{\"key\":\"trainId\",\"value\":\"\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:53:44', '2026-01-18 16:53:44');
INSERT INTO `api_case_step` VALUES (52, 5, 1, 28, 2, '步骤2-获取证书图片/PDF', '使用提取的证书ID获取证书图片或PDF', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.errno\",\"operator\":\"equals\",\"value\":\"0\"},{\"path\":\"$.data\",\"operator\":\"notNull\"}]}', NULL, '/free-certificate/v1/certificate/picture', 'GET', '[{\"key\":\"certificateId\",\"value\":\"{{certificate_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 16:53:44', '2026-01-18 16:53:44');
INSERT INTO `api_case_step` VALUES (53, 5, 4, 30, 1, '步骤1-查询用户成长数据', '获取用户公益分、公益币等成长数据', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.code\",\"operator\":\"equals\",\"value\":0},{\"path\":\"$.data.publicWelfarePoints\",\"operator\":\"notNull\"},{\"path\":\"$.data.publicWelfareCoins\",\"operator\":\"notNull\"},{\"path\":\"$.data.growthLevel\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.publicWelfarePoints\",\"name\":\"user_points\"},{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.publicWelfareCoins\",\"name\":\"user_coins\"}]', '/growth-system/v1/getUserGrowthInfo', 'GET', '[{\"key\":\"userCode\",\"value\":\"TEST_USER_CODE\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 17:02:05', '2026-01-18 17:02:05');
INSERT INTO `api_case_step` VALUES (54, 5, 4, 30, 2, '步骤2-查询公益币流水明细', '获取用户公益币获取和消费明细，验证数据一致性', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.code\",\"operator\":\"equals\",\"value\":0},{\"path\":\"$.data.list\",\"operator\":\"notNull\"}]}', NULL, '/growth-system/v1/getPointsFlow', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"TEST_USER_CODE\",\"current\":1,\"size\":20}', 'JSON', '2026-01-18 17:02:05', '2026-01-18 17:02:05');
INSERT INTO `api_case_step` VALUES (55, 5, 6, 31, 1, '步骤1-发起PK挑战', '用户发起PK挑战', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.code\",\"operator\":\"equals\",\"value\":0},{\"path\":\"$.data.pkId\",\"operator\":\"notNull\"}]}', '[{\"from\":\"response_body\",\"type\":\"jsonPath\",\"express\":\"$.data.pkId\",\"name\":\"pk_id\"}]', '/pk/v1/startPK', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"USER_A\",\"targetUserCode\":\"USER_B\",\"pkType\":1,\"duration\":7}', 'JSON', '2026-01-18 17:02:36', '2026-01-18 17:02:36');
INSERT INTO `api_case_step` VALUES (56, 5, 6, 31, 2, '步骤2-查询PK实时结果', '使用提取的PK ID查询PK结果和排名', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.code\",\"operator\":\"equals\",\"value\":0},{\"path\":\"$.data.pkStatus\",\"operator\":\"notNull\"},{\"path\":\"$.data.myRank\",\"operator\":\"notNull\"}]}', NULL, '/pk/v1/getPKResult', 'GET', '[{\"key\":\"pkId\",\"value\":\"{{pk_id}}\"}]', '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '[]', 'JSON', '2026-01-18 17:02:36', '2026-01-18 17:02:36');
INSERT INTO `api_case_step` VALUES (57, 5, 6, 31, 3, '步骤3-查询我的所有PK记录', '查询用户所有PK记录，验证新创建的PK是否在列表中', '{\"responseCode\":200,\"jsonPath\":[{\"path\":\"$.code\",\"operator\":\"equals\",\"value\":0},{\"path\":\"$.data.list\",\"operator\":\"notNull\"}]}', NULL, '/pk/v1/getMyPKList', 'POST', NULL, '[{\"key\":\"Content-Type\",\"value\":\"application/json\"},{\"key\":\"Authorization\",\"value\":\"Bearer token_value\"}]', '{\"userCode\":\"USER_A\",\"current\":1,\"size\":10,\"status\":\"\"}', 'JSON', '2026-01-18 17:02:36', '2026-01-18 17:02:36');

-- ----------------------------
-- Table structure for api_module
-- ----------------------------
DROP TABLE IF EXISTS `api_module`;
CREATE TABLE `api_module`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` bigint UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API模块名称',
  `gmt_create` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'API模块表：用于组织和管理接口' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api_module
-- ----------------------------
INSERT INTO `api_module` VALUES (26, 5, '课程模块', '2026-01-18 14:39:46', '2026-01-18 14:39:50');
INSERT INTO `api_module` VALUES (30, 5, '考试模块', '2026-01-18 15:39:27', '2026-01-18 15:39:36');
INSERT INTO `api_module` VALUES (31, 5, '证书模块', '2026-01-18 15:45:13', '2026-01-18 15:45:24');
INSERT INTO `api_module` VALUES (32, 6, '成长体系', '2026-01-18 16:05:35', '2026-01-18 16:06:03');
INSERT INTO `api_module` VALUES (33, 6, 'PK功能模块', '2026-01-18 16:09:53', '2026-01-18 16:10:08');
INSERT INTO `api_module` VALUES (34, 6, '徽章模块', '2026-01-18 16:10:31', '2026-01-18 16:10:49');

SET FOREIGN_KEY_CHECKS = 1;
