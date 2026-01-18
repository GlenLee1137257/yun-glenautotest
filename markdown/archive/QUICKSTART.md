# 快速部署 Glen自动化测试平台

## ⚠️ 重要提示

您正在WSL2环境中部署。请先确保:

1. ✅ Windows上已安装 **Docker Desktop**
2. ✅ Docker Desktop中已启用 **WSL Integration**
   - 打开Docker Desktop → Settings → Resources → WSL Integration
   - 启用Ubuntu集成

---

## 🚀 一键部署

```bash
# 1. 进入项目目录
cd /home/hinkad/yun-glenautotest

# 2. 给脚本执行权限(仅首次需要)
chmod +x *.sh

# 3. 执行启动脚本
./restart-all.sh
```

---

## 📋 访问地址

部署完成后,使用以下地址访问:

### 🌐 前端应用
```
http://localhost:5173
账号: 13432898570
密码: C1137257
```

### 🔧 Nacos控制台
```
http://localhost:8848/nacos
用户名: nacos
密码: nacos
```

### 📦 MinIO控制台
```
http://localhost:9001
用户名: admin
密码: glen123456
```

### 🗄️ MySQL数据库
```
Host: localhost:3306
用户名: root
密码: glen123456
```

---

## 🔍 检查服务状态

```bash
# 查看Docker容器
docker compose ps

# 查看后端服务
ps aux | grep spring-boot

# 查看前端服务
ps aux | grep vite

# 查看日志
tail -f /home/hinkad/yun-glenautotest/backend/logs/gateway.log
```

---

## 🛑 停止服务

```bash
cd /home/hinkad/yun-glenautotest
./stop-all.sh
```

---

## ❗ 如果Docker命令不可用

请在Windows PowerShell中执行:

```powershell
# 重启WSL
wsl --shutdown

# 然后重新打开WSL终端
```

确保Docker Desktop正在运行,并已启用WSL集成。

---

**部署脚本路径**: /home/hinkad/yun-glenautotest/restart-all.sh
