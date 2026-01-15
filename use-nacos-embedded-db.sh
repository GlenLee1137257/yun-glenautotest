#!/bin/bash

# 使用 Nacos 内置 Derby 数据库（不使用 MySQL）

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  使用 Nacos 内置数据库"
echo "=========================================="
echo ""
echo "注意：这将使用 Derby 内置数据库，而不是 MySQL。"
echo "适用于快速启动和测试，生产环境建议使用 MySQL。"
echo ""

# 1. 停止并删除现有容器
echo -e "${YELLOW}[1/5] 停止并删除现有 Nacos 容器...${NC}"
docker stop glen-nacos 2>/dev/null || true
docker rm glen-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已删除${NC}"

# 2. 清理旧数据
echo ""
echo -e "${YELLOW}[2/5] 清理旧数据...${NC}"
rm -rf /home/data/nacos/data 2>/dev/null || true
echo -e "${GREEN}✓ 已清理${NC}"

# 3. 启动 Nacos（使用内置数据库）
echo ""
echo -e "${YELLOW}[3/5] 启动 Nacos（使用内置 Derby 数据库）...${NC}"
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

# 4. 等待启动
echo ""
echo -e "${YELLOW}[4/5] 等待 Nacos 启动（最多 120 秒）...${NC}"
sleep 20

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
    
    # 检查 HTTP 连接
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos HTTP 连接成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    # 检查是否有错误
    if docker logs glen-nacos 2>&1 | tail -10 | grep -q "No DataSource set"; then
        echo -e "${RED}✗ 仍然报错 'No DataSource set'${NC}"
        docker logs glen-nacos 2>&1 | tail -30
        exit 1
    fi
    
    if [ $((WAIT_COUNT % 10)) -eq 0 ]; then
        echo "  等待中... (${WAIT_COUNT}/${MAX_WAIT} 秒，HTTP: $HTTP_STATUS)"
    fi
    
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

# 5. 验证
echo ""
echo -e "${YELLOW}[5/5] 验证...${NC}"

# 检查容器状态
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ 容器未运行${NC}"
    docker logs glen-nacos 2>&1 | tail -50
    exit 1
fi

# 最终测试
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
echo "HTTP 状态码: $HTTP_STATUS"

GRPC_TEST=$(timeout 2 bash -c "echo > /dev/tcp/localhost/9848" 2>/dev/null && echo "ok" || echo "fail")
echo "gRPC 端口: $GRPC_TEST"

# 显示最新日志
echo ""
echo "最新日志（最后 20 行）："
docker logs glen-nacos 2>&1 | tail -20

echo ""
echo "=========================================="
if [ "$SUCCESS" -eq 1 ] || [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}  Nacos 启动成功！${NC}"
    echo "=========================================="
    echo ""
    echo "Nacos 控制台："
    echo "  URL: http://115.190.216.91:8848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
    echo ""
    echo "数据存储："
    echo "  使用内置 Derby 数据库"
    echo "  数据目录: /home/data/nacos/data"
    echo ""
    echo "注意："
    echo "  1. 当前使用内置数据库，数据存储在容器内"
    echo "  2. 适合开发和测试环境"
    echo "  3. 如需生产环境，建议迁移到 MySQL"
else
    echo -e "${YELLOW}  Nacos 可能还在启动中${NC}"
    echo "=========================================="
    echo ""
    echo "请等待 1-2 分钟，然后检查："
    echo "  docker logs glen-nacos | tail -50"
    echo "  curl http://localhost:8848/nacos/"
fi
echo ""
