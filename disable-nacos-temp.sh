#!/bin/bash

# 临时禁用 Nacos 注册，让服务先启动

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  临时禁用 Nacos 注册"
echo "=========================================="
echo ""

PROJECT_DIR="/opt/yun-glenautotest/backend/glen-autotest"
SERVICES_DIR="/opt/glen-services"

cd "$PROJECT_DIR"

# 1. 备份配置文件
echo -e "${YELLOW}[1/5] 备份配置文件...${NC}"
for service in glen-gateway glen-account glen-data glen-engine; do
    if [ -f "$service/src/main/resources/application.properties" ]; then
        cp "$service/src/main/resources/application.properties" "$service/src/main/resources/application.properties.bak"
        echo "  ✓ 已备份: $service"
    fi
done

# 2. 注释掉 Nacos 配置
echo ""
echo -e "${YELLOW}[2/5] 注释 Nacos 配置...${NC}"
for service in glen-gateway glen-account glen-data glen-engine; do
    if [ -f "$service/src/main/resources/application.properties" ]; then
        # 注释掉 Nacos discovery 配置
        sed -i 's/^spring.cloud.nacos.discovery/#spring.cloud.nacos.discovery/g' "$service/src/main/resources/application.properties"
        # 注释掉 Nacos config 配置（如果有）
        sed -i 's/^spring.cloud.nacos.config/#spring.cloud.nacos.config/g' "$service/src/main/resources/application.properties"
        echo "  ✓ 已注释: $service"
    fi
done

# 3. 重新打包
echo ""
echo -e "${YELLOW}[3/5] 重新打包服务...${NC}"
mvn clean package -DskipTests -pl glen-gateway,glen-account,glen-data,glen-engine -am

# 4. 更新 JAR 文件
echo ""
echo -e "${YELLOW}[4/5] 更新 JAR 文件...${NC}"
cp glen-gateway/target/glen-gateway.jar "$SERVICES_DIR/gateway/" 2>/dev/null || true
cp glen-account/target/glen-account.jar "$SERVICES_DIR/account/" 2>/dev/null || true
cp glen-data/target/glen-data.jar "$SERVICES_DIR/data/" 2>/dev/null || true
cp glen-engine/target/glen-engine.jar "$SERVICES_DIR/engine/" 2>/dev/null || true
echo -e "${GREEN}✓ JAR 文件已更新${NC}"

# 5. 重启服务
echo ""
echo -e "${YELLOW}[5/5] 重启服务...${NC}"
systemctl restart glen-gateway
sleep 5
systemctl restart glen-account
sleep 5
systemctl restart glen-data
sleep 5
systemctl restart glen-engine
sleep 10

echo ""
echo "=========================================="
echo "  服务状态"
echo "=========================================="
systemctl status glen-gateway --no-pager | grep -E "Active:"
systemctl status glen-account --no-pager | grep -E "Active:"
systemctl status glen-data --no-pager | grep -E "Active:"
systemctl status glen-engine --no-pager | grep -E "Active:"

echo ""
echo "=========================================="
echo "  完成！"
echo "=========================================="
echo ""
echo "注意：这是临时方案，服务间无法通过 Nacos 发现。"
echo "后续需要修复 Nacos 连接问题。"
echo ""
