#!/bin/bash

# 创建拥有全部权限的管理员账号

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  创建管理员账号"
echo "=========================================="
echo ""

# 默认账号信息
ADMIN_USERNAME="${1:-admin}"
ADMIN_PASSWORD="${2:-admin123}"
ADMIN_EMAIL="${3:-admin@glen.com}"

echo "账号信息："
echo "  用户名: $ADMIN_USERNAME"
echo "  密码: $ADMIN_PASSWORD"
echo "  邮箱: $ADMIN_EMAIL"
echo ""

read -p "确认创建？(y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消"
    exit 0
fi

# 计算 MD5 密码（使用 MySQL 的 MD5 函数）
# 执行 SQL
docker exec -i glen-mysql mysql -uroot -pyunautotest glen_account <<EOF
-- 1. 创建账号（启用状态）
INSERT INTO account (username, is_disabled, gmt_create, gmt_modified)
VALUES ('$ADMIN_USERNAME', 0, NOW(), NOW())
ON DUPLICATE KEY UPDATE is_disabled=0, gmt_modified=NOW();

-- 获取账号ID
SET @account_id = (SELECT id FROM account WHERE username = '$ADMIN_USERNAME');

-- 2. 创建超级管理员角色（如果不存在）
INSERT INTO role (name, code, description, gmt_create, gmt_modified)
VALUES ('超级管理员', 'SUPER_ADMIN', '拥有所有权限的超级管理员', NOW(), NOW())
ON DUPLICATE KEY UPDATE name=name;

-- 获取角色ID
SET @role_id = (SELECT id FROM role WHERE code = 'SUPER_ADMIN');

-- 3. 获取所有权限并分配给角色
INSERT INTO role_permission (role_id, permission_id, gmt_create, gmt_modified)
SELECT @role_id, id, NOW(), NOW()
FROM permission
WHERE NOT EXISTS (
    SELECT 1 FROM role_permission 
    WHERE role_id = @role_id AND permission_id = permission.id
);

-- 4. 将角色分配给账号
INSERT INTO account_role (account_id, role_id, gmt_create, gmt_modified)
VALUES (@account_id, @role_id, NOW(), NOW())
ON DUPLICATE KEY UPDATE account_id=account_id;

-- 5. 创建登录凭证（密码使用 MD5 加密）
-- 邮箱登录
INSERT INTO social_account (account_id, identity_type, identifier, credential, gmt_create, gmt_modified)
VALUES (@account_id, 'mail', '$ADMIN_EMAIL', MD5('$ADMIN_PASSWORD'), NOW(), NOW())
ON DUPLICATE KEY UPDATE credential=MD5('$ADMIN_PASSWORD'), gmt_modified=NOW();

-- 6. 用户名登录（使用用户名作为 identifier）
INSERT INTO social_account (account_id, identity_type, identifier, credential, gmt_create, gmt_modified)
VALUES (@account_id, 'phone', '$ADMIN_USERNAME', MD5('$ADMIN_PASSWORD'), NOW(), NOW())
ON DUPLICATE KEY UPDATE credential=MD5('$ADMIN_PASSWORD'), gmt_modified=NOW();

-- 显示创建结果
SELECT 
    a.id as account_id,
    a.username,
    r.name as role_name,
    r.code as role_code,
    COUNT(rp.permission_id) as permission_count
FROM account a
JOIN account_role ar ON a.id = ar.account_id
JOIN role r ON ar.role_id = r.id
LEFT JOIN role_permission rp ON r.id = rp.role_id
WHERE a.username = '$ADMIN_USERNAME'
GROUP BY a.id, a.username, r.name, r.code;
EOF

echo ""
echo "=========================================="
echo -e "${GREEN}  账号创建完成！${NC}"
echo "=========================================="
echo ""
echo "登录信息："
echo "  用户名: $ADMIN_USERNAME"
echo "  密码: $ADMIN_PASSWORD"
echo "  邮箱: $ADMIN_EMAIL"
echo ""
echo "注意：如果登录失败，可能需要后端重新加密密码。"
echo "请尝试登录，如果失败，查看后端日志或联系开发人员。"
echo ""
