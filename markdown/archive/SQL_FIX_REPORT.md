## ✅ SQL错误已修复！

### 问题描述
执行 `02-glen_account-data.sql` 时出现错误：
```
1364 - Field 'code' doesn't have a default value
```

### 根本原因
数据库表 `role` 和 `permission` 有一个必需的字段 `code`（角色编码/权限编码），但插入数据时没有提供该字段的值。

### 已修复内容

#### 1. **role 表插入语句**
✅ **修复前**：缺少 `code` 字段
```sql
INSERT INTO `role` (`id`, `name`, `description`, `gmt_create`, `gmt_modified`)
```

✅ **修复后**：添加 `code` 字段和对应值
```sql
INSERT INTO `role` (`id`, `name`, `code`, `description`, `gmt_create`, `gmt_modified`)
VALUES
  (1, '超级管理员', 'ROLE_SUPER_ADMIN', '拥有系统所有权限', NOW(), NOW()),
  (2, '项目管理员', 'ROLE_PROJECT_ADMIN', '项目管理权限', NOW(), NOW()),
  (3, '测试工程师', 'ROLE_TESTER', '测试执行权限', NOW(), NOW())
```

#### 2. **account 表插入语句**
✅ **修复**：移除了不存在的字段（password, email, phone, name等），只保留实际存在的字段
```sql
INSERT INTO `account` (`id`, `username`, `is_disabled`, `gmt_create`, `gmt_modified`)
VALUES
  (1, 'admin', 0, NOW(), NOW())
```

#### 3. **permission 表插入语句**
✅ **修复**：
- 添加了 `code` 字段和权限编码
- 移除了不存在的字段（parent_id, path, component, icon, type, sort, state）
- 简化为实际表结构所需的字段

```sql
INSERT INTO `permission` (`id`, `name`, `code`, `description`, `gmt_create`, `gmt_modified`)
VALUES
  (1, '项目管理', 'project:view', '项目管理菜单', NOW(), NOW()),
  (2, '项目列表', 'project:list', '查看项目列表', NOW(), NOW()),
  ...
```

---

### 🎯 现在可以执行的操作

1. **重新执行修复后的SQL文件**
   
   在Navicat中：
   - 选择数据库 `glen_account`
   - 运行SQL文件：`Mysql/02-glen_account-data.sql`
   - ✅ 应该可以成功执行了！

2. **如果之前执行失败留下了部分数据**
   
   可以先清空表再重新执行：
   ```sql
   USE glen_account;
   
   -- 清空表（保留表结构）
   TRUNCATE TABLE `role_permission`;
   TRUNCATE TABLE `account_role`;
   TRUNCATE TABLE `role`;
   TRUNCATE TABLE `permission`;
   TRUNCATE TABLE `account`;
   
   -- 然后重新执行 02-glen_account-data.sql
   ```

---

### 📊 修复后的数据内容

执行成功后将创建：

| 数据类型 | 数量 | 说明 |
|---------|------|------|
| 角色 | 3个 | 超级管理员、项目管理员、测试工程师 |
| 账号 | 1个 | admin (管理员账号) |
| 权限 | 50个 | 项目、API、UI、压测、任务、系统管理等权限 |
| 角色权限关联 | 50个 | 超级管理员拥有所有权限 |
| 账号角色关联 | 1个 | admin 关联到超级管理员角色 |

---

### 🔐 登录信息

**注意**：由于 `account` 表结构简化，密码需要通过其他表（如 `social_account`）管理。

如果需要添加密码登录，需要在 `social_account` 表中插入数据：
```sql
INSERT INTO `social_account` (`account_id`, `identity_type`, `identifier`, `credential`)
VALUES (1, 'username', 'admin', '$2a$10$加密后的密码');
```

---

### ✅ 下一步

继续执行数据库初始化的其他SQL文件：
- ✅ `02-glen_account-data.sql` - **已修复，可以重新执行**
- ⏭️ `12-permission-data.sql`
- ⏭️ `dcloud_api_sql/dcloud_api.sql`
- ⏭️ 其他SQL文件...

---

**修复时间**: 2026-01-17  
**修复文件**: `/home/hinkad/yun-glenautotest/Mysql/02-glen_account-data.sql`  
**状态**: ✅ 已完成修复
