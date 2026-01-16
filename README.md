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
│   ├── public/                # 静态资源
│   ├── package.json           # 依赖配置
│   └── build.sh              # 前端构建脚本
│
├── Mysql/                     # 数据库脚本
│   ├── 创建数据库.sql         # 数据库创建脚本
│   ├── 02-glen_account-data.sql  # 初始管理员数据
│   ├── 10-nacos_config-schema.sql  # Nacos 配置表
│   └── account_sql/          # 各模块SQL脚本
│       dcloud_api_sql/
│       ...
│
├── docker-compose.yml         # Docker 编排配置
├── .env.dev                   # 开发环境变量
├── .env.prod.template         # 生产环境模板
├── start.sh                   # 一键启动脚本
└── README.md                  # 本文档
```

## 🛠️ 技术栈

### 后端
- **框架**: Spring Boot 3.0.2
- **微服务**: Spring Cloud 2022.0.0
- **服务注册**: Nacos 2.2.3
- **数据库**: MySQL 8.0
- **缓存**: Redis 7.0
- **消息队列**: Kafka 3.5
- **对象存储**: MinIO
- **构建工具**: Maven 3.8+

### 前端
- **框架**: Vue 3.4.4
- **构建工具**: Vite 5.0.10
- **语言**: TypeScript
- **UI 框架**: Ant Design Vue 4.0.8
- **状态管理**: Pinia
- **包管理器**: pnpm

## 🚀 快速开始

### 环境要求

- **JDK**: 17+
- **Node.js**: 18+
- **Maven**: 3.8+
- **pnpm**: 8+
- **Docker**: 20+
- **Docker Compose**: 2+

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
docker-compose up -d
```

**等待服务就绪（约1-2分钟）**，可以访问：
- Nacos 控制台: http://localhost:8848/nacos (用户名/密码: nacos/nacos)
- MinIO 控制台: http://localhost:9001 (用户名/密码: admin/glen123456)

### 3. 初始化数据库

所有 SQL 脚本在 `Mysql/` 目录下：

```bash
# 按顺序执行以下 SQL 脚本：
# 1. 创建数据库.sql
# 2. account_sql/*.sql
# 3. dcloud_api_sql/*.sql
# 4. dcloud_ui_sql/*.sql
# 5. dcloud_stress_sql/*.sql
# 6. job_sql/*.sql
# 7. sys_dict/*.sql
# 8. 02-glen_account-data.sql (初始管理员)
```

或者使用MySQL客户端导入：
```bash
mysql -h localhost -u root -pglen123456 < Mysql/创建数据库.sql
# ... 依次导入其他脚本
```

### 4. 配置Nacos

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

```bash
cd frontend
./build.sh  # 首次运行，安装依赖并构建

# 或者开发模式
pnpm install
pnpm run dev
```

访问：http://localhost:5173

## 🔐 默认账号

- **用户名**: admin
- **密码**: admin123

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
- 角色权限控制
- 用户管理
- 项目隔离

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
   docker-compose --env-file .env.prod up -d
   ```

## 🐛 常见问题

### 1. 数据库连接失败
- 检查 MySQL 是否启动：`docker-compose ps`
- 检查数据库密码是否正确
- 确认所有数据库已创建

### 2. Nacos 连接失败
- 等待 Nacos 完全启动（约30秒）
- 检查 Nacos 控制台是否可访问
- 确认配置文件已在 Nacos 创建

### 3. 前端无法访问后端
- 检查所有后端服务是否启动
- 检查网关服务（8000端口）是否正常
- 检查 Nacos 服务注册是否成功

### 4. UI 自动化测试失败
- 安装 ChromeDriver
- 设置 `CHROME_DRIVER_PATH` 环境变量
- Linux 环境需要安装 Chrome 浏览器依赖

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

## 📄 许可证

Copyright © 2026 Glen AutoTest Platform

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题，请提交 Issue 或联系项目维护者。

---

**Glen AutoTest Platform** - 让自动化测试更简单！
