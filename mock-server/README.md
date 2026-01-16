# Glen 自动化云测平台 - Mock Server

## 📋 说明

本Mock Server用于Glen自动化云测平台的演示和测试，提供完整的REST API模拟环境。

## 🚀 快速启动

### 前置条件

确保已安装Node.js（建议v14+）

### 安装依赖

```bash
cd mock-server
npm install
```

### 启动服务

#### 方式1：启动测试环境（端口3000）

```bash
npm start
```

访问：http://localhost:3000

#### 方式2：启动生产环境（端口3001）

```bash
npm run start:prod
```

访问：http://localhost:3001

#### 方式3：同时启动两个环境

**Windows PowerShell:**
```powershell
# 终端1 - 启动测试环境
npm start

# 终端2 - 启动生产环境（新开一个终端）
npm run start:prod
```

**Linux/Mac:**
```bash
# 后台启动测试环境
npm start &

# 后台启动生产环境
npm run start:prod &
```

## 📡 可用接口

### 1. 课程管理接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询课程列表 | GET | /courses | 支持分页、搜索、筛选 |
| 查询课程详情 | GET | /courses/:id | 根据ID查询单个课程 |
| 创建课程 | POST | /courses | 创建新课程 |
| 更新课程 | PUT | /courses/:id | 更新课程信息 |
| 删除课程 | DELETE | /courses/:id | 删除课程 |

**示例请求：**
```bash
# 查询所有课程
curl http://localhost:3000/courses

# 分页查询（第1页，每页10条）
curl http://localhost:3000/courses?_page=1&_limit=10

# 搜索课程（名称包含"Python"）
curl http://localhost:3000/courses?name_like=Python

# 按分类筛选
curl http://localhost:3000/courses?categoryId=1

# 查询单个课程
curl http://localhost:3000/courses/1

# 创建课程
curl -X POST http://localhost:3000/courses \
  -H "Content-Type: application/json" \
  -d '{"name":"新课程","price":299}'
```

### 2. 课程分类接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询分类列表 | GET | /categories | 查询所有分类 |
| 查询分类详情 | GET | /categories/:id | 查询单个分类 |

**示例请求：**
```bash
# 查询所有分类
curl http://localhost:3000/categories

# 查询显示的分类
curl http://localhost:3000/categories?isShow=1
```

### 3. 考试管理接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询考试列表 | GET | /exams | 查询所有考试 |
| 查询考试详情 | GET | /exams/:id | 查询单个考试 |
| 创建考试 | POST | /exams | 创建新考试 |
| 更新考试 | PUT | /exams/:id | 更新考试信息 |

**示例请求：**
```bash
# 查询所有考试
curl http://localhost:3000/exams

# 分页查询
curl http://localhost:3000/exams?_page=1&_limit=10
```

### 4. 证书管理接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询证书列表 | GET | /certificates | 查询所有证书 |
| 查询用户证书 | GET | /certificates?userCode=USER001 | 查询指定用户的证书 |
| 查询证书详情 | GET | /certificates/:id | 查询单个证书 |

**示例请求：**
```bash
# 查询所有证书
curl http://localhost:3000/certificates

# 查询指定用户的证书
curl http://localhost:3000/certificates?userCode=USER001
```

### 5. 用户管理接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询用户列表 | GET | /users | 查询所有用户 |
| 查询用户详情 | GET | /users/:id | 查询单个用户 |

### 6. 评论管理接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询评论列表 | GET | /comments | 查询所有评论 |
| 查询课程评论 | GET | /comments?courseId=1 | 查询指定课程的评论 |

### 7. 学习记录接口

| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 查询学习记录 | GET | /learningRecords | 查询所有学习记录 |
| 查询用户学习记录 | GET | /learningRecords?userCode=USER001 | 查询指定用户的学习记录 |

## 🔍 查询参数说明

json-server 支持多种查询方式：

### 分页
```bash
# 第1页，每页10条
GET /courses?_page=1&_limit=10
```

### 排序
```bash
# 按价格升序
GET /courses?_sort=price&_order=asc

# 按价格降序
GET /courses?_sort=price&_order=desc
```

### 筛选
```bash
# 精确匹配
GET /courses?categoryId=1

# 模糊搜索（包含）
GET /courses?name_like=Python

# 范围查询
GET /courses?price_gte=200&price_lte=500
```

### 关联查询
```bash
# 查询课程并包含评论
GET /courses/1?_embed=comments

# 查询评论并包含课程信息
GET /comments?_expand=course
```

## 📊 数据说明

### 课程数据（courses）
- 包含5个示例课程
- 涵盖Python、JMeter、接口测试、SCORM等主题
- 包含完整的课程信息（价格、时长、分类等）

### 分类数据（categories）
- 3个课程分类
- 支持层级结构

### 考试数据（exams）
- 3个考试
- 包含考试时长、及格分数等信息

### 证书数据（certificates）
- 3个证书记录
- 关联考试和用户信息

### 用户数据（users）
- 3个测试用户（2个学员+1个教师）

### 评论数据（comments）
- 3条课程评论

### 学习记录（learningRecords）
- 3条学习进度记录

## 🎯 在云测平台中的使用

### 环境配置

**测试环境：**
- 协议：HTTP
- 域名：localhost
- 端口：3000
- 完整地址：http://localhost:3000

**生产环境（模拟）：**
- 协议：HTTP
- 域名：localhost
- 端口：3001
- 完整地址：http://localhost:3001

### 接口配置示例

参考《Glen自动化云测平台-演示项目配置手册.md》获取详细配置。

## 🛠️ 进阶使用

### 修改数据

直接编辑 `db.json` 文件，保存后json-server会自动重新加载。

### 自定义路由

创建 `routes.json` 文件：

```json
{
  "/api/*": "/$1",
  "/courses/:id/comments": "/comments?courseId=:id"
}
```

启动时指定路由文件：

```bash
json-server --watch db.json --routes routes.json --port 3000
```

### 添加中间件

创建 `middleware.js` 文件实现自定义逻辑（如统一响应格式、token验证等）。

## 📝 注意事项

1. **数据持久化**：json-server会将所有POST/PUT/DELETE操作保存到db.json文件
2. **数据重置**：如需重置数据，重新启动json-server即可（或手动恢复db.json文件）
3. **CORS**：json-server默认支持CORS，可跨域访问
4. **性能**：适合开发和演示，不适合生产环境高并发场景

## 🔗 相关资源

- [json-server官方文档](https://github.com/typicode/json-server)
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - 在线测试API

---

**维护者**: Glen Lee  
**更新日期**: 2026-01-13
