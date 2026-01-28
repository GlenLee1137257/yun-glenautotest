-- ====================================================================
-- Glen AutoTest Platform - 角色权限配置更新脚本
-- ====================================================================
-- 功能说明：
-- 1. 为项目管理员（role_id=2）配置：读（r）、写（w）、执行（x）权限
-- 2. 为测试工程师（role_id=3）配置：读（r）、执行（x）权限
-- 
-- 权限分类：
-- - 读权限（r）：view, list 类型的权限
-- - 写权限（w）：create, edit, delete 类型的权限  
-- - 执行权限（x）：execute, toggle 类型的权限
-- ====================================================================

-- 清理旧数据（如果存在）
DELETE FROM `role_permission` WHERE `role_id` IN (2, 3);

-- ====================================================================
-- 项目管理员（role_id=2）权限配置
-- 拥有读（r）+ 写（w）+ 执行（x）权限
-- ====================================================================

-- 【项目管理模块】全部权限（id: 1-5）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 1, NOW(), NOW()),   -- 项目管理菜单
(2, 2, NOW(), NOW()),   -- 项目列表（读）
(2, 3, NOW(), NOW()),   -- 创建项目（写）
(2, 4, NOW(), NOW()),   -- 编辑项目（写）
(2, 5, NOW(), NOW());   -- 删除项目（写）

-- 【接口测试模块】全部权限（id: 10-15）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 10, NOW(), NOW()),  -- 接口测试菜单
(2, 11, NOW(), NOW()),  -- 接口列表（读）
(2, 12, NOW(), NOW()),  -- 创建接口（写）
(2, 13, NOW(), NOW()),  -- 编辑接口（写）
(2, 14, NOW(), NOW()),  -- 删除接口（写）
(2, 15, NOW(), NOW());  -- 执行接口（执行）

-- 【UI测试模块】全部权限（id: 20-25）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 20, NOW(), NOW()),  -- UI测试菜单
(2, 21, NOW(), NOW()),  -- UI用例列表（读）
(2, 22, NOW(), NOW()),  -- 创建UI用例（写）
(2, 23, NOW(), NOW()),  -- 编辑UI用例（写）
(2, 24, NOW(), NOW()),  -- 删除UI用例（写）
(2, 25, NOW(), NOW());  -- 执行UI用例（执行）

-- 【压力测试模块】全部权限（id: 30-35）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 30, NOW(), NOW()),  -- 压力测试菜单
(2, 31, NOW(), NOW()),  -- 压测用例列表（读）
(2, 32, NOW(), NOW()),  -- 创建压测用例（写）
(2, 33, NOW(), NOW()),  -- 编辑压测用例（写）
(2, 34, NOW(), NOW()),  -- 删除压测用例（写）
(2, 35, NOW(), NOW());  -- 执行压测（执行）

-- 【定时任务模块】全部权限（id: 40-45）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 40, NOW(), NOW()),  -- 定时任务菜单
(2, 41, NOW(), NOW()),  -- 任务列表（读）
(2, 42, NOW(), NOW()),  -- 创建任务（写）
(2, 43, NOW(), NOW()),  -- 编辑任务（写）
(2, 44, NOW(), NOW()),  -- 删除任务（写）
(2, 45, NOW(), NOW());  -- 启用/禁用任务（执行）

-- 【系统管理模块】部分权限（id: 50-53，仅查看权限，不包括增删改）
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 50, NOW(), NOW()),  -- 系统管理菜单
(2, 51, NOW(), NOW()),  -- 账号管理（读）
(2, 52, NOW(), NOW()),  -- 角色管理（读）
(2, 53, NOW(), NOW());  -- 权限管理（读）

-- 【项目级权限】读写权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(2, 101, NOW(), NOW()); -- 项目读写权限


-- ====================================================================
-- 测试工程师（role_id=3）权限配置
-- 拥有读（r）+ 执行（x）权限，不包括写（w）权限
-- ====================================================================

-- 【项目管理模块】只读权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 1, NOW(), NOW()),   -- 项目管理菜单
(3, 2, NOW(), NOW());   -- 项目列表（读）

-- 【接口测试模块】读 + 执行权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 10, NOW(), NOW()),  -- 接口测试菜单
(3, 11, NOW(), NOW()),  -- 接口列表（读）
(3, 15, NOW(), NOW());  -- 执行接口（执行）

-- 【UI测试模块】读 + 执行权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 20, NOW(), NOW()),  -- UI测试菜单
(3, 21, NOW(), NOW()),  -- UI用例列表（读）
(3, 25, NOW(), NOW());  -- 执行UI用例（执行）

-- 【压力测试模块】读 + 执行权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 30, NOW(), NOW()),  -- 压力测试菜单
(3, 31, NOW(), NOW()),  -- 压测用例列表（读）
(3, 35, NOW(), NOW());  -- 执行压测（执行）

-- 【定时任务模块】只读权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 40, NOW(), NOW()),  -- 定时任务菜单
(3, 41, NOW(), NOW());  -- 任务列表（读）

-- 【项目级权限】只读权限
INSERT INTO `role_permission` (`role_id`, `permission_id`, `gmt_create`, `gmt_modified`) VALUES
(3, 102, NOW(), NOW()); -- 项目只读权限


-- ====================================================================
-- 执行结果查询
-- ====================================================================
-- 查看项目管理员的权限数量（应该约35个）
SELECT 
    '项目管理员权限统计' AS `角色`,
    COUNT(*) AS `权限数量`
FROM `role_permission` 
WHERE `role_id` = 2;

-- 查看测试工程师的权限数量（应该约13个）
SELECT 
    '测试工程师权限统计' AS `角色`,
    COUNT(*) AS `权限数量`
FROM `role_permission` 
WHERE `role_id` = 3;

-- 查看超级管理员的权限数量（应该约42个）
SELECT 
    '超级管理员权限统计' AS `角色`,
    COUNT(DISTINCT `permission_id`) AS `权限数量`
FROM `role_permission` 
WHERE `role_id` = 1;

-- ====================================================================
-- 完成提示
-- ====================================================================
SELECT '✅ 角色权限配置更新完成！' AS `执行结果`;
SELECT '项目管理员：拥有读、写、执行权限（约35个）' AS `配置说明`;
SELECT '测试工程师：拥有读、执行权限（约13个）' AS `配置说明`;
