#!/bin/bash

# 快速修复构建问题

set -e

echo "=========================================="
echo "  快速修复构建问题"
echo "=========================================="
echo ""

cd /opt/yun-glenautotest/frontend

echo "[1/2] 安装 npm-run-all..."
pnpm add -D npm-run-all

echo ""
echo "[2/2] 重新构建..."
pnpm run build

echo ""
echo "=========================================="
echo "  修复完成！"
echo "=========================================="
echo ""
echo "如果构建成功，请继续执行部署脚本的后续步骤："
echo "  cd /opt/yun-glenautotest"
echo "  bash deploy-frontend.sh"
echo ""
