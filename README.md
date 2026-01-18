# 🚀 Glen自动化测试平台

> 基于 Spring Cloud 微服务架构的企业级自动化测试平台，支持接口自动化测试、UI自动化测试、压力测试等多种测试场景

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.0.2-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Vue](https://img.shields.io/badge/Vue-3.4.4-4FC08D.svg)](https://vuejs.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📋 目录

- [项目简介](#-项目简介)
- [功能特性](#-功能特性)
- [技术栈](#-技术栈)
- [系统架构](#-系统架构)
- [快速开始](#-快速开始)
- [环境要求](#-环境要求)
- [项目结构](#-项目结构)
- [部署指南](#-部署指南)
- [使用说明](#-使用说明)
- [配置说明](#-配置说明)
- [常见问题](#-常见问题)
- [贡献指南](#-贡献指南)

---

## 🎯 项目简介

Glen自动化测试平台是一个企业级自动化测试解决方案，采用微服务架构设计，支持多种测试场景。平台提供了完整的测试用例管理、测试执行、测试报告等功能，帮助团队提高测试效率和质量。

### 核心优势

- ✅ **微服务架构** - 基于 Spring Cloud 的分布式架构，服务解耦，易于扩展
- ✅ **容器化部署** - Docker 容器化部署，环境一致性高
- ✅ **权限管理** - 基于 Sa-Token 的细粒度权限控制
- ✅ **多场景支持** - 支持接口、UI、压力测试多种场景
- ✅ **异步任务** - 基于 Kafka 的异步任务处理
- ✅ **文件存储** - MinIO 对象存储，支持大文件上传

---

## ✨ 功能特性

### 🔐 账号权限管理
- 用户登录注册
- 角色权限管理
- 细粒度权限控制
- 多登录方式支持

### 📦 项目管理
- 项目创建和管理
- 项目权限分配
- 项目数据统计

### 🔌 接口自动化测试
- 接口用例管理
- 接口测试执行
- 测试报告生成
- 支持多种请求方式

### 🖥️ UI自动化测试
- UI用例管理
- Selenium驱动
- 元素定位管理
- UI元素库

### ⚡ 压力测试
- JMeter脚本管理
- 压测任务执行
- 压测报告分析

### ⏰ 定时任务
- 任务调度管理
- 定时执行测试
- 任务监控

---

## 🛠️ 技术栈

### 后端技术

| 技术 | 版本 | 说明 |
|------|------|------|
| **Spring Boot** | 3.0.2 | 微服务框架 |
| **Spring Cloud** | 2022.0.0 | 微服务治理 |
| **Spring Cloud Alibaba** | 2022.0.0.0-RC2 | 阿里云微服务组件 |
| **MyBatis Plus** | 3.5.3.1 | ORM框架 |
| **Sa-Token** | 1.37.0 | 权限认证框架 |
| **JDK** | 17 | Java运行环境 |
| **Maven** | 3.9+ | 构建工具 |

### 前端技术

| 技术 | 版本 | 说明 |
|------|------|------|
| **Vue** | 3.4.4 | 前端框架 |
| **Vite** | 5.0.10 | 构建工具 |
| **TypeScript** | 5.3.3 | 类型支持 |
| **Ant Design Vue** | 4.0.8 | UI组件库 |
| **Pinia** | 2.1.7 | 状态管理 |
| **Vue Router** | 4.2.5 | 路由管理 |
| **UnoCSS** | 0.58.3 | 原子化CSS |
| **pnpm** | 8.8.0+ | 包管理器 |

### 中间件

| 组件 | 版本 | 说明 |
|------|------|------|
| **Nacos** | 2.2.1 | 服务注册与配置中心 |
| **Redis** | 7.0.8 | 缓存和会话存储 |
| **Kafka** | 3.3.2 | 消息队列（异步任务） |
| **Zookeeper** | 3.8.0 | Kafka依赖 |
| **MinIO** | latest | 对象存储（文件上传） |
| **MySQL** | 8.0 | 关系型数据库 |

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                     前端应用 (Vue3)                           │
│                    前端开发服务器                              │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  API网关 (Gateway)                            │
│                    网关服务端口                                │
└──────┬────────┬──────────┬──────────┬───────────────────────┘
       │        │          │          │
       ▼        ▼          ▼          ▼
   ┌──────┐ ┌──────┐  ┌──────┐  ┌────────┐
   │账号  │ │数据  │  │引擎  │  │Nacos   │
   │服务  │ │服务  │  │服务  │  │服务    │
   └───┬──┘ └───┬──┘  └───┬──┘  └────┬───┘
       │        │          │          │
       └────────┴──────────┴──────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
    ┌──────┐   ┌──────┐   ┌──────┐
    │MySQL │   │Redis │   │MinIO │
    │数据库 │   │缓存  │   │对象  │
    │      │   │      │   │存储  │
    └──────┘   └──────┘   └──────┘
```

> 📝 具体端口配置请参考：[项目部署指南](markdown/01-项目部署指南.md)

---

## 🚀 快速开始

### 环境要求

| 软件 | 版本要求 | 说明 |
|------|---------|------|
| **JDK** | 17+ | Java开发环境 |
| **Maven** | 3.9+ | Java构建工具 |
| **Node.js** | 18+ | 前端运行环境 |
| **pnpm** | 8.8.0+ | 前端包管理器 |
| **Docker** | 最新版 | 容器运行环境 |
| **Docker Compose** | 最新版 | 容器编排工具 |

### 一键启动（推荐）

```bash
# 克隆项目
git clone <repository-url>
cd yun-glenautotest

# 启动所有服务（包括Docker中间件、后端、前端）
./restart-all.sh
```

### 分步启动

#### 1. 启动Docker中间件

```bash
# 启动MySQL、Redis、Nacos、Kafka、MinIO等中间件
docker compose up -d
```

#### 2. 初始化数据库

```bash
# 自动执行所有SQL脚本
./init-database.sh

# 或手动导入SQL文件到Navicat
# 详见 markdown/01-项目部署指南.md
```

#### 3. 启动后端服务

```bash
# 启动所有后端微服务
./start-backend.sh

# 或手动启动单个服务
cd backend/glen-gateway
mvn spring-boot:run
```

#### 4. 启动前端服务

```bash
# 启动前端应用
./start-frontend.sh

# 或手动启动
cd frontend
pnpm install
pnpm run dev
```

---

## 📁 项目结构

```
yun-glenautotest/
├── backend/                 # 后端服务
│   ├── glen-gateway/        # API网关服务
│   ├── glen-account/        # 账号服务
│   ├── glen-data/           # 数据服务
│   ├── glen-engine/         # 引擎服务（核心业务）
│   └── glen-common/         # 公共模块
├── frontend/                # 前端应用
│   ├── src/                 # 源代码
│   ├── public/              # 静态资源
│   └── package.json         # 依赖配置
├── Mysql/                   # 数据库SQL脚本
│   ├── glen_account.sql     # 账号数据库
│   ├── glen_api.sql         # API数据库
│   └── ...                  # 其他数据库脚本
├── markdown/                # 项目文档
│   ├── 01-项目部署指南.md
│   ├── 02-项目分析介绍.md
│   └── 03-系统账号密码.md
├── docker-compose.yml       # Docker编排配置
├── start-backend.sh         # 后端启动脚本
├── start-frontend.sh        # 前端启动脚本
├── restart-all.sh           # 一键启动脚本
└── README.md                # 项目说明文档
```

---

## 📖 部署指南

详细的部署文档请参考：[项目部署指南](markdown/01-项目部署指南.md)

### Docker中间件部署

```bash
# 启动所有中间件
docker compose up -d

# 查看服务状态
docker compose ps

# 停止所有服务
docker compose down
```

### 后端服务部署

```bash
# 启动所有后端服务
./start-backend.sh

# 停止所有后端服务
./stop-backend.sh

# 重启所有后端服务
./restart-backend.sh
```

### 前端服务部署

```bash
# 启动前端服务
./start-frontend.sh

# 或手动启动
cd frontend
pnpm install
pnpm run dev
```

---

## 💻 使用说明

### 访问地址

启动成功后，您可以通过以下服务访问系统：

| 服务 | 说明 |
|------|------|
| **前端应用** | 主要访问入口，提供Web界面 |
| **API网关** | 统一API入口，负责路由和权限控制 |
| **Nacos控制台** | 服务注册与配置中心管理界面 |
| **MinIO控制台** | 对象存储管理界面 |

> 📝 具体访问地址和端口配置请参考：[项目部署指南](markdown/01-项目部署指南.md)

### 账号信息

系统提供了默认测试账号用于快速体验功能。

> 📝 默认账号、密码和数据库连接信息请参考：[系统账号密码](markdown/03-系统账号密码.md)  
> ⚠️ **重要**：生产环境请务必修改默认密码！

### 数据库连接

系统使用MySQL作为主数据库，支持多数据库架构。

主要数据库：
- `glen_account` - 账号服务数据库
- `glen_api` - API服务数据库
- `glen_ui` - UI服务数据库
- `glen_stress` - 压力测试数据库
- `glen_engine` - 引擎服务数据库
- `glen_data` - 数据服务数据库
- `glen_job` - 任务服务数据库
- `glen_dict` - 字典服务数据库
- `nacos_config` - Nacos配置数据库

> 📝 数据库连接配置信息请参考：[系统账号密码](markdown/03-系统账号密码.md)

---

## ⚙️ 配置说明

### 后端配置

后端服务配置文件位于 `backend/*/src/main/resources/application.properties`

主要配置项：
- 数据库连接配置
- Redis配置
- Nacos配置
- MinIO配置
- Sa-Token配置

### 前端配置

前端配置文件位于 `frontend/vite.config.ts`

主要配置项：
- 开发服务器端口
- 代理配置
- 构建配置

### Docker配置

Docker配置位于 `docker-compose.yml`

主要配置项：
- 中间件端口映射
- 数据卷挂载
- 环境变量

> 📝 详细配置请参考：[完整配置手册](markdown/Glen自动化云测平台-贝好学贝壳公益-完整配置手册.md)

---

## ❓ 常见问题

### 1. 端口冲突

如果遇到端口冲突，可以修改 `docker-compose.yml` 中的端口映射配置。

```bash
# 清理端口占用
./cleanup-backend-ports.sh
```

### 2. Maven命令未找到

```bash
# 添加到PATH
export PATH=$PATH:/mnt/d/apache-maven-3.9.11/bin
source ~/.bashrc
```

### 3. 数据库连接失败

检查：
- MySQL容器是否正常运行
- 端口配置是否正确
- 用户名密码是否正确
- 数据库是否已初始化

```bash
# 检查MySQL容器状态
docker ps | grep mysql

# 查看MySQL容器日志
docker logs glen-mysql
```

> 📝 数据库连接配置请参考：[系统账号密码](markdown/03-系统账号密码.md)

### 4. Nacos启动失败

```bash
# 检查Nacos容器日志
docker logs glen-nacos

# 确认nacos_config数据库已初始化
```

> 📝 更多问题请参考：[项目部署指南](markdown/01-项目部署指南.md)

---

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 代码规范

- 遵循 Java 代码规范
- 遵循 Vue 代码规范
- 添加必要的注释
- 编写单元测试

---

## 📚 相关文档

- [项目部署指南](markdown/01-项目部署指南.md) - 详细的部署步骤
- [项目分析介绍](markdown/02-项目分析介绍.md) - 项目架构和功能说明
- [系统账号密码](markdown/03-系统账号密码.md) - 系统账号和密码信息
- [完整配置手册](markdown/Glen自动化云测平台-贝好学贝壳公益-完整配置手册.md) - 完整配置说明

---

## 📄 许可证

本项目采用 MIT 许可证。详情请参阅 [LICENSE](LICENSE) 文件。

---

## 👥 作者

- **Glen** - *项目维护者*

---

## 🙏 致谢

感谢以下开源项目的支持：

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue.js](https://vuejs.org/)
- [Nacos](https://nacos.io/)
- [MinIO](https://min.io/)
- [Ant Design Vue](https://antdv.com/)

---

## 📞 联系方式

如有问题或建议，欢迎提出 Issue 或 Pull Request。

---

<div align="center">

**如果这个项目对你有帮助，请给个 ⭐ Star 支持一下！**

Made with ❤️ by Glen

</div>
# yun-glenautotest
