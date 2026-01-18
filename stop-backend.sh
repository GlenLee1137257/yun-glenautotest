#!/bin/bash
# Glen AutoTest Platform - 停止后端服务脚本

set -e

PROJECT_ROOT="/home/hinkad/yun-glenautotest"
cd $PROJECT_ROOT

echo "========================================="
echo "Glen 自动化测试平台 - 停止后端服务"
echo "========================================="
echo ""

# 停止后端服务进程
echo "正在停止后端服务..."

# 方式1: 通过进程名停止
echo "  1. 停止 Spring Boot 进程..."
pkill -f "spring-boot:run" 2>/dev/null && echo "    ✅ Spring Boot 进程已停止" || echo "    ℹ️  无 Spring Boot 进程"

# 方式2: 通过端口停止（更可靠）
echo "  2. 停止占用端口的进程..."
for port in 8000 8081 8082 8083; do
    pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        service_name=""
        case $port in
            8000) service_name="gateway-service" ;;
            8081) service_name="account-service" ;;
            8082) service_name="data-service" ;;
            8083) service_name="engine-service" ;;
        esac
        echo "    停止 $service_name (端口 $port, PID: $pid)..."
        kill -9 $pid 2>/dev/null || true
    fi
done

# 等待进程完全退出
sleep 2

# 验证停止结果
echo ""
echo "验证停止结果:"
all_stopped=true
for port in 8000 8081 8082 8083; do
    if lsof -ti :$port > /dev/null 2>&1; then
        echo "  ⚠️  端口 $port: 仍被占用"
        all_stopped=false
    else
        service_name=""
        case $port in
            8000) service_name="gateway" ;;
            8081) service_name="account" ;;
            8082) service_name="data" ;;
            8083) service_name="engine" ;;
        esac
        echo "  ✅ $service_name-service (端口 $port): 已停止"
    fi
done

echo ""
if [ "$all_stopped" = true ]; then
    echo "========================================="
    echo "✅ 所有后端服务已成功停止"
    echo "========================================="
else
    echo "========================================="
    echo "⚠️  部分服务可能未完全停止，请检查"
    echo "========================================="
fi
