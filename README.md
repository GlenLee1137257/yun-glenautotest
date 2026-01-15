# Glen自动化云测平台

> 一个功能完善的自动化测试平台，支持接口自动化、UI自动化、压力测试等多种测试场景。

## 📋 项目简介

Glen自动化云测平台是一个基于 Spring Boot 3.x 和 Vue 3 开发的现代化自动化测试平台，提供完整的测试管理、执行和报告功能。

## 🏗️ 项目结构

```
glen-autotest/
├── backend/                    # 后端服务（Spring Boot）
│   └── glen-autotest/
│       ├── glen-account/      # 账号权限服务
│       ├── glen-api/          # 接口自动化服务
│       ├── glen-data/         # 数据服务
│       ├── glen-engine/       # 引擎服务
│       ├── glen-gateway/      # 网关服务
│       └── glen-common/       # 公共模块
│
└── frontend/                  # 前端应用（Vue 3）
    └── glen-autotest-frontend/
        ├── src/
        ├── public/
        └── package.json
```

## 🛠️ 技术栈

### 后端
- **框架**: Spring Boot 3.x
- **数据库**: MySQL 8.0
- **缓存**: Redis 7.x
- **服务注册**: Nacos 2.x
- **消息队列**: Kafka
- **对象存储**: MinIO
- **构建工具**: Maven

### 前端
- **框架**: Vue 3
- **构建工具**: Vite
- **UI 框架**: Element Plus
- **包管理器**: pnpm

## 🚀 快速开始

### 环境要求

- JDK 17+
- Maven 3.8+
- Node.js 18+
- pnpm 8.8.0+
- Docker Desktop（用于中间件）

### 本地开发

详细的环境配置和启动步骤请参考：
- [项目启动指南.md](./项目启动指南.md)（如果存在）
- [云服务器部署指南.md](./云服务器部署指南.md)（如果存在）

## 📦 部署

### 云服务器部署

详细的部署步骤请参考：[云服务器部署指南.md](./云服务器部署指南.md)

## 📝 功能特性

- ✅ 接口自动化测试
- ✅ UI自动化测试
- ✅ 压力测试
- ✅ 测试计划管理
- ✅ 测试报告生成
- ✅ 用户权限管理

## 📄 许可证

[添加您的许可证信息]

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

[添加您的联系方式]
