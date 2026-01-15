#!/bin/bash

# 最终修复 Nacos 配置

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  最终修复 Nacos 配置"
echo "=========================================="
echo ""

# 1. 检查当前 Nacos 环境变量
echo -e "${YELLOW}[1/7] 检查当前 Nacos 环境变量...${NC}"
docker inspect glen-nacos | grep -A 20 "Env" | head -30
echo ""

# 2. 停止并删除 Nacos 容器
echo -e "${YELLOW}[2/7] 停止并删除 Nacos 容器...${NC}"
docker stop glen-nacos 2>/dev/null || true
docker rm glen-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已删除${NC}"

# 3. 获取 MySQL IP
echo ""
echo -e "${YELLOW}[3/7] 获取 MySQL IP...${NC}"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
echo -e "${GREEN}MySQL IP: $MYSQL_IP${NC}"

# 4. 测试 MySQL 连接
echo ""
echo -e "${YELLOW}[4/7] 测试 MySQL 连接...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest -e "SELECT 1;" 2>&1 | grep -v "Using a password" && echo -e "${GREEN}✓ MySQL 连接正常${NC}"

# 5. 确认 nacos_config 数据库存在
echo ""
echo -e "${YELLOW}[5/7] 确认 nacos_config 数据库...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest -e "SHOW DATABASES LIKE 'nacos%';" 2>&1 | grep -v "Using a password"

# 6. 使用正确的环境变量启动 Nacos
echo ""
echo -e "${YELLOW}[6/7] 启动 Nacos（使用正确的环境变量）...${NC}"
docker run -d \
  --name glen-nacos \
  -p 8848:8848 \
  -p 9848:9848 \
  -e MODE=standalone \
  -e PREFER_HOST_MODE=hostname \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e MYSQL_SERVICE_HOST=${MYSQL_IP} \
  -e MYSQL_SERVICE_PORT=3306 \
  -e MYSQL_SERVICE_USER=root \
  -e MYSQL_SERVICE_PASSWORD=yunautotest \
  -e MYSQL_SERVICE_DB_NAME=nacos_config \
  -e MYSQL_SERVICE_DB_PARAM="characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false" \
  -e NACOS_AUTH_ENABLE=false \
  -e JVM_XMS=256m \
  -e JVM_XMX=256m \
  -e JVM_XMN=128m \
  -v /home/data/nacos/logs:/home/nacos/logs \
  --restart=always \
  nacos/nacos-server:v2.2.3

echo -e "${GREEN}✓ Nacos 容器已启动${NC}"

# 7. 等待并验证
echo ""
echo -e "${YELLOW}[7/7] 等待 Nacos 启动（120 秒）...${NC}"
sleep 10

# 检查容器状态
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ 容器启动失败${NC}"
    docker logs glen-nacos 2>&1 | tail -50
    exit 1
fi

# 循环检查启动状态
MAX_WAIT=120
WAIT_COUNT=0
SUCCESS=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    # 检查日志中的成功标志
    if docker logs glen-nacos 2>&1 | grep -q "Nacos started successfully"; then
        echo -e "${GREEN}✓ Nacos 启动成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    # 检查是否有错误
    if docker logs glen-nacos 2>&1 | grep -q "No DataSource set"; then
        echo -e "${RED}✗ 仍然报错 'No DataSource set'${NC}"
        echo "查看完整日志："
        docker logs glen-nacos 2>&1 | tail -50
        exit 1
    fi
    
    # 定期输出等待状态
    if [ $((WAIT_COUNT % 10)) -eq 0 ]; then
        echo "  等待中... (${WAIT_COUNT}/${MAX_WAIT} 秒)"
    fi
    
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

# 即使没有看到成功标志，也测试 HTTP 连接
echo ""
echo "测试 HTTP 连接..."
sleep 10
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Nacos HTTP 连接成功${NC}"
    SUCCESS=1
elif [ "$SUCCESS" -eq 0 ]; then
    echo -e "${YELLOW}⚠ Nacos 可能还在启动中（HTTP: $HTTP_STATUS）${NC}"
    echo "查看最新日志："
    docker logs glen-nacos 2>&1 | tail -30
fi

# 显示环境变量（验证）
echo ""
echo "验证环境变量配置："
docker exec glen-nacos env | grep -E "MYSQL|SPRING_DATASOURCE" || echo "环境变量未找到"

echo ""
echo "=========================================="
if [ "$SUCCESS" -eq 1 ]; then
    echo -e "${GREEN}  Nacos 修复成功！${NC}"
    echo "=========================================="
    echo ""
    echo "Nacos 控制台："
    echo "  URL: http://115.190.216.91:8848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
else
    echo -e "${YELLOW}  Nacos 可能还在启动中${NC}"
    echo "=========================================="
    echo ""
    echo "请等待 1-2 分钟，然后执行以下命令检查："
    echo "  docker logs glen-nacos | tail -50"
    echo "  curl http://localhost:8848/nacos/"
fi
echo ""
