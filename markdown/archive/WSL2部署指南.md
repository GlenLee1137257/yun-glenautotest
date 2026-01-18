# Glen自动化测试平台 - WSL2部署指南

## 📋 环境说明

- **操作系统**: Ubuntu 24.04 LTS (WSL2)
- **项目路径**: /home/hinkad/yun-glenautotest
- **部署方式**: Docker Compose + Maven + Vite

---

## 🚀 快速部署步骤

### 前置条件

由于您使用的是WSL2环境,需要先在Windows上安装并配置Docker Desktop:

1. **安装Docker Desktop for Windows**
   - 下载地址: https://www.docker.com/products/docker-desktop
   - 安装后启动Docker Desktop

2. **启用WSL2集成**
   - 打开Docker Desktop
   - 进入 Settings → Resources → WSL Integration
   - 启用 "Enable integration with my default WSL distro"
   - 或选择 Ubuntu-24.04 并启用
   - 点击 "Apply & Restart"

3. **在WSL2中验证Docker**
   ```bash
   docker --version
   docker ps
   ```

---

## 方案A: 自动部署(推荐)

### Step 1: 安装环境(首次部署)

```bash
cd /home/hinkad/yun-glenautotest

# 运行环境安装脚本
./setup-environment.sh
```

**该脚本将自动安装:**
- JDK 17
- Maven 配置
- Node.js 20
- pnpm
- 必要的工具

**注意**: 需要输入sudo密码

### Step 2: 一键部署

```bash
cd /home/hinkad/yun-glenautotest

# 运行部署脚本
./deploy.sh
```

**部署过程包括:**
1. 启动Docker中间件(MySQL, Redis, Nacos, Kafka, MinIO)
2. 检查并初始化数据库
3. 编译后端项目
4. 启动4个后端服务(gateway, account, engine, data)
5. 安装前端依赖
6. 启动前端服务

---

## 方案B: 使用项目自带脚本

如果Docker Desktop已经配置好WSL集成,可以直接使用项目自带的启动脚本:

```bash
cd /home/hinkad/yun-glenautotest

# 确保脚本有执行权限
chmod +x restart-all.sh stop-all.sh

# 启动所有服务
./restart-all.sh
```

---

## 方案C: 手动部署

### 1. 启动Docker中间件

```bash
cd /home/hinkad/yun-glenautotest

# 启动所有中间件
docker compose up -d

# 查看容器状态
docker compose ps

# 等待服务启动(约30秒)
sleep 30
```

### 2. 检查数据库

```bash
# 查看数据库是否已初始化
docker exec glen-mysql mysql -uroot -pglen123456 -e "SHOW DATABASES LIKE 'glen_%';"
```

### 3. 编译后端项目

```bash
cd /home/hinkad/yun-glenautotest/backend

# Maven编译
mvn clean package -DskipTests
```

### 4. 启动后端服务

```bash
# 创建日志目录
mkdir -p /home/hinkad/yun-glenautotest/backend/logs

cd /home/hinkad/yun-glenautotest/backend

# 启动Gateway服务
nohup mvn -f glen-gateway spring-boot:run > logs/gateway.log 2>&1 &
sleep 5

# 启动Account服务
nohup mvn -f glen-account spring-boot:run > logs/account.log 2>&1 &
sleep 5

# 启动Engine服务
nohup mvn -f glen-engine spring-boot:run > logs/engine.log 2>&1 &
sleep 5

# 启动Data服务
nohup mvn -f glen-data spring-boot:run > logs/data.log 2>&1 &
sleep 10
```

### 5. 安装并启动前端

```bash
cd /home/hinkad/yun-glenautotest/frontend

# 安装依赖(首次)
pnpm install

# 启动前端
nohup pnpm run dev > /home/hinkad/yun-glenautotest/backend/logs/frontend.log 2>&1 &
```

---

## 📌 服务访问地址

### 前端应用
- **URL**: http://localhost:5173
- **测试账号**: 13432898570
- **密码**: C1137257

### Nacos控制台
- **URL**: http://localhost:8848/nacos
- **用户名**: nacos
- **密码**: nacos

### MinIO控制台
- **URL**: http://localhost:9001
- **用户名**: admin
- **密码**: glen123456

### MySQL数据库
- **Host**: localhost:3306
- **用户名**: root
- **密码**: glen123456 (配置在docker-compose.yml中)

### Redis
- **Host**: localhost:6379
- **密码**: glen123456

---

## 🔍 服务验证

### 检查Docker容器

```bash
# 查看所有容器状态
docker compose ps

# 查看容器日志
docker logs glen-mysql
docker logs glen-nacos
docker logs glen-redis
```

### 检查后端服务

```bash
# 查看后端进程
ps aux | grep "spring-boot:run"

# 查看服务日志
tail -f /home/hinkad/yun-glenautotest/backend/logs/gateway.log
tail -f /home/hinkad/yun-glenautotest/backend/logs/account.log
```

### 检查前端服务

```bash
# 查看前端进程
ps aux | grep "vite"

# 查看前端日志
tail -f /home/hinkad/yun-glenautotest/backend/logs/frontend.log
```

### 检查端口占用

```bash
# 检查关键端口
netstat -tlnp | grep -E '3306|6379|8848|9092|9000|9001|5173'
```

---

## 🛠️ 常用运维命令

### 停止所有服务

```bash
cd /home/hinkad/yun-glenautotest

# 使用停止脚本
./stop-all.sh

# 或手动停止
pkill -f "spring-boot:run"
pkill -f "vite"
docker compose down
```

### 重启服务

```bash
cd /home/hinkad/yun-glenautotest

# 使用重启脚本
./restart-all.sh
```

### 查看日志

```bash
# 实时查看Gateway日志
tail -f /home/hinkad/yun-glenautotest/backend/logs/gateway.log

# 查看最后100行
tail -n 100 /home/hinkad/yun-glenautotest/backend/logs/gateway.log

# 搜索错误
grep "ERROR" /home/hinkad/yun-glenautotest/backend/logs/*.log
```

---

## ❗ 常见问题

### 1. Docker命令找不到

**问题**: `The command 'docker' could not be found`

**解决方案**:
- 确保Docker Desktop已安装并运行
- 在Docker Desktop中启用WSL2集成
- 重启WSL2: 在Windows PowerShell中运行 `wsl --shutdown` 后重新打开

### 2. Maven报错JAVA_HOME未设置

**问题**: `The JAVA_HOME environment variable is not defined correctly`

**解决方案**:
```bash
# 设置JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# 添加到bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### 3. 端口被占用

**问题**: 端口冲突

**解决方案**:
```bash
# 查找占用端口的进程
netstat -tlnp | grep <端口号>

# 杀死进程
kill -9 <PID>
```

### 4. 数据库连接失败

**问题**: 后端无法连接MySQL

**解决方案**:
```bash
# 检查MySQL容器状态
docker logs glen-mysql

# 手动测试连接
docker exec -it glen-mysql mysql -uroot -pglen123456 -e "SELECT 1;"

# 检查数据库是否存在
docker exec glen-mysql mysql -uroot -pglen123456 -e "SHOW DATABASES;"
```

### 5. 前端无法访问

**问题**: 浏览器无法打开前端页面

**解决方案**:
```bash
# 检查前端是否运行
ps aux | grep vite

# 查看前端日志
tail -f /home/hinkad/yun-glenautotest/backend/logs/frontend.log

# 检查5173端口
netstat -tlnp | grep 5173
```

---

## 📦 环境配置文件

### .env.dev

项目使用环境变量配置,主要配置在 `.env.dev` 文件中:

```bash
# 数据库密码
MYSQL_ROOT_PASSWORD=glen123456

# Redis密码
REDIS_PASSWORD=glen123456

# MinIO配置
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=glen123456
```

---

## 🎯 下一步操作

1. **首次部署**: 运行 `./setup-environment.sh` 安装环境
2. **启动服务**: 运行 `./deploy.sh` 或 `./restart-all.sh`
3. **访问前端**: 打开浏览器访问 http://localhost:5173
4. **登录系统**: 使用测试账号 13432898570 / C1137257
5. **检查Nacos**: 访问 http://localhost:8848/nacos 查看服务注册情况

---

**文档版本**: 1.0  
**更新日期**: 2026-01-17  
**适用环境**: WSL2 Ubuntu 24.04
