#!/bin/bash

# 将运行中的 Nacos 从内置数据库迁移到 MySQL

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  将 Nacos 迁移到 MySQL"
echo "=========================================="
echo ""

# 1. 确认 Nacos 正在运行
echo -e "${YELLOW}[1/7] 确认 Nacos 容器状态...${NC}"
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ Nacos 容器未运行，请先启动 Nacos${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Nacos 容器正在运行${NC}"

# 2. 获取 MySQL IP
echo ""
echo -e "${YELLOW}[2/7] 获取 MySQL 容器 IP...${NC}"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
if [ -z "$MYSQL_IP" ]; then
    echo -e "${RED}✗ 无法获取 MySQL IP${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MySQL IP: $MYSQL_IP${NC}"

# 3. 测试 MySQL 连接
echo ""
echo -e "${YELLOW}[3/7] 测试 MySQL 连接...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest -e "SELECT 1;" 2>&1 | grep -v "Using a password" && echo -e "${GREEN}✓ MySQL 连接正常${NC}"

# 4. 确认 nacos_config 数据库
echo ""
echo -e "${YELLOW}[4/7] 确认 nacos_config 数据库...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest -e "SHOW DATABASES LIKE 'nacos%';" 2>&1 | grep -v "Using a password"

# 5. 在容器内修改配置文件
echo ""
echo -e "${YELLOW}[5/7] 修改 Nacos 配置文件...${NC}"

# 备份原配置
docker exec glen-nacos cp /home/nacos/conf/application.properties /home/nacos/conf/application.properties.backup 2>/dev/null || true

# 修改配置（在容器内执行）
docker exec glen-nacos bash -c "cat >> /home/nacos/conf/application.properties << 'EOF'

#*************** Config Module Related Configurations ***************#
### If use MySQL as datasource:
spring.datasource.platform=mysql

### Count of DB:
db.num=1

### Connect URL of DB:
db.url.0=jdbc:mysql://${MYSQL_IP}:3306/nacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user.0=root
db.password.0=yunautotest

### Connection pool configuration: hikariCP
db.pool.config.connectionTimeout=30000
db.pool.config.validationTimeout=10000
db.pool.config.maximumPoolSize=20
db.pool.config.minimumIdle=2
EOF
"

echo -e "${GREEN}✓ 配置文件已修改${NC}"

# 6. 验证配置
echo ""
echo -e "${YELLOW}[6/7] 验证配置文件...${NC}"
docker exec glen-nacos cat /home/nacos/conf/application.properties | grep -E "spring.datasource.platform|db.url.0|db.user.0" || echo -e "${RED}配置未找到${NC}"

# 7. 重启 Nacos 容器
echo ""
echo -e "${YELLOW}[7/7] 重启 Nacos 容器...${NC}"
docker restart glen-nacos
echo -e "${GREEN}✓ 容器已重启${NC}"

# 等待启动
echo ""
echo "等待 Nacos 重新启动（最多 120 秒）..."
sleep 20

MAX_WAIT=120
WAIT_COUNT=0
SUCCESS=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    # 检查是否有 DataSource 错误
    if docker logs glen-nacos 2>&1 | tail -30 | grep -q "No DataSource set"; then
        echo -e "${RED}✗ 迁移失败，仍然报错 'No DataSource set'${NC}"
        echo ""
        echo "恢复原配置..."
        docker exec glen-nacos cp /home/nacos/conf/application.properties.backup /home/nacos/conf/application.properties 2>/dev/null || true
        docker restart glen-nacos
        echo -e "${YELLOW}已回滚到内置数据库${NC}"
        exit 1
    fi
    
    # 检查启动成功标志
    if docker logs glen-nacos 2>&1 | grep -q "Nacos started successfully"; then
        # 检查是否使用了 MySQL
        if docker logs glen-nacos 2>&1 | grep -q "use mysql"; then
            echo -e "${GREEN}✓ Nacos 启动成功并使用 MySQL！（等待了 ${WAIT_COUNT} 秒）${NC}"
            SUCCESS=1
            break
        elif docker logs glen-nacos 2>&1 | grep -q "use embedded storage"; then
            echo -e "${YELLOW}⚠ Nacos 启动成功但仍使用内置数据库${NC}"
            echo "查看配置..."
            docker exec glen-nacos cat /home/nacos/conf/application.properties | tail -20
            break
        else
            echo -e "${GREEN}✓ Nacos 启动成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
            SUCCESS=1
            break
        fi
    fi
    
    # 测试 HTTP
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos HTTP 连接成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    if [ $((WAIT_COUNT % 10)) -eq 0 ]; then
        echo "  等待中... (${WAIT_COUNT}/${MAX_WAIT} 秒，HTTP: $HTTP_STATUS)"
    fi
    
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

# 最终验证
echo ""
echo "=========================================="
echo "  验证结果"
echo "=========================================="
echo ""

# 检查容器状态
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ 容器未运行${NC}"
    docker logs glen-nacos 2>&1 | tail -50
    exit 1
fi

# 测试连接
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
echo "HTTP 状态码: $HTTP_STATUS"

# 查看启动日志
echo ""
echo "启动日志（包含数据源信息）："
docker logs glen-nacos 2>&1 | grep -E "Nacos started|use embedded|use mysql|datasource" || docker logs glen-nacos 2>&1 | tail -20

echo ""
if [ "$SUCCESS" -eq 1 ]; then
    echo -e "${GREEN}=========================================="
    echo -e "  迁移完成"
    echo -e "==========================================${NC}"
    echo ""
    echo "Nacos 控制台："
    echo "  URL: http://115.190.216.91:8848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
    echo ""
    echo "配置文件："
    echo "  容器内: /home/nacos/conf/application.properties"
    echo "  备份: /home/nacos/conf/application.properties.backup"
else
    echo -e "${YELLOW}=========================================="
    echo -e "  迁移可能未完成"
    echo -e "==========================================${NC}"
    echo ""
    echo "请手动检查："
    echo "  docker logs glen-nacos | tail -50"
    echo "  docker exec glen-nacos cat /home/nacos/conf/application.properties | tail -20"
fi
echo ""
