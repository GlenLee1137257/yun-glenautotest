#!/bin/bash

# 查看服务详细日志

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SERVICE_NAME="${1:-glen-account}"

echo "=========================================="
echo "  查看 $SERVICE_NAME 详细日志"
echo "=========================================="
echo ""

# 1. 查看 systemd 日志（包含标准输出和错误）
echo -e "${YELLOW}[1/3] Systemd 日志（最后 50 行）...${NC}"
journalctl -u $SERVICE_NAME -n 50 --no-pager

# 2. 查看应用日志文件（如果存在）
echo ""
echo -e "${YELLOW}[2/3] 应用日志文件...${NC}"
SERVICES_DIR="/opt/glen-services"
SERVICE_SHORT_NAME=$(echo $SERVICE_NAME | sed 's/glen-//')
SERVICE_DIR="$SERVICES_DIR/$SERVICE_SHORT_NAME"

# 根据服务名确定日志文件名
case $SERVICE_NAME in
    glen-gateway)
        LOG_FILE="$SERVICE_DIR/gateway.log"
        ;;
    glen-account)
        LOG_FILE="$SERVICE_DIR/account.log"
        ;;
    glen-data)
        LOG_FILE="$SERVICE_DIR/data.log"
        ;;
    glen-engine)
        LOG_FILE="$SERVICE_DIR/engine.log"
        ;;
    *)
        LOG_FILE="$SERVICE_DIR/${SERVICE_NAME}.log"
        ;;
esac

if [ -f "$LOG_FILE" ]; then
    echo "日志文件: $LOG_FILE"
    echo "文件大小: $(ls -lh "$LOG_FILE" | awk '{print $5}')"
    echo ""
    echo "最后 100 行（包含错误信息）："
    tail -100 "$LOG_FILE" | grep -E "ERROR|Exception|Failed|failed|error|exception" -A 5 -B 5 || tail -50 "$LOG_FILE"
else
    echo "未找到日志文件: $LOG_FILE"
    echo "检查服务目录: $SERVICE_DIR"
    if [ -d "$SERVICE_DIR" ]; then
        echo "目录内容："
        ls -lh "$SERVICE_DIR" | head -10
    fi
fi

# 3. 尝试直接运行 JAR 查看错误
echo ""
echo -e "${YELLOW}[3/3] 尝试直接运行 JAR（查看启动错误）...${NC}"
JAR_FILE="$SERVICE_DIR/${SERVICE_NAME}.jar"
if [ -f "$JAR_FILE" ]; then
    echo "JAR 文件: $JAR_FILE"
    echo "注意：这将启动服务，按 Ctrl+C 停止"
    echo ""
    read -p "是否直接运行查看错误？(y/n): " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        cd "$SERVICE_DIR"
        java -jar "$JAR_FILE" 2>&1 | head -100
    else
        echo "已跳过"
    fi
else
    echo "未找到 JAR 文件: $JAR_FILE"
fi

echo ""
echo "=========================================="
echo "  提示"
echo "=========================================="
echo ""
echo "查看实时日志："
echo "  journalctl -u $SERVICE_NAME -f"
echo ""
echo "查看所有服务的日志："
echo "  bash view-service-logs.sh glen-gateway"
echo "  bash view-service-logs.sh glen-account"
echo "  bash view-service-logs.sh glen-data"
echo "  bash view-service-logs.sh glen-engine"
echo ""
