#!/bin/bash

# 快速启动脚本：恢复 Nacos + 重启后端服务 + 部署前端

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  Glen 自动化云测平台 - 快速启动"
echo "=========================================="
echo ""

# 1. 恢复 Nacos（如果未运行）
echo -e "${YELLOW}[1/4] 检查并恢复 Nacos...${NC}"
if ! docker ps | grep -q glen-nacos; then
    echo "Nacos 未运行，正在恢复..."
    bash restore-nacos-embedded.sh
    sleep 10
else
    echo -e "${GREEN}✓ Nacos 正在运行${NC}"
fi

# 验证 Nacos
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
if [ "$HTTP_STATUS" != "200" ]; then
    echo -e "${RED}✗ Nacos 未就绪，请等待片刻后重试${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Nacos 已就绪${NC}"

# 2. 重启后端服务
echo ""
echo -e "${YELLOW}[2/4] 重启后端服务...${NC}"
systemctl restart glen-gateway
sleep 5
systemctl restart glen-account
sleep 5
systemctl restart glen-data
sleep 5
systemctl restart glen-engine
sleep 10
echo -e "${GREEN}✓ 后端服务已重启${NC}"

# 检查服务状态
echo ""
echo "后端服务状态："
for service in glen-gateway glen-account glen-data glen-engine; do
    STATUS=$(systemctl is-active $service 2>/dev/null || echo "unknown")
    if [ "$STATUS" = "active" ]; then
        echo -e "  ${GREEN}✓ $service: $STATUS${NC}"
    else
        echo -e "  ${RED}✗ $service: $STATUS${NC}"
    fi
done

# 3. 部署前端
echo ""
echo -e "${YELLOW}[3/4] 部署前端...${NC}"
bash deploy-frontend.sh

# 4. 验证
echo ""
echo -e "${YELLOW}[4/4] 验证部署...${NC}"
echo ""
echo "=========================================="
echo -e "${GREEN}  部署完成！${NC}"
echo "=========================================="
echo ""
echo "访问地址："
echo "  前端: http://115.190.216.91/"
echo "  Nacos: http://115.190.216.91:8848/nacos"
echo "  API 网关: http://115.190.216.91:8000/"
echo ""
echo "如果无法访问，请检查："
echo "  1. 防火墙是否开放 80, 8000, 8848 端口"
echo "  2. 后端服务状态: systemctl status glen-*"
echo "  3. Nginx 状态: systemctl status nginx"
echo ""
