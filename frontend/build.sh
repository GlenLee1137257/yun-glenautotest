#!/bin/bash
# Glen AutoTest Platform - Frontend Build Script

set -e

echo "========================================="
echo "Glen AutoTest Platform - Frontend Build"
echo "========================================="

# 检查Node.js是否安装
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# 检查pnpm是否安装
if ! command -v pnpm &> /dev/null; then
    echo "Error: pnpm is not installed. Installing pnpm..."
    npm install -g pnpm
fi

echo "Node version: $(node --version)"
echo "pnpm version: $(pnpm --version)"
echo ""

# 安装依赖
echo "Installing dependencies..."
pnpm install

if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "✗ Failed to install dependencies"
    exit 1
fi

# 类型检查
echo ""
echo "Running type check..."
pnpm run type-check

if [ $? -eq 0 ]; then
    echo "✓ Type check passed"
else
    echo "✗ Type check failed"
    exit 1
fi

# 构建
echo ""
echo "Building..."
pnpm run build

if [ $? -eq 0 ]; then
    echo "✓ Build successful"
else
    echo "✗ Build failed"
    exit 1
fi

# 显示构建结果
echo ""
echo "========================================="
echo "Build Summary"
echo "========================================="
if [ -d "dist" ]; then
    echo "Output directory: $(pwd)/dist"
    echo "Total size: $(du -sh dist | cut -f1)"
else
    echo "Warning: dist directory not found"
fi

echo ""
echo "Build completed successfully!"
