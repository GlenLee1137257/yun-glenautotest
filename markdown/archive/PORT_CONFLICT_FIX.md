## ⚠️ 部署遇到端口冲突问题

### 问题原因
WSL2环境的端口转发机制存在已知问题,导致3306端口无法正常转发。

---

## 🔧 快速解决方案

### 方案1: 重启WSL2 (最简单,推荐!)

**在Windows PowerShell中执行**:

```powershell
wsl --shutdown
```

然后:
1. 重新打开WSL终端
2. 运行: `cd /home/hinkad/yun-glenautotest`
3. 运行: `./deploy.sh`

---

### 方案2: 使用备用端口配置

如果方案1不work,请使用备用配置:

```bash
cd /home/hinkad/yun-glenautotest

# 备份原配置
cp docker-compose.yml docker-compose.yml.backup

# 使用备用端口配置
cp docker-compose.alternative.yml docker-compose.yml

# 重新部署
./deploy.sh
```

**备用端口映射**:
- MySQL: **3307**:3306 (避免与其他MySQL冲突)
- Redis: 6379:6379 (不变)
- Nacos: 8848:8848 (不变)
- 其他服务保持不变

**前端连接配置需要相应修改**:
- 数据库连接改为 `localhost:3307`

---

### 方案3: 重启Docker Desktop

1. 在Windows任务栏找到Docker Desktop图标
2. 右键 → Quit Docker Desktop
3. 等待10秒
4. 重新启动Docker Desktop
5. 等待Docker完全启动(图标变绿)
6. 在WSL2中运行: `./deploy.sh`

---

## 📋 完整的故障排除步骤

### Step 1: 清理现有容器

```bash
cd /home/hinkad/yun-glenautotest
docker compose down
docker ps -a | grep -E 'mysql|redis|nacos' | awk '{print $1}' | xargs docker rm -f
```

### Step 2: 选择解决方案

**优先尝试**: 方案1 (重启WSL2)  
**如果失败**: 方案3 (重启Docker Desktop)  
**最后手段**: 方案2 (修改端口)

### Step 3: 重新部署

```bash
cd /home/hinkad/yun-glenautotest
./deploy.sh
```

---

## 🔍 验证端口

部署前检查端口占用:

```bash
# 检查3306端口
netstat -tlnp | grep 3306

# 检查Docker容器
docker ps -a | grep mysql

# 停止所有旧容器
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null
```

---

## 📝 技术细节

这个错误:
```
Error response from daemon: ports are not available: exposing port TCP 0.0.0.0:3306 -> 127.0.0.1:0: /forwards/expose returned unexpected status: 500
```

是WSL2的端口转发守护进程问题,通常由以下原因引起:
1. WSL2网络栈状态不一致
2. Docker Desktop的端口代理缓存
3. Windows防火墙规则冲突
4. 旧容器的端口占用残留

**最有效的解决方法是重启WSL2**,这会重置整个网络栈。

---

## 🚀 快速修复命令

```bash
# 运行修复脚本
./fix-wsl2-port.sh

# 或按照提示,在Windows PowerShell中:
wsl --shutdown

# 然后重新打开WSL并部署
cd /home/hinkad/yun-glenautotest
./deploy.sh
```

---

**如果以上方案都不work,请告诉我,我会创建一个完全不使用Docker的本地部署方案。**
