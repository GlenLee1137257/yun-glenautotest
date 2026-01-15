#!/bin/bash

# 配置 Nginx 部署前端

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  配置 Nginx 部署前端"
echo "=========================================="
echo ""

GATEWAY_IP="115.190.216.91"
GATEWAY_PORT="8000"
FRONTEND_DIR="/opt/yun-glenautotest/frontend"

# 1. 检查构建产物
echo -e "${YELLOW}[1/5] 检查构建产物...${NC}"
if [ ! -d "$FRONTEND_DIR/dist" ]; then
    echo -e "${RED}✗ 构建产物不存在，请先执行构建${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建产物存在: $FRONTEND_DIR/dist${NC}"

# 2. 检查 Nginx
echo ""
echo -e "${YELLOW}[2/5] 检查 Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    echo "安装 Nginx..."
    apt-get update
    apt-get install -y nginx
fi
echo -e "${GREEN}✓ Nginx 已安装${NC}"

# 3. 创建 Nginx 配置
echo ""
echo -e "${YELLOW}[3/5] 创建 Nginx 配置...${NC}"
NGINX_CONF="/etc/nginx/sites-available/glen-frontend"
NGINX_ENABLED="/etc/nginx/sites-enabled/glen-frontend"

cat > "$NGINX_CONF" << EOF
server {
    listen 80;
    server_name ${GATEWAY_IP};

    root ${FRONTEND_DIR}/dist;
    index index.html;

    # 前端静态文件
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # API 代理到网关（代理所有服务路径）
    location ~ ^/(account-service|engine-service|data-service)/ {
        proxy_pass http://localhost:${GATEWAY_PORT};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Port \$server_port;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
EOF

echo -e "${GREEN}✓ 配置文件已创建: $NGINX_CONF${NC}"

# 4. 启用配置
echo ""
echo -e "${YELLOW}[4/5] 启用 Nginx 配置...${NC}"
# 删除默认配置（如果存在）
rm -f /etc/nginx/sites-enabled/default
# 创建软链接
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
echo -e "${GREEN}✓ 配置已启用${NC}"

# 5. 测试并重载
echo ""
echo -e "${YELLOW}[5/5] 测试并重载 Nginx...${NC}"
nginx -t
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Nginx 配置测试失败${NC}"
    exit 1
fi

systemctl reload nginx || systemctl restart nginx
echo -e "${GREEN}✓ Nginx 已重载${NC}"

echo ""
echo "=========================================="
echo -e "${GREEN}  Nginx 配置完成！${NC}"
echo "=========================================="
echo ""
echo "访问地址："
echo "  前端: http://${GATEWAY_IP}/"
echo "  Nacos: http://${GATEWAY_IP}:8848/nacos"
echo "  API 网关: http://${GATEWAY_IP}:${GATEWAY_PORT}/"
echo ""
echo "如果无法访问，请检查："
echo "  1. 防火墙是否开放 80 端口"
echo "  2. Nginx 状态: systemctl status nginx"
echo "  3. Nginx 日志: tail -f /var/log/nginx/error.log"
echo "  4. 后端服务状态: systemctl status glen-gateway"
echo ""
