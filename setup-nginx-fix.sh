#!/bin/bash

# 配置 Nginx 部署前端（修复版）

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

# 1. 检查并安装 Nginx
echo -e "${YELLOW}[1/6] 检查 Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    echo "安装 Nginx..."
    apt-get update
    apt-get install -y nginx
fi
echo -e "${GREEN}✓ Nginx 已安装${NC}"

# 2. 检查并创建配置目录
echo ""
echo -e "${YELLOW}[2/6] 检查配置目录...${NC}"
if [ ! -d "/etc/nginx/sites-available" ]; then
    echo "创建配置目录..."
    mkdir -p /etc/nginx/sites-available
    mkdir -p /etc/nginx/sites-enabled
fi
echo -e "${GREEN}✓ 配置目录存在${NC}"

# 3. 检查构建产物
echo ""
echo -e "${YELLOW}[3/6] 检查构建产物...${NC}"
if [ ! -d "$FRONTEND_DIR/dist" ]; then
    echo -e "${RED}✗ 构建产物不存在，请先执行构建${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建产物存在: $FRONTEND_DIR/dist${NC}"

# 4. 创建 Nginx 配置
echo ""
echo -e "${YELLOW}[4/6] 创建 Nginx 配置...${NC}"
NGINX_CONF="/etc/nginx/sites-available/glen-frontend"

cat > "$NGINX_CONF" << 'EOF'
server {
    listen 80;
    server_name 115.190.216.91;

    root /opt/yun-glenautotest/frontend/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~ ^/(account-service|engine-service|data-service)/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
EOF

echo -e "${GREEN}✓ 配置文件已创建: $NGINX_CONF${NC}"

# 5. 启用配置
echo ""
echo -e "${YELLOW}[5/6] 启用 Nginx 配置...${NC}"
# 删除默认配置（如果存在）
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
# 创建软链接
NGINX_ENABLED="/etc/nginx/sites-enabled/glen-frontend"
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
echo -e "${GREEN}✓ 配置已启用${NC}"

# 6. 测试并重载
echo ""
echo -e "${YELLOW}[6/6] 测试并重载 Nginx...${NC}"
nginx -t
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Nginx 配置测试失败${NC}"
    echo "查看错误信息："
    nginx -t 2>&1
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
echo "验证命令："
echo "  systemctl status nginx"
echo "  curl http://localhost/"
echo ""
