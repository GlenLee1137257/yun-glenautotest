#!/bin/bash

# 部署 MySQL 5.7 专门给 Nacos 使用

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  部署 MySQL 5.7 给 Nacos 使用"
echo "=========================================="
echo ""
echo "注意：这将创建一个新的 MySQL 5.7 容器专门给 Nacos 使用"
echo "原有的 MySQL 8.0 (glen-mysql) 保持不变"
echo ""

# 1. 检查 MySQL 5.7 镜像
echo -e "${YELLOW}[1/7] 检查 MySQL 5.7 镜像...${NC}"
if ! docker images | grep -q "mysql.*5.7"; then
    echo "拉取 MySQL 5.7 镜像..."
    docker pull mysql:5.7 || echo -e "${YELLOW}镜像拉取可能失败，尝试继续...${NC}"
fi
docker images | grep "mysql" || true

# 2. 停止并删除旧的 Nacos MySQL（如果存在）
echo ""
echo -e "${YELLOW}[2/7] 清理旧容器...${NC}"
docker stop glen-mysql-nacos 2>/dev/null || true
docker rm glen-mysql-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已清理${NC}"

# 3. 启动 MySQL 5.7
echo ""
echo -e "${YELLOW}[3/7] 启动 MySQL 5.7 容器...${NC}"
docker run -d \
  --name glen-mysql-nacos \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=yunautotest \
  -e MYSQL_DATABASE=nacos_config \
  -v /home/data/mysql-nacos:/var/lib/mysql \
  --restart=always \
  mysql:5.7 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_unicode_ci \
  --default-authentication-plugin=mysql_native_password

echo -e "${GREEN}✓ MySQL 5.7 容器已启动${NC}"

# 4. 等待 MySQL 启动
echo ""
echo -e "${YELLOW}[4/7] 等待 MySQL 5.7 启动（30 秒）...${NC}"
sleep 30

# 5. 获取 MySQL 5.7 IP
echo ""
echo -e "${YELLOW}[5/7] 获取 MySQL 5.7 IP...${NC}"
MYSQL57_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql-nacos)
echo -e "${GREEN}MySQL 5.7 IP: $MYSQL57_IP${NC}"

# 6. 初始化 Nacos 数据库
echo ""
echo -e "${YELLOW}[6/7] 初始化 Nacos 数据库表结构...${NC}"
docker exec -i glen-mysql-nacos mysql -uroot -pyunautotest nacos_config <<'EOF'
CREATE TABLE IF NOT EXISTS config_info (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(255) DEFAULT NULL,
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  app_name varchar(128) DEFAULT NULL,
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  c_desc varchar(256) DEFAULT NULL,
  c_use varchar(64) DEFAULT NULL,
  effect varchar(64) DEFAULT NULL,
  type varchar(64) DEFAULT NULL,
  c_schema text,
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfo_datagrouptenant (data_id,group_id,tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

CREATE TABLE IF NOT EXISTS config_info_aggr (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(255) NOT NULL COMMENT 'group_id',
  datum_id varchar(255) NOT NULL COMMENT 'datum_id',
  content longtext NOT NULL COMMENT '内容',
  gmt_modified datetime NOT NULL COMMENT '修改时间',
  app_name varchar(128) DEFAULT NULL,
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfoaggr_datagrouptenantdatum (data_id,group_id,tenant_id,datum_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';

CREATE TABLE IF NOT EXISTS config_info_beta (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  beta_ips varchar(1024) DEFAULT NULL COMMENT 'betaIps',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfobeta_datagrouptenant (data_id,group_id,tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

CREATE TABLE IF NOT EXISTS config_info_tag (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  tag_id varchar(128) NOT NULL COMMENT 'tag_id',
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL COMMENT 'content',
  md5 varchar(32) DEFAULT NULL COMMENT 'md5',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  src_user text COMMENT 'source user',
  src_ip varchar(50) DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (id),
  UNIQUE KEY uk_configinfotag_datagrouptenanttag (data_id,group_id,tenant_id,tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

CREATE TABLE IF NOT EXISTS config_tags_relation (
  id bigint(20) NOT NULL COMMENT 'id',
  tag_name varchar(128) NOT NULL COMMENT 'tag_name',
  tag_type varchar(64) DEFAULT NULL COMMENT 'tag_type',
  data_id varchar(255) NOT NULL COMMENT 'data_id',
  group_id varchar(128) NOT NULL COMMENT 'group_id',
  tenant_id varchar(128) DEFAULT '' COMMENT 'tenant_id',
  nid bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (nid),
  UNIQUE KEY uk_configtagrelation_configidtag (id,tag_name,tag_type),
  KEY idx_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

CREATE TABLE IF NOT EXISTS group_capacity (
  id bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  group_id varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  quota int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  max_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  max_aggr_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  max_aggr_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  max_history_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_group_id (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

CREATE TABLE IF NOT EXISTS his_config_info (
  id bigint(64) unsigned NOT NULL,
  nid bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  data_id varchar(255) NOT NULL,
  group_id varchar(128) NOT NULL,
  app_name varchar(128) DEFAULT NULL COMMENT 'app_name',
  content longtext NOT NULL,
  md5 varchar(32) DEFAULT NULL,
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  src_user text,
  src_ip varchar(50) DEFAULT NULL,
  op_type char(10) DEFAULT NULL,
  tenant_id varchar(128) DEFAULT '' COMMENT '租户字段',
  encrypted_data_key text NOT NULL COMMENT '秘钥',
  PRIMARY KEY (nid),
  KEY idx_gmt_create (gmt_create),
  KEY idx_gmt_modified (gmt_modified),
  KEY idx_did (data_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';

CREATE TABLE IF NOT EXISTS tenant_capacity (
  id bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  tenant_id varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  quota int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  max_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  max_aggr_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  max_aggr_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  max_history_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  gmt_create datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  gmt_modified datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';

CREATE TABLE IF NOT EXISTS tenant_info (
  id bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  kp varchar(128) NOT NULL COMMENT 'kp',
  tenant_id varchar(128) default '' COMMENT 'tenant_id',
  tenant_name varchar(128) default '' COMMENT 'tenant_name',
  tenant_desc varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
  create_source varchar(32) DEFAULT NULL COMMENT 'create_source',
  gmt_create bigint(20) NOT NULL COMMENT '创建时间',
  gmt_modified bigint(20) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_tenant_info_kptenantid (kp,tenant_id),
  KEY idx_tenant_id (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

CREATE TABLE IF NOT EXISTS users (
  username varchar(50) NOT NULL PRIMARY KEY,
  password varchar(500) NOT NULL,
  enabled boolean NOT NULL
);

CREATE TABLE IF NOT EXISTS roles (
  username varchar(50) NOT NULL,
  role varchar(50) NOT NULL,
  constraint uk_username_role UNIQUE (username,role)
);

CREATE TABLE IF NOT EXISTS permissions (
  role varchar(50) NOT NULL,
  resource varchar(255) NOT NULL,
  action varchar(8) NOT NULL,
  constraint uk_role_permission UNIQUE (role,resource,action)
);

INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE) ON DUPLICATE KEY UPDATE password='$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu';
INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN') ON DUPLICATE KEY UPDATE role='ROLE_ADMIN';
EOF

echo -e "${GREEN}✓ 数据库表结构初始化完成${NC}"

# 7. 配置 Nacos 使用 MySQL 5.7
echo ""
echo -e "${YELLOW}[7/7] 配置 Nacos 使用 MySQL 5.7...${NC}"

# 停止 Nacos
docker stop glen-nacos 2>/dev/null || true

# 创建配置文件
mkdir -p /tmp/nacos-config
cat > /tmp/nacos-config/application.properties << EOF
server.servlet.contextPath=/nacos
server.port=8848

spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://${MYSQL57_IP}:3306/nacos_config?characterEncoding=utf8&connectTimeout=5000&socketTimeout=5000&autoReconnect=true&useSSL=false
db.user.0=root
db.password.0=yunautotest

nacos.core.auth.enabled=false
nacos.standalone=true
EOF

# 复制配置并启动
docker cp /tmp/nacos-config/application.properties glen-nacos:/home/nacos/conf/application.properties
docker start glen-nacos

echo -e "${GREEN}✓ Nacos 配置已更新${NC}"

# 等待启动
echo ""
echo "等待 Nacos 启动（60 秒）..."
sleep 60

# 检查结果
echo ""
echo "=========================================="
echo "  部署完成"
echo "=========================================="
echo ""
echo "MySQL 5.7 (专用于 Nacos)："
echo "  容器名: glen-mysql-nacos"
echo "  端口: 3307"
echo "  IP: $MYSQL57_IP"
echo "  数据库: nacos_config"
echo ""
echo "MySQL 8.0 (业务数据库)："
echo "  容器名: glen-mysql"
echo "  端口: 3306"
echo ""

# 检查 Nacos 状态
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null || echo "000")
echo "Nacos HTTP 状态码: $HTTP_STATUS"

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✓ Nacos 启动成功！${NC}"
else
    echo -e "${YELLOW}⚠ Nacos 可能还在启动中，请稍等片刻${NC}"
fi

echo ""
echo "Nacos 控制台："
echo "  URL: http://115.190.216.91:8848/nacos"
echo "  用户名: nacos"
echo "  密码: nacos"
echo ""
echo "查看 Nacos 日志："
echo "  docker logs glen-nacos | tail -50"
echo ""
