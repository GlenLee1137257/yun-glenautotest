# Glen 自动化测试平台

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-WSL2%20%7C%20Linux-orange.svg)]()
[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue.svg)]()
[![Java](https://img.shields.io/badge/Java-17%2B-red.svg)]()
[![Vue](https://img.shields.io/badge/Vue-3.x-green.svg)]()

> 一个功能强大的自动化测试平台,支持接口测试、UI测试、性能测试

---

## 📋 项目简介

Glen自动化测试平台是一个基于微服务架构的综合自动化测试解决方案,提供:

- **接口测试**: RESTful API自动化测试
- **UI测试**: Web UI自动化测试  
- **性能测试**: 压力测试和性能分析
- **测试管理**: 测试用例管理和报告生成

### 技术栈

**后端**:
- Spring Boot 2.7.x
- Spring Cloud 2021.x
- Nacos 2.2.3 (服务注册与配置)
- MySQL 8.0 (数据存储)
- Redis 7.0 (缓存)
- Kafka (消息队列)
- MinIO (对象存储)

**前端**:
- Vue 3.x
- Vite 4.x
- Element Plus
- TypeScript

---

## 🚀 快速开始

### 前置要求

- **Docker Desktop** (WSL2需在Windows上安装)
- **JDK 17+**
- **Maven 3.8+**
- **Node.js 18+**
- **pnpm 8.8.0+**

### 三步部署

```bash
# Step 1: 检查环境
./check-environment.sh

# Step 2: 安装依赖(如需要)
./setup-environment.sh

# Step 3: 启动服务
./deploy.sh
```

### 访问应用

部署完成后访问:

- **前端页面**: http://localhost:5173
- **Nacos控制台**: http://localhost:8848/nacos
- **MinIO控制台**: http://localhost:9001

**测试账号**: 13432898570 / C1137257

---

## 📚 文档导航

### 🎯 快速入门
- **[QUICKSTART.md](QUICKSTART.md)** - 3步快速部署
- **[README-DEPLOY.sh](README-DEPLOY.sh)** - 部署助手(可执行)
- **[DEPLOYMENT_GUIDE.txt](DEPLOYMENT_GUIDE.txt)** - 可视化部署指南

### 📖 详细文档
- **[DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md)** - 完整部署摘要
- **[WSL2部署指南.md](WSL2部署指南.md)** - WSL2环境专用教程
- **[部署完成总结.md](部署完成总结.md)** - 部署后验证指南
- **[PROJECT_RESOURCES.md](PROJECT_RESOURCES.md)** - 项目资源清单

### 📋 项目原有文档
- **[项目启动指南](markdown/项目启动指南.md)** - Windows本地环境
- **[云服务器部署指南](markdown/云服务器部署指南.md)** - 生产环境部署
- **[运维手册](markdown/运维手册.md)** - 日常运维操作
- **[REFACTORING_SUMMARY](markdown/REFACTORING_SUMMARY.md)** - 项目重构总结

---

## 🛠️ 部署脚本

| 脚本 | 功能 | 使用场景 |
|-----|------|---------|
| `check-environment.sh` | 检查环境依赖 | 部署前必查 |
| `setup-environment.sh` | 自动安装环境 | 首次部署 |
| `deploy.sh` | 完整部署(含编译) | 首次部署或重新部署 |
| `restart-all.sh` | 快速启动所有服务 | 日常启动 |
| `stop-all.sh` | 停止所有服务 | 日常停止 |
| `README-DEPLOY.sh` | 显示部署助手 | 查看快速指引 |

### 使用示例

```bash
# 查看部署助手
./README-DEPLOY.sh

# 检查环境
./check-environment.sh

# 首次完整部署
./deploy.sh

# 日常快速启动
./restart-all.sh

# 停止所有服务
./stop-all.sh
```

---

## 📊 系统架构

```
┌─────────────────────────────────────────┐
│         前端 Frontend (Vue3)            │
│         http://localhost:5173           │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│      API网关 glen-gateway :8000        │
└──────┬───────┬────────┬─────────────────┘
       │       │        │
       ↓       ↓        ↓
   ┌────────┐ ┌─────────┐ ┌──────────┐
   │ glen   │ │  glen   │ │  glen    │
   │ account│ │  data   │ │  engine  │
   │  :8081 │ │  :8082  │ │  :8083   │
   └────────┘ └─────────┘ └──────────┘
       │          │           │
       └──────────┴───────────┘
                  │
       ┌──────────┴─────────────────┐
       │                            │
       ↓                            ↓
   ┌────────┐  ┌──────┐  ┌──────────┐
   │ MySQL  │  │Redis │  │  Nacos   │
   │ :3306  │  │:6379 │  │  :8848   │
   └────────┘  └──────┘  └──────────┘
       ↓
   ┌────────┐  ┌──────┐
   │ Kafka  │  │MinIO │
   │ :9092  │  │:9000 │
   └────────┘  └──────┘
```

---

## 🔧 常用命令

### 服务管理

```bash
# 查看Docker容器状态
docker compose ps

# 查看后端服务
ps aux | grep spring-boot

# 查看前端服务
ps aux | grep vite

# 重启Docker服务
docker compose restart
```

### 日志查看

```bash
# 后端日志
tail -f backend/logs/gateway.log
tail -f backend/logs/account.log
tail -f backend/logs/engine.log
tail -f backend/logs/data.log

# 前端日志
tail -f backend/logs/frontend.log

# Docker日志
docker logs -f glen-mysql
docker logs -f glen-nacos
```

---

## 🔐 默认凭据

### 应用登录
- **URL**: http://localhost:5173
- **账号**: 13432898570
- **密码**: C1137257

### Nacos控制台
- **URL**: http://localhost:8848/nacos
- **用户名**: nacos
- **密码**: nacos

### MinIO对象存储
- **URL**: http://localhost:9001
- **用户名**: admin
- **密码**: glen123456

### 数据库
- **MySQL**: localhost:3306, root / glen123456
- **Redis**: localhost:6379, glen123456

---

## 📦 项目结构

```
yun-glenautotest/
├── backend/              # 后端微服务
│   ├── glen-gateway/    # 网关服务
│   ├── glen-account/    # 账户服务
│   ├── glen-data/       # 数据服务
│   ├── glen-engine/     # 测试引擎
│   └── glen-common/     # 公共模块
├── frontend/            # 前端应用
├── Mysql/               # 数据库初始化脚本
├── markdown/            # 项目文档
├── docker-compose.yml   # Docker编排
└── *.sh                 # 部署脚本
```

---

## ❗ 常见问题

### Docker命令找不到(WSL2)

```bash
# 确保Docker Desktop已在Windows上运行
# 在Docker Desktop中启用WSL Integration
# Settings → Resources → WSL Integration → 启用Ubuntu

# 在Windows PowerShell中重启WSL
wsl --shutdown
```

### Maven报JAVA_HOME错误

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo 'export JAVA_HOME=$JAVA_HOME' >> ~/.bashrc
source ~/.bashrc
```

### 端口被占用

```bash
# 查找占用进程
netstat -tlnp | grep <端口>

# 停止所有服务
./stop-all.sh
```

更多问题请查看 **[WSL2部署指南.md](WSL2部署指南.md)**

---

## 🤝 贡献

欢迎贡献代码、报告问题或提出改进建议!

---

## 📄 许可证

本项目采用 Apache 2.0 许可证

---

## 📞 联系我们

- **项目路径**: /home/hinkad/yun-glenautotest
- **部署环境**: WSL2 Ubuntu 24.04
- **版本**: v1.0
- **更新日期**: 2026-01-17

---

**快速开始**: `./README-DEPLOY.sh` 或查看 [QUICKSTART.md](QUICKSTART.md)
