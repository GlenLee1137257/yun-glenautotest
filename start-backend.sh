#!/bin/bash
# Glen自动化测试平台 - 后端服务启动脚本
# 执行环境: WSL2
# 启动顺序: account -> data -> engine -> gateway

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="/home/hinkad/yun-glenautotest"
BACKEND_DIR="${PROJECT_ROOT}/backend"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}║           Glen自动化测试平台 - 后端服务启动脚本                   ║${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查环境
echo -e "${YELLOW}[1/5]${NC} 检查运行环境..."
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java未安装${NC}"
    exit 1
fi
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven未安装${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 环境检查通过${NC}"
echo ""

# 检查中间件
echo -e "${YELLOW}[2/5]${NC} 检查中间件服务..."
if ! docker ps | grep -q glen-mysql; then
    echo -e "${RED}❌ MySQL容器未运行${NC}"
    exit 1
fi
if ! docker ps | grep -q glen-nacos; then
    echo -e "${RED}❌ Nacos容器未运行${NC}"
    exit 1
fi
if ! docker ps | grep -q glen-redis; then
    echo -e "${RED}❌ Redis容器未运行${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 中间件服务正常${NC}"
echo ""

# 编译项目
echo -e "${YELLOW}[3/5]${NC} 编译后端项目..."
cd ${BACKEND_DIR}
if ! mvn clean package -DskipTests > /tmp/backend-build.log 2>&1; then
    echo -e "${RED}❌ 编译失败，查看日志: tail -50 /tmp/backend-build.log${NC}"
    tail -30 /tmp/backend-build.log
    exit 1
fi
echo -e "${GREEN}✅ 编译成功${NC}"
echo ""

# 创建日志目录
mkdir -p ${PROJECT_ROOT}/logs

# 启动服务的函数
start_service() {
    local service_name=$1
    local service_dir=$2
    local port=$3
    
    echo -e "${YELLOW}启动 ${service_name} (端口: ${port})...${NC}"
    
    cd ${service_dir}
    
    # 后台启动服务
    nohup mvn spring-boot:run > ${PROJECT_ROOT}/logs/${service_name}.log 2>&1 &
    local pid=$!
    echo $pid > ${PROJECT_ROOT}/logs/${service_name}.pid
    
    # 等待服务启动
    local max_wait=60
    local elapsed=0
    while [ $elapsed -lt $max_wait ]; do
        if curl -s http://localhost:${port}/actuator/health > /dev/null 2>&1 || \
           grep -q "Started.*Application" ${PROJECT_ROOT}/logs/${service_name}.log 2>/dev/null; then
            echo -e "${GREEN}✅ ${service_name} 启动成功 (PID: $pid)${NC}"
            return 0
        fi
        sleep 2
        elapsed=$((elapsed + 2))
    done
    
    echo -e "${YELLOW}⚠️  ${service_name} 可能还在启动中，请查看日志: tail -f ${PROJECT_ROOT}/logs/${service_name}.log${NC}"
    return 0
}

# 步骤4: 按顺序启动服务
echo -e "${YELLOW}[4/5]${NC} 启动后端微服务..."
echo ""

# 1. 启动 account-service
start_service "account-service" "${BACKEND_DIR}/glen-account" "8081"
sleep 5

# 2. 启动 data-service
start_service "data-service" "${BACKEND_DIR}/glen-data" "8082"
sleep 5

# 3. 启动 engine-service
start_service "engine-service" "${BACKEND_DIR}/glen-engine" "8083"
sleep 5

# 4. 启动 gateway-service
start_service "gateway-service" "${BACKEND_DIR}/glen-gateway" "8000"
sleep 5

echo ""

# 步骤5: 验证服务状态
echo -e "${YELLOW}[5/5]${NC} 验证服务状态..."
echo ""

sleep 10

# 检查Nacos中的服务注册
echo -e "${BLUE}检查Nacos服务注册...${NC}"
echo "请访问 http://localhost:8848/nacos 查看服务注册情况"
echo ""

# 检查端口监听
echo -e "${BLUE}检查服务端口...${NC}"
for port in 8081 8082 8083 8000; do
    if netstat -tlnp 2>/dev/null | grep -q ":${port} "; then
        echo -e "${GREEN}✅ 端口 ${port} 正在监听${NC}"
    else
        echo -e "${YELLOW}⚠️  端口 ${port} 未监听${NC}"
    fi
done

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                                   ║${NC}"
echo -e "${GREEN}║              🎉 后端服务启动脚本执行完成！                         ║${NC}"
echo -e "${GREEN}║                                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📊 服务信息:${NC}"
echo "  - account-service: http://localhost:8081"
echo "  - data-service: http://localhost:8082"
echo "  - engine-service: http://localhost:8083"
echo "  - gateway-service: http://localhost:8000"
echo ""

echo -e "${BLUE}📋 查看日志:${NC}"
echo "  tail -f ${PROJECT_ROOT}/logs/account-service.log"
echo "  tail -f ${PROJECT_ROOT}/logs/data-service.log"
echo "  tail -f ${PROJECT_ROOT}/logs/engine-service.log"
echo "  tail -f ${PROJECT_ROOT}/logs/gateway-service.log"
echo ""

echo -e "${BLUE}🛑 停止服务:${NC}"
echo "  cd ${PROJECT_ROOT}"
echo "  ./stop-backend.sh"
echo ""

echo -e "${BLUE}🌐 Nacos控制台:${NC}"
echo "  http://localhost:8848/nacos (用户名: nacos, 密码: nacos)"
echo ""

echo -e "${GREEN}后端服务启动完成！🚀${NC}"
