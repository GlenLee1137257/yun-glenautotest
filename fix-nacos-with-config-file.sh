#!/bin/bash

# 通过修改配置文件来修复 Nacos

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  通过配置文件修复 Nacos"
echo "=========================================="
echo ""

# 1. 创建自定义配置文件目录
echo -e "${YELLOW}[1/8] 创建配置文件目录...${NC}"
mkdir -p /home/data/nacos/conf
echo -e "${GREEN}✓ 已创建${NC}"

# 2. 获取 MySQL IP
echo ""
echo -e "${YELLOW}[2/8] 获取 MySQL IP...${NC}"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
echo -e "${GREEN}MySQL IP: $MYSQL_IP${NC}"

# 3. 创建 application.properties 配置文件
echo ""
echo -e "${YELLOW}[3/8] 创建 application.properties...${NC}"
cat > /home/data/nacos/conf/application.properties << EOF
# Spring
server.servlet.contextPath=/\${server.servlet.contextPath:/nacos}
server.contextPath=/nacos
server.port=\${NACOS_APPLICATION_PORT:8848}

# Servlet
server.servlet.context-path=/nacos
server.error.include-message=ALWAYS

# Tomcat
server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D %{User-Agent}i %{Request-Source}i
server.tomcat.basedir=file:.
server.tomcat.max-http-post-size=10485760

# MySQL
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://${MYSQL_IP}:3306/nacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user.0=root
db.password.0=yunautotest

# Connection pool
db.pool.config.connectionTimeout=30000
db.pool.config.validationTimeout=10000
db.pool.config.maximumPoolSize=20
db.pool.config.minimumIdle=2

# Nacos
nacos.cmdb.dumpTaskInterval=3600
nacos.cmdb.eventTaskInterval=10
nacos.cmdb.labelTaskInterval=300
nacos.cmdb.loadDataAtStart=false

# Metrics
management.endpoints.web.exposure.include=*
management.metrics.export.elastic.enabled=false
management.metrics.export.influx.enabled=false

# Auth
nacos.core.auth.enabled=false
nacos.core.auth.system.type=nacos
nacos.core.auth.plugin.nacos.token.secret.key=SecretKey012345678901234567890123456789012345678901234567890123456789
EOF

echo -e "${GREEN}✓ 配置文件已创建${NC}"

# 4. 显示配置文件内容（验证）
echo ""
echo "配置文件内容："
cat /home/data/nacos/conf/application.properties | grep -E "db\.|spring.datasource" || true

# 5. 停止并删除现有容器
echo ""
echo -e "${YELLOW}[4/8] 停止并删除现有 Nacos 容器...${NC}"
docker stop glen-nacos 2>/dev/null || true
docker rm glen-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已删除${NC}"

# 6. 启动新容器（挂载配置文件）
echo ""
echo -e "${YELLOW}[5/8] 启动 Nacos（挂载配置文件）...${NC}"
docker run -d \
  --name glen-nacos \
  -p 8848:8848 \
  -p 9848:9848 \
  -e MODE=standalone \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e JVM_XMS=256m \
  -e JVM_XMX=256m \
  -e JVM_XMN=128m \
  -v /home/data/nacos/logs:/home/nacos/logs \
  -v /home/data/nacos/conf/application.properties:/home/nacos/conf/application.properties \
  --restart=always \
  nacos/nacos-server:v2.2.3

echo -e "${GREEN}✓ Nacos 容器已启动${NC}"

# 7. 等待并监控启动
echo ""
echo -e "${YELLOW}[6/8] 等待 Nacos 启动（最多 120 秒）...${NC}"
sleep 15

MAX_WAIT=120
WAIT_COUNT=0
SUCCESS=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    # 检查是否有 DataSource 错误
    if docker logs glen-nacos 2>&1 | tail -20 | grep -q "No DataSource set"; then
        echo -e "${RED}✗ 仍然报错 'No DataSource set'${NC}"
        echo ""
        echo "容器内配置文件内容："
        docker exec glen-nacos cat /home/nacos/conf/application.properties | grep -E "db\.|spring.datasource" 2>/dev/null || echo "无法读取"
        echo ""
        echo "完整日志："
        docker logs glen-nacos 2>&1 | tail -50
        exit 1
    fi
    
    # 检查是否启动成功
    if docker logs glen-nacos 2>&1 | grep -q "Nacos started successfully"; then
        echo -e "${GREEN}✓ Nacos 启动成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        break
    fi
    
    # 检查 HTTP 端口
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

# 8. 最终验证
echo ""
echo -e "${YELLOW}[7/8] 最终验证...${NC}"

# 检查容器状态
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}✗ 容器未运行${NC}"
    exit 1
fi

# 测试 HTTP
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
echo "HTTP 状态码: $HTTP_STATUS"

# 测试 gRPC
GRPC_TEST=$(timeout 2 bash -c "echo > /dev/tcp/localhost/9848" 2>/dev/null && echo "ok" || echo "fail")
echo "gRPC 端口: $GRPC_TEST"

# 查看最新日志
echo ""
echo "最新日志（最后 20 行）："
docker logs glen-nacos 2>&1 | tail -20

echo ""
echo -e "${YELLOW}[8/8] 显示访问信息...${NC}"
echo ""
echo "=========================================="
if [ "$SUCCESS" -eq 1 ] || [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}  Nacos 修复成功！${NC}"
    echo "=========================================="
    echo ""
    echo "Nacos 控制台："
    echo "  URL: http://115.190.216.91:8848/nacos"
    echo "  用户名: nacos"
    echo "  密码: nacos"
    echo ""
    echo "配置文件位置："
    echo "  主机: /home/data/nacos/conf/application.properties"
    echo "  容器: /home/nacos/conf/application.properties"
else
    echo -e "${YELLOW}  Nacos 可能还在启动中${NC}"
    echo "=========================================="
    echo ""
    echo "请等待 1-2 分钟，然后检查："
    echo "  docker logs glen-nacos | tail -50"
    echo "  curl http://localhost:8848/nacos/"
fi
echo ""
