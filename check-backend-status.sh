#!/bin/bash

# 检查后端服务状态和日志

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  检查后端服务状态"
echo "=========================================="
echo ""

# 1. 检查服务状态
echo -e "${YELLOW}[1/4] 检查服务状态...${NC}"
for service in glen-gateway glen-account glen-data glen-engine; do
    STATUS=$(systemctl is-active $service 2>/dev/null || echo "inactive")
    if [ "$STATUS" = "active" ]; then
        echo -e "${GREEN}✓ $service: $STATUS${NC}"
    else
        echo -e "${RED}✗ $service: $STATUS${NC}"
    fi
done

# 2. 检查端口监听
echo ""
echo -e "${YELLOW}[2/4] 检查端口监听...${NC}"
PORTS=(8000 8001 8002 8003)
SERVICES=("gateway" "account" "data" "engine")
for i in "${!PORTS[@]}"; do
    PORT=${PORTS[$i]}
    SERVICE=${SERVICES[$i]}
    if netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
        echo -e "${GREEN}✓ 端口 $PORT ($SERVICE) 正在监听${NC}"
    else
        echo -e "${RED}✗ 端口 $PORT ($SERVICE) 未监听${NC}"
    fi
done

# 3. 检查 Nacos 注册
echo ""
echo -e "${YELLOW}[3/4] 检查 Nacos 服务注册...${NC}"
NACOS_HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
if [ "$NACOS_HTTP" = "200" ]; then
    echo -e "${GREEN}✓ Nacos 可访问${NC}"
    # 尝试查看服务列表（需要认证，可能失败）
    echo "  访问 Nacos 控制台查看服务注册: http://115.190.216.91:8848/nacos"
else
    echo -e "${RED}✗ Nacos 不可访问 (HTTP: $NACOS_HTTP)${NC}"
fi

# 4. 查看最近日志
echo ""
echo -e "${YELLOW}[4/4] 查看最近错误日志...${NC}"
echo ""
echo "--- glen-gateway 日志（最后 20 行）---"
journalctl -u glen-gateway -n 20 --no-pager | tail -20 || echo "无法获取日志"
echo ""
echo "--- glen-account 日志（最后 20 行）---"
journalctl -u glen-account -n 20 --no-pager | tail -20 || echo "无法获取日志"
echo ""
echo "--- glen-data 日志（最后 20 行）---"
journalctl -u glen-data -n 20 --no-pager | tail -20 || echo "无法获取日志"
echo ""
echo "--- glen-engine 日志（最后 20 行）---"
journalctl -u glen-engine -n 20 --no-pager | tail -20 || echo "无法获取日志"

echo ""
echo "=========================================="
echo "  检查完成"
echo "=========================================="
echo ""
echo "如果服务未运行，请执行："
echo "  systemctl start glen-gateway"
echo "  systemctl start glen-account"
echo "  systemctl start glen-data"
echo "  systemctl start glen-engine"
echo ""
echo "查看详细日志："
echo "  journalctl -u glen-account -f"
echo ""
