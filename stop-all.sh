#!/bin/bash
# Glen AutoTest Platform - Stop All Services Script

echo "========================================="
echo "Glen AutoTest Platform - Stopping All Services"
echo "========================================="

# Stop backend services
echo ""
echo "Step 1: Stopping backend services..."
pkill -f "glen-gateway" && echo "  - glen-gateway stopped" || echo "  - glen-gateway not running"
pkill -f "glen-account" && echo "  - glen-account stopped" || echo "  - glen-account not running"
pkill -f "glen-engine" && echo "  - glen-engine stopped" || echo "  - glen-engine not running"
pkill -f "glen-data" && echo "  - glen-data stopped" || echo "  - glen-data not running"

# Stop frontend
echo ""
echo "Step 2: Stopping frontend service..."
pkill -f "vite" && echo "  - frontend stopped" || echo "  - frontend not running"

# Stop Docker middleware services
echo ""
echo "Step 3: Stopping Docker middleware services..."
cd /home/hinkad/yun-glenautotest
docker compose down

echo ""
echo "========================================="
echo "All services stopped successfully!"
echo "========================================="
echo ""
echo "To restart services, run: ./restart-all.sh"
echo ""
