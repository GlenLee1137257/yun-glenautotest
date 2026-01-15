#!/bin/bash

# Nacos 连接问题诊断和修复脚本

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  Nacos 连接问题诊断和修复"
echo "=========================================="
echo ""

# 1. 检查 Nacos 容器状态
echo -e "${YELLOW}[1/6] 检查 Nacos 容器状态...${NC}"
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ Nacos 容器未运行${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Nacos 容器运行中${NC}"

# 2. 检查端口监听
echo ""
echo -e "${YELLOW}[2/6] 检查端口监听...${NC}"
echo "HTTP 端口 8848:"
netstat -tlnp | grep 8848 || echo "  未监听"
echo "gRPC 端口 9848:"
netstat -tlnp | grep 9848 || echo "  未监听"

# 3. 检查 Nacos 容器内部状态
echo ""
echo -e "${YELLOW}[3/6] 检查 Nacos 容器内部...${NC}"
NACOS_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-nacos)
echo "Nacos 容器 IP: $NACOS_IP"

# 检查容器内端口
echo "容器内端口监听:"
docker exec glen-nacos netstat -tlnp 2>/dev/null | grep -E "8848|9848" || echo "  无法检查"

# 4. 测试 Nacos 连接
echo ""
echo -e "${YELLOW}[4/6] 测试 Nacos 连接...${NC}"

# 测试 HTTP
echo "测试 HTTP (localhost:8848):"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://localhost:8848/nacos/ 2>&1 || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}  ✓ HTTP 连接成功 (200)${NC}"
else
    echo -e "${RED}  ✗ HTTP 连接失败 (代码: $HTTP_CODE)${NC}"
fi

# 测试容器 IP
echo "测试 HTTP (容器IP $NACOS_IP:8848):"
HTTP_CODE_IP=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://$NACOS_IP:8848/nacos/ 2>&1 || echo "000")
if [ "$HTTP_CODE_IP" = "200" ]; then
    echo -e "${GREEN}  ✓ 容器IP HTTP 连接成功 (200)${NC}"
else
    echo -e "${RED}  ✗ 容器IP HTTP 连接失败 (代码: $HTTP_CODE_IP)${NC}"
fi

# 测试 gRPC 端口
echo "测试 gRPC (localhost:9848):"
if timeout 3 bash -c "echo > /dev/tcp/localhost/9848" 2>/dev/null; then
    echo -e "${GREEN}  ✓ gRPC 端口可连接${NC}"
else
    echo -e "${RED}  ✗ gRPC 端口无法连接${NC}"
fi

# 5. 查看 Nacos 日志
echo ""
echo -e "${YELLOW}[5/6] 查看 Nacos 最新日志...${NC}"
docker logs glen-nacos --tail 30 | grep -E "started|ready|error|exception|Nacos" -i | tail -10

# 6. 修复方案
echo ""
echo -e "${YELLOW}[6/6] 尝试修复...${NC}"

# 方案 A: 重启 Nacos
echo "方案 A: 重启 Nacos 容器..."
docker restart glen-nacos
echo "等待 Nacos 启动（60秒）..."
sleep 60

# 再次测试
echo ""
echo "再次测试连接..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://localhost:8848/nacos/ 2>&1 || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✓ Nacos 连接成功！${NC}"
    
    # 重启所有服务
    echo ""
    echo "重启所有后端服务..."
    systemctl restart glen-gateway
    sleep 5
    systemctl restart glen-account
    sleep 5
    systemctl restart glen-data
    sleep 5
    systemctl restart glen-engine
    sleep 10
    
    echo ""
    echo "=== 服务状态 ==="
    systemctl status glen-gateway --no-pager | grep -E "Active:"
    systemctl status glen-account --no-pager | grep -E "Active:"
    systemctl status glen-data --no-pager | grep -E "Active:"
    systemctl status glen-engine --no-pager | grep -E "Active:"
else
    echo -e "${RED}✗ Nacos 仍无法连接${NC}"
    echo ""
    echo "请检查："
    echo "1. Nacos 容器日志: docker logs glen-nacos"
    echo "2. 防火墙设置"
    echo "3. 端口映射配置"
fi

echo ""
echo "=========================================="
echo "  诊断完成"
echo "=========================================="
