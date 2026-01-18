# 🎉 部署完成总结

**部署时间**: 2026-01-18  
**部署环境**: WSL2 Ubuntu  
**部署状态**: ✅ 后端服务已部署，前端服务待启动

---

## ✅ 部署状态

### 1. Docker中间件服务

| 服务 | 容器名 | 端口 | 状态 | 访问地址 |
|------|--------|------|------|---------|
| **MySQL** | glen-mysql | 3307 | ✅ 运行中 | `localhost:3307` |
| **Redis** | glen-redis | 6379 | ✅ 运行中 | `localhost:6379` |
| **Nacos** | glen-nacos | 8848, 9848, 9849 | ✅ 运行中 | http://localhost:8848/nacos |
| **Zookeeper** | glen-zookeeper | 2181 | ✅ 运行中 | `localhost:2181` |
| **Kafka** | glen-kafka | 9092 | ✅ 运行中 | `localhost:9092` |
| **MinIO** | glen-minio | 9000, 9001 | ✅ 运行中 | http://localhost:9001 |

**检查命令**:
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

---

### 2. 后端服务

| 服务 | 端口 | 状态 | 说明 |
|------|------|------|------|
| **account-service** | 8081 | ✅ 运行中 | 账号服务 |
| **data-service** | 8082 | ✅ 运行中 | 数据服务 |
| **engine-service** | 8083 | ✅ 运行中 | 引擎服务 |
| **gateway-service** | 8000 | ✅ 运行中 | API网关 |

**检查命令**:
```bash
for port in 8081 8082 8083 8000; do
    timeout 2 bash -c "echo > /dev/tcp/localhost/$port" 2>/dev/null && echo "✅ 端口 $port: 运行中" || echo "❌ 端口 $port: 未运行"
done
```

---

### 3. 前端服务

| 服务 | 端口 | 状态 | 说明 |
|------|------|------|------|
| **前端应用** | 5173 | ⏳ 待启动 | Vue3 + Vite |

**启动命令**:
```bash
# 方式1: 使用启动脚本
./start-frontend.sh

# 方式2: 手动启动
cd frontend && pnpm dev
```

---

## 🌐 完整访问地址

### ⭐ 主要访问地址

| 服务 | 访问地址 | 用户名/密码 | 说明 |
|------|---------|------------|------|
| **前端应用** | **http://localhost:5173** | - | ⭐ 主要访问入口 |
| **网关服务** | **http://localhost:8000** | - | API网关 |

### 🛠️ 管理控制台

| 服务 | 访问地址 | 用户名 | 密码 | 说明 |
|------|---------|--------|------|------|
| **Nacos控制台** | http://localhost:8848/nacos | `nacos` | `nacos` | 服务注册与配置中心 |
| **MinIO控制台** | http://localhost:9001 | `admin` | `glen123456` | 对象存储管理 |

### 🔌 后端服务

| 服务 | 访问地址 | 说明 |
|------|---------|------|
| **account-service** | http://localhost:8081 | 账号服务（直连，不推荐） |
| **data-service** | http://localhost:8082 | 数据服务（直连，不推荐） |
| **engine-service** | http://localhost:8083 | 引擎服务（直连，不推荐） |

> **注意**: 后端服务建议通过网关（端口8000）访问，不要直接访问各个服务端口。

---

## 📋 数据库信息

### MySQL连接信息

| 配置项 | 值 |
|--------|-----|
| **主机** | `localhost` |
| **端口** | `3307` |
| **用户名** | `root` |
| **密码** | `glen123456` |

### 数据库列表

已创建的数据库：

- ✅ `nacos_config` - Nacos配置数据库
- ✅ `glen_account` - 账号服务数据库
- ✅ `glen_data` - 数据服务数据库
- ✅ `glen_engine` - 引擎服务数据库
- ✅ `glen_api` - API服务数据库
- ✅ `glen_ui` - UI服务数据库
- ✅ `glen_stress` - 压力测试数据库
- ✅ `glen_job` - 任务服务数据库
- ✅ `glen_dict` - 字典服务数据库

**Navicat连接字符串**:
```
主机: localhost
端口: 3307
用户名: root
密码: glen123456
```

---

## 🔑 重要凭证

### Nacos

- **用户名**: `nacos`
- **密码**: `nacos`
- **控制台**: http://localhost:8848/nacos

### MinIO

- **用户名**: `admin`
- **密码**: `glen123456`
- **控制台**: http://localhost:9001
- **API端点**: http://localhost:9000

### MySQL

- **用户名**: `root`
- **密码**: `glen123456`
- **端口**: `3307`

---

## 📊 部署架构

```
┌─────────────────────────────────────────────────────────────┐
│                     前端应用 (5173)                           │
│                   Vue3 + Vite                                │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  API网关 (8000)                              │
│              gateway-service                                 │
└──────┬────────┬──────────┬──────────┬───────────────────────┘
       │        │          │          │
       ▼        ▼          ▼          ▼
   ┌──────┐ ┌──────┐  ┌──────┐  ┌────────┐
   │8081  │ │8082  │  │8083  │  │8848    │
   │Account│ │Data  │  │Engine│  │Nacos   │
   └───┬──┘ └───┬──┘  └───┬──┘  └────┬───┘
       │        │          │          │
       └────────┴──────────┴──────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
    ┌──────┐   ┌──────┐   ┌──────┐
    │MySQL │   │Redis │   │MinIO │
    │ 3307 │   │ 6379 │   │ 9000 │
    └──────┘   └──────┘   └──────┘
```

---

## 🚀 启动顺序

### 完整启动流程

1. ✅ **启动Docker中间件** (已完成)
   ```bash
   docker-compose up -d
   ```

2. ✅ **初始化数据库** (已完成)
   ```bash
   ./init-database.sh
   ```

3. ✅ **启动后端服务** (已完成)
   ```bash
   ./start-backend.sh
   # 或手动启动各个服务
   ```

4. ⏳ **启动前端服务** (待启动)
   ```bash
   ./start-frontend.sh
   ```

---

## 🎯 下一步操作

### 1. 启动前端服务

```bash
# 进入项目目录
cd /home/hinkad/yun-glenautotest

# 启动前端服务
./start-frontend.sh

# 或手动启动
cd frontend && pnpm dev
```

### 2. 访问系统

前端启动后，访问: **http://localhost:5173**

### 3. 测试功能

- ✅ 登录功能
- ✅ API调用
- ✅ 各功能模块

---

## 📝 常用命令

### Docker管理

```bash
# 查看容器状态
docker ps

# 停止所有中间件
docker-compose down

# 启动所有中间件
docker-compose up -d

# 查看日志
docker-compose logs -f [服务名]
```

### 后端服务管理

```bash
# 清理端口
./cleanup-backend-ports.sh

# 启动后端服务
./start-backend.sh

# 停止后端服务（手动）
pkill -f "spring-boot:run"
```

### 前端服务管理

```bash
# 启动前端服务
./start-frontend.sh

# 或手动启动
cd frontend && pnpm dev

# 停止前端服务
# 按 Ctrl+C 或
pkill -f "vite"
```

### 查看服务状态

```bash
# 查看所有服务状态
./show-services.sh
```

---

## 🔍 验证部署

### 1. 检查中间件

```bash
docker ps | grep glen-
```

应该看到6个容器运行中。

### 2. 检查后端服务

```bash
for port in 8081 8082 8083 8000; do
    timeout 2 bash -c "echo > /dev/tcp/localhost/$port" 2>/dev/null && echo "✅ 端口 $port: 运行中" || echo "❌ 端口 $port: 未运行"
done
```

应该看到4个端口都在运行。

### 3. 检查前端服务

```bash
lsof -i :5173
```

前端启动后应该看到监听。

### 4. 检查Nacos服务注册

访问: http://localhost:8848/nacos

登录后查看"服务管理" → "服务列表"，应该看到4个后端服务已注册。

---

## 🐛 常见问题

### Q1: 端口被占用

**解决**: 
```bash
# 清理后端端口
./cleanup-backend-ports.sh

# 清理前端端口
lsof -ti :5173 | xargs kill -9
```

### Q2: 服务无法访问

**检查**:
1. 服务是否运行（检查端口）
2. 防火墙设置
3. WSL2端口转发

### Q3: 数据库连接失败

**检查**:
1. MySQL容器是否运行: `docker ps | grep mysql`
2. 端口是否正确（3307）
3. 密码是否正确（glen123456）

---

## 📚 相关文档

- `markdown/项目启动指南.md` - 完整启动指南
- `markdown/BACKEND_START_GUIDE.md` - 后端启动指南
- `markdown/FRONTEND_START_GUIDE.md` - 前端启动指南
- `markdown/DATABASE_INIT_GUIDE.md` - 数据库初始化指南

---

## ✅ 部署检查清单

- [x] Docker中间件已启动（6个服务）
- [x] 数据库已初始化（9个数据库）
- [x] 后端服务已启动（4个服务）
- [ ] 前端服务已启动
- [ ] 前端页面可访问
- [ ] 前后端通信正常
- [ ] 功能测试通过

---

**文档位置**: `/home/hinkad/yun-glenautotest/markdown/DEPLOYMENT_COMPLETE.md`  
**最后更新**: 2026-01-18
