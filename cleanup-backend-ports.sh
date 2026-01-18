#!/bin/bash
# 清理后端服务端口脚本

echo "清理后端服务端口..."

# 清理spring-boot进程（优先清理）
pkill -9 -f "spring-boot:run" 2>/dev/null
pkill -9 -f "glen-account" 2>/dev/null
pkill -9 -f "glen-data" 2>/dev/null
pkill -9 -f "glen-engine" 2>/dev/null
pkill -9 -f "glen-gateway" 2>/dev/null

# 清理所有后端服务端口
for port in 8081 8082 8083 8000; do
    pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        service_name=""
        case $port in
            8081) service_name="account-service" ;;
            8082) service_name="data-service" ;;
            8083) service_name="engine-service" ;;
            8000) service_name="gateway-service" ;;
        esac
        echo "  停止占用端口 $port ($service_name) 的进程 (PID: $pid)..."
        kill -9 $pid 2>/dev/null
    fi
done

# 等待进程完全退出
sleep 3

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
