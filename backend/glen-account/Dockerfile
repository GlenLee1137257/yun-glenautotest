# Glen AutoTest Platform - Account Service Dockerfile
FROM openjdk:17-jdk-slim-buster

# 定义构建参数
ARG JAR_FILE=target/glen-account.jar
ARG SERVICE_PORT=8081

# 设置环境变量
ENV JAVA_OPTS="-Xms256m -Xmx512m" \
    SERVER_PORT=${SERVICE_PORT} \
    TZ=Asia/Shanghai

# 安装必要的工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制 JAR 文件
COPY ${JAR_FILE} app.jar

# 暴露端口
EXPOSE ${SERVER_PORT}

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:${SERVER_PORT}/actuator/health || exit 1

# 启动命令
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/app.jar"]
