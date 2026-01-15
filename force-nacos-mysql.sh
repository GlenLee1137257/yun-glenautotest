#!/bin/bash

# 强制 Nacos 使用 MySQL（完全替换配置文件）

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  强制 Nacos 使用 MySQL"
echo "=========================================="
echo ""

# 1. 获取 MySQL IP
echo -e "${YELLOW}[1/6] 获取 MySQL IP...${NC}"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
echo -e "${GREEN}MySQL IP: $MYSQL_IP${NC}"

# 2. 创建新的配置文件（本地）
echo ""
echo -e "${YELLOW}[2/6] 创建新的配置文件...${NC}"
mkdir -p /tmp/nacos-config

cat > /tmp/nacos-config/application.properties << EOF
# Spring
server.servlet.contextPath=\${server.servlet.contextPath:/nacos}
server.contextPath=/nacos
server.port=\${NACOS_APPLICATION_PORT:8848}
server.servlet.context-path=/nacos
server.error.include-message=ALWAYS

# Tomcat
server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D %{User-Agent}i %{Request-Source}i
server.tomcat.basedir=file:.
server.tomcat.max-http-post-size=10485760

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

#*************** Access Log Related Configurations ***************#
server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D %{User-Agent}i %{Request-Source}i
server.tomcat.basedir=

#*************** Access Control Related Configurations ***************#
nacos.core.auth.system.type=nacos
nacos.core.auth.enabled=false
nacos.core.auth.default.token.secret.key=SecretKey012345678901234567890123456789012345678901234567890123456789
nacos.core.auth.default.token.expire.seconds=18000
nacos.core.auth.plugin.nacos.token.secret.key=SecretKey012345678901234567890123456789012345678901234567890123456789

#*************** Istio Related Configurations ***************#
nacos.istio.mcp.server.enabled=false

#*************** Core Related Configurations ***************#
nacos.core.auth.caching.enabled=true
nacos.core.auth.enable.userAgentAuthWhite=false
nacos.core.auth.server.identity.key=serverIdentity
nacos.core.auth.server.identity.value=security

#*************** Naming Module Related Configurations ***************#
nacos.naming.empty-service.auto-clean=true
nacos.naming.empty-service.clean.initial-delay-ms=50000
nacos.naming.empty-service.clean.period-time-ms=30000

#*************** CMDB Module Related Configurations ***************#
nacos.cmdb.dumpTaskInterval=3600
nacos.cmdb.eventTaskInterval=10
nacos.cmdb.labelTaskInterval=300
nacos.cmdb.loadDataAtStart=false

#*************** Metrics Related Configurations ***************#
management.endpoints.web.exposure.include=*
management.metrics.export.elastic.enabled=false
management.metrics.export.influx.enabled=false

#*************** Server Related Configurations ***************#
nacos.standalone=true
EOF

echo -e "${GREEN}✓ 配置文件已创建${NC}"

# 3. 显示配置文件关键内容
echo ""
echo "MySQL 配置："
cat /tmp/nacos-config/application.properties | grep -E "spring.datasource.platform|db.url.0|db.user.0|db.password.0"

# 4. 停止 Nacos
echo ""
echo -e "${YELLOW}[3/6] 停止 Nacos 容器...${NC}"
docker stop glen-nacos
echo -e "${GREEN}✓ 已停止${NC}"

# 5. 复制配置文件到容器
echo ""
echo -e "${YELLOW}[4/6] 替换容器内配置文件...${NC}"
docker cp /tmp/nacos-config/application.properties glen-nacos:/home/nacos/conf/application.properties
echo -e "${GREEN}✓ 配置文件已替换${NC}"

# 6. 启动 Nacos
echo ""
echo -e "${YELLOW}[5/6] 启动 Nacos 容器...${NC}"
docker start glen-nacos
echo -e "${GREEN}✓ 已启动${NC}"

# 等待启动
echo ""
echo -e "${YELLOW}[6/6] 等待 Nacos 启动（最多 120 秒）...${NC}"
sleep 20

MAX_WAIT=120
WAIT_COUNT=0
SUCCESS=0
USE_MYSQL=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    # 检查错误
    if docker logs glen-nacos 2>&1 | tail -30 | grep -q "No DataSource set"; then
        echo -e "${RED}✗ 迁移失败，报错 'No DataSource set'${NC}"
        echo ""
        echo "查看日志："
        docker logs glen-nacos 2>&1 | tail -50
        exit 1
    fi
    
    # 检查是否使用 MySQL
    LATEST_LOG=$(docker logs glen-nacos 2>&1 | tail -20)
    
    if echo "$LATEST_LOG" | grep -q "Nacos started successfully"; then
        if echo "$LATEST_LOG" | grep -q "use mysql"; then
            echo -e "${GREEN}✓ Nacos 启动成功并使用 MySQL！（等待了 ${WAIT_COUNT} 秒）${NC}"
            SUCCESS=1
            USE_MYSQL=1
            break
        elif echo "$LATEST_LOG" | grep -q "use embedded storage"; then
            echo -e "${RED}✗ Nacos 启动成功但仍使用内置数据库${NC}"
            echo ""
            echo "查看配置文件："
            docker exec glen-nacos cat /home/nacos/conf/application.properties | head -50
            echo ""
            echo "查看启动日志："
            docker logs glen-nacos 2>&1 | grep -E "datasource|database|mysql|embedded" -i
            break
        else
            echo -e "${GREEN}✓ Nacos 启动成功（等待了 ${WAIT_COUNT} 秒）${NC}"
            SUCCESS=1
            break
        fi
    fi
    
    # 测试 HTTP
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos HTTP 连接成功！（等待了 ${WAIT_COUNT} 秒）${NC}"
        SUCCESS=1
        # 检查是否使用 MySQL
        if docker logs glen-nacos 2>&1 | grep "Nacos started successfully" | grep -q "use mysql"; then
            USE_MYSQL=1
        fi
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

# 查看数据源日志
echo ""
echo "数据源相关日志："
docker logs glen-nacos 2>&1 | grep -E "Nacos started|datasource|database" -i | tail -5

# 验证配置文件
echo ""
echo "容器内配置文件（前 30 行）："
docker exec glen-nacos cat /home/nacos/conf/application.properties | head -30

echo ""
if [ "$USE_MYSQL" -eq 1 ]; then
    echo -e "${GREEN}=========================================="
    echo -e "  成功迁移到 MySQL！"
    echo -e "==========================================${NC}"
elif [ "$SUCCESS" -eq 1 ]; then
    echo -e "${YELLOW}=========================================="
    echo -e "  Nacos 已启动，但可能仍使用内置数据库"
    echo -e "==========================================${NC}"
    echo ""
    echo "可能的原因："
    echo "  1. MySQL 连接失败"
    echo "  2. nacos_config 数据库表结构不完整"
    echo "  3. Nacos 版本与 MySQL 版本不兼容"
    echo ""
    echo "建议："
    echo "  1. 检查 MySQL 日志: docker logs glen-mysql | tail -50"
    echo "  2. 测试 MySQL 连接: docker exec glen-mysql mysql -uroot -pyunautotest nacos_config -e 'SHOW TABLES;'"
else
    echo -e "${RED}=========================================="
    echo -e "  启动失败或超时"
    echo -e "==========================================${NC}"
fi
echo ""
echo "Nacos 控制台："
echo "  URL: http://115.190.216.91:8848/nacos"
echo "  用户名: nacos"
echo "  密码: nacos"
echo ""
