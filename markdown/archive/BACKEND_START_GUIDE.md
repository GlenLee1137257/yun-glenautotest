# 🚀 后端服务启动指南

**更新时间**: 2026-01-18  
**环境**: WSL2 Ubuntu

---

## ✅ 前置检查

### 1. Maven环境

Maven安装在: `/mnt/d/apache-maven-3.9.11/bin/mvn`

**如果新终端找不到 `mvn` 命令**，使用以下方式：

#### 方式1: 使用完整路径（推荐）

```bash
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run
```

#### 方式2: 配置PATH（永久生效）

已在 `~/.bashrc` 中添加了Maven路径，执行：

```bash
source ~/.bashrc
```

然后就可以直接使用 `mvn` 命令了。

---

### 2. 验证环境

```bash
# 检查Java
java -version  # 应该显示 Java 17

# 检查Maven
/mnt/d/apache-maven-3.9.11/bin/mvn -version
# 或者 (配置PATH后)
mvn -version

# 检查中间件
docker ps | grep glen-
```

---

## 🎯 启动服务

### 启动顺序

**重要**：必须按照以下顺序启动！

1. **glen-account** (端口 8081) ⭐ 最先启动
2. **glen-data** (端口 8082) - 等待account启动后
3. **glen-engine** (端口 8083) - 等待data启动后
4. **glen-gateway** (端口 8000) - 最后启动

---

### 方式1: 使用Maven命令（开发环境，推荐）

在**4个不同的终端**中分别执行：

#### 终端1 - 启动 account-service

```bash
cd /home/hinkad/yun-glenautotest/backend/glen-account
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run
```

**等待启动完成**（看到 "Started AccountApplication" 日志，约30-60秒）

#### 终端2 - 启动 data-service

```bash
cd /home/hinkad/yun-glenautotest/backend/glen-data
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run
```

**等待启动完成**（约30-60秒）

#### 终端3 - 启动 engine-service

```bash
cd /home/hinkad/yun-glenautotest/backend/glen-engine
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run
```

**等待启动完成**（约30-60秒）

#### 终端4 - 启动 gateway-service

```bash
cd /home/hinkad/yun-glenautotest/backend/glen-gateway
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run
```

---

### 方式2: 后台启动（生产环境）

#### 使用Maven后台启动

```bash
cd /home/hinkad/yun-glenautotest/backend

# 启动 account-service
cd glen-account
nohup /mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run > ../../logs/account-service.log 2>&1 &
sleep 30

# 启动 data-service
cd ../glen-data
nohup /mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run > ../../logs/data-service.log 2>&1 &
sleep 30

# 启动 engine-service
cd ../glen-engine
nohup /mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run > ../../logs/engine-service.log 2>&1 &
sleep 30

# 启动 gateway-service
cd ../glen-gateway
nohup /mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run > ../../logs/gateway-service.log 2>&1 &
```

#### 使用JAR文件启动（需要先编译）

```bash
cd /home/hinkad/yun-glenautotest/backend

# 启动 account-service
nohup java -jar glen-account/target/glen-account.jar > ../logs/account-service.log 2>&1 &
sleep 30

# 启动 data-service
nohup java -jar glen-data/target/glen-data.jar > ../logs/data-service.log 2>&1 &
sleep 30

# 启动 engine-service
nohup java -jar glen-engine/target/glen-engine.jar > ../logs/engine-service.log 2>&1 &
sleep 30

# 启动 gateway-service
nohup java -jar glen-gateway/target/glen-gateway.jar > ../logs/gateway-service.log 2>&1 &
```

---

## 🔍 验证服务状态

### 1. 检查端口监听

```bash
netstat -tlnp | grep -E "8081|8082|8083|8000"
```

**期望输出**:
```
tcp6  0  0  :::8081  :::*  LISTEN  进程ID/java
tcp6  0  0  :::8082  :::*  LISTEN  进程ID/java
tcp6  0  0  :::8083  :::*  LISTEN  进程ID/java
tcp6  0  0  :::8000  :::*  LISTEN  进程ID/java
```

### 2. 查看Nacos服务注册

访问: **http://localhost:8848/nacos**

1. 登录（用户名: `nacos`, 密码: `nacos`）
2. 点击 "服务管理" -> "服务列表"
3. 应该看到以下服务（状态为"健康"）:
   - `account-service` (1个实例)
   - `data-service` (1个实例)
   - `engine-service` (1个实例)
   - `gateway-service` (1个实例)

### 3. 测试服务健康检查

```bash
# 测试 account-service
curl http://localhost:8081/actuator/health

# 测试 data-service
curl http://localhost:8082/actuator/health

# 测试 engine-service
curl http://localhost:8083/actuator/health

# 测试 gateway-service
curl http://localhost:8000/actuator/health
```

### 4. 查看服务日志

```bash
# 查看 account-service 日志
tail -f /home/hinkad/yun-glenautotest/logs/account-service.log

# 查看 data-service 日志
tail -f /home/hinkad/yun-glenautotest/logs/data-service.log

# 查看 engine-service 日志
tail -f /home/hinkad/yun-glenautotest/logs/engine-service.log

# 查看 gateway-service 日志
tail -f /home/hinkad/yun-glenautotest/logs/gateway-service.log
```

---

## 📊 服务访问地址

启动成功后，可以通过以下地址访问：

| 服务 | 访问地址 | 说明 |
|------|---------|------|
| account-service | http://localhost:8081 | 账号服务 |
| data-service | http://localhost:8082 | 数据服务 |
| engine-service | http://localhost:8083 | 引擎服务 |
| gateway-service | http://localhost:8000 | 网关服务（统一入口） |
| Nacos控制台 | http://localhost:8848/nacos | 服务注册中心 |

---

## 🐛 常见问题

### Q1: Maven命令找不到

**错误**: `Command 'mvn' not found`

**解决**:
```bash
# 使用完整路径
/mnt/d/apache-maven-3.9.11/bin/mvn spring-boot:run

# 或配置PATH后重新加载
source ~/.bashrc
mvn spring-boot:run
```

### Q2: 端口被占用

**错误**: `Address already in use`

**解决**:
```bash
# 查找占用端口的进程
netstat -tlnp | grep 8081

# 或使用lsof
lsof -i :8081

# 停止占用端口的进程
kill -9 <进程ID>
```

### Q3: 服务启动失败

**检查**:
1. 查看服务日志：`tail -f logs/xxx-service.log`
2. 检查MySQL连接（端口3307）
3. 检查Nacos连接（localhost:8848）
4. 检查Redis连接（localhost:6379）

### Q4: 依赖找不到

**错误**: `Could not find artifact com.glen.autotest:glen-common`

**解决**:
```bash
cd /home/hinkad/yun-glenautotest/backend
/mnt/d/apache-maven-3.9.11/bin/mvn install -DskipTests
```

### Q5: 服务无法注册到Nacos

**检查**:
1. Nacos是否运行：`docker ps | grep nacos`
2. Nacos是否可访问：`curl http://localhost:8848/nacos`
3. 配置文件中的Nacos地址是否正确
4. Nacos用户名密码是否正确（nacos/nacos）

---

## 🛑 停止服务

### 方式1: 查找并停止进程

```bash
# 查找Java进程
ps aux | grep spring-boot

# 停止所有服务
pkill -f "spring-boot:run"
# 或
pkill -f "glen-"
```

### 方式2: 按端口停止

```bash
# 查找占用8081端口的进程并停止
lsof -ti :8081 | xargs kill -9

# 批量停止所有服务端口
for port in 8081 8082 8083 8000; do
    lsof -ti :$port | xargs kill -9 2>/dev/null
done
```

---

## 📋 启动检查清单

- [ ] Maven环境已配置
- [ ] Java环境已配置（Java 17）
- [ ] Docker中间件已启动（MySQL, Redis, Nacos等）
- [ ] 数据库已初始化
- [ ] 配置文件已正确（MySQL端口3307）
- [ ] 按顺序启动4个服务
- [ ] 验证服务端口监听
- [ ] 验证Nacos服务注册
- [ ] 测试服务健康检查

---

## 🎯 下一步

后端服务启动成功后：

1. ✅ 启动前端服务
2. ✅ 测试系统功能
3. ✅ 访问前端页面

详见: `markdown/项目启动指南.md`

---

**文档位置**: `/home/hinkad/yun-glenautotest/markdown/BACKEND_START_GUIDE.md`  
**最后更新**: 2026-01-18
