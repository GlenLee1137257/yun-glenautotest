#!/bin/bash
# Glen自动化测试平台 - 前端服务启动脚本
# 执行环境: WSL2

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="/home/hinkad/yun-glenautotest"
FRONTEND_DIR="${PROJECT_ROOT}/frontend"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}║           Glen自动化测试平台 - 前端服务启动脚本                   ║${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查环境
echo -e "${YELLOW}[1/4]${NC} 检查运行环境..."

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js未安装${NC}"
    exit 1
fi

if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}❌ pnpm未安装${NC}"
    exit 1
fi

NODE_VERSION=$(node -v)
PNPM_VERSION=$(pnpm -v)
echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
echo -e "${GREEN}✅ pnpm: $PNPM_VERSION${NC}"
echo ""

# 检查后端服务
echo -e "${YELLOW}[2/4]${NC} 检查后端服务..."
BACKEND_SERVICES_OK=true

for port in 8081 8082 8083 8000; do
    service_name=""
    case $port in
        8081) service_name="account-service" ;;
        8082) service_name="data-service" ;;
        8083) service_name="engine-service" ;;
        8000) service_name="gateway-service" ;;
    esac
    
    if timeout 2 bash -c "echo > /dev/tcp/localhost/$port" 2>/dev/null; then
        echo -e "${GREEN}✅ $service_name (端口 $port): 运行中${NC}"
    else
        echo -e "${YELLOW}⚠️  $service_name (端口 $port): 未运行${NC}"
        BACKEND_SERVICES_OK=false
    fi
done

if [ "$BACKEND_SERVICES_OK" = false ]; then
    echo -e "${YELLOW}⚠️  部分后端服务未运行，前端可能无法正常工作${NC}"
fi

echo ""

# 进入前端目录
cd ${FRONTEND_DIR}

# 安装依赖（如果需要）
echo -e "${YELLOW}[3/4]${NC} 检查依赖..."
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}安装前端依赖（首次运行需要几分钟）...${NC}"
    pnpm install
    echo -e "${GREEN}✅ 依赖安装完成${NC}"
else
    echo -e "${GREEN}✅ 依赖已安装${NC}"
fi
echo ""

# 启动前端服务
echo -e "${YELLOW}[4/4]${NC} 启动前端服务..."
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}前端服务正在启动...${NC}"
echo ""
echo -e "${BLUE}访问地址:${NC}"
echo -e "  🌐 http://localhost:5173"
echo ""
echo -e "${BLUE}后端服务地址:${NC}"
echo -e "  🔌 网关服务: http://localhost:8000"
echo -e "  📊 Nacos: http://localhost:8848/nacos"
echo ""
echo -e "${BLUE}停止服务:${NC}"
echo -e "  按 Ctrl+C 停止前端服务"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 启动开发服务器
pnpm dev
