# Glen自动化测试平台 - 项目资源清单

## 📦 部署资源总览

本文档列出了所有为部署准备的脚本、文档和配置文件。

---

## 🚀 自动化部署脚本

所有脚本位于项目根目录 `/home/hinkad/yun-glenautotest/`

### 核心部署脚本

| 文件名 | 大小 | 权限 | 功能说明 |
|-------|------|------|---------|
| `check-environment.sh` | 5.4KB | ✅ 可执行 | **环境检查脚本**<br>检查Docker、JDK、Maven、Node.js、pnpm是否安装<br>显示彩色输出和详细的修复建议 |
| `setup-environment.sh` | 5.9KB | ✅ 可执行 | **环境安装脚本**<br>自动安装JDK 17、配置Maven、安装Node.js和pnpm<br>配置Docker(如可用)<br>⚠️ 需要sudo权限 |
| `deploy.sh` | 7.7KB | ✅ 可执行 | **完整部署脚本**<br>1. 启动Docker中间件<br>2. 检查数据库<br>3. 编译后端项目<br>4. 启动后端服务<br>5. 安装前端依赖<br>6. 启动前端服务 |
| `restart-all.sh` | 2.2KB | ✅ 可执行 | **快速启动脚本**(已修复路径)<br>适用于环境已配置的情况<br>快速启动所有服务 |
| `stop-all.sh` | 1.2KB | ✅ 可执行 | **停止服务脚本**<br>停止所有后端、前端和Docker服务 |
| `README-DEPLOY.sh` | 5.0KB | ✅ 可执行 | **部署助手**<br>显示精美的部署指南<br>包含步骤、地址、命令速查 |

### 使用示例

```bash
# 1. 查看部署助手
./README-DEPLOY.sh

# 2. 检查环境
./check-environment.sh

# 3. 安装环境(如需要)
./setup-environment.sh

# 4. 部署项目
./deploy.sh         # 或
./restart-all.sh    # 快速启动

# 5. 停止服务
./stop-all.sh
```

---

## 📚 部署文档

### 中文文档(项目根目录)

| 文件名 | 大小 | 内容说明 |
|-------|------|---------|
| `QUICKSTART.md` | 1.6KB | **快速开始指南**<br>最简化的3步部署说明<br>适合快速查阅 |
| `DEPLOYMENT_SUMMARY.md` | 6.9KB | **部署摘要**<br>完整的部署配置说明<br>包含架构图、地址、密码 |
| `WSL2部署指南.md` | 7.0KB | **WSL2详细教程**<br>WSL2环境专用部署指南<br>包含故障排查和注意事项 |
| `部署完成总结.md` | 12KB | **部署总结**<br>部署完成后的总结文档<br>包含验证清单和下一步操作 |
| `DEPLOYMENT_GUIDE.txt` | 8KB | **可视化部署指南**<br>纯文本格式,带边框和表格<br>可直接在终端查看 |
| `PROJECT_RESOURCES.md` | - | **本文档**<br>项目资源清单 |

### 项目原有文档(markdown目录)

| 文件名 | 内容说明 |
|-------|---------|
| `REFACTORING_SUMMARY.md` | 项目重构和部署完整总结 |
| `项目启动指南.md` | Windows本地环境启动详细指南 |
| `云服务器部署指南.md` | 生产环境(Ubuntu Server)部署方案 |
| `中间件部署清单.md` | Docker中间件配置清单 |
| `运维手册.md` | 日常运维操作手册 |
| `前端启动指南.md` | 前端项目启动说明 |
| `项目分析报告.md` | 项目技术分析 |

---

## ⚙️ 配置文件

### Docker配置

| 文件名 | 说明 |
|-------|------|
| `docker-compose.yml` | **Docker Compose编排文件**<br>定义6个中间件容器:<br>- MySQL 8.0<br>- Redis 7.0<br>- Nacos 2.2.3<br>- Zookeeper 3.9<br>- Kafka<br>- MinIO |
| `mysql.cnf` | MySQL配置文件<br>字符集和连接设置 |
| `.env.dev` | 环境变量配置(被gitignore)<br>包含密码等敏感信息 |

### 数据库初始化脚本

位于 `Mysql/` 目录:

```
Mysql/
├── account_sql/           # glen_account 数据库
├── dcloud_api_sql/        # glen_api 数据库
├── dcloud_ui_sql/         # glen_ui 数据库
├── dcloud_stress_sql/     # glen_stress 数据库
├── job_sql/               # glen_job 数据库
├── sys_dict/              # glen_dict 数据库
├── 10-nacos_config-schema.sql    # nacos_config 数据库
└── *.sql                  # 其他初始化脚本
```

---

## 🗂️ 项目目录结构

```
/home/hinkad/yun-glenautotest/
│
├── 📜 部署脚本 (可执行)
│   ├── check-environment.sh
│   ├── setup-environment.sh
│   ├── deploy.sh
│   ├── restart-all.sh
│   ├── stop-all.sh
│   └── README-DEPLOY.sh
│
├── 📄 部署文档
│   ├── QUICKSTART.md
│   ├── DEPLOYMENT_SUMMARY.md
│   ├── WSL2部署指南.md
│   ├── 部署完成总结.md
│   ├── DEPLOYMENT_GUIDE.txt
│   └── PROJECT_RESOURCES.md (本文档)
│
├── 🐳 Docker配置
│   ├── docker-compose.yml
│   ├── mysql.cnf
│   └── .env.dev (被忽略)
│
├── 🗄️ Mysql/              # 数据库初始化脚本
│   ├── account_sql/
│   ├── dcloud_api_sql/
│   ├── dcloud_ui_sql/
│   └── ... (其他SQL目录)
│
├── 💻 backend/            # 后端代码
│   ├── glen-gateway/     # 网关服务 :8000
│   ├── glen-account/     # 账户服务 :8081
│   ├── glen-data/        # 数据服务 :8082
│   ├── glen-engine/      # 测试引擎 :8083
│   ├── glen-common/      # 公共模块
│   ├── logs/             # 服务日志(运行时创建)
│   └── pom.xml           # Maven父POM
│
├── 🎨 frontend/           # 前端代码
│   ├── src/              # Vue3源码
│   ├── public/           # 静态资源
│   ├── package.json      # 依赖配置
│   └── vite.config.ts    # Vite配置
│
└── 📚 markdown/           # 项目文档
    ├── REFACTORING_SUMMARY.md
    ├── 项目启动指南.md
    ├── 云服务器部署指南.md
    └── ... (其他文档)
```

---

## 🔑 访问凭据汇总

### 应用访问

| 服务 | URL | 账号 | 密码 |
|-----|-----|------|------|
| **前端应用** | http://localhost:5173 | 13432898570 | C1137257 |
| **Nacos控制台** | http://localhost:8848/nacos | nacos | nacos |
| **MinIO控制台** | http://localhost:9001 | admin | glen123456 |

### 数据库和中间件

| 服务 | 连接地址 | 账号 | 密码 |
|-----|---------|------|------|
| **MySQL** | localhost:3306 | root | glen123456 |
| **Redis** | localhost:6379 | - | glen123456 |
| **Kafka** | localhost:9092 | - | - |

> 💡 所有密码配置在 `docker-compose.yml` 中,可根据需要修改

---

## 🎯 快速命令参考

### 部署相关

```bash
# 查看所有脚本和文档
ls -lh *.sh *.md

# 显示部署助手
./README-DEPLOY.sh

# 查看可视化指南
cat DEPLOYMENT_GUIDE.txt

# 检查环境
./check-environment.sh

# 完整部署
./deploy.sh
```

### 服务管理

```bash
# 启动服务
./restart-all.sh

# 停止服务
./stop-all.sh

# 查看Docker状态
docker compose ps

# 查看后端进程
ps aux | grep spring-boot

# 查看前端进程
ps aux | grep vite
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
docker logs -f glen-redis
```

---

## ✅ 部署前检查清单

使用本清单确保所有资源都已准备就绪:

### 脚本检查

- [x] check-environment.sh (5.4KB, 可执行)
- [x] setup-environment.sh (5.9KB, 可执行)
- [x] deploy.sh (7.7KB, 可执行)
- [x] restart-all.sh (2.2KB, 可执行, 已修复路径)
- [x] stop-all.sh (1.2KB, 可执行)
- [x] README-DEPLOY.sh (5.0KB, 可执行)

### 文档检查

- [x] QUICKSTART.md (1.6KB)
- [x] DEPLOYMENT_SUMMARY.md (6.9KB)
- [x] WSL2部署指南.md (7.0KB)
- [x] 部署完成总结.md (12KB)
- [x] DEPLOYMENT_GUIDE.txt (8KB)
- [x] PROJECT_RESOURCES.md (本文档)

### 配置检查

- [x] docker-compose.yml (4KB, 定义6个容器)
- [x] mysql.cnf (MySQL配置)
- [x] Mysql/ 目录 (包含所有SQL初始化脚本)

### 代码检查

- [x] backend/ 目录 (4个微服务 + 公共模块)
- [x] frontend/ 目录 (Vue3前端代码)

---

## 📊 资源统计

### 脚本统计

- **脚本数量**: 6个
- **总大小**: ~32KB
- **所有脚本**: ✅ 已添加执行权限

### 文档统计

- **文档数量**: 6个 (根目录) + 8个 (markdown目录)
- **总大小**: ~50KB
- **格式**: Markdown + 纯文本

### 代码统计

- **后端模块**: 5个 (gateway, account, data, engine, common)
- **前端框架**: Vue3 + Vite
- **数据库**: 8个 (glen_* x 7 + nacos_config)
- **中间件**: 6个 Docker容器

---

## 🎉 总结

所有部署资源已准备完毕!您现在拥有:

✅ **6个自动化部署脚本** - 涵盖环境检查、安装、部署、启动、停止  
✅ **6个详细部署文档** - 从快速开始到完整教程  
✅ **完整的Docker配置** - 一键启动6个中间件  
✅ **数据库初始化脚本** - 自动创建8个数据库  
✅ **完整的项目代码** - 后端微服务 + 前端应用  

**下一步**: 按照 `DEPLOYMENT_GUIDE.txt` 或 `QUICKSTART.md` 开始部署!

---

**文档创建时间**: 2026-01-17  
**项目版本**: Glen AutoTest v1.0  
**部署环境**: WSL2 Ubuntu 24.04  
**维护者**: Glen AutoTest Team
