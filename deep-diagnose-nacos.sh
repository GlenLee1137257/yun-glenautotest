#!/bin/bash

# Nacos 深度诊断脚本

set -e

echo "=========================================="
echo "  Nacos 深度诊断"
echo "=========================================="
echo ""

# 1. 检查 Nacos 容器详细信息
echo "[1] Nacos 容器详细信息"
echo "---"
docker inspect glen-nacos | grep -A 30 "State"
echo ""

# 2. 检查端口映射
echo "[2] 端口映射"
echo "---"
docker port glen-nacos
echo ""

# 3. 检查容器网络
echo "[3] 容器网络配置"
echo "---"
docker inspect glen-nacos | grep -A 20 "NetworkSettings"
echo ""

# 4. 检查容器内进程
echo "[4] 容器内进程"
echo "---"
docker exec glen-nacos ps aux 2>/dev/null | head -10 || echo "无法检查"
echo ""

# 5. 检查容器内端口监听
echo "[5] 容器内端口监听"
echo "---"
docker exec glen-nacos netstat -tlnp 2>/dev/null | grep -E "8848|9848" || echo "无法检查或端口未监听"
echo ""

# 6. 检查 Nacos 日志中的错误
echo "[6] Nacos 日志中的错误"
echo "---"
docker logs glen-nacos 2>&1 | grep -i "error\|exception\|failed" | tail -20 || echo "无错误"
echo ""

# 7. 检查 Nacos 启动状态
echo "[7] Nacos 启动状态"
echo "---"
docker logs glen-nacos 2>&1 | tail -50 | grep -E "started|ready|Nacos|Port" -i
echo ""

# 8. 测试各种连接方式
echo "[8] 连接测试"
echo "---"
echo "测试 localhost:8848:"
curl -v http://localhost:8848/nacos/ 2>&1 | head -10 || echo "连接失败"
echo ""

NACOS_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-nacos)
echo "测试容器IP ($NACOS_IP:8848):"
curl -v http://$NACOS_IP:8848/nacos/ 2>&1 | head -10 || echo "连接失败"
echo ""

# 9. 检查防火墙
echo "[9] 防火墙检查"
echo "---"
if command -v ufw >/dev/null 2>&1; then
    ufw status | grep -E "8848|9848" || echo "未找到相关规则"
fi
if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --list-ports 2>/dev/null | grep -E "8848|9848" || echo "未找到相关规则"
fi
echo ""

# 10. 检查 Docker 网络
echo "[10] Docker 网络"
echo "---"
docker network inspect bridge | grep -A 10 "glen-nacos" || echo "未找到"
echo ""

echo "=========================================="
echo "  诊断完成"
echo "=========================================="
