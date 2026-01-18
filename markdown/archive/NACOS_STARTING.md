## ⏳ Nacos正在启动中...

### 当前状态

✅ Nacos容器已启动  
✅ 端口8848已监听  
✅ Java进程正在运行  
⏳ **正在初始化MySQL数据库** (这需要2-5分钟)

### 为什么需要这么长时间?

Nacos首次启动时需要:
1. 连接MySQL数据库
2. 创建数据库表结构(约70个表)
3. 初始化配置数据
4. 启动HTTP服务

由于是首次启动,这个过程可能需要 **2-5分钟**。

---

## 🔍 如何检查Nacos是否启动完成

### 方法1: 查看Docker日志(推荐)

```bash
# 实时查看Nacos启动日志
docker logs -f glen-nacos
```

**看到以下内容说明启动成功**:
```
Nacos started successfully in stand alone mode
或
Started Nacos in xxx seconds
```

### 方法2: 检查健康状态

```bash
# 查看健康状态
docker ps | grep nacos

# 状态应该显示: Up XX minutes (healthy)
```

### 方法3: 测试访问

```bash
# 在WSL2中测试
curl http://localhost:8848/nacos/

# 或直接在浏览器访问
# http://localhost:8848/nacos
```

---

## 🚀 快速检查脚本

运行以下命令每10秒检查一次状态:

```bash
cd /home/hinkad/yun-glenautotest

# 运行监控脚本
./wait-for-nacos.sh
```

或手动检查:

```bash
# 每30秒检查一次直到成功
while true; do 
  echo "检查Nacos状态..."
  if curl -s http://localhost:8848/nacos/ | grep -q "Nacos"; then
    echo "✅ Nacos启动成功!"
    break
  fi
  echo "⏳ 还在启动中,30秒后再试..."
  sleep 30
done
```

---

## 📋 当前日志显示

根据刚才的检查:
- ✅ Tomcat已初始化 (端口8848)
- ⏳ 正在初始化Spring上下文
- ⏳ 正在连接MySQL并创建表结构

**预计还需要等待 1-3 分钟**

---

## ⚠️ 如果10分钟后仍无法访问

可能是MySQL连接问题,检查:

```bash
# 1. 检查MySQL是否健康
docker ps | grep mysql

# 2. 测试MySQL连接
docker exec -it glen-mysql mysql -uroot -pglen123456 -e "SHOW DATABASES;"

# 3. 查看Nacos完整日志找错误
docker logs glen-nacos 2>&1 | grep -i error

# 4. 重启Nacos
docker restart glen-nacos
```

---

## 💡 提示

- **不要反复刷新浏览器**,这会增加Nacos的负担
- **耐心等待2-5分钟**,首次启动确实需要时间
- 启动完成后,后续重启会很快(10-20秒)

---

**当前时间**: 2026-01-17 23:47  
**Nacos启动开始时间**: 23:31  
**已运行时间**: 约16分钟  
**建议**: 查看日志是否有错误

如果已经超过10分钟,建议重启Nacos容器。
