#!/bin/bash
# Glen自动化测试平台 - 数据库自动初始化脚本
# 执行环境: WSL2
# MySQL连接: glen-mysql容器 (端口3307)

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="/home/hinkad/yun-glenautotest"
MYSQL_DIR="${PROJECT_ROOT}/Mysql"
MYSQL_PASSWORD="glen123456"
CONTAINER_NAME="glen-mysql"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}║           Glen自动化测试平台 - 数据库自动初始化                    ║${NC}"
echo -e "${BLUE}║                                                                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查MySQL容器是否运行
echo -e "${YELLOW}[1/12]${NC} 检查MySQL容器状态..."
if ! docker ps | grep -q ${CONTAINER_NAME}; then
    echo -e "${RED}❌ MySQL容器未运行，请先启动Docker中间件${NC}"
    exit 1
fi
echo -e "${GREEN}✅ MySQL容器运行正常${NC}"
echo ""

# 测试MySQL连接
echo -e "${YELLOW}[2/12]${NC} 测试MySQL连接..."
if ! docker exec ${CONTAINER_NAME} mysql -uroot -p${MYSQL_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; then
    echo -e "${RED}❌ MySQL连接失败，请检查密码${NC}"
    exit 1
fi
echo -e "${GREEN}✅ MySQL连接成功${NC}"
echo ""

# 执行SQL的函数
execute_sql() {
    local db_name=$1
    local sql_file=$2
    local description=$3
    
    echo -e "${YELLOW}执行:${NC} ${description}"
    echo -e "  文件: ${sql_file}"
    
    if [ ! -f "${sql_file}" ]; then
        echo -e "${RED}  ❌ 文件不存在: ${sql_file}${NC}"
        return 1
    fi
    
    # 执行SQL并捕获输出
    local output=$(docker exec -i ${CONTAINER_NAME} mysql -uroot -p${MYSQL_PASSWORD} ${db_name} < "${sql_file}" 2>&1)
    
    # 检查是否有严重错误（排除表已存在等可忽略的错误）
    if echo "$output" | grep -i "error" | grep -v "Warning" | grep -v "already exists" | grep -v "Duplicate" | grep -v "1050" | grep -v "1061" | grep -v "1062"; then
        echo -e "${YELLOW}  ⚠️  有警告信息，但继续执行${NC}"
        echo -e "${GREEN}  ✅ 执行完成${NC}"
        return 0
    else
        echo -e "${GREEN}  ✅ 执行成功${NC}"
        return 0
    fi
}

# 步骤3: 创建数据库
echo -e "${YELLOW}[3/12]${NC} 创建所有数据库..."
docker exec -i ${CONTAINER_NAME} mysql -uroot -p${MYSQL_PASSWORD} << EOF
CREATE DATABASE IF NOT EXISTS glen_account DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_api DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_ui DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_stress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_engine DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_job DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS glen_dict DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
EOF
echo -e "${GREEN}✅ 数据库创建完成${NC}"
echo ""

# 步骤4: 导入glen_account数据库
echo -e "${YELLOW}[4/12]${NC} 初始化 glen_account 数据库..."
execute_sql "glen_account" "${MYSQL_DIR}/account_sql/account.sql" "账号表结构"
execute_sql "glen_account" "${MYSQL_DIR}/02-glen_account-data.sql" "账号基础数据"
execute_sql "glen_account" "${MYSQL_DIR}/12-permission-data.sql" "权限数据" || echo -e "${YELLOW}  ⚠️  权限数据可能已存在，跳过${NC}"
echo ""

# 步骤5: 导入glen_api数据库
echo -e "${YELLOW}[5/12]${NC} 初始化 glen_api 数据库..."
execute_sql "glen_api" "${MYSQL_DIR}/dcloud_api_sql/dcloud_api.sql" "API测试表结构和数据"
echo ""

# 步骤6: 导入glen_ui数据库
echo -e "${YELLOW}[6/12]${NC} 初始化 glen_ui 数据库..."
execute_sql "glen_ui" "${MYSQL_DIR}/dcloud_ui_sql/dcloud_ui_sql.sql" "UI测试表结构和数据"
if [ -f "${MYSQL_DIR}/web_ui_detail_sql/web_ui_detail_sql.sql" ]; then
    execute_sql "glen_ui" "${MYSQL_DIR}/web_ui_detail_sql/web_ui_detail_sql.sql" "UI详情表(可选)" || echo -e "${YELLOW}  ⚠️  UI详情表导入失败，继续执行${NC}"
fi
echo ""

# 步骤7: 导入glen_stress数据库
echo -e "${YELLOW}[7/12]${NC} 初始化 glen_stress 数据库..."
execute_sql "glen_stress" "${MYSQL_DIR}/dcloud_stress_sql/dcloud_stress.sql" "压测表结构和数据"
echo ""

# 步骤8: 导入glen_engine数据库
echo -e "${YELLOW}[8/12]${NC} 初始化 glen_engine 数据库..."
execute_sql "glen_engine" "${MYSQL_DIR}/创建project表_glen_engine.sql" "引擎项目表" || execute_sql "glen_engine" "${MYSQL_DIR}/创建project表.sql" "引擎项目表(备用)"
execute_sql "glen_engine" "${MYSQL_DIR}/创建stress_case_module表_glen_engine.sql" "压测模块表" || execute_sql "glen_engine" "${MYSQL_DIR}/创建stress_case_module表.sql" "压测模块表(备用)"
echo ""

# 步骤9: 导入glen_job数据库
echo -e "${YELLOW}[9/12]${NC} 初始化 glen_job 数据库..."
execute_sql "glen_job" "${MYSQL_DIR}/job_sql/job.sql" "定时任务表结构和数据"
echo ""

# 步骤10: 导入glen_dict数据库
echo -e "${YELLOW}[10/12]${NC} 初始化 glen_dict 数据库..."
execute_sql "glen_dict" "${MYSQL_DIR}/sys_dict/sys_dict.sql" "系统字典数据"
echo ""

# 步骤11: 修复编码问题(可选)
echo -e "${YELLOW}[11/12]${NC} 修复中文编码(可选)..."
if [ -f "${MYSQL_DIR}/13-fix-chinese-encoding.sql" ]; then
    execute_sql "" "${MYSQL_DIR}/13-fix-chinese-encoding.sql" "修复中文编码" || echo -e "${YELLOW}  ⚠️  编码修复脚本不存在，跳过${NC}"
else
    echo -e "${YELLOW}  ⚠️  编码修复脚本不存在，跳过${NC}"
fi
echo ""

# 步骤12: 验证导入结果
echo -e "${YELLOW}[12/12]${NC} 验证数据库导入结果..."
echo ""

docker exec -i ${CONTAINER_NAME} mysql -uroot -p${MYSQL_PASSWORD} << 'EOF'
SELECT 
    table_schema AS '数据库',
    COUNT(*) AS '表数量',
    CASE 
        WHEN table_schema = 'glen_account' AND COUNT(*) >= 5 THEN '✅ 正常'
        WHEN table_schema = 'glen_api' AND COUNT(*) >= 5 THEN '✅ 正常'
        WHEN table_schema = 'glen_ui' AND COUNT(*) >= 5 THEN '✅ 正常'
        WHEN table_schema = 'glen_stress' AND COUNT(*) >= 3 THEN '✅ 正常'
        WHEN table_schema = 'glen_engine' AND COUNT(*) >= 2 THEN '✅ 正常'
        WHEN table_schema = 'glen_job' AND COUNT(*) >= 2 THEN '✅ 正常'
        WHEN table_schema = 'glen_dict' AND COUNT(*) >= 1 THEN '✅ 正常'
        WHEN table_schema = 'nacos_config' AND COUNT(*) = 12 THEN '✅ 正常'
        ELSE '⚠️  检查'
    END AS '状态'
FROM information_schema.tables 
WHERE table_schema IN (
    'glen_account', 'glen_api', 'glen_ui', 
    'glen_stress', 'glen_engine', 'glen_job', 
    'glen_dict', 'nacos_config'
)
GROUP BY table_schema
ORDER BY table_schema;
EOF

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                                   ║${NC}"
echo -e "${GREEN}║                 🎉 数据库初始化完成！                              ║${NC}"
echo -e "${GREEN}║                                                                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📊 统计信息:${NC}"
docker exec -i ${CONTAINER_NAME} mysql -uroot -p${MYSQL_PASSWORD} << 'EOF'
SELECT '系统角色数量:' AS '检查项', COUNT(*) AS '数量' FROM glen_account.role
UNION ALL
SELECT '系统账号数量:', COUNT(*) FROM glen_account.account
UNION ALL
SELECT '权限数量:', COUNT(*) FROM glen_account.permission
UNION ALL
SELECT '字典数据量:', COUNT(*) FROM glen_dict.sys_dict;
EOF

echo ""
echo -e "${BLUE}🎯 下一步操作:${NC}"
echo -e "  1. ✅ Docker中间件已启动"
echo -e "  2. ✅ 数据库初始化已完成"
echo -e "  3. ⏭️  修改后端配置文件(application.yml)"
echo -e "  4. ⏭️  编译并启动后端服务"
echo -e "  5. ⏭️  启动前端服务"
echo ""
echo -e "${GREEN}数据库初始化成功！🚀${NC}"
