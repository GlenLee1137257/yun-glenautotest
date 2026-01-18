# 📊 Glen自动化测试平台 - 数据库初始化指南

> **执行环境**: Navicat连接到MySQL (localhost:3307)  
> **MySQL密码**: glen123456  
> **生成时间**: 2026-01-17

---

## 📋 执行步骤

### 第一步：创建所有数据库

**在Navicat中执行以下SQL** (或执行文件 `创建数据库.sql`)：

```sql
-- ============================================
-- 云测平台数据库创建脚本
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

-- 8. Nacos配置数据库 (已创建,跳过)
-- CREATE DATABASE IF NOT EXISTS nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 查看所有创建的数据库
SHOW DATABASES;
```

---

### 第二步：导入各数据库的表结构和数据

**在Navicat中按照以下顺序导入SQL文件**：

#### 1️⃣ glen_account (账号权限数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_account`
2. 右键 -> "运行SQL文件..."
3. 依次执行以下SQL文件：

```
📁 Mysql/account_sql/account.sql              # 主表结构和基础数据
📁 Mysql/02-glen_account-data.sql             # 补充数据
📁 Mysql/12-permission-data.sql               # 权限数据
```

**包含的表**：
- sys_user (用户表)
- sys_role (角色表)
- sys_permission (权限表)
- sys_user_role (用户角色关系表)
- sys_role_permission (角色权限关系表)

---

#### 2️⃣ glen_api (接口自动化数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_api`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/dcloud_api_sql/dcloud_api.sql        # API测试相关表
```

**包含的表**：
- api_project (API项目表)
- api_module (API模块表)
- api_case (API用例表)
- api_report (API报告表)
- api_environment (API环境表)

---

#### 3️⃣ glen_ui (UI自动化数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_ui`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/dcloud_ui_sql/dcloud_ui_sql.sql      # UI测试相关表
📁 Mysql/web_ui_detail_sql/web_ui_detail_sql.sql  # UI详情表(可选)
```

**包含的表**：
- ui_project (UI项目表)
- ui_module (UI模块表)
- ui_case (UI用例表)
- ui_report (UI报告表)
- ui_element (UI元素表)

---

#### 4️⃣ glen_stress (压力测试数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_stress`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/dcloud_stress_sql/dcloud_stress.sql  # 压测相关表
```

**包含的表**：
- stress_project (压测项目表)
- stress_scenario (压测场景表)
- stress_report (压测报告表)

---

#### 5️⃣ glen_engine (引擎服务数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_engine`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/创建project表_glen_engine.sql        # 项目表
📁 Mysql/创建stress_case_module表_glen_engine.sql  # 压测用例模块表
```

**包含的表**：
- project (项目表)
- stress_case_module (压测用例模块表)

---

#### 6️⃣ glen_job (定时任务数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_job`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/job_sql/job.sql                      # 定时任务表
```

**包含的表**：
- job_info (任务信息表)
- job_log (任务日志表)

---

#### 7️⃣ glen_dict (系统字典数据库)

**操作步骤**：
1. 在Navicat中选择数据库 `glen_dict`
2. 右键 -> "运行SQL文件..."
3. 执行以下SQL文件：

```
📁 Mysql/sys_dict/sys_dict.sql                # 系统字典表(推荐)
或
📁 Mysql/sys_dict/sys_dict_navicat.sql        # Navicat专用版本
```

**包含的表**：
- sys_dict (系统字典表)

---

### 第三步：修复中文编码问题(可选)

如果导入后发现中文乱码，执行以下文件：

```
📁 Mysql/13-fix-chinese-encoding.sql          # 修复中文编码
```

---

## ✅ 验证导入结果

### 方法1: 在Navicat中验证

1. 刷新数据库列表
2. 展开各数据库，查看表是否正确创建
3. 随机打开几个表，查看是否有数据

### 方法2: 执行SQL验证

在Navicat查询窗口执行：

```sql
-- 检查各数据库的表数量
SELECT 
    table_schema AS '数据库',
    COUNT(*) AS '表数量'
FROM information_schema.tables 
WHERE table_schema IN (
    'glen_account', 'glen_api', 'glen_ui', 
    'glen_stress', 'glen_engine', 'glen_job', 
    'glen_dict', 'nacos_config'
)
GROUP BY table_schema
ORDER BY table_schema;

-- 检查glen_account数据库的用户数量
SELECT COUNT(*) AS '用户数量' FROM glen_account.sys_user;

-- 检查系统字典数据
SELECT COUNT(*) AS '字典数量' FROM glen_dict.sys_dict;
```

**期望结果**：
- glen_account: 至少5个表，有用户数据
- glen_api: 至少5个表
- glen_ui: 至少5个表
- glen_stress: 至少3个表
- glen_engine: 至少2个表
- glen_job: 至少2个表
- glen_dict: 至少1个表，有字典数据
- nacos_config: 12个表(已完成)

---

## 📝 SQL文件清单汇总

### 必须执行的SQL文件(按顺序)：

| 序号 | 数据库 | SQL文件路径 | 说明 |
|-----|--------|------------|------|
| 1 | - | `创建数据库.sql` | 创建所有数据库 |
| 2 | glen_account | `account_sql/account.sql` | 账号表结构 |
| 3 | glen_account | `02-glen_account-data.sql` | 账号数据 |
| 4 | glen_account | `12-permission-data.sql` | 权限数据 |
| 5 | glen_api | `dcloud_api_sql/dcloud_api.sql` | API表结构 |
| 6 | glen_ui | `dcloud_ui_sql/dcloud_ui_sql.sql` | UI表结构 |
| 7 | glen_stress | `dcloud_stress_sql/dcloud_stress.sql` | 压测表结构 |
| 8 | glen_engine | `创建project表_glen_engine.sql` | 项目表 |
| 9 | glen_engine | `创建stress_case_module表_glen_engine.sql` | 压测模块表 |
| 10 | glen_job | `job_sql/job.sql` | 任务表结构 |
| 11 | glen_dict | `sys_dict/sys_dict.sql` | 字典表数据 |

### 可选执行的SQL文件：

| 序号 | 数据库 | SQL文件路径 | 说明 |
|-----|--------|------------|------|
| 1 | glen_ui | `web_ui_detail_sql/web_ui_detail_sql.sql` | UI详情补充 |
| 2 | 所有 | `13-fix-chinese-encoding.sql` | 修复编码问题 |

---

## 🚨 常见问题

### Q1: Navicat连接MySQL失败？
**A**: 确认连接信息：
- 主机: `localhost` 或 `127.0.0.1`
- 端口: `3307` (注意不是3306!)
- 用户名: `root`
- 密码: `glen123456`

### Q2: 执行SQL时报错"数据库不存在"？
**A**: 先执行 `创建数据库.sql` 创建所有数据库

### Q3: 导入后中文显示乱码？
**A**: 执行 `13-fix-chinese-encoding.sql` 修复编码

### Q4: 某个SQL文件执行失败？
**A**: 查看错误信息，可能是：
- 表已存在(可忽略)
- 字段冲突(检查是否重复执行)
- 语法错误(联系管理员)

---

## 💡 快速导入提示

### 方式1: Navicat批量导入(推荐)

1. 在Navicat左侧选择MySQL连接
2. 点击"工具" -> "运行SQL文件"
3. 选择目标数据库
4. 选择SQL文件并执行

### 方式2: Navicat拖拽导入

1. 打开Navicat查询窗口
2. 将SQL文件拖入查询窗口
3. 点击"运行"按钮

### 方式3: 命令行批量导入(Linux/WSL)

如果您想使用命令行方式，切换到终端执行：

```bash
cd /home/hinkad/yun-glenautotest/Mysql

# 批量导入脚本(推荐使用Navicat)
docker exec -i glen-mysql mysql -uroot -pglen123456 glen_account < account_sql/account.sql
docker exec -i glen-mysql mysql -uroot -pglen123456 glen_account < 02-glen_account-data.sql
# ... 其他导入命令
```

---

## 📊 导入完成后的下一步

1. ✅ 验证所有表已正确创建
2. ✅ 检查是否有用户数据
3. ⏭️ 修改后端配置文件(application.yml)
4. ⏭️ 编译并启动后端服务
5. ⏭️ 启动前端服务

---

**文档生成时间**: 2026-01-17  
**MySQL连接**: localhost:3307  
**所有SQL文件位置**: `/home/hinkad/yun-glenautotest/Mysql/`
