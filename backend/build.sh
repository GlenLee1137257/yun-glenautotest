#!/bin/bash
# Glen AutoTest Platform - Backend Build Script

set -e

echo "========================================="
echo "Glen AutoTest Platform - Backend Build"
echo "========================================="

# 检查Maven是否安装
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven is not installed. Please install Maven first."
    exit 1
fi

# 检查Java版本
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "Error: Java 17 or higher is required. Current version: $JAVA_VERSION"
    exit 1
fi

echo "Java version: $JAVA_VERSION"
echo "Maven version: $(mvn --version | head -1)"
echo ""

# 清理并编译
echo "Cleaning and compiling..."
mvn clean compile -DskipTests

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
    exit 1
fi

# 打包
echo ""
echo "Packaging..."
mvn package -DskipTests

if [ $? -eq 0 ]; then
    echo "✓ Packaging successful"
else
    echo "✗ Packaging failed"
    exit 1
fi

# 显示打包结果
echo ""
echo "========================================="
echo "Build Summary"
echo "========================================="
find . -name "glen-*.jar" -type f | while read jar; do
    size=$(du -h "$jar" | cut -f1)
    echo "$jar ($size)"
done

echo ""
echo "Build completed successfully!"
