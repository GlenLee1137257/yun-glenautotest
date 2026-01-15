#!/bin/bash

# Glen自动化云测平台 - 完整后端部署脚本
# 使用前请确保：1. 中间件已启动 2. 数据库已初始化 3. 代码已编译

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Glen自动化云测平台 - 后端服务部署"
echo "=========================================="
echo ""

# 项目路径
PROJECT_DIR="/opt/yun-glenautotest/backend/glen-autotest"
SERVICES_DIR="/opt/glen-services"

# 1. 检查中间件服务
echo -e "${YELLOW}[1/6] 检查中间件服务...${NC}"
echo "检查 MySQL..."
if ! docker ps | grep -q glen-mysql; then
    echo -e "${RED}✗ MySQL 未运行，请先启动中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MySQL 运行中${NC}"

echo "检查 Redis..."
if ! docker ps | grep -q glen-redis; then
    echo -e "${RED}✗ Redis 未运行，请先启动中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Redis 运行中${NC}"

echo "检查 Nacos..."
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ Nacos 未运行，请先启动中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Nacos 运行中${NC}"

echo "检查 Kafka..."
if ! docker ps | grep -q glen-kafka; then
    echo -e "${RED}✗ Kafka 未运行，请先启动中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Kafka 运行中${NC}"

echo "检查 MinIO..."
if ! docker ps | grep -q glen-minio; then
    echo -e "${RED}✗ MinIO 未运行，请先启动中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MinIO 运行中${NC}"

# 2. 检查 JAR 文件
echo ""
echo -e "${YELLOW}[2/6] 检查编译产物...${NC}"
cd "$PROJECT_DIR"

# 查找 JAR 文件的函数
find_jar() {
    local module=$1
    local jar_name=$2
    
    # 方法1: 在 target 目录查找（精确匹配或带版本号）
    if [ -d "$module/target" ]; then
        # 先尝试精确匹配（无版本号）
        if [ -f "$module/target/${jar_name}.jar" ]; then
            echo "$module/target/${jar_name}.jar"
            return 0
        fi
        # 再尝试带版本号的
        local target_jar=$(find "$module/target" -maxdepth 1 -name "${jar_name}*.jar" -not -name "*-sources.jar" -not -name "*-javadoc.jar" 2>/dev/null | head -1)
        if [ -n "$target_jar" ] && [ -f "$target_jar" ]; then
            echo "$target_jar"
            return 0
        fi
    fi
    
    # 方法2: 在 Maven 本地仓库查找
    local maven_jar=$(find ~/.m2/repository -name "${jar_name}*.jar" -path "*/${module}/*" -not -name "*-sources.jar" -not -name "*-javadoc.jar" 2>/dev/null | head -1)
    if [ -n "$maven_jar" ] && [ -f "$maven_jar" ]; then
        echo "$maven_jar"
        return 0
    fi
    
    return 1
}

# 检查并记录 JAR 文件路径
ACCOUNT_JAR=$(find_jar "glen-account" "glen-account")
DATA_JAR=$(find_jar "glen-data" "glen-data")
ENGINE_JAR=$(find_jar "glen-engine" "glen-engine")
GATEWAY_JAR=$(find_jar "glen-gateway" "glen-gateway")

if [ -z "$ACCOUNT_JAR" ] || [ -z "$DATA_JAR" ] || [ -z "$ENGINE_JAR" ] || [ -z "$GATEWAY_JAR" ]; then
    echo -e "${RED}✗ 找不到 JAR 文件${NC}"
    echo "请先执行: mvn clean package -DskipTests"
    echo ""
    echo "尝试查找结果："
    [ -n "$ACCOUNT_JAR" ] && echo "  ✓ Account: $ACCOUNT_JAR" || echo "  ✗ Account: 未找到"
    [ -n "$DATA_JAR" ] && echo "  ✓ Data: $DATA_JAR" || echo "  ✗ Data: 未找到"
    [ -n "$ENGINE_JAR" ] && echo "  ✓ Engine: $ENGINE_JAR" || echo "  ✗ Engine: 未找到"
    [ -n "$GATEWAY_JAR" ] && echo "  ✓ Gateway: $GATEWAY_JAR" || echo "  ✗ Gateway: 未找到"
    exit 1
fi

echo -e "${GREEN}✓ Account: $(basename $ACCOUNT_JAR)${NC}"
echo -e "${GREEN}✓ Data: $(basename $DATA_JAR)${NC}"
echo -e "${GREEN}✓ Engine: $(basename $ENGINE_JAR)${NC}"
echo -e "${GREEN}✓ Gateway: $(basename $GATEWAY_JAR)${NC}"

# 3. 创建服务目录
echo ""
echo -e "${YELLOW}[3/6] 创建服务目录...${NC}"
mkdir -p "$SERVICES_DIR"/{account,data,engine,gateway}
echo -e "${GREEN}✓ 服务目录创建完成${NC}"

# 4. 复制 JAR 文件
echo ""
echo -e "${YELLOW}[4/6] 复制 JAR 文件...${NC}"
cp "$ACCOUNT_JAR" "$SERVICES_DIR/account/" 2>/dev/null || true
cp "$DATA_JAR" "$SERVICES_DIR/data/" 2>/dev/null || true
cp "$ENGINE_JAR" "$SERVICES_DIR/engine/" 2>/dev/null || true
cp "$GATEWAY_JAR" "$SERVICES_DIR/gateway/" 2>/dev/null || true
echo -e "${GREEN}✓ JAR 文件复制完成${NC}"

# 5. 创建启动脚本
echo ""
echo -e "${YELLOW}[5/6] 创建启动脚本...${NC}"

# Account 服务启动脚本
cat > "$SERVICES_DIR/account/start.sh" << 'EOF'
#!/bin/bash
cd /opt/glen-services/account
JAR_FILE=$(ls *.jar | head -1)
nohup java -jar -Xms512m -Xmx512m "$JAR_FILE" > account.log 2>&1 &
echo $! > account.pid
echo "Account Service started, PID: $(cat account.pid)"
EOF

# Data 服务启动脚本
cat > "$SERVICES_DIR/data/start.sh" << 'EOF'
#!/bin/bash
cd /opt/glen-services/data
JAR_FILE=$(ls *.jar | head -1)
nohup java -jar -Xms512m -Xmx512m "$JAR_FILE" > data.log 2>&1 &
echo $! > data.pid
echo "Data Service started, PID: $(cat data.pid)"
EOF

# Engine 服务启动脚本
cat > "$SERVICES_DIR/engine/start.sh" << 'EOF'
#!/bin/bash
cd /opt/glen-services/engine
JAR_FILE=$(ls *.jar | head -1)
nohup java -jar -Xms1024m -Xmx1024m "$JAR_FILE" > engine.log 2>&1 &
echo $! > engine.pid
echo "Engine Service started, PID: $(cat engine.pid)"
EOF

# Gateway 服务启动脚本
cat > "$SERVICES_DIR/gateway/start.sh" << 'EOF'
#!/bin/bash
cd /opt/glen-services/gateway
JAR_FILE=$(ls *.jar | head -1)
nohup java -jar -Xms512m -Xmx512m "$JAR_FILE" > gateway.log 2>&1 &
echo $! > gateway.pid
echo "Gateway Service started, PID: $(cat gateway.pid)"
EOF

chmod +x "$SERVICES_DIR"/*/start.sh
echo -e "${GREEN}✓ 启动脚本创建完成${NC}"

# 6. 创建 systemd 服务（推荐）
echo ""
echo -e "${YELLOW}[6/6] 创建 systemd 服务...${NC}"

# Account Service
ACCOUNT_JAR_NAME=$(basename "$ACCOUNT_JAR")
cat > /etc/systemd/system/glen-account.service << EOF
[Unit]
Description=Glen Account Service
After=network.target glen-mysql.service glen-redis.service glen-nacos.service

[Service]
Type=simple
User=root
WorkingDirectory=$SERVICES_DIR/account
ExecStart=/usr/bin/java -jar -Xms512m -Xmx512m $SERVICES_DIR/account/$ACCOUNT_JAR_NAME
Restart=always
RestartSec=10
StandardOutput=append:$SERVICES_DIR/account/account.log
StandardError=append:$SERVICES_DIR/account/account.log

[Install]
WantedBy=multi-user.target
EOF

# Data Service
DATA_JAR_NAME=$(basename "$DATA_JAR")
cat > /etc/systemd/system/glen-data.service << EOF
[Unit]
Description=Glen Data Service
After=network.target glen-mysql.service glen-redis.service glen-nacos.service glen-kafka.service

[Service]
Type=simple
User=root
WorkingDirectory=$SERVICES_DIR/data
ExecStart=/usr/bin/java -jar -Xms512m -Xmx512m $SERVICES_DIR/data/$DATA_JAR_NAME
Restart=always
RestartSec=10
StandardOutput=append:$SERVICES_DIR/data/data.log
StandardError=append:$SERVICES_DIR/data/data.log

[Install]
WantedBy=multi-user.target
EOF

# Engine Service
ENGINE_JAR_NAME=$(basename "$ENGINE_JAR")
cat > /etc/systemd/system/glen-engine.service << EOF
[Unit]
Description=Glen Engine Service
After=network.target glen-mysql.service glen-redis.service glen-nacos.service glen-kafka.service glen-minio.service

[Service]
Type=simple
User=root
WorkingDirectory=$SERVICES_DIR/engine
ExecStart=/usr/bin/java -jar -Xms1024m -Xmx1024m $SERVICES_DIR/engine/$ENGINE_JAR_NAME
Restart=always
RestartSec=10
StandardOutput=append:$SERVICES_DIR/engine/engine.log
StandardError=append:$SERVICES_DIR/engine/engine.log

[Install]
WantedBy=multi-user.target
EOF

# Gateway Service
GATEWAY_JAR_NAME=$(basename "$GATEWAY_JAR")
cat > /etc/systemd/system/glen-gateway.service << EOF
[Unit]
Description=Glen Gateway Service
After=network.target glen-nacos.service

[Service]
Type=simple
User=root
WorkingDirectory=$SERVICES_DIR/gateway
ExecStart=/usr/bin/java -jar -Xms512m -Xmx512m $SERVICES_DIR/gateway/$GATEWAY_JAR_NAME
Restart=always
RestartSec=10
StandardOutput=append:$SERVICES_DIR/gateway/gateway.log
StandardError=append:$SERVICES_DIR/gateway/gateway.log

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
echo -e "${GREEN}✓ systemd 服务创建完成${NC}"

echo ""
echo "=========================================="
echo "  部署完成！"
echo "=========================================="
echo ""
echo "启动服务（按顺序）："
echo "  1. systemctl start glen-gateway"
echo "  2. systemctl start glen-account"
echo "  3. systemctl start glen-data"
echo "  4. systemctl start glen-engine"
echo ""
echo "查看服务状态："
echo "  systemctl status glen-gateway"
echo "  systemctl status glen-account"
echo "  systemctl status glen-data"
echo "  systemctl status glen-engine"
echo ""
echo "查看日志："
echo "  tail -f $SERVICES_DIR/gateway/gateway.log"
echo "  tail -f $SERVICES_DIR/account/account.log"
echo "  tail -f $SERVICES_DIR/data/data.log"
echo "  tail -f $SERVICES_DIR/engine/engine.log"
echo ""
echo "设置开机自启："
echo "  systemctl enable glen-gateway glen-account glen-data glen-engine"
echo ""
