# 🔧 端口冲突解决方案

**更新时间**: 2026-01-18

---

## 📊 问题描述

启动服务时遇到端口冲突：
```
Web server failed to start. Port 8081 was already in use.
```

---

## 🔍 快速诊断

### 查找占用端口的进程

```bash
# 方式1: 使用lsof（推荐）
lsof -i :8081

# 方式2: 使用netstat
netstat -tlnp | grep :8081

# 方式3: 查找所有后端服务端口
for port in 8081 8082 8083 8000; do
    echo "端口 $port:"
    lsof -ti :$port && echo "  被占用" || echo "  空闲"
done
```

---

## ✅ 解决方案

### 方案1: 停止占用端口的进程（推荐）

#### 使用lsof

```bash
# 停止占用8081的进程
lsof -ti :8081 | xargs kill -9

# 停止所有后端服务端口
for port in 8081 8082 8083 8000; do
    lsof -ti :$port | xargs kill -9 2>/dev/null
done
```

#### 使用pkill

```bash
# 停止所有spring-boot进程
pkill -f "spring-boot:run"

# 或停止所有glen相关进程
pkill -f "glen-"
```

#### 使用进程名查找

```bash
# 查找进程
ps aux | grep spring-boot | grep -v grep

# 停止进程（替换<PID>为实际进程ID）
kill -9 <PID>
```

---

### 方案2: 修改服务端口（不推荐）

如果需要多个实例运行，可以修改配置文件中的端口：

```properties
# 例如：修改account-service端口为8085
server.port=8085
```

---

## 🔍 检查服务状态

### 检查所有后端服务端口

```bash
#!/bin/bash
echo "检查后端服务端口状态:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for port in 8081 8082 8083 8000; do
    service_name=""
    case $port in
        8081) service_name="account-service" ;;
        8082) service_name="data-service" ;;
        8083) service_name="engine-service" ;;
        8000) service_name="gateway-service" ;;
    esac
    
    if lsof -ti :$port > /dev/null 2>&1; then
        pid=$(lsof -ti :$port | head -1)
        echo "端口 $port ($service_name): ✅ 被进程 $pid 占用"
    else
        echo "端口 $port ($service_name): ⏳ 空闲"
    fi
done
```

---

## 🚀 启动服务前检查

在启动服务前，建议先检查端口状态：

```bash
# 快速检查脚本
check_ports() {
    for port in 8081 8082 8083 8000; do
        if lsof -ti :$port > /dev/null 2>&1; then
            echo "⚠️  端口 $port 被占用，正在清理..."
            lsof -ti :$port | xargs kill -9 2>/dev/null
        fi
    done
    echo "✅ 端口检查完成"
}

# 执行检查
check_ports
```

---

## 📋 常见端口占用场景

| 端口 | 服务 | 常见占用原因 |
|------|------|------------|
| 8081 | account-service | 之前启动的服务未停止 |
| 8082 | data-service | 之前启动的服务未停止 |
| 8083 | engine-service | 之前启动的服务未停止 |
| 8000 | gateway-service | 之前启动的服务未停止 |

---

## 💡 预防措施

### 方式1: 启动前清理端口

```bash
# 在启动脚本中添加端口清理
cleanup_ports() {
    echo "清理端口..."
    for port in 8081 8082 8083 8000; do
        lsof -ti :$port | xargs kill -9 2>/dev/null
    done
    sleep 2
}

# 在启动服务前调用
cleanup_ports
```

### 方式2: 使用进程管理

使用 `screen` 或 `tmux` 管理服务进程，便于查看和停止：

```bash
# 使用screen
screen -S account-service -d -m mvn spring-boot:run

# 查看screen会话
screen -ls

# 重新连接
screen -r account-service

# 停止screen会话
screen -X -S account-service quit
```

---

## 🔧 一键清理脚本

创建清理脚本 `cleanup-backend.sh`:

```bash
#!/bin/bash
echo "清理后端服务端口..."

for port in 8081 8082 8083 8000; do
    pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        echo "停止占用端口 $port 的进程 (PID: $pid)..."
        kill -9 $pid
    fi
done

# 清理spring-boot进程
pkill -f "spring-boot:run" 2>/dev/null

sleep 2

echo "✅ 清理完成"
echo ""
echo "端口状态:"
for port in 8081 8082 8083 8000; do
    if lsof -ti :$port > /dev/null 2>&1; then
        echo "  ⚠️  端口 $port: 仍被占用"
    else
        echo "  ✅ 端口 $port: 空闲"
    fi
done
```

---

## 📝 相关文档

- `markdown/BACKEND_START_GUIDE.md` - 后端服务启动指南
- `markdown/PORT_CONFLICT_FIX.md` - 端口冲突修复指南

---

**文档位置**: `/home/hinkad/yun-glenautotest/markdown/PORT_CONFLICT_SOLUTION.md`  
**最后更新**: 2026-01-18
