# Glen自动化测试平台 - 重构与部署总结

## 📋 项目概况

**项目名称**: Glen自动化测试平台 (原dcloud-autotest)  
**项目路径**: `/home/hinkad/yun-glenautotest`  
**技术栈**: Spring Boot + Vue3 + Nacos + MySQL + Redis + Kafka + MinIO  
**部署环境**: WSL2 Ubuntu 24.04

---

## 🔄 重构内容

### 1. 项目重命名
- 原名称: `dcloud-autotest` → 新名称: `glen-autotest`
- 所有模块、包名、配置已统一更新为 glen 前缀

### 2. 容器化部署
- 使用 Docker Compose 管理所有中间件
- 容器命名统一使用 `glen-` 前缀
- 配置了数据持久化和健康检查

### 3. 自动化脚本
创建了完整的部署和运维脚本:
- `check-environment.sh` - 环境检查
- `setup-environment.sh` - 环境安装
- `deploy.sh` - 完整部署
- `restart-all.sh` - 快速启动
- `stop-all.sh` - 停止服务

---

## 🎯 部署方案

### 当前环境需求

✅ 已准备:
- Docker Compose配置文件
- 后端代码(4个微服务)
- 前端代码
- MySQL初始化脚本
- 部署脚本

❌ 需要安装:
- Docker Desktop for Windows (WSL2集成)
- JDK 17
- Maven配置
- Node.js 20
- pnpm

### 推荐部署流程

#### Step 1: Docker Desktop设置 (Windows)

1. 安装 Docker Desktop for Windows
2. 启用 WSL2 Integration
   - Settings → Resources → WSL Integration
   - 启用 Ubuntu 24.04 集成
   - Apply & Restart

#### Step 2: 安装依赖 (WSL2)

```bash
cd /home/hinkad/yun-glenautotest
./setup-environment.sh
```

#### Step 3: 部署项目

```bash
./deploy.sh
```

或使用项目原有脚本:

```bash
./restart-all.sh
```

---

## 📦 服务架构

### 中间件服务 (Docker)

| 服务 | 容器名 | 端口 | 说明 |
|-----|-------|------|------|
| MySQL 8.0 | glen-mysql | 3306 | 数据库 |
| Redis 7.0 | glen-redis | 6379 | 缓存 |
| Nacos 2.2.3 | glen-nacos | 8848, 9848 | 配置中心 |
| Zookeeper 3.9 | glen-zookeeper | 2181 | Kafka依赖 |
| Kafka | glen-kafka | 9092 | 消息队列 |
| MinIO | glen-minio | 9000, 9001 | 对象存储 |

### 后端服务 (Spring Boot)

| 服务 | 模块 | 端口 | 说明 |
|-----|-----|------|------|
| Gateway | glen-gateway | 8000 | API网关 |
| Account | glen-account | 8081 | 账户服务 |
| Data | glen-data | 8082 | 数据服务 |
| Engine | glen-engine | 8083 | 测试引擎 |

### 前端服务 (Vue3)

| 服务 | 端口 | 说明 |
|-----|------|------|
| Frontend | 5173 | Vite开发服务器 |

---

## 🔑 访问凭据

### 应用登录
- URL: http://localhost:5173
- 账号: 13432898570
- 密码: C1137257

### Nacos控制台
- URL: http://localhost:8848/nacos
- 用户名: nacos
- 密码: nacos

### MinIO控制台
- URL: http://localhost:9001
- 用户名: admin
- 密码: glen123456

### MySQL
- Host: localhost:3306
- 用户名: root
- 密码: glen123456 (默认,配置在docker-compose.yml)

### Redis
- Host: localhost:6379
- 密码: glen123456

---

## 📂 项目结构

```
/home/hinkad/yun-glenautotest/
├── backend/                      # 后端代码
│   ├── glen-gateway/            # 网关服务
│   ├── glen-account/            # 账户服务
│   ├── glen-data/               # 数据服务
│   ├── glen-engine/             # 测试引擎
│   ├── glen-common/             # 公共模块
│   ├── logs/                    # 服务日志
│   └── pom.xml                  # Maven父POM
├── frontend/                     # 前端代码
│   ├── src/                     # 源码
│   ├── package.json             # 依赖配置
│   └── vite.config.ts           # Vite配置
├── Mysql/                        # 数据库初始化脚本
│   ├── account_sql/             # 账户库
│   ├── dcloud_api_sql/          # API测试库
│   ├── dcloud_ui_sql/           # UI测试库
│   ├── dcloud_stress_sql/       # 压测库
│   ├── job_sql/                 # 定时任务库
│   ├── sys_dict/                # 数据字典库
│   └── *.sql                    # 初始化脚本
├── markdown/                     # 项目文档
│   ├── 项目启动指南.md
│   ├── 云服务器部署指南.md
│   ├── 中间件部署清单.md
│   ├── 运维手册.md
│   └── REFACTORING_SUMMARY.md  # 本文件
├── docker-compose.yml            # Docker编排
├── check-environment.sh          # 环境检查
├── setup-environment.sh          # 环境安装
├── deploy.sh                     # 完整部署
├── restart-all.sh                # 快速启动
├── stop-all.sh                   # 停止服务
├── DEPLOYMENT_SUMMARY.md         # 部署摘要
├── QUICKSTART.md                 # 快速开始
└── WSL2部署指南.md               # WSL2详细指南
```

---

## 🚀 快速命令

```bash
# 检查环境
./check-environment.sh

# 启动所有服务
./restart-all.sh

# 停止所有服务
./stop-all.sh

# 查看Docker状态
docker compose ps

# 查看服务日志
tail -f backend/logs/gateway.log

# 重启Docker服务
docker compose restart

# 重新部署(含编译)
./deploy.sh
```

---

## 🔧 配置说明

### 环境变量

在 `.env.dev` 或 `docker-compose.yml` 中配置:

```bash
MYSQL_ROOT_PASSWORD=glen123456
REDIS_PASSWORD=glen123456
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=glen123456
```

### 数据库配置

MySQL数据库在首次启动时会自动执行 `Mysql/` 目录下的初始化脚本,创建:

- glen_account - 账户数据库
- glen_api - API测试数据库
- glen_ui - UI测试数据库
- glen_stress - 压测数据库
- glen_engine - 引擎数据库
- glen_job - 定时任务数据库
- glen_dict - 数据字典数据库
- nacos_config - Nacos配置数据库

---

## 📊 服务监控

### 健康检查

所有Docker容器配置了健康检查:

```bash
# 查看容器健康状态
docker compose ps
```

### 日志位置

- Gateway: `backend/logs/gateway.log`
- Account: `backend/logs/account.log`
- Engine: `backend/logs/engine.log`
- Data: `backend/logs/data.log`
- Frontend: `backend/logs/frontend.log`

### 端口占用检查

```bash
# 检查所有关键端口
netstat -tlnp | grep -E '3306|6379|8848|9092|9000|9001|5173|8000|8081|8082|8083'
```

---

## ⚠️ 注意事项

### WSL2环境

1. **Docker Desktop必须在Windows上运行**
   - Docker服务不在WSL2内部运行
   - 需要启用WSL Integration

2. **路径映射**
   - WSL2路径: `/home/hinkad/yun-glenautotest`
   - Windows路径: 通过文件管理器 `\\wsl$\Ubuntu\home\hinkad\yun-glenautotest`

3. **性能优化**
   - 项目文件放在WSL2文件系统内(不要放在/mnt/下)
   - 使用Docker volumes而非bind mount存储数据

### 启动顺序

1. Docker中间件 (MySQL, Redis, Nacos必须先启动)
2. 等待15-30秒让中间件就绪
3. 启动后端服务 (Gateway → Account → Engine → Data)
4. 启动前端服务

### 常见问题

1. **Docker命令找不到**
   - 确保Docker Desktop已启动
   - 检查WSL Integration是否启用
   - 重启WSL: `wsl --shutdown` (在Windows PowerShell中)

2. **Maven报JAVA_HOME错误**
   - 设置环境变量: `export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64`
   - 添加到 ~/.bashrc 永久生效

3. **端口被占用**
   - 查找进程: `netstat -tlnp | grep <端口>`
   - 停止冲突服务或修改配置中的端口

4. **数据库连接失败**
   - 检查MySQL容器状态: `docker logs glen-mysql`
   - 等待数据库完全启动(约30秒)
   - 验证密码是否正确

---

## 📚 相关文档

详细文档请查看 `markdown/` 目录:

- **DEPLOYMENT_SUMMARY.md** - 部署总结(本文件)
- **QUICKSTART.md** - 快速开始指南
- **WSL2部署指南.md** - WSL2环境详细部署
- **项目启动指南.md** - 完整启动步骤
- **云服务器部署指南.md** - 生产环境部署
- **中间件部署清单.md** - 中间件配置清单
- **运维手册.md** - 日常运维操作

---

## ✅ 部署检查清单

部署完成后,请验证以下内容:

- [ ] Docker Desktop已启动并启用WSL集成
- [ ] 所有Docker容器运行正常 (`docker compose ps`)
- [ ] MySQL数据库已初始化,包含8个数据库
- [ ] Nacos控制台可访问 (http://localhost:8848/nacos)
- [ ] 4个后端服务已注册到Nacos
- [ ] 前端页面可访问 (http://localhost:5173)
- [ ] 可以使用测试账号登录系统
- [ ] MinIO控制台可访问 (http://localhost:9001)

---

## 🎉 下一步

部署完成后:

1. 访问前端: http://localhost:5173
2. 使用测试账号登录: 13432898570 / C1137257
3. 创建测试项目
4. 配置接口测试用例
5. 执行测试并查看报告

---

**重构日期**: 2026-01-17  
**文档版本**: 1.0  
**维护者**: Glen AutoTest Team
