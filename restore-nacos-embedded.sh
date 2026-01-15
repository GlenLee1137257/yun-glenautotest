#!/bin/bash

# 恢复 Nacos 到使用内置数据库的状态

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  恢复 Nacos 到内置数据库模式"
echo "=========================================="
echo ""

# 1. 停止并删除 Nacos 容器
echo -e "${YELLOW}[1/4] 停止并删除 Nacos 容器...${NC}"
docker stop glen-nacos 2>/dev/null || true
docker rm glen-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已删除${NC}"

# 2. 清理配置（如果有）
echo ""
echo -e "${YELLOW}[2/4] 清理旧配置...${NC}"
rm -rf /home/data/nacos/data 2>/dev/null || true
rm -rf /tmp/nacos-config 2>/dev/null || true
echo -e "${GREEN}✓ 已清理${NC}"

# 3. 启动 Nacos（使用内置数据库）
echo ""
echo -e "${YELLOW}[3/4] 启动 Nacos（使用内置 Derby 数据库）...${NC}"
docker run -d \
  --name glen-nacos \
  -p 8848:8848 \
  -p 9848:9848 \
  -e MODE=standalone \
  -e JVM_XMS=512m \
  -e JVM_XMX=512m \
  -v /home/data/nacos/logs:/home/nacos/logs \
  -v /home/data/nacos/data:/home/nacos/data \
  --restart=always \
  nacos/nacos-server:v2.2.3

echo -e "${GREEN}✓ Nacos 容器已启动${NC}"

# 4. 等待并验证
echo ""
echo -e "${YELLOW}[4/4] 等待 Nacos 启动（60 秒）...${NC}"
sleep 20

MAX_WAIT=60
WAIT_COUNT=0
SUCCESS=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos 启动成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    if docker logs glen-nacos 2>&1 | tail -10 | grep -q "Nacos started successfully"; then
        echo -e "${GREEN}✓ Nacos 启动成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    if [ $((WAIT_COUNT % 10)) -eq 0 ]; then
        echo "  等待中... (${WAIT_COUNT}/${MAX_WAIT} 秒，HTTP: $HTTP_STATUS)"
    fi
    
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

echo ""
echo "=========================================="
if [ "$SUCCESS" -eq 1 ]; then
    echo -e "${GREEN}  Nacos 已恢复！${NC}"
    echo "=========================================="
    echo ""
    echo "Nacos 控制台："
    echo "  URL: http://115.190.216.91:8848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
    echo ""
    echo "当前使用：内置 Derby 数据库"
else
    echo -e "${YELLOW}  Nacos 可能还在启动中${NC}"
    echo "=========================================="
    echo ""
    echo "请等待片刻，然后检查："
    echo "  docker logs glen-nacos | tail -50"
    echo "  curl http://localhost:8848/nacos/"
fi
echo ""
