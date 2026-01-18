#!/bin/bash
# Glen自动化测试平台 - 一键部署脚本

set -e

echo "========================================="
echo "Glen AutoTest Platform - Deployment Script"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="/home/hinkad/yun-glenautotest"
cd $PROJECT_ROOT

# 检查环境
check_environment() {
    echo -e "${BLUE}=== 检查环境 ===${NC}"
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker未安装${NC}"
        echo "请先运行: ./setup-environment.sh"
        exit 1
    fi
    
    # 检查Docker是否运行
    if ! docker ps &> /dev/null; then
        echo -e "${YELLOW}⚠️  Docker服务未运行,尝试启动...${NC}"
        sudo service docker start
        sleep 3
    fi
    
    # 检查Java
    if ! command -v java &> /dev/null; then
        echo -e "${RED}❌ Java未安装${NC}"
        echo "请先运行: ./setup-environment.sh"
        exit 1
    fi
    
    # 检查Maven
    if ! command -v mvn &> /dev/null; then
        echo -e "${RED}❌ Maven未安装或未配置${NC}"
        echo "请先运行: ./setup-environment.sh"
        exit 1
    fi
    
    # 检查Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js未安装${NC}"
        echo "请先运行: ./setup-environment.sh"
        exit 1
    fi
    
    # 检查pnpm
    if ! command -v pnpm &> /dev/null; then
        echo -e "${RED}❌ pnpm未安装${NC}"
        echo "请先运行: ./setup-environment.sh"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 环境检查通过${NC}"
    echo ""
}

# 1. 启动Docker中间件
start_docker_services() {
    echo -e "${BLUE}=== Step 1: 启动Docker中间件服务 ===${NC}"
    
    # 检查是否已有运行的容器
    if docker ps | grep -q "glen-"; then
        echo -e "${YELLOW}检测到已运行的容器,停止旧容器...${NC}"
        docker compose down
    fi
    
    # 启动所有中间件
    echo "启动 MySQL, Redis, Nacos, Kafka, MinIO..."
    docker compose up -d
    
    # 等待服务就绪
    echo -e "${YELLOW}等待中间件服务启动 (30秒)...${NC}"
    sleep 30
    
    # 检查容器状态
    echo ""
    echo "Docker容器状态:"
    docker compose ps
    echo ""
    
    echo -e "${GREEN}✅ Docker中间件启动完成${NC}"
    echo ""
}

# 2. 检查数据库
check_database() {
    echo -e "${BLUE}=== Step 2: 检查数据库 ===${NC}"
    
    # 等待MySQL完全启动
    echo "等待MySQL完全启动..."
    sleep 10
    
    # 检查数据库是否存在
    echo "检查数据库..."
    
    DATABASES=$(docker exec glen-mysql mysql -uroot -pglen123456 -e "SHOW DATABASES LIKE 'glen_%';" 2>/dev/null | grep -v Database || true)
    
    if [ -z "$DATABASES" ]; then
        echo -e "${YELLOW}⚠️  数据库未初始化,正在初始化...${NC}"
        
        # SQL文件应该已通过volume自动导入
        echo "SQL文件位置: ./Mysql/"
        echo "Docker会在首次启动时自动执行初始化脚本"
        echo ""
        echo -e "${YELLOW}如果数据库仍未创建,请手动执行:${NC}"
        echo "  docker exec -i glen-mysql mysql -uroot -pglen123456 < Mysql/init.sql"
    else
        echo -e "${GREEN}✅ 数据库已存在:${NC}"
        echo "$DATABASES"
    fi
    
    echo ""
}

# 3. 编译后端项目
build_backend() {
    echo -e "${BLUE}=== Step 3: 编译后端项目 ===${NC}"
    
    cd $PROJECT_ROOT/backend
    
    echo "开始Maven编译..."
    mvn clean package -DskipTests
    
    echo -e "${GREEN}✅ 后端编译完成${NC}"
    echo ""
}

# 4. 启动后端服务
start_backend_services() {
    echo -e "${BLUE}=== Step 4: 启动后端服务 ===${NC}"
    
    # 创建日志目录
    mkdir -p $PROJECT_ROOT/backend/logs
    
    cd $PROJECT_ROOT/backend
    
    # 停止旧的服务
    echo "停止旧的后端服务..."
    pkill -f "spring-boot:run" || true
    sleep 3
    
    # 启动服务
    echo "启动 glen-gateway..."
    nohup mvn -f glen-gateway spring-boot:run > logs/gateway.log 2>&1 &
    echo "  PID: $!"
    sleep 5
    
    echo "启动 glen-account..."
    nohup mvn -f glen-account spring-boot:run > logs/account.log 2>&1 &
    echo "  PID: $!"
    sleep 5
    
    echo "启动 glen-engine..."
    nohup mvn -f glen-engine spring-boot:run > logs/engine.log 2>&1 &
    echo "  PID: $!"
    sleep 5
    
    echo "启动 glen-data..."
    nohup mvn -f glen-data spring-boot:run > logs/data.log 2>&1 &
    echo "  PID: $!"
    sleep 10
    
    echo -e "${GREEN}✅ 后端服务启动完成${NC}"
    echo ""
}

# 5. 安装前端依赖
install_frontend_deps() {
    echo -e "${BLUE}=== Step 5: 安装前端依赖 ===${NC}"
    
    cd $PROJECT_ROOT/frontend
    
    if [ ! -d "node_modules" ]; then
        echo "安装前端依赖..."
        pnpm install
    else
        echo "前端依赖已安装,跳过..."
    fi
    
    echo -e "${GREEN}✅ 前端依赖安装完成${NC}"
    echo ""
}

# 6. 启动前端服务
start_frontend() {
    echo -e "${BLUE}=== Step 6: 启动前端服务 ===${NC}"
    
    cd $PROJECT_ROOT/frontend
    
    # 停止旧的前端服务
    echo "停止旧的前端服务..."
    pkill -f "vite" || true
    sleep 2
    
    # 启动前端
    echo "启动前端服务..."
    nohup pnpm run dev > $PROJECT_ROOT/backend/logs/frontend.log 2>&1 &
    echo "  PID: $!"
    sleep 5
    
    echo -e "${GREEN}✅ 前端服务启动完成${NC}"
    echo ""
}

# 7. 验证服务
verify_services() {
    echo -e "${BLUE}=== Step 7: 验证服务 ===${NC}"
    
    echo "Docker容器:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep glen || true
    echo ""
    
    echo "后端服务进程:"
    ps aux | grep "spring-boot:run" | grep -v grep || echo "  未检测到后端服务"
    echo ""
    
    echo "前端服务进程:"
    ps aux | grep "vite" | grep -v grep || echo "  未检测到前端服务"
    echo ""
}

# 8. 显示访问信息
show_access_info() {
    echo ""
    echo "========================================="
    echo -e "${GREEN}部署完成!${NC}"
    echo "========================================="
    echo ""
    echo -e "${BLUE}📋 服务访问地址:${NC}"
    echo ""
    echo "  🌐 前端页面:"
    echo "     http://localhost:5173"
    echo ""
    echo "  🔧 Nacos控制台:"
    echo "     http://localhost:8848/nacos"
    echo "     用户名: nacos"
    echo "     密码: nacos"
    echo ""
    echo "  📦 MinIO控制台:"
    echo "     http://localhost:9001"
    echo "     用户名: admin"
    echo "     密码: glen123456"
    echo ""
    echo "  🗄️  MySQL:"
    echo "     Host: localhost:3306"
    echo "     用户名: root"
    echo "     密码: glen123456"
    echo ""
    echo "  📝 测试账号:"
    echo "     账号: 13432898570"
    echo "     密码: C1137257"
    echo ""
    echo -e "${BLUE}📊 日志文件位置:${NC}"
    echo "  - Gateway:  $PROJECT_ROOT/backend/logs/gateway.log"
    echo "  - Account:  $PROJECT_ROOT/backend/logs/account.log"
    echo "  - Engine:   $PROJECT_ROOT/backend/logs/engine.log"
    echo "  - Data:     $PROJECT_ROOT/backend/logs/data.log"
    echo "  - Frontend: $PROJECT_ROOT/backend/logs/frontend.log"
    echo ""
    echo -e "${BLUE}📌 常用命令:${NC}"
    echo "  查看日志: tail -f $PROJECT_ROOT/backend/logs/gateway.log"
    echo "  停止服务: ./stop-all.sh"
    echo "  重启服务: ./restart-all.sh"
    echo ""
}

# 主函数
main() {
    check_environment
    start_docker_services
    check_database
    build_backend
    start_backend_services
    install_frontend_deps
    start_frontend
    verify_services
    show_access_info
}

main
