# Glen自动化测试平台 - 部署摘要

## 📍 当前状态

**项目路径**: `/home/hinkad/yun-glenautotest`  
**运行环境**: WSL2 Ubuntu 24.04  
**检查时间**: 2026-01-17

---

## ❗ 环境检查结果

### 缺少的环境:

1. ❌ **Docker** - 需要Docker Desktop for Windows并启用WSL集成
2. ❌ **Java JDK 17** - 需要安装
3. ⚠️  **Maven** - 已安装但需要配置JAVA_HOME
4. ❌ **Node.js** - 需要安装  
5. ⚠️  **pnpm** - 已安装但依赖Node.js

### 已准备的资源:

✅ docker-compose.yml 配置文件  
✅ 后端代码 (glen-account, glen-data, glen-engine, glen-gateway)  
✅ 前端代码  
✅ MySQL初始化脚本  
✅ 部署脚本 (restart-all.sh, stop-all.sh, deploy.sh)

---

## 🚀 部署方案

由于您在WSL2环境中,推荐以下部署方案:

### 方案 1: Windows Docker Desktop + WSL2 (推荐)

这是最简单的方案,无需在WSL2中安装Docker。

#### Step 1: 在Windows上安装Docker Desktop

1. 下载Docker Desktop: https://www.docker.com/products/docker-desktop
2. 安装并启动Docker Desktop
3. 在Docker Desktop设置中:
   - 进入 `Settings` → `Resources` → `WSL Integration`
   - 启用 `Enable integration with my default WSL distro`
   - 或选择 `Ubuntu-24.04` 并启用
   - 点击 `Apply & Restart`

#### Step 2: 在WSL2中安装其他依赖

打开WSL2终端,运行:

```bash
cd /home/hinkad/yun-glenautotest

# 运行环境安装脚本 (需要sudo密码)
./setup-environment.sh
```

这将安装:
- JDK 17
- 配置Maven的JAVA_HOME
- Node.js 20
- pnpm

#### Step 3: 部署项目

环境准备完成后:

```bash
cd /home/hinkad/yun-glenautotest

# 方式1: 完整部署(含编译)
./deploy.sh

# 方式2: 快速启动(已编译过)
./restart-all.sh
```

---

### 方案 2: 手动安装所有环境

如果您想完全在WSL2中部署,需要手动安装Docker Engine:

```bash
# 安装Docker Engine
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 安装JDK
sudo apt update
sudo apt install -y openjdk-17-jdk

# 配置JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装pnpm
sudo npm install -g pnpm

# 启动Docker
sudo service docker start
```

然后运行部署脚本:

```bash
cd /home/hinkad/yun-glenautotest
./deploy.sh
```

---

## 📋 部署完成后的访问地址

服务启动后,您可以通过以下地址访问:

### 🌐 前端应用
```
URL: http://localhost:5173
测试账号: 13432898570
密码: C1137257
```

### 🔧 Nacos配置中心
```
URL: http://localhost:8848/nacos
用户名: nacos
密码: nacos
```

### 📦 MinIO对象存储
```
URL: http://localhost:9001
用户名: admin
密码: glen123456
```

### 🗄️ MySQL数据库
```
Host: localhost:3306
用户名: root
密码: glen123456
```

### 📊 Redis缓存
```
Host: localhost:6379
密码: glen123456
```

---

## 🛠️ 已创建的部署脚本

所有脚本已放置在项目根目录 `/home/hinkad/yun-glenautotest/`:

| 脚本名称 | 功能说明 |
|---------|---------|
| `check-environment.sh` | 检查环境是否就绪 |
| `setup-environment.sh` | 自动安装JDK、Maven、Node.js、pnpm |
| `deploy.sh` | 完整部署流程(含编译) |
| `restart-all.sh` | 快速启动所有服务 |
| `stop-all.sh` | 停止所有服务 |

### 使用方法:

```bash
# 1. 检查环境
./check-environment.sh

# 2. 安装环境(如有缺失)
./setup-environment.sh

# 3. 部署项目
./deploy.sh

# 4. 查看服务状态
docker compose ps
ps aux | grep spring-boot
ps aux | grep vite

# 5. 查看日志
tail -f backend/logs/gateway.log

# 6. 停止服务
./stop-all.sh
```

---

## 📝 服务架构

```
┌─────────────────────────────────────────┐
│         前端 Frontend (Vite)            │
│         http://localhost:5173           │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│      网关 glen-gateway :8000            │
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

## ⚡ 快速命令参考

```bash
# 检查环境
./check-environment.sh

# 启动服务
./restart-all.sh

# 停止服务
./stop-all.sh

# 查看Docker容器
docker compose ps

# 查看日志
tail -f backend/logs/gateway.log
tail -f backend/logs/account.log
tail -f backend/logs/engine.log
tail -f backend/logs/data.log
tail -f backend/logs/frontend.log

# 重启Docker容器
docker compose restart

# 查看后端进程
ps aux | grep spring-boot

# 查看前端进程
ps aux | grep vite
```

---

## 📚 参考文档

项目文档位于 `markdown/` 目录:

- `项目启动指南.md` - 详细的启动步骤
- `云服务器部署指南.md` - 服务器部署方案
- `中间件部署清单.md` - 中间件配置信息
- `运维手册.md` - 日常运维操作
- `WSL2部署指南.md` - WSL2环境部署详细说明

---

## 🆘 需要帮助?

如果遇到问题:

1. 运行环境检查: `./check-environment.sh`
2. 查看日志文件排查错误
3. 检查端口是否被占用: `netstat -tlnp | grep <端口>`
4. 重启Docker Desktop (WSL2环境)
5. 查看文档: `cat WSL2部署指南.md`

---

**创建时间**: 2026-01-17  
**项目版本**: 1.0  
**部署环境**: WSL2 Ubuntu 24.04
