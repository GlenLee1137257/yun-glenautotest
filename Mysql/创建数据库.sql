-- ============================================
-- 云测平台数据库创建脚本
-- 生成日期: 2026年1月11日
-- 说明: 在Navicat中执行此脚本创建所有需要的数据库
-- ============================================

-- 1. 账号权限数据库
CREATE DATABASE IF NOT EXISTS glen_account DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 2. 接口自动化数据库
CREATE DATABASE IF NOT EXISTS glen_api DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 3. UI自动化数据库
CREATE DATABASE IF NOT EXISTS glen_ui DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 4. 压力测试数据库
CREATE DATABASE IF NOT EXISTS glen_stress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 5. 引擎服务数据库
CREATE DATABASE IF NOT EXISTS glen_engine DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 6. 定时任务数据库
CREATE DATABASE IF NOT EXISTS glen_job DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 7. 系统字典数据库
CREATE DATABASE IF NOT EXISTS glen_dict DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 8. Nacos配置数据库
CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 查看所有创建的数据库
SHOW DATABASES;
