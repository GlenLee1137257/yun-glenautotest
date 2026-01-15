#!/bin/bash

# 在服务器上更新前端代码并重新部署

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  更新前端代码并重新部署"
echo "=========================================="
echo ""

cd /opt/yun-glenautotest

# 1. 处理本地修改
echo -e "${YELLOW}[1/5] 处理本地修改...${NC}"

# 备份并恢复 custom-fetch.ts（保留相对路径配置）
if [ -f "frontend/src/composables/custom-fetch.ts" ]; then
    echo "备份 custom-fetch.ts..."
    cp frontend/src/composables/custom-fetch.ts /tmp/custom-fetch.ts.bak
fi

# 处理未跟踪的文件
if [ -f "deploy-frontend.sh" ]; then
    echo "移动 deploy-frontend.sh..."
    mv deploy-frontend.sh /tmp/deploy-frontend.sh.bak 2>/dev/null || rm -f deploy-frontend.sh
fi

# Stash 本地修改
echo "暂存本地修改..."
git stash push -m "backup local changes before pull" || true

# 2. 拉取最新代码
echo ""
echo -e "${YELLOW}[2/5] 拉取最新代码...${NC}"
git pull
echo -e "${GREEN}✓ 代码已更新${NC}"

# 3. 恢复 custom-fetch.ts 的相对路径配置
echo ""
echo -e "${YELLOW}[3/5] 恢复 custom-fetch.ts 配置...${NC}"
if [ -f "/tmp/custom-fetch.ts.bak" ]; then
    # 检查新代码中是否已经是相对路径
    if grep -q "export const baseUrl = ''" frontend/src/composables/custom-fetch.ts; then
        echo -e "${GREEN}✓ baseUrl 已经是相对路径配置${NC}"
    else
        echo "更新 baseUrl 为相对路径..."
        sed -i "s|export const baseUrl = .*|export const baseUrl = ''|g" frontend/src/composables/custom-fetch.ts
        echo -e "${GREEN}✓ baseUrl 已更新为相对路径${NC}"
    fi
fi

# 4. 重新构建
echo ""
echo -e "${YELLOW}[4/5] 重新构建前端...${NC}"
cd frontend

# 确保 npm-run-all 已安装
if ! pnpm list npm-run-all &> /dev/null; then
    echo "安装 npm-run-all..."
    pnpm add -D npm-run-all
fi

# 构建
pnpm run build-only
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 构建失败${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 构建完成${NC}"

# 5. 重载 Nginx
echo ""
echo -e "${YELLOW}[5/5] 重载 Nginx...${NC}"
systemctl reload nginx
echo -e "${GREEN}✓ Nginx 已重载${NC}"

echo ""
echo "=========================================="
echo -e "${GREEN}  前端更新完成！${NC}"
echo "=========================================="
echo ""
echo "访问地址："
echo "  前端: http://115.190.216.91/"
echo ""
echo "如果页面没有更新，请清除浏览器缓存或使用 Ctrl+F5 强制刷新"
echo ""
