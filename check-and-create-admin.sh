#!/bin/bash

# 检查并创建管理员账号

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  检查并创建管理员账号"
echo "=========================================="
echo ""

ADMIN_USERNAME="${1:-admin}"
ADMIN_PASSWORD="${2:-admin123}"
ADMIN_EMAIL="${3:-admin@glen.com}"

# 1. 检查账号是否存在
echo -e "${YELLOW}[1/3] 检查账号是否存在...${NC}"
ACCOUNT_EXISTS=$(docker exec glen-mysql mysql -uroot -pyunautotest glen_account -Nse "SELECT COUNT(*) FROM account WHERE username='$ADMIN_USERNAME';" 2>/dev/null || echo "0")

if [ "$ACCOUNT_EXISTS" = "1" ]; then
    echo -e "${GREEN}✓ 账号已存在${NC}"
    
    # 检查账号状态
    IS_DISABLED=$(docker exec glen-mysql mysql -uroot -pyunautotest glen_account -Nse "SELECT is_disabled FROM account WHERE username='$ADMIN_USERNAME';" 2>/dev/null || echo "1")
    if [ "$IS_DISABLED" = "1" ]; then
        echo -e "${YELLOW}⚠ 账号被禁用，正在启用...${NC}"
        docker exec glen-mysql mysql -uroot -pyunautotest glen_account -e "UPDATE account SET is_disabled=0 WHERE username='$ADMIN_USERNAME';" 2>/dev/null
        echo -e "${GREEN}✓ 账号已启用${NC}"
    fi
    
    # 更新密码
    echo "更新密码..."
    docker exec glen-mysql mysql -uroot -pyunautotest glen_account <<EOF
SET @account_id = (SELECT id FROM account WHERE username = '$ADMIN_USERNAME');
UPDATE social_account SET credential=MD5('$ADMIN_PASSWORD') WHERE account_id=@account_id;
EOF
    echo -e "${GREEN}✓ 密码已更新${NC}"
else
    echo -e "${YELLOW}账号不存在，正在创建...${NC}"
    
    # 2. 创建账号
    echo ""
    echo -e "${YELLOW}[2/3] 创建管理员账号...${NC}"
    docker exec -i glen-mysql mysql -uroot -pyunautotest glen_account <<EOF
-- 创建账号（启用状态）
INSERT INTO account (username, is_disabled, gmt_create, gmt_modified)
VALUES ('$ADMIN_USERNAME', 0, NOW(), NOW());

-- 获取账号ID
SET @account_id = LAST_INSERT_ID();

-- 创建超级管理员角色（如果不存在）
INSERT INTO role (name, code, description, gmt_create, gmt_modified)
VALUES ('超级管理员', 'SUPER_ADMIN', '拥有所有权限的超级管理员', NOW(), NOW())
ON DUPLICATE KEY UPDATE name=name;

-- 获取角色ID
SET @role_id = (SELECT id FROM role WHERE code = 'SUPER_ADMIN');

-- 获取所有权限并分配给角色
INSERT INTO role_permission (role_id, permission_id, gmt_create, gmt_modified)
SELECT @role_id, id, NOW(), NOW()
FROM permission
WHERE NOT EXISTS (
    SELECT 1 FROM role_permission 
    WHERE role_id = @role_id AND permission_id = permission.id
);

-- 将角色分配给账号
INSERT INTO account_role (account_id, role_id, gmt_create, gmt_modified)
VALUES (@account_id, @role_id, NOW(), NOW())
ON DUPLICATE KEY UPDATE account_id=account_id;

-- 创建登录凭证（密码使用 MD5 加密）
INSERT INTO social_account (account_id, identity_type, identifier, credential, gmt_create, gmt_modified)
VALUES (@account_id, 'mail', '$ADMIN_EMAIL', MD5('$ADMIN_PASSWORD'), NOW(), NOW())
ON DUPLICATE KEY UPDATE credential=MD5('$ADMIN_PASSWORD'), gmt_modified=NOW();

-- 用户名登录
INSERT INTO social_account (account_id, identity_type, identifier, credential, gmt_create, gmt_modified)
VALUES (@account_id, 'phone', '$ADMIN_USERNAME', MD5('$ADMIN_PASSWORD'), NOW(), NOW())
ON DUPLICATE KEY UPDATE credential=MD5('$ADMIN_PASSWORD'), gmt_modified=NOW();
EOF
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 账号创建成功${NC}"
    else
        echo -e "${RED}✗ 账号创建失败${NC}"
        exit 1
    fi
fi

# 3. 验证账号信息
echo ""
echo -e "${YELLOW}[3/3] 验证账号信息...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest glen_account <<EOF
SELECT 
    a.id as account_id,
    a.username,
    a.is_disabled,
    r.name as role_name,
    r.code as role_code,
    COUNT(DISTINCT rp.permission_id) as permission_count,
    COUNT(DISTINCT sa.id) as login_methods
FROM account a
LEFT JOIN account_role ar ON a.id = ar.account_id
LEFT JOIN role r ON ar.role_id = r.id
LEFT JOIN role_permission rp ON r.id = rp.role_id
LEFT JOIN social_account sa ON a.id = sa.account_id
WHERE a.username = '$ADMIN_USERNAME'
GROUP BY a.id, a.username, a.is_disabled, r.name, r.code;
EOF

echo ""
echo "=========================================="
echo -e "${GREEN}  账号准备完成！${NC}"
echo "=========================================="
echo ""
echo "登录信息："
echo "  用户名: $ADMIN_USERNAME"
echo "  密码: $ADMIN_PASSWORD"
echo "  邮箱: $ADMIN_EMAIL"
echo ""
echo "可以使用以下方式登录："
echo "  1. 用户名: $ADMIN_USERNAME"
echo "  2. 邮箱: $ADMIN_EMAIL"
echo ""
echo "如果仍然无法登录，请检查："
echo "  1. 后端服务日志: journalctl -u glen-account -n 50"
echo "  2. 数据库连接是否正常"
echo ""
