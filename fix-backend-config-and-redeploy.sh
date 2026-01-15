#!/bin/bash

# 修复后端配置并重新部署

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  修复后端配置并重新部署"
echo "=========================================="
echo ""

PROJECT_DIR="/opt/yun-glenautotest/backend/glen-autotest"
SERVICES_DIR="/opt/glen-services"

cd "$PROJECT_DIR"

# 1. 检查并修复配置文件
echo -e "${YELLOW}[1/6] 检查配置文件...${NC}"

# 修复数据库名称
echo "修复数据库名称..."
sed -i 's/test_account/glen_account/g' glen-account/src/main/resources/application.properties
sed -i 's/test_api/glen_api/g' glen-data/src/main/resources/application.properties
sed -i 's/test_engine/glen_engine/g' glen-engine/src/main/resources/application.properties
sed -i 's/test_account/glen_account/g' glen-gateway/src/main/resources/application.properties

echo -e "${GREEN}✓ 配置文件已修复${NC}"

# 2. 停止所有服务
echo ""
echo -e "${YELLOW}[2/6] 停止所有服务...${NC}"
systemctl stop glen-gateway 2>/dev/null || true
systemctl stop glen-account 2>/dev/null || true
systemctl stop glen-data 2>/dev/null || true
systemctl stop glen-engine 2>/dev/null || true
sleep 3
echo -e "${GREEN}✓ 所有服务已停止${NC}"

# 3. 检查端口占用
echo ""
echo -e "${YELLOW}[3/6] 检查端口占用...${NC}"
PORTS=(8000 8081 8082 8083)
for PORT in "${PORTS[@]}"; do
    PID=$(lsof -ti:$PORT 2>/dev/null || netstat -tlnp 2>/dev/null | grep ":$PORT " | awk '{print $7}' | cut -d'/' -f1 | head -1)
    if [ -n "$PID" ]; then
        echo "端口 $PORT 被进程 $PID 占用，正在终止..."
        kill -9 $PID 2>/dev/null || true
        sleep 1
    fi
done
echo -e "${GREEN}✓ 端口检查完成${NC}"

# 4. 重新编译
echo ""
echo -e "${YELLOW}[4/6] 重新编译项目...${NC}"
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 编译失败${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 编译完成${NC}"

# 5. 更新 JAR 文件
echo ""
echo -e "${YELLOW}[5/6] 更新 JAR 文件...${NC}"

# 查找 JAR 文件函数
find_jar() {
    local module_path=$1
    local base_name=$2
    local target_jar=$(find "$module_path/target" -maxdepth 1 -name "${base_name}.jar" 2>/dev/null | head -1)
    if [ -n "$target_jar" ]; then
        echo "$target_jar"
        return 0
    fi
    target_jar=$(find "$module_path/target" -maxdepth 1 -name "${base_name}-*.jar" -not -name "*-sources.jar" -not -name "*-javadoc.jar" 2>/dev/null | head -1)
    if [ -n "$target_jar" ]; then
        echo "$target_jar"
        return 0
    fi
    return 1
}

# 复制 JAR 文件
GATEWAY_JAR=$(find_jar glen-gateway glen-gateway)
ACCOUNT_JAR=$(find_jar glen-account glen-account)
DATA_JAR=$(find_jar glen-data glen-data)
ENGINE_JAR=$(find_jar glen-engine glen-engine)

if [ -n "$GATEWAY_JAR" ]; then
    cp "$GATEWAY_JAR" "$SERVICES_DIR/gateway/" && echo "✓ Gateway JAR 已更新"
fi
if [ -n "$ACCOUNT_JAR" ]; then
    cp "$ACCOUNT_JAR" "$SERVICES_DIR/account/" && echo "✓ Account JAR 已更新"
fi
if [ -n "$DATA_JAR" ]; then
    cp "$DATA_JAR" "$SERVICES_DIR/data/" && echo "✓ Data JAR 已更新"
fi
if [ -n "$ENGINE_JAR" ]; then
    cp "$ENGINE_JAR" "$SERVICES_DIR/engine/" && echo "✓ Engine JAR 已更新"
fi

# 6. 重启服务
echo ""
echo -e "${YELLOW}[6/6] 重启服务...${NC}"
systemctl daemon-reload
systemctl start glen-gateway
sleep 5
systemctl start glen-account
sleep 5
systemctl start glen-data
sleep 5
systemctl start glen-engine
sleep 10

echo ""
echo "=========================================="
echo "  服务状态"
echo "=========================================="
for service in glen-gateway glen-account glen-data glen-engine; do
    STATUS=$(systemctl is-active $service 2>/dev/null || echo "inactive")
    if [ "$STATUS" = "active" ]; then
        echo -e "${GREEN}✓ $service: $STATUS${NC}"
    else
        echo -e "${RED}✗ $service: $STATUS${NC}"
    fi
done

echo ""
echo "=========================================="
echo -e "${GREEN}  修复完成！${NC}"
echo "=========================================="
echo ""
echo "如果服务状态为 active，说明已成功启动。"
echo "如果仍有问题，请查看日志："
echo "  journalctl -u glen-account -n 50"
echo ""
