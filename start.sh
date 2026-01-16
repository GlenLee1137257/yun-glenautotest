#!/bin/bash
# Glen AutoTest Platform - Start All Services Script

set -e

echo "========================================="
echo "Glen AutoTest Platform - Starting Services"
echo "========================================="

# 加载环境变量
if [ -f ".env.dev" ]; then
    echo "Loading development environment variables..."
    export $(cat .env.dev | grep -v '^#' | xargs)
elif [ -f ".env.prod" ]; then
    echo "Loading production environment variables..."
    export $(cat .env.prod | grep -v '^#' | xargs)
else
    echo "Warning: No environment file found (.env.dev or .env.prod)"
    echo "Using default configuration..."
fi

echo ""

# 检查Docker是否在运行
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# 启动Docker服务
echo "Step 1: Starting Docker services (MySQL, Redis, Nacos, Kafka, MinIO)..."
docker compose up -d

echo "Waiting for services to be ready..."
sleep 10

# 检查服务健康状态
echo ""
echo "Checking service health..."
docker compose ps

echo ""
echo "========================================="
echo "Service URLs:"
echo "========================================="
echo "MySQL:      localhost:3306"
echo "Redis:      localhost:6379"
echo "Nacos:      http://localhost:8848/nacos"
echo "Kafka:      localhost:9092"
echo "MinIO:      http://localhost:9000 (Console: http://localhost:9001)"
echo ""

# 提示用户启动后端服务
echo "========================================="
echo "Next Steps:"
echo "========================================="
echo "1. Backend Services:"
echo "   cd backend/glen-gateway && mvn spring-boot:run &"
echo "   cd backend/glen-account && mvn spring-boot:run &"
echo "   cd backend/glen-engine && mvn spring-boot:run &"
echo "   cd backend/glen-data && mvn spring-boot:run &"
echo ""
echo "2. Frontend:"
echo "   cd frontend && pnpm run dev"
echo ""
echo "========================================="
echo "Docker services started successfully!"
echo "========================================="
