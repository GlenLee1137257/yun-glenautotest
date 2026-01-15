#!/bin/bash

# 检查 Nacos 详细日志

echo "=========================================="
echo "  Nacos 详细日志检查"
echo "=========================================="
echo ""

echo "[1] 检查容器状态"
echo "---"
docker ps -a | grep glen-nacos
echo ""

echo "[2] 检查容器内端口监听"
echo "---"
docker exec glen-nacos ss -tlnp 2>/dev/null | grep -E "8848|9848" || echo "未找到监听端口"
echo ""

echo "[3] 检查容器内 Java 进程"
echo "---"
docker exec glen-nacos ps aux | grep java || echo "Java 进程未找到"
echo ""

echo "[4] 检查 Nacos 启动日志文件"
echo "---"
docker exec glen-nacos cat /home/nacos/logs/start.out 2>/dev/null | tail -50 || echo "start.out 不存在"
echo ""

echo "[5] 检查 Nacos 主日志"
echo "---"
docker exec glen-nacos cat /home/nacos/logs/nacos.log 2>/dev/null | tail -50 || echo "nacos.log 不存在"
echo ""

echo "[6] 检查容器标准输出（最近 100 行）"
echo "---"
docker logs glen-nacos 2>&1 | tail -100 | grep -E "ERROR|Exception|failed|started|Port" -A 2 -B 2 || docker logs glen-nacos 2>&1 | tail -50
echo ""

echo "[7] 测试连接"
echo "---"
echo "测试 localhost:8848:"
curl -v http://localhost:8848/nacos/ 2>&1 | head -20
echo ""

echo "[8] 检查 MySQL 连接"
echo "---"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
echo "MySQL IP: $MYSQL_IP"
docker exec glen-mysql mysql -uroot -pyunautotest -e "SHOW DATABASES LIKE 'nacos%';" 2>&1 | grep -v "Using a password"
echo ""

echo "=========================================="
echo "  检查完成"
echo "=========================================="
