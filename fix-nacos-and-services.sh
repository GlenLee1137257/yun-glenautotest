#!/bin/bash

# Glen 自动化云测平台 - Nacos 和服务修复脚本
# 一次性解决所有 Nacos 连接和服务启动问题

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  Glen 平台 - Nacos 和服务修复"
echo "=========================================="
echo ""

# 1. 检查并重启 Nacos
echo -e "${YELLOW}[1/6] 检查 Nacos 容器...${NC}"
if docker ps | grep -q glen-nacos; then
    echo -e "${GREEN}✓ Nacos 容器运行中${NC}"
    echo "重启 Nacos 以确保完全启动..."
    docker restart glen-nacos
    echo "等待 Nacos 启动（60秒）..."
    sleep 60
else
    echo -e "${RED}✗ Nacos 容器未运行${NC}"
    exit 1
fi

# 2. 验证 Nacos 是否完全启动
echo ""
echo -e "${YELLOW}[2/6] 验证 Nacos 启动...${NC}"
NACOS_READY=false
for i in {1..30}; do
    # 检查 HTTP 端口
    if curl -s http://localhost:8848/nacos/v1/console/health/readiness 2>&1 | grep -q "UP"; then
        # 检查 gRPC 端口
        if timeout 2 bash -c "echo > /dev/tcp/localhost/9848" 2>&1 > /dev/null; then
            echo -e "${GREEN}✓ Nacos 已完全启动（HTTP + gRPC）${NC}"
            NACOS_READY=true
            break
        fi
    fi
    echo "等待中... ($i/30)"
    sleep 2
done

if [ "$NACOS_READY" = false ]; then
    echo -e "${RED}✗ Nacos 启动超时，但继续尝试启动服务...${NC}"
    echo "查看 Nacos 日志："
    docker logs glen-nacos --tail 20
fi

# 3. 停止所有服务
echo ""
echo -e "${YELLOW}[3/6] 停止所有服务...${NC}"
systemctl stop glen-gateway glen-account glen-data glen-engine 2>/dev/null || true
sleep 3

# 4. 检查配置文件中的数据库名称
echo ""
echo -e "${YELLOW}[4/6] 检查并修复数据库配置...${NC}"
cd /opt/yun-glenautotest/backend/glen-autotest

# 修复所有 test_* 数据库名为 glen_*
find . -name "application.properties" -type f -exec sed -i 's/test_api/glen_api/g' {} \;
find . -name "application.properties" -type f -exec sed -i 's/test_account/glen_account/g' {} \;
find . -name "application.properties" -type f -exec sed -i 's/test_ui/glen_ui/g' {} \;
find . -name "application.properties" -type f -exec sed -i 's/test_stress/glen_stress/g' {} \;
find . -name "application.properties" -type f -exec sed -i 's/test_engine/glen_engine/g' {} \;
echo -e "${GREEN}✓ 数据库配置已修复${NC}"

# 5. 重新打包所有服务（包含修复后的配置）
echo ""
echo -e "${YELLOW}[5/6] 重新打包服务...${NC}"
mvn clean package -DskipTests -q
echo -e "${GREEN}✓ 打包完成${NC}"

# 6. 更新 JAR 文件
echo ""
echo -e "${YELLOW}[6/6] 更新服务 JAR 文件...${NC}"
cp glen-gateway/target/glen-gateway.jar /opt/glen-services/gateway/ 2>/dev/null || true
cp glen-account/target/glen-account.jar /opt/glen-services/account/ 2>/dev/null || true
cp glen-data/target/glen-data.jar /opt/glen-services/data/ 2>/dev/null || true
cp glen-engine/target/glen-engine.jar /opt/glen-services/engine/ 2>/dev/null || true
echo -e "${GREEN}✓ JAR 文件已更新${NC}"

# 7. 按顺序启动服务
echo ""
echo -e "${YELLOW}[7/7] 启动服务（按顺序）...${NC}"

echo "启动 Gateway..."
systemctl start glen-gateway
sleep 10

echo "启动 Account..."
systemctl start glen-account
sleep 10

echo "启动 Data..."
systemctl start glen-data
sleep 10

echo "启动 Engine..."
systemctl start glen-engine
sleep 10

# 8. 检查服务状态
echo ""
echo "=========================================="
echo "  服务状态检查"
echo "=========================================="
echo ""

for service in glen-gateway glen-account glen-data glen-engine; do
    status=$(systemctl is-active $service 2>/dev/null || echo "unknown")
    if [ "$status" = "active" ]; then
        echo -e "${GREEN}✓ $service: $status${NC}"
    else
        echo -e "${RED}✗ $service: $status${NC}"
        echo "  查看日志: tail -50 /opt/glen-services/${service#glen-}/${service#glen-}.log"
    fi
done

echo ""
echo "=========================================="
echo "  修复完成！"
echo "=========================================="
echo ""
echo "如果服务仍有问题，查看日志："
echo "  tail -f /opt/glen-services/gateway/gateway.log"
echo "  tail -f /opt/glen-services/account/account.log"
echo "  tail -f /opt/glen-services/data/data.log"
echo "  tail -f /opt/glen-services/engine/engine.log"
echo ""
echo "检查服务端口："
echo "  netstat -tlnp | grep java"
echo ""
