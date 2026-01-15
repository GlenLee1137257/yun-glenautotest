#!/bin/bash

# 修复 Nacos 数据源配置

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  修复 Nacos 数据源配置"
echo "=========================================="
echo ""

# 1. 停止并删除现有 Nacos 容器
echo -e "${YELLOW}[1/6] 停止并删除现有 Nacos 容器...${NC}"
docker stop glen-nacos 2>/dev/null || true
docker rm glen-nacos 2>/dev/null || true
echo -e "${GREEN}✓ 已删除${NC}"

# 2. 获取 MySQL 容器 IP
echo ""
echo -e "${YELLOW}[2/6] 获取 MySQL 容器 IP...${NC}"
MYSQL_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glen-mysql)
if [ -z "$MYSQL_IP" ]; then
    echo -e "${RED}✗ 无法获取 MySQL IP，请确保 MySQL 容器正在运行${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MySQL IP: $MYSQL_IP${NC}"

# 3. 创建 Nacos 数据库
echo ""
echo -e "${YELLOW}[3/6] 创建 Nacos 数据库...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest <<EOF
CREATE DATABASE IF NOT EXISTS nacos_config CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
FLUSH PRIVILEGES;
EOF
echo -e "${GREEN}✓ 数据库创建成功${NC}"

# 4. 初始化 Nacos 表结构
echo ""
echo -e "${YELLOW}[4/6] 初始化 Nacos 表结构...${NC}"
docker exec glen-mysql mysql -uroot -pyunautotest nacos_config <<'EOF'
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
  usage int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  max_size int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  max_aggr_count int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
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
  usage int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
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

INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);
INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
EOF
echo -e "${GREEN}✓ 表结构初始化成功${NC}"

# 5. 启动新的 Nacos 容器（配置 MySQL）
echo ""
echo -e "${YELLOW}[5/6] 启动配置了 MySQL 的 Nacos 容器...${NC}"
docker run -d \
  --name glen-nacos \
  -p 8848:8848 \
  -p 9848:9848 \
  -e MODE=standalone \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e MYSQL_SERVICE_HOST=${MYSQL_IP} \
  -e MYSQL_SERVICE_PORT=3306 \
  -e MYSQL_SERVICE_DB_NAME=nacos_config \
  -e MYSQL_SERVICE_USER=root \
  -e MYSQL_SERVICE_PASSWORD=yunautotest \
  -e MYSQL_DATABASE_NUM=1 \
  -e JVM_XMS=256m \
  -e JVM_XMX=256m \
  -v /home/data/nacos/logs:/home/nacos/logs \
  --restart=always \
  nacos/nacos-server:v2.2.3

echo -e "${GREEN}✓ Nacos 容器已启动${NC}"

# 6. 等待并检查 Nacos 启动
echo ""
echo -e "${YELLOW}[6/6] 等待 Nacos 启动（60秒）...${NC}"
sleep 60

# 检查容器状态
if docker ps | grep -q glen-nacos; then
    echo -e "${GREEN}✓ Nacos 容器运行中${NC}"
    
    # 检查日志
    echo ""
    echo "查看 Nacos 启动日志："
    docker logs glen-nacos 2>&1 | tail -30 | grep -E "Nacos.*start|Port|Console|ERROR" || true
    
    # 测试连接
    echo ""
    echo "测试 Nacos 连接："
    sleep 5
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8848/nacos/ 2>/dev/null)
    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}✓ Nacos HTTP 连接成功${NC}"
        echo ""
        echo "Nacos 控制台："
        echo "  URL: http://115.190.216.91:8848/nacos"
        echo "  用户名: nacos"
        echo "  密码: nacos"
    else
        echo -e "${YELLOW}⚠ Nacos 可能还在启动中，HTTP 状态码: $HTTP_STATUS${NC}"
        echo "请等待 1-2 分钟后访问 Nacos 控制台"
    fi
else
    echo -e "${RED}✗ Nacos 容器启动失败${NC}"
    echo "查看日志："
    docker logs glen-nacos 2>&1 | tail -50
    exit 1
fi

echo ""
echo "=========================================="
echo "  修复完成！"
echo "=========================================="
