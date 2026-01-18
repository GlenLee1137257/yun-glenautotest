#!/bin/bash
# Glen AutoTest Platform - 重启后端服务脚本

set -e

PROJECT_ROOT="/home/hinkad/yun-glenautotest"
cd $PROJECT_ROOT

echo "========================================="
echo "Glen 自动化测试平台 - 重启后端服务"
echo "========================================="
echo ""

# 步骤1: 停止现有服务
echo "步骤 1/3: 停止现有服务..."
./stop-backend.sh

echo ""
echo "等待 3 秒..."
sleep 3

# 步骤2: 清理端口
echo ""
echo "步骤 2/3: 清理端口..."
./cleanup-backend-ports.sh

echo ""
echo "等待 2 秒..."
sleep 2

# 步骤3: 启动服务
echo ""
echo "步骤 3/3: 启动后端服务..."
./start-backend.sh

echo ""
echo "========================================="
echo "✅ 后端服务重启完成"
echo "========================================="
