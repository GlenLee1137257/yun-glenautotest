# ✅ Nacos访问指南

## 🎉 Nacos已成功启动!

Nacos已经在WSL2环境中成功启动并运行。

---

## 🌐 访问地址

### 从浏览器访问(Windows)

由于您在WSL2环境中运行Docker,需要通过`localhost`访问:

```
http://localhost:8848/nacos
```

### 登录凭证

- **用户名**: `nacos`
- **密码**: `nacos`

---

## 🔍 为什么之前无法访问?

问题原因:**Nacos数据库表未初始化**

Nacos需要在MySQL的`nacos_config`数据库中有完整的表结构才能正常启动。初始部署时数据库是空的,导致Nacos启动失败并抛出"No DataSource set"错误。

### 解决方案

1. 从Nacos官方仓库下载MySQL初始化脚本(nacos-mysql-schema.sql)
2. 执行SQL脚本创建12个必需的表
3. 重启Nacos容器

现在数据库表已创建完成,Nacos成功启动!

---

## 📊 当前所有中间件状态

| 服务 | 容器名 | 访问地址 | 状态 |
|------|--------|----------|------|
| MySQL | glen-mysql | localhost:3307 | ✅ 运行中 |
| Redis | glen-redis | localhost:6379 | ✅ 运行中 |
| **Nacos** | glen-nacos | **http://localhost:8848/nacos** | ✅ 运行中 |
| Zookeeper | glen-zookeeper | localhost:2181 | ✅ 运行中 |
| Kafka | glen-kafka | localhost:9092 | ✅ 运行中 |
| MinIO | glen-minio | localhost:9000 (API)<br>localhost:9001 (控制台) | ✅ 运行中 |

---

## 🧪 验证Nacos功能

### 1. 访问控制台

在浏览器中打开:
```
http://localhost:8848/nacos
```

### 2. 登录

- 用户名: `nacos`
- 密码: `nacos`

### 3. 检查配置管理

登录后可以看到:
- 配置管理 (Configuration Management)
- 服务管理 (Service Management)
- 命名空间 (Namespace)
- 集群管理 (Cluster Management)

---

## 🔧 常用操作

### 查看Nacos日志

```bash
docker logs -f glen-nacos
```

### 重启Nacos

```bash
docker restart glen-nacos
```

### 检查Nacos健康状态

```bash
curl http://localhost:8848/nacos/actuator/health
```

### 查看Nacos版本

```bash
curl http://localhost:8848/nacos/v1/console/server/state
```

---

## 📝 Nacos数据库表结构

初始化后的`nacos_config`数据库包含以下12个表:

1. `config_info` - 配置信息表
2. `config_info_aggr` - 配置聚合表
3. `config_info_beta` - Beta配置表
4. `config_info_tag` - 标签配置表
5. `config_tags_relation` - 配置标签关系表
6. `group_capacity` - 分组容量表
7. `his_config_info` - 历史配置表
8. `tenant_capacity` - 租户容量表
9. `tenant_info` - 租户信息表
10. `users` - 用户表
11. `roles` - 角色表
12. `permissions` - 权限表

---

## 🚨 常见问题

### Q: 浏览器提示"无法访问此网站"

**A**: 检查以下几点:
1. 确认Nacos容器正在运行: `docker ps | grep nacos`
2. 检查端口转发: `netstat -tlnp | grep 8848`
3. 确认Docker Desktop的WSL集成已启用
4. 尝试重启Nacos: `docker restart glen-nacos`

### Q: 页面显示但无法登录

**A**: 使用正确的凭证:
- 默认用户名: `nacos`
- 默认密码: `nacos`

### Q: 如何修改默认密码?

**A**: 登录后在"权限控制" -> "用户列表"中修改

---

## 🎯 下一步操作

1. ✅ Nacos已启动 - **完成**
2. 🔄 配置后端服务连接Nacos
3. 🔄 在Nacos中添加配置文件
4. 🔄 启动后端微服务
5. 🔄 启动前端服务

---

**Nacos启动时间**: 2026-01-17 23:42:31  
**文档生成时间**: 2026-01-17 23:44  
**部署环境**: WSL2 Ubuntu
