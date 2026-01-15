#!/bin/bash

# 前端部署脚本

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  Glen 自动化云测平台 - 前端部署"
echo "=========================================="
echo ""

PROJECT_DIR="/opt/yun-glenautotest"
FRONTEND_DIR="$PROJECT_DIR/frontend"
GATEWAY_IP="115.190.216.91"
GATEWAY_PORT="8000"

# 1. 检查环境
echo -e "${YELLOW}[1/7] 检查环境...${NC}"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js 未安装${NC}"
    echo "请先安装 Node.js 18+"
    exit 1
fi
NODE_VERSION=$(node -v)
echo -e "${GREEN}✓ Node.js: $NODE_VERSION${NC}"

# 检查 pnpm
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}⚠ pnpm 未安装，尝试安装...${NC}"
    npm install -g pnpm
fi
PNPM_VERSION=$(pnpm -v)
echo -e "${GREEN}✓ pnpm: $PNPM_VERSION${NC}"

# 检查项目目录
if [ ! -d "$FRONTEND_DIR" ]; then
    echo -e "${RED}✗ 前端目录不存在: $FRONTEND_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 前端目录存在${NC}"

# 2. 进入前端目录
echo ""
echo -e "${YELLOW}[2/7] 进入前端目录...${NC}"
cd "$FRONTEND_DIR"
echo -e "${GREEN}✓ 当前目录: $(pwd)${NC}"

# 3. 修改 API 基础 URL
echo ""
echo -e "${YELLOW}[3/7] 配置 API 基础 URL...${NC}"
API_BASE_URL="http://${GATEWAY_IP}:${GATEWAY_PORT}"

# 备份原文件
if [ -f "src/composables/custom-fetch.ts" ]; then
    cp src/composables/custom-fetch.ts src/composables/custom-fetch.ts.bak
    echo -e "${GREEN}✓ 已备份原文件${NC}"
    
    # 修改 baseUrl 为相对路径（通过 Nginx 代理）
    sed -i "s|export const baseUrl = .*|export const baseUrl = ''|g" src/composables/custom-fetch.ts
    echo -e "${GREEN}✓ API 基础 URL 已更新为相对路径（通过 Nginx 代理）${NC}"
else
    echo -e "${YELLOW}⚠ 未找到 custom-fetch.ts，跳过${NC}"
fi

# 4. 安装依赖
echo ""
echo -e "${YELLOW}[4/7] 安装依赖...${NC}"
if [ ! -d "node_modules" ]; then
    echo "首次安装依赖，可能需要较长时间..."
    pnpm install
else
    echo "更新依赖..."
    pnpm install
fi

# 确保 npm-run-all 已安装（构建脚本需要）
if ! pnpm list npm-run-all &> /dev/null; then
    echo "安装 npm-run-all..."
    pnpm add -D npm-run-all
fi
echo -e "${GREEN}✓ 依赖安装完成${NC}"

# 5. 构建项目
echo ""
echo -e "${YELLOW}[5/7] 构建项目...${NC}"
pnpm run build
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 构建失败${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建完成${NC}"

# 6. 检查构建产物
echo ""
echo -e "${YELLOW}[6/7] 检查构建产物...${NC}"
if [ ! -d "dist" ]; then
    echo -e "${RED}✗ 构建产物目录不存在${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建产物目录: $(pwd)/dist${NC}"
ls -lh dist/ | head -10

# 7. 部署到 Nginx
echo ""
echo -e "${YELLOW}[7/7] 配置 Nginx...${NC}"

# 检查 Nginx 是否安装
if ! command -v nginx &> /dev/null; then
    echo "安装 Nginx..."
    apt-get update
    apt-get install -y nginx
fi

# 创建 Nginx 配置
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

# 创建软链接
ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

# 测试 Nginx 配置
nginx -t
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Nginx 配置测试失败${NC}"
    exit 1
fi

# 重载 Nginx
systemctl reload nginx || systemctl restart nginx
echo -e "${GREEN}✓ Nginx 配置已更新并重载${NC}"

echo ""
echo "=========================================="
echo -e "${GREEN}  前端部署完成！${NC}"
echo "=========================================="
echo ""
echo "访问地址："
echo "  前端: http://${GATEWAY_IP}/"
echo "  API 网关: http://${GATEWAY_IP}:${GATEWAY_PORT}/"
echo ""
echo "Nginx 配置："
echo "  配置文件: $NGINX_CONF"
echo "  静态文件: ${FRONTEND_DIR}/dist"
echo ""
echo "如果无法访问，请检查："
echo "  1. 防火墙是否开放 80 端口"
echo "  2. Nginx 状态: systemctl status nginx"
echo "  3. Nginx 日志: tail -f /var/log/nginx/error.log"
echo ""
