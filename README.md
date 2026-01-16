# Glen 自动化云测平台

> 一个功能完善的自动化测试平台，支持接口自动化、UI自动化、压力测试等多种测试场景。

## 📋 项目简介

Glen 自动化云测平台是一个基于 Spring Boot 3.x 和 Vue 3 开发的现代化自动化测试平台，提供完整的测试管理、执行和报告功能。

## 🏗️ 项目结构

```
yun-glenautotest/
├── backend/                    # 后端服务（Spring Boot 3.0.2）
│   ├── glen-gateway/          # 网关服务 (8000)
│   ├── glen-account/          # 账号权限服务 (8081)
│   ├── glen-data/             # 数据服务 (8082)
│   ├── glen-engine/           # 引擎服务 (8083)
│   ├── glen-common/           # 公共模块
│   ├── pom.xml               # Maven 父配置
│   └── build.sh              # 后端构建脚本
│
├── frontend/                   # 前端应用（Vue 3.4.4）
│   ├── src/                   # 源代码
│   ├── dist/                  # 生产构建目录
│   ├── public/                # 静态资源
│   ├── package.json           # 依赖配置
│   ├── vite.config.ts         # Vite 配置
│   └── build.sh              # 前端构建脚本
│
├── Mysql/                     # 数据库脚本
│   ├── 创建数据库.sql         # 数据库创建脚本
│   ├── 02-glen_account-data.sql  # 初始管理员数据
│   ├── 10-nacos_config-schema.sql  # Nacos 配置表
│   ├── 10-nacos_missing_tables.sql  # Nacos 缺失表修复
│   ├── 11-nacos_default_user.sql  # Nacos 默认用户
│   ├── 12-permission-data.sql  # 权限数据
│   ├── 13-fix-chinese-encoding.sql  # 中文编码修复
│   ├── account_sql/          # 各模块SQL脚本
│   ├── dcloud_api_sql/
│   ├── dcloud_ui_sql/
│   ├── dcloud_stress_sql/
│   ├── job_sql/
│   └── sys_dict/
│
├── docker-compose.yml         # Docker 编排配置
├── mysql.cnf               # MySQL 字符集配置
├── .env.dev               # 开发环境变量
├── .env.prod.template       # 生产环境模板
├── start.sh               # 一键启动脚本
└── README.md              # 本文档
```

## 🛠️ 技术栈

### 后端
- **框架**: Spring Boot 3.0.2
- **微服务**: Spring Cloud 2022.0.0
- **服务注册**: Nacos 2.2.3
- **数据库**: MySQL 8.0 (utf8mb4)
- **缓存**: Redis 7.0
- **消息队列**: Kafka 3.5
- **对象存储**: MinIO
- **构建工具**: Maven 3.8+
- **网关**: Spring Cloud Gateway

### 前端
- **框架**: Vue 3.4.4
- **构建工具**: Vite 5.0.10
- **语言**: TypeScript
- **UI 框架**: Ant Design Vue 4.0.8
- **状态管理**: Pinia
- **包管理器**: pnpm 8
- **HTTP 客户端**: VueUse

### 基础设施
- **容器**: Docker & Docker Compose
- **Web 服务器**: Nginx
- **进程管理**: Systemd

## 🚀 快速开始

### 环境要求

- **JDK**: 17+
- **Node.js**: 18+
- **Maven**: 3.8+
- **pnpm**: 8+
- **Docker**: 20+
- **Docker Compose**: 2+
- **Nginx**: 1.18+

### 1. 克隆项目

```bash
git clone <repository-url>
cd yun-glenautotest
```

### 2. 启动基础服务（Docker）

```bash
# 启动 MySQL、Redis、Nacos、Kafka、MinIO
./start.sh

# 或者手动启动
docker compose up -d
```

**等待服务就绪（约1-2分钟）**，可以访问：
- Nacos 控制台: http://localhost:8848/nacos (用户名/密码: nacos/nacos)
- MinIO 控制台: http://localhost:9001 (用户名/密码: admin/glen123456)

### 3. 初始化数据库

所有 SQL 脚本在 `Mysql/` 目录下：

```bash
# 使用 Navicat 或 MySQL 客户端连接后执行以下脚本

# 1. 创建数据库
Mysql/创建数据库.sql

# 2. 账号模块表结构
Mysql/account_sql/account.sql

# 3. 各业务模块表结构
Mysql/创建project表_glen_engine.sql
Mysql/创建stress_case_module表_glen_engine.sql

# 4. 初始数据
Mysql/02-glen_account-data.sql

# 5. 权限数据
Mysql/12-permission-data.sql

# 6. Nacos 配置表
Mysql/10-nacos_config-schema.sql
Mysql/10-nacos_missing_tables.sql
Mysql/11-nacos_default_user.sql

# 如遇中文乱码，执行修复脚本
Mysql/13-fix-chinese-encoding.sql
```

#### 数据库连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | `115.190.216.91` 或 `localhost` |
| 端口 | `3306` |
| 用户名 | `root` |
| 密码 | `glen123456` |

#### 可用数据库

| 数据库名称 | 说明 |
|-----------|------|
| glen_account | 账号权限 |
| glen_api | 接口数据 |
| glen_dict | 数据字典 |
| glen_engine | 测试引擎 |
| glen_job | 定时任务 |
| glen_stress | 压力测试 |
| glen_ui | UI 自动化 |
| nacos_config | Nacos 配置 |

> **注意**: MySQL 已配置 utf8mb4 字符集，确保 Navicat 连接时使用 utf8mb4 编码。

### 4. 配置 Nacos

访问 Nacos 控制台，为每个服务创建配置文件：
- `glen-gateway.properties`
- `glen-account.properties`
- `glen-engine.properties`
- `glen-data.properties`

参考 `backend/glen-*/src/main/resources/application.properties` 中的配置。

### 5. 启动后端服务

#### 方式一：Maven 命令（推荐开发环境）

```bash
# 构建所有模块
cd backend
./build.sh



# 启动各个服务（新开4个终端）
cd backend/glen-gateway && mvn spring-boot:run
cd backend/glen-account && mvn spring-boot:run
cd backend/glen-engine && mvn spring-boot:run
cd backend/glen-data && mvn spring-boot:run
```

#### 方式二：打包后运行

```bash
cd backend
./build.sh

java -jar glen-gateway/target/glen-gateway.jar &
java -jar glen-account/target/glen-account.jar &
java -jar glen-engine/target/glen-engine.jar &
java -jar glen-data/target/glen-data.jar &
```

### 6. 启动前端

#### 开发模式（推荐）

```bash
cd frontend
pnpm install
pnpm run dev
```

访问：http://localhost:5173

#### 生产模式

```bash
cd frontend
./build.sh  # 构建静态文件到 dist/ 目录

# Nginx 配置已设置，自动服务 dist/ 目录
sudo systemctl reload nginx
```

访问：http://localhost 或 http://115.190.216.91

### 7. 配置 Nginx（可选）

Nginx 配置文件位置：`/etc/nginx/sites-available/glen-frontend`

```nginx
server {
    listen 80;
    server_name 115.190.216.91;

    root /opt/yun-glenautotest/frontend/dist;

    # 后端服务代理
    location ~ ^/(account-service|engine-service|data-service)/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🔐 测试账号

| 用户名 | 密码 | identityType | 说明 |
|--------|------|-------------|------|
| admin | admin123 | mail | 系统管理员 |
| testuser | test123 | phone | 测试账号 |

## 🎯 主要功能

### 1. 接口自动化测试
- HTTP 请求测试
- 接口用例管理
- 批量执行
- 断言验证
- 测试报告

### 2. UI 自动化测试
- Selenium WebDriver 集成
- 元素定位管理
- UI 用例编排
- 录制回放
- 截图报告

### 3. 压力测试
- JMeter 集成
- 并发压测
- 性能指标统计
- TPS/响应时间分析

### 4. 定时任务
- Cron 表达式定时
- 定时执行测试
- 邮件通知

### 5. 权限管理
- 角色权限控制（RBAC）
- 用户管理
- 项目隔离
- 权限：PROJECT_AUTH, PROJECT_READ_WRITE, PROJECT_READ_ONLY

## 🔧 配置说明

### 环境变量

开发环境使用 `.env.dev`：
```bash
MYSQL_ROOT_PASSWORD=glen123456
REDIS_PASSWORD=glen123456
NACOS_SERVER_ADDR=localhost:8848
# ... 其他配置
```

生产环境创建 `.env.prod`：
```bash
cp .env.prod.template .env.prod
# 编辑 .env.prod，填写实际值
```

### MySQL 字符集配置

项目已配置 `mysql.cnf` 文件确保中文正确显示：

```ini
[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4

[mysqld]
init-connect='SET NAMES utf8mb4'
```

如遇中文乱码，可执行 `Mysql/13-fix-chinese-encoding.sql` 修复。

### Chrome Driver 配置

UI 自动化需要 ChromeDriver，可以通过环境变量指定：

```bash
export CHROME_DRIVER_PATH=/usr/bin/chromedriver
```

或使用默认路径：
- **Mac**: `/usr/local/bin/chromedriver`
- **Linux**: `/usr/bin/chromedriver`
- **Windows**: `C:\Program Files\chromedriver.exe`

## 📦 构建与部署

### Docker 构建

```bash
# 后端服务
cd backend/glen-gateway
docker build -t glen-gateway:latest .

cd backend/glen-account
docker build -t glen-account:latest .

cd backend/glen-engine
docker build -t glen-engine:latest .

cd backend/glen-data
docker build -t glen-data:latest .
```

### 生产部署

1. 修改 `docker-compose.yml` 中的环境变量
2. 创建 `.env.prod` 配置文件
3. 启动所有服务：
   ```bash
   docker compose --env-file .env.prod up -d
   ```
4. 配置 Nginx 反向代理
5. 设置 SSL 证书（可选）

## 🔌 访问地址

| 环境 | 地址 | 说明 |
|------|------|------|
| 前端开发 | `http://115.190.216.91:5173` | Vite 开发服务器，热更新 |
| 前端生产 | `http://115.190.216.91` | Nginx 静态服务 |
| Nacos 控制台 | `http://115.190.216.91:8848/nacos` | nacos/nacos |
| MinIO 控制台 | `http://115.190.216.91:9001` | admin/glen123456 |

> **注意**: 前端开发和生产共享相同的后端服务和数据库，只是代码运行方式不同。

## 🐛 常见问题

### 1. 数据库连接失败
- 检查 MySQL 是否启动：`docker compose ps`
- 检查数据库密码是否正确（`glen123456`）
- 确认所有数据库已创建（共 8 个数据库）
- 确认 Navicat 连接使用 utf8mb4 编码

### 2. Nacos 连接失败
- 等待 Nacos 完全启动（约30秒）
- 检查 Nacos 控制台是否可访问
- 确认配置文件已在 Nacos 创建
- 检查用户名/密码：nacos/nacos

### 3. 前端无法访问后端
- 检查所有后端服务是否启动（8000, 8081, 8082, 8083）
- 检查网关服务（8000端口）是否正常
- 检查 Nacos 服务注册是否成功
- 确认 Vite 代理配置正确（vite.config.ts）

### 4. 中文显示乱码
- 确认 MySQL 使用 utf8mb4 字符集
- 确认 Navicat 连接编码为 utf8mb4
- 执行 `Mysql/13-fix-chinese-encoding.sql` 修复已有数据

### 5. UI 自动化测试失败
- 安装 ChromeDriver
- 设置 `CHROME_DRIVER_PATH` 环境变量
- Linux 环境需要安装 Chrome 浏览器依赖

### 6. 权限错误
- 确认用户已分配角色
- 确认角色已分配权限
- 执行 `Mysql/12-permission-data.sql` 初始化权限

## 📝 开发指南

### 代码规范
- 后端：遵循 Spring Boot 最佳实践
- 前端：使用 ESLint + Prettier
- 提交信息：使用 Conventional Commits 格式

### 分支管理
- `main`: 主分支
- `refactor-consolidation`: 重构分支
- `feature/*`: 新功能分支
- `bugfix/*`: 错误修复分支

### API 调试

```bash
# 登录获取 token
TOKEN=$(curl -s -X POST http://localhost:8000/account-service/api/v1/account/login \
  -H "Content-Type: application/json" \
  -d '{"identifier":"testuser","credential":"test123","identityType":"phone"}' | \
  jq -r '.data.tokenValue')

# 使用 token 调用其他接口
curl -X GET http://localhost:8000/account-service/api/v1/account/findLoginAccountRole \
  -H "satoken: $TOKEN"
```

## 📄 许可证

Copyright © 2026 Glen AutoTest Platform

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题，请提交 Issue 或联系项目维护者。

---

**Glen AutoTest Platform** - 让自动化测试更简单！
