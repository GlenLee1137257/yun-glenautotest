# 🎉 Docker中间件部署成功!

## ✅ 已成功启动的服务

| 服务 | 状态 | 端口映射 | 说明 |
|------|------|---------|------|
| **glen-mysql** | ✅ Healthy | `0.0.0.0:3307->3306/tcp` | MySQL 8.0 |
| **glen-redis** | ✅ Healthy | `0.0.0.0:6379->6379/tcp` | Redis 7.0 |
| **glen-nacos** | ✅ Starting | `0.0.0.0:8848->8848/tcp` | Nacos 2.2.3 |
| **glen-zookeeper** | ✅ Running | `0.0.0.0:2181->2181/tcp` | Zookeeper 3.9 |
| **glen-kafka** | ✅ Starting | `0.0.0.0:9092->9092/tcp` | Kafka |
| **glen-minio** | ✅ Healthy | `0.0.0.0:9000-9001->9000-9001/tcp` | MinIO |

---

## 🌐 访问地址

### Nacos配置中心
```
URL: http://localhost:8848/nacos
用户名: nacos
密码: nacos
```

### MinIO对象存储
```
URL: http://localhost:9001
用户名: admin
密码: glen123456
```

### MySQL数据库
```
Host: localhost:3307  ⚠️ 注意端口是3307,不是3306
用户名: root
密码: glen123456
```

### Redis缓存
```
Host: localhost:6379
密码: glen123456
```

---

## ⚠️ 重要提示

### MySQL端口变更
由于WSL2端口转发问题,MySQL使用了 **3307** 端口而不是默认的3306。

**后端服务配置需要相应修改**:
- 位置: `backend/glen-*/src/main/resources/application.properties`
- 修改: `spring.datasource.url=jdbc:mysql://localhost:3307/...`

---

## 📋 下一步操作

### 1. 等待Nacos完全启动 (约1-2分钟)

```bash
# 查看Nacos日志
docker logs -f glen-nacos

# 或等待1分钟后访问
# http://localhost:8848/nacos
```

### 2. 修改后端配置文件

需要将MySQL端口从3306改为3307:

```bash
cd /home/hinkad/yun-glenautotest/backend

# 查找所有包含3306的配置
grep -r "3306" glen-*/src/main/resources/
```

### 3. 启动后端服务

```bash
cd /home/hinkad/yun-glenautotest

# 使用部署脚本的后续步骤
# 或手动启动
```

### 4. 启动前端服务

```bash
cd /home/hinkad/yun-glenautotest/frontend
pnpm install
pnpm run dev
```

---

## 🔍 验证服务

### 检查Docker容器
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### 访问Nacos控制台
1. 等待1-2分钟
2. 访问: http://localhost:8848/nacos
3. 登录: nacos / nacos
4. 查看"服务管理" -> "服务列表"(后端启动后会显示)

### 测试MySQL连接
```bash
# 测试连接(注意端口3307)
docker exec -it glen-mysql mysql -uroot -pglen123456 -e "SELECT 1;"
```

---

## 🐛 如果遇到问题

### Nacos启动慢
Nacos需要1-2分钟完全启动,请耐心等待。查看日志:
```bash
docker logs -f glen-nacos
```

### MySQL连接失败
确保使用端口 **3307** 而不是3306:
```
jdbc:mysql://localhost:3307/glen_account...
```

### 端口冲突
如果还有端口冲突,停止所有旧容器:
```bash
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null
cd /home/hinkad/yun-glenautotest
docker compose up -d
```

---

## 🎯 快速命令

```bash
# 查看所有容器状态
docker ps

# 查看日志
docker logs -f glen-nacos
docker logs -f glen-mysql

# 重启服务
cd /home/hinkad/yun-glenautotest
docker compose restart

# 停止服务
docker compose down
```

---

**部署时间**: 2026-01-17  
**状态**: ✅ Docker中间件部署成功  
**下一步**: 修改后端配置,启动后端和前端服务
