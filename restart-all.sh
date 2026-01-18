#!/bin/bash
# Glen AutoTest Platform - Restart All Services Script

set -e

echo "========================================="
echo "Glen AutoTest Platform - Starting All Services"
echo "========================================="

# Get project directory
PROJECT_ROOT="/home/hinkad/yun-glenautotest"
cd $PROJECT_ROOT

# Create logs directory
mkdir -p $PROJECT_ROOT/backend/logs

# Start Docker middleware services
echo ""
echo "Step 1: Starting Docker middleware services..."
docker compose up -d

echo "Waiting for services to be ready..."
sleep 15

# Check Docker services status
echo ""
echo "Step 2: Checking Docker services status..."
docker compose ps

# Start backend services
echo ""
echo "Step 3: Starting backend services..."
cd $PROJECT_ROOT/backend

nohup mvn -f glen-gateway spring-boot:run > logs/gateway.log 2>&1 &
echo "  - glen-gateway started (PID: $!)"
sleep 3

nohup mvn -f glen-account spring-boot:run > logs/account.log 2>&1 &
echo "  - glen-account started (PID: $!)"
sleep 3

nohup mvn -f glen-engine spring-boot:run > logs/engine.log 2>&1 &
echo "  - glen-engine started (PID: $!)"
sleep 3

nohup mvn -f glen-data spring-boot:run > logs/data.log 2>&1 &
echo "  - glen-data started (PID: $!)"
sleep 10

# Start frontend
echo ""
echo "Step 4: Starting frontend service..."
cd $PROJECT_ROOT/frontend
nohup pnpm run dev > $PROJECT_ROOT/backend/logs/frontend.log 2>&1 &
echo "  - frontend started (PID: $!)"

echo ""
echo "========================================="
echo "All services started successfully!"
echo "========================================="
echo ""
echo "Service Logs:"
echo "  - Gateway:  $PROJECT_ROOT/backend/logs/gateway.log"
echo "  - Account:  $PROJECT_ROOT/backend/logs/account.log"
echo "  - Engine:   $PROJECT_ROOT/backend/logs/engine.log"
echo "  - Data:     $PROJECT_ROOT/backend/logs/data.log"
echo "  - Frontend: $PROJECT_ROOT/backend/logs/frontend.log"
echo ""
echo "Access URLs:"
echo "  - Frontend: http://localhost:5173"
echo "  - Nacos:    http://localhost:8848/nacos (nacos/nacos)"
echo "  - MinIO:    http://localhost:9001 (admin/glen123456)"
echo ""
echo "To view logs in real-time:"
echo "  tail -f $PROJECT_ROOT/backend/logs/gateway.log"
echo ""
