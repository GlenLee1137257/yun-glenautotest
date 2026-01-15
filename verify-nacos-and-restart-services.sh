#!/bin/bash

# 验证 Nacos 并重启后端服务

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  验证 Nacos 并重启后端服务"
echo "=========================================="
echo ""

# 1. 检查 Nacos 容器状态
echo -e "${YELLOW}[1/5] 检查 Nacos 容器状态...${NC}"
if docker ps | grep -q glen-nacos; then
    echo -e "${GREEN}✓ Nacos 容器运行中${NC}"
else
    echo -e "${RED}✗ Nacos 容器未运行${NC}"
    exit 1
fi

# 2. 等待 Nacos 完全启动
echo ""
echo -e "${YELLOW}[2/5] 等待 Nacos 完全启动（最多等待 120 秒）...${NC}"
MAX_WAIT=120
WAIT_COUNT=0
HTTP_STATUS=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos HTTP 连接成功（等待了 ${WAIT_COUNT} 秒）${NC}"
        break
    fi
    if [ $((WAIT_COUNT % 10)) -eq 0 ]; then
        echo "  等待中... (${WAIT_COUNT}/${MAX_WAIT} 秒)"
    fi
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

if [ "$HTTP_STATUS" != "200" ]; then
    echo -e "${RED}✗ Nacos 启动超时或连接失败（HTTP 状态码: $HTTP_STATUS）${NC}"
    echo "查看 Nacos 日志："
    docker logs glen-nacos 2>&1 | tail -30
    exit 1
fi

# 3. 测试 gRPC 端口
echo ""
echo -e "${YELLOW}[3/5] 测试 Nacos gRPC 端口 (9848)...${NC}"
GRPC_TEST=$(timeout 2 bash -c "echo > /dev/tcp/localhost/9848" 2>/dev/null && echo "ok" || echo "fail")
if [ "$GRPC_TEST" = "ok" ]; then
    echo -e "${GREEN}✓ gRPC 端口 (9848) 可访问${NC}"
else
    echo -e "${YELLOW}⚠ gRPC 端口可能还未就绪，但 HTTP 已可用${NC}"
fi

# 4. 显示 Nacos 信息
echo ""
echo -e "${YELLOW}[4/5] Nacos 访问信息...${NC}"
echo -e "${GREEN}Nacos 控制台：${NC}"
echo "  URL: http://115.190.216.91:8848/nacos"
echo "  用户名: nacos"
echo "  密码: nacos"
echo ""

# 5. 重启所有后端服务
echo -e "${YELLOW}[5/5] 重启所有后端服务...${NC}"
systemctl restart glen-gateway
sleep 5
echo -e "${GREEN}✓ glen-gateway 已重启${NC}"

systemctl restart glen-account
sleep 5
echo -e "${GREEN}✓ glen-account 已重启${NC}"

systemctl restart glen-data
sleep 5
echo -e "${GREEN}✓ glen-data 已重启${NC}"

systemctl restart glen-engine
sleep 10
echo -e "${GREEN}✓ glen-engine 已重启${NC}"

# 6. 检查服务状态
echo ""
echo "=========================================="
echo "  服务状态"
echo "=========================================="
echo ""
for service in glen-gateway glen-account glen-data glen-engine; do
    echo -e "${YELLOW}$service:${NC}"
    systemctl status $service --no-pager | grep -E "Active:|Main PID:" || true
    echo ""
done

# 7. 检查服务日志中的 Nacos 连接状态
echo "=========================================="
echo "  检查 Nacos 注册状态"
echo "=========================================="
echo ""
for service in glen-gateway glen-account glen-data glen-engine; do
    echo -e "${YELLOW}$service 日志（最近 5 行，包含 Nacos）:${NC}"
    journalctl -u $service -n 20 --no-pager | grep -i "nacos\|registered\|discovery" | tail -3 || echo "  无相关日志"
    echo ""
done

echo "=========================================="
echo "  完成！"
echo "=========================================="
echo ""
echo "如果服务状态为 'active (running)'，说明服务已成功启动。"
echo "如果看到 'Client not connected' 错误，请等待 30-60 秒后再次检查。"
echo ""
