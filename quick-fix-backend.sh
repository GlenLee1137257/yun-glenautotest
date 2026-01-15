#!/bin/bash

# 快速修复后端配置（不重新编译，直接修改配置文件）

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  快速修复后端配置"
echo "=========================================="
echo ""

PROJECT_DIR="/opt/yun-glenautotest/backend/glen-autotest"

# 1. 拉取最新代码
echo -e "${YELLOW}[1/4] 拉取最新代码...${NC}"
cd "$PROJECT_DIR"
git pull
echo -e "${GREEN}✓ 代码已更新${NC}"

# 2. 修复配置文件
echo ""
echo -e "${YELLOW}[2/4] 修复配置文件...${NC}"
sed -i 's/test_account/glen_account/g' glen-account/src/main/resources/application.properties
sed -i 's/test_api/glen_api/g' glen-data/src/main/resources/application.properties
sed -i 's/test_engine/glen_engine/g' glen-engine/src/main/resources/application.properties
sed -i 's/test_account/glen_account/g' glen-gateway/src/main/resources/application.properties

echo "验证修复结果："
grep "spring.datasource.url" glen-account/src/main/resources/application.properties | grep -v "^#" | head -1
grep "spring.datasource.url" glen-data/src/main/resources/application.properties | grep -v "^#" | head -1
grep "spring.datasource.url" glen-engine/src/main/resources/application.properties | grep -v "^#" | head -1
echo -e "${GREEN}✓ 配置文件已修复${NC}"

# 3. 停止服务
echo ""
echo -e "${YELLOW}[3/4] 停止所有服务...${NC}"
systemctl stop glen-gateway 2>/dev/null || true
systemctl stop glen-account 2>/dev/null || true
systemctl stop glen-data 2>/dev/null || true
systemctl stop glen-engine 2>/dev/null || true

# 释放端口
for PORT in 8000 8081 8082 8083; do
    PID=$(lsof -ti:$PORT 2>/dev/null || netstat -tlnp 2>/dev/null | grep ":$PORT " | awk '{print $7}' | cut -d'/' -f1 | head -1)
    if [ -n "$PID" ] && [ "$PID" != "-" ]; then
        echo "释放端口 $PORT (PID: $PID)..."
        kill -9 $PID 2>/dev/null || true
    fi
done
sleep 3
echo -e "${GREEN}✓ 服务已停止${NC}"

# 4. 重新编译和部署
echo ""
echo -e "${YELLOW}[4/4] 重新编译和部署...${NC}"
echo "这可能需要几分钟时间..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 编译失败${NC}"
    exit 1
fi

# 复制 JAR 文件
SERVICES_DIR="/opt/glen-services"

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

# 重启服务
echo ""
echo "重启服务..."
systemctl daemon-reload
systemctl start glen-gateway
sleep 8
systemctl start glen-account
sleep 8
systemctl start glen-data
sleep 8
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
        echo "  查看日志: journalctl -u $service -n 30"
    fi
done

echo ""
echo "=========================================="
echo -e "${GREEN}  修复完成！${NC}"
echo "=========================================="
echo ""
echo "如果服务状态为 active，可以尝试登录。"
echo "如果服务仍在重启，请查看日志："
echo "  journalctl -u glen-account -n 50"
echo ""
