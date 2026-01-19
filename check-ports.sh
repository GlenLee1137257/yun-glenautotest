#!/bin/bash
# Glen AutoTest Platform - Port Check Script
# 功能：检查 Docker 容器端口占用、系统端口占用、常用服务端口状态

echo "========================================="
echo "Glen AutoTest Platform - Port Check"
echo "========================================="
echo ""

# 1. Docker 容器端口占用
echo "=== Docker 容器端口占用 ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -20
echo ""

# 2. 系统端口占用（需要 sudo）
echo "=== 系统端口占用（TCP/UDP LISTEN）==="
if command -v ss >/dev/null 2>&1; then
    sudo ss -tulnp 2>/dev/null | grep LISTEN | head -30 || echo "需要 sudo 权限查看详细进程信息"
else
    sudo netstat -tulnp 2>/dev/null | grep LISTEN | head -30 || echo "需要 sudo 权限查看详细进程信息"
fi
echo ""

# 3. 常用服务端口检查
echo "=== 常用服务端口检查 ==="
ports=(
    "3306:MySQL (默认)"
    "3307:MySQL (Glen项目)"
    "6379:Redis"
    "8848:Nacos"
    "9000:MinIO API"
    "9001:MinIO Console"
    "9092:Kafka"
    "2181:Zookeeper"
    "8000:Gateway"
    "8081:Account Service"
    "8082:Engine Service"
    "8083:Data Service"
    "5173:Frontend (Vite)"
)

for port_info in "${ports[@]}"; do
    port="${port_info%%:*}"
    desc="${port_info##*:}"
    
    # 检查 Docker 容器占用
    docker_occupied=$(docker ps --format "{{.Names}}:{{.Ports}}" | grep -oE "0\.0\.0\.0:$port|::$port" | head -1)
    
    # 检查系统端口占用
    if sudo lsof -i :$port >/dev/null 2>&1; then
        process=$(sudo lsof -i :$port 2>/dev/null | tail -n 1 | awk '{print $1, $2}' | tr '\n' ' ')
        echo "Port $port ($desc): OCCUPIED by $process"
        sudo lsof -i :$port 2>/dev/null | tail -n 1 | awk '{printf "  -> Process: %s (PID: %s, User: %s)\n", $1, $2, $3}'
        if [ -n "$docker_occupied" ]; then
            echo "  -> Docker: $docker_occupied"
        fi
    elif [ -n "$docker_occupied" ]; then
        echo "Port $port ($desc): OCCUPIED by Docker"
        echo "  -> Docker: $docker_occupied"
    else
        echo "Port $port ($desc): FREE"
    fi
done

echo ""
echo "========================================="
echo "Port Check Completed"
echo "========================================="