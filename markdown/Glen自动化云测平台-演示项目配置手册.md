# Glen 自动化云测平台 - 演示项目配置手册

> **文档版本**: v2.0  
> **更新日期**: 2026-01-13  
> **适用场景**: 面试演示、功能展示、学习实践

---

## 📋 文档说明

本文档基于 **JSONPlaceholder + 本地Mock Server** 方案，提供完整的Glen自动化云测平台演示配置。

### ✅ 方案优势

- ✅ **快速启动**：5分钟内完成环境搭建
- ✅ **完全可控**：所有数据在本地，可随意修改
- ✅ **完整功能**：覆盖接口自动化的所有核心特性
- ✅ **真实场景**：模拟在线教育平台的真实业务流程
- ✅ **无需联网**：本地运行，不依赖外部服务

---

## 🎯 演示场景设计

### 业务背景

模拟一个**在线教育平台**的测试场景，包含以下业务模块：

1. **课程管理模块**：课程的增删改查、分类管理
2. **考试管理模块**：考试的创建、查询、更新
3. **证书管理模块**：证书的颁发、查询、验证
4. **用户管理模块**：用户信息查询
5. **评论系统**：课程评论的查询和管理
6. **学习记录**：学习进度跟踪

### 测试覆盖

- ✅ **完整业务流程**：从课程查询 → 课程学习 → 考试 → 证书获取
- ✅ **多种请求方式**：GET、POST、PUT、DELETE
- ✅ **变量传递**：跨步骤的数据关联
- ✅ **断言验证**：状态码、响应体、数据格式
- ✅ **复杂场景**：分页、搜索、筛选、排序

---

## 🚀 第一步：启动Mock Server

### 1.1 安装依赖

```bash
cd E:\resume\yunautotest\mock-server
npm install
```

### 1.2 启动服务

#### 方式1：启动测试环境（推荐用于演示）

```bash
npm start
```

服务地址：`http://localhost:3000`

#### 方式2：同时启动测试和生产环境

**终端1 - 测试环境：**
```bash
cd E:\resume\yunautotest\mock-server
npm start
```

**终端2 - 生产环境（新开终端）：**
```bash
cd E:\resume\yunautotest\mock-server
npm run start:prod
```

服务地址：`http://localhost:3001`

### 1.3 验证服务

浏览器访问：`http://localhost:3000/courses`

应该看到课程列表的JSON数据。

---

## 🔧 第二步：平台基础配置

### 2.1 创建项目

登录Glen自动化云测平台，进入"项目管理"：

**项目名称**：在线教育平台测试项目  
**项目标识**：edu_platform_test  
**项目描述**：模拟在线教育平台的完整测试场景，包含课程、考试、证书等核心业务模块  
**负责人**：[你的姓名]  
**项目类型**：Web应用

### 2.2 配置测试环境

进入项目 → "环境管理" → "新增环境"：

**环境名称**：测试环境  
**环境标识**：test  
**协议**：HTTP  
**域名**：localhost  
**端口**：3000  
**环境描述**：本地Mock Server测试环境

**全局请求头（可选）**：
```
Content-Type: application/json; charset=utf-8
```

**全局变量**：
```json
{
  "base_url": "http://localhost:3000",
  "timeout": 5000
}
```

### 2.3 配置生产环境（可选）

**环境名称**：生产环境（模拟）  
**环境标识**：prod  
**协议**：HTTP  
**域名**：localhost  
**端口**：3001  
**环境描述**：模拟生产环境

---

## 📡 第三步：接口管理配置

### 3.1 创建接口模块

进入"接口自动化" → "接口管理"，创建以下模块：

| 模块名称 | 模块标识 | 说明 |
|---------|---------|------|
| 课程管理 | course_module | 课程的增删改查 |
| 考试管理 | exam_module | 考试相关接口 |
| 证书管理 | certificate_module | 证书相关接口 |
| 用户管理 | user_module | 用户信息查询 |

---

### 3.2 课程管理模块 - 接口配置

#### 3.2.1 查询课程分类列表

**接口名称**：查询课程分类列表  
**接口路径**：`/categories`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：查询所有课程分类，用于课程筛选

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "isShow": "1"
}
```

**期望响应示例**：
```json
[
  {
    "id": 1,
    "name": "测试技术",
    "level": 1,
    "parentId": 0,
    "sort": 1,
    "isShow": 1,
    "description": "软件测试技术相关课程"
  }
]
```

---

#### 3.2.2 分页查询课程列表

**接口名称**：分页查询课程列表  
**接口路径**：`/courses`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：分页查询课程列表，支持按分类筛选

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "categoryId": "1"
}
```

**参数说明**：
- `_page`：当前页码（从1开始）
- `_limit`：每页数量
- `categoryId`：课程分类ID（可选）

**期望响应示例**：
```json
[
  {
    "id": 1,
    "name": "Python自动化测试实战",
    "description": "从零基础到精通Python自动化测试，包含Selenium、Pytest、接口测试等",
    "price": 299.00,
    "categoryId": 1,
    "categoryName": "测试技术",
    "teacherName": "张老师",
    "learnCount": 1520,
    "status": 1
  }
]
```

---

#### 3.2.3 查询课程详情

**接口名称**：查询课程详情  
**接口路径**：`/courses/{id}`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：根据课程ID查询课程详细信息

**路径参数**：
- `id`：课程ID（例如：1）

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**期望响应示例**：
```json
{
  "id": 1,
  "name": "Python自动化测试实战",
  "description": "从零基础到精通Python自动化测试，包含Selenium、Pytest、接口测试等",
  "cover": "https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Python+Testing",
  "courseDuration": 3600,
  "price": 299.00,
  "categoryId": 1,
  "categoryName": "测试技术",
  "teacherName": "张老师",
  "learnCount": 1520,
  "status": 1,
  "courseType": 1,
  "courseSource": 1,
  "createTime": "2024-01-15 10:00:00"
}
```

---

#### 3.2.4 搜索课程（按名称模糊查询）

**接口名称**：搜索课程  
**接口路径**：`/courses`  
**请求方式**：GET  
**接口等级**：P1  
**接口描述**：根据课程名称进行模糊搜索

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "name_like": "Python",
  "_page": "1",
  "_limit": "10"
}
```

**参数说明**：
- `name_like`：课程名称关键词（模糊匹配）

---

#### 3.2.5 创建课程

**接口名称**：创建课程  
**接口路径**：`/courses`  
**请求方式**：POST  
**接口等级**：P1  
**接口描述**：创建新课程

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**请求体**：
```json
{
  "name": "Selenium WebDriver高级实战",
  "description": "深入学习Selenium WebDriver高级特性",
  "price": 399.00,
  "categoryId": 1,
  "categoryName": "测试技术",
  "teacherName": "测试讲师",
  "courseDuration": 4500,
  "learnCount": 0,
  "status": 1,
  "isShow": 1,
  "courseType": 1,
  "courseSource": 1,
  "canDrag": 1,
  "canSpeed": 1
}
```

**期望响应**：返回创建的课程对象，包含自动生成的ID。

---

#### 3.2.6 更新课程信息

**接口名称**：更新课程信息  
**接口路径**：`/courses/{id}`  
**请求方式**：PUT  
**接口等级**：P1  
**接口描述**：更新指定课程的信息

**路径参数**：
- `id`：课程ID

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**请求体**：
```json
{
  "price": 199.00,
  "description": "更新后的课程描述"
}
```

---

#### 3.2.7 删除课程

**接口名称**：删除课程  
**接口路径**：`/courses/{id}`  
**请求方式**：DELETE  
**接口等级**：P2  
**接口描述**：删除指定课程

**路径参数**：
- `id`：课程ID

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

---

#### 3.2.8 查询课程评论

**接口名称**：查询课程评论  
**接口路径**：`/comments`  
**请求方式**：GET  
**接口等级**：P1  
**接口描述**：查询指定课程的评论列表

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "courseId": "1",
  "_sort": "createTime",
  "_order": "desc"
}
```

**参数说明**：
- `courseId`：课程ID
- `_sort`：排序字段
- `_order`：排序方式（asc升序/desc降序）

---

### 3.3 考试管理模块 - 接口配置

#### 3.3.1 查询考试列表

**接口名称**：查询考试列表  
**接口路径**：`/exams`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：分页查询考试列表

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "status": "1"
}
```

**期望响应示例**：
```json
[
  {
    "id": 1,
    "examName": "Python自动化测试基础考试",
    "description": "测试Python自动化测试基础知识掌握情况",
    "passScore": 60,
    "totalScore": 100,
    "duration": 3600,
    "questionCount": 20,
    "status": 1,
    "startTime": "2024-12-01 09:00:00",
    "endTime": "2024-12-31 23:59:59"
  }
]
```

---

#### 3.3.2 查询考试详情

**接口名称**：查询考试详情  
**接口路径**：`/exams/{id}`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：根据考试ID查询详细信息

**路径参数**：
- `id`：考试ID

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

---

#### 3.3.3 创建考试

**接口名称**：创建考试  
**接口路径**：`/exams`  
**请求方式**：POST  
**接口等级**：P1  
**接口描述**：创建新考试

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**请求体**：
```json
{
  "examName": "接口自动化测试认证考试",
  "description": "接口自动化测试能力认证",
  "passScore": 70,
  "totalScore": 100,
  "duration": 5400,
  "questionCount": 30,
  "status": 1,
  "startTime": "2024-12-01 09:00:00",
  "endTime": "2024-12-31 23:59:59"
}
```

---

### 3.4 证书管理模块 - 接口配置

#### 3.4.1 查询证书列表

**接口名称**：查询证书列表  
**接口路径**：`/certificates`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：分页查询证书列表

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "status": "1"
}
```

---

#### 3.4.2 查询用户证书

**接口名称**：查询用户证书  
**接口路径**：`/certificates`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：查询指定用户的所有证书

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "userCode": "USER001"
}
```

**期望响应示例**：
```json
[
  {
    "id": 1,
    "certificateId": "CERT-2024-001",
    "certificateName": "Python自动化测试工程师认证",
    "certificateNo": "CERT202412001",
    "userCode": "USER001",
    "userName": "测试用户1",
    "examId": 1,
    "examName": "Python自动化测试基础考试",
    "score": 85,
    "status": 1,
    "issueDate": "2024-12-10",
    "validDate": "2026-12-10"
  }
]
```

---

#### 3.4.3 查询证书详情

**接口名称**：查询证书详情  
**接口路径**：`/certificates/{id}`  
**请求方式**：GET  
**接口等级**：P0  
**接口描述**：根据证书ID查询详细信息

**路径参数**：
- `id`：证书ID

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

---

### 3.5 用户管理模块 - 接口配置

#### 3.5.1 查询用户列表

**接口名称**：查询用户列表  
**接口路径**：`/users`  
**请求方式**：GET  
**接口等级**：P1  
**接口描述**：分页查询用户列表

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "role": "student"
}
```

---

#### 3.5.2 查询用户详情

**接口名称**：查询用户详情  
**接口路径**：`/users/{id}`  
**请求方式**：GET  
**接口等级**：P1  
**接口描述**：根据用户ID查询详细信息

**路径参数**：
- `id`：用户ID

---

#### 3.5.3 查询学习记录

**接口名称**：查询学习记录  
**接口路径**：`/learningRecords`  
**请求方式**：GET  
**接口等级**：P1  
**接口描述**：查询指定用户的学习记录

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "userCode": "USER001"
}
```

**期望响应示例**：
```json
[
  {
    "id": 1,
    "userCode": "USER001",
    "courseId": 1,
    "courseName": "Python自动化测试实战",
    "progress": 75,
    "lastLearnTime": "2024-12-22 16:30:00",
    "totalLearnTime": 2700,
    "isComplete": 0
  }
]
```

---

## 🧪 第四步：用例管理配置

### 4.1 创建用例模块

进入"接口自动化" → "用例管理"，创建以下用例模块：

| 用例模块名称 | 模块标识 | 说明 |
|------------|---------|------|
| 课程业务流程测试 | course_flow_test | 课程查询、创建、更新完整流程 |
| 考试证书流程测试 | exam_certificate_flow | 考试查询 → 证书查询完整流程 |
| 用户学习流程测试 | user_learning_flow | 用户 → 学习记录 → 课程详情完整流程 |

---

### 4.2 用例1：课程完整业务流程测试

**用例名称**：课程完整业务流程测试  
**用例模块**：课程业务流程测试  
**用例等级**：P0  
**用例描述**：测试从课程分类查询 → 课程列表查询 → 课程详情查询 → 创建课程 → 更新课程的完整业务流程

---

#### 步骤1：查询课程分类列表

**步骤名称**：查询课程分类列表  
**步骤描述**：查询所有可用的课程分类，提取分类ID用于后续查询  
**请求方式**：GET  
**接口地址**：`/categories`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "isShow": "1"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].id
  关联变量名: category_id
  变量描述: 提取第一个分类的ID
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].name
  期望值: 测试技术
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].isShow
  期望值: 1
```

---

#### 步骤2：分页查询课程列表

**步骤名称**：分页查询课程列表  
**步骤描述**：使用上一步提取的分类ID查询课程列表，提取课程ID  
**请求方式**：GET  
**接口地址**：`/courses`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "categoryId": "{{category_id}}"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].id
  关联变量名: course_id
  变量描述: 提取第一个课程的ID

- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].name
  关联变量名: course_name
  变量描述: 提取课程名称
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].categoryId
  期望值: {{category_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $.length
  期望值: 1
```

---

#### 步骤3：查询课程详情

**步骤名称**：查询课程详情  
**步骤描述**：使用提取的课程ID查询课程详细信息  
**请求方式**：GET  
**接口地址**：`/courses/{{course_id}}`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: {{course_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.name
  期望值: {{course_name}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.categoryId
  期望值: {{category_id}}
```

---

#### 步骤4：创建新课程

**步骤名称**：创建新课程  
**步骤描述**：创建一个新的测试课程  
**请求方式**：POST  
**接口地址**：`/courses`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**请求体**：
```json
{
  "name": "自动化测试新课程-{{$timestamp}}",
  "description": "这是一个自动创建的测试课程",
  "price": 299.00,
  "categoryId": {{category_id}},
  "categoryName": "测试技术",
  "teacherName": "自动化测试",
  "courseDuration": 3600,
  "learnCount": 0,
  "status": 1,
  "isShow": 1,
  "courseType": 1,
  "courseSource": 1,
  "canDrag": 1,
  "canSpeed": 1
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $.id
  关联变量名: new_course_id
  变量描述: 提取新创建的课程ID
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 201
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: NOT_EQUAL
  关联表达式: $.id
  期望值: null
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: CONTAIN
  关联表达式: $.name
  期望值: 自动化测试新课程
```

---

#### 步骤5：更新课程信息

**步骤名称**：更新课程信息  
**步骤描述**：更新刚创建的课程的价格和描述  
**请求方式**：PUT  
**接口地址**：`/courses/{{new_course_id}}`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**请求体**：
```json
{
  "price": 199.00,
  "description": "价格已更新：原价299，现价199"
}
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: {{new_course_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.price
  期望值: 199
```

---

#### 步骤6：查询课程评论

**步骤名称**：查询课程评论  
**步骤描述**：查询原始课程的评论列表  
**请求方式**：GET  
**接口地址**：`/comments`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "courseId": "{{course_id}}",
  "_sort": "createTime",
  "_order": "desc"
}
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].courseId
  期望值: {{course_id}}
```

---

### 4.3 用例2：考试证书完整流程测试

**用例名称**：考试证书完整流程测试  
**用例模块**：考试证书流程测试  
**用例等级**：P0  
**用例描述**：测试从考试列表查询 → 考试详情查询 → 用户证书查询的完整业务流程

---

#### 步骤1：查询考试列表

**步骤名称**：查询考试列表  
**步骤描述**：分页查询所有进行中的考试  
**请求方式**：GET  
**接口地址**：`/exams`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_page": "1",
  "_limit": "10",
  "status": "1"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].id
  关联变量名: exam_id
  变量描述: 提取第一个考试的ID

- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].examName
  关联变量名: exam_name
  变量描述: 提取考试名称
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].status
  期望值: 1
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $.length
  期望值: 1
```

---

#### 步骤2：查询考试详情

**步骤名称**：查询考试详情  
**步骤描述**：使用提取的考试ID查询考试详细信息  
**请求方式**：GET  
**接口地址**：`/exams/{{exam_id}}`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: {{exam_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.examName
  期望值: {{exam_name}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $.passScore
  期望值: 0
```

---

#### 步骤3：查询用户证书列表

**步骤名称**：查询用户证书列表  
**步骤描述**：查询指定用户已获得的所有证书  
**请求方式**：GET  
**接口地址**：`/certificates`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "userCode": "USER001"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].id
  关联变量名: certificate_id
  变量描述: 提取第一个证书的ID

- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].certificateNo
  关联变量名: certificate_no
  变量描述: 提取证书编号
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].userCode
  期望值: USER001
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].status
  期望值: 1
```

---

#### 步骤4：查询证书详情

**步骤名称**：查询证书详情  
**步骤描述**：使用提取的证书ID查询证书详细信息  
**请求方式**：GET  
**接口地址**：`/certificates/{{certificate_id}}`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: {{certificate_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.certificateNo
  期望值: {{certificate_no}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.userCode
  期望值: USER001
```

---

### 4.4 用例3：用户学习完整流程测试

**用例名称**：用户学习完整流程测试  
**用例模块**：用户学习流程测试  
**用例等级**：P0  
**用例描述**：测试从用户查询 → 学习记录查询 → 课程详情查询的完整业务流程

---

#### 步骤1：查询用户信息

**步骤名称**：查询用户信息  
**步骤描述**：查询指定用户的详细信息  
**请求方式**：GET  
**接口地址**：`/users/1`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $.userCode
  关联变量名: user_code
  变量描述: 提取用户编码
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: 1
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.role
  期望值: student
```

---

#### 步骤2：查询用户学习记录

**步骤名称**：查询用户学习记录  
**步骤描述**：使用用户编码查询学习记录  
**请求方式**：GET  
**接口地址**：`/learningRecords`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "userCode": "{{user_code}}"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].courseId
  关联变量名: learning_course_id
  变量描述: 提取正在学习的课程ID

- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].progress
  关联变量名: learning_progress
  变量描述: 提取学习进度
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $[0].userCode
  期望值: {{user_code}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $.length
  期望值: 1
```

---

#### 步骤3：查询学习课程详情

**步骤名称**：查询学习课程详情  
**步骤描述**：根据学习记录中的课程ID查询课程详细信息  
**请求方式**：GET  
**接口地址**：`/courses/{{learning_course_id}}`  
**接口等级**：P0  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: EQUAL
  关联表达式: $.id
  期望值: {{learning_course_id}}
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: NOT_EQUAL
  关联表达式: $.name
  期望值: null
```

---

### 4.5 用例4：课程搜索与筛选测试

**用例名称**：课程搜索与筛选测试  
**用例模块**：课程业务流程测试  
**用例等级**：P1  
**用例描述**：测试课程的搜索、筛选、排序功能

---

#### 步骤1：按名称搜索课程

**步骤名称**：按名称搜索课程  
**步骤描述**：使用关键词模糊搜索课程  
**请求方式**：GET  
**接口地址**：`/courses`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "name_like": "Python",
  "_page": "1",
  "_limit": "10"
}
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: CONTAIN
  关联表达式: $[0].name
  期望值: Python
```

---

#### 步骤2：按价格范围筛选

**步骤名称**：按价格范围筛选  
**步骤描述**：查询价格在200-400之间的课程  
**请求方式**：GET  
**接口地址**：`/courses`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "price_gte": "200",
  "price_lte": "400",
  "_page": "1",
  "_limit": "10"
}
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $[0].price
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: LESS_THEN
  关联表达式: $[0].price
  期望值: 400
```

---

#### 步骤3：按价格排序（降序）

**步骤名称**：按价格排序（降序）  
**步骤描述**：查询课程并按价格从高到低排序  
**请求方式**：GET  
**接口地址**：`/courses`  
**接口等级**：P1  
**环境选择**：测试环境

**请求头**：
```
名称: Content-Type
内容: application/json; charset=utf-8
```

**查询参数**：
```json
{
  "_sort": "price",
  "_order": "desc",
  "_page": "1",
  "_limit": "5"
}
```

**关联变量**：
```yaml
- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[0].price
  关联变量名: highest_price
  变量描述: 提取最高价格

- 关联来源: RESPONSE_DATA
  关联类型: JSONPATH
  关联表达式: $[1].price
  关联变量名: second_price
  变量描述: 提取第二高价格
```

**断言**：
```yaml
- 断言来源: RESPONSE_CODE
  断言类型: REGEXP
  断言动作: EQUAL
  关联表达式: 
  期望值: 200
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $[0].price
  期望值: 0
  说明: 验证第一个价格存在且大于0
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $[1].price
  期望值: 0
  说明: 验证第二个价格存在且大于0
  
- 断言来源: RESPONSE_DATA
  断言类型: JSONPATH
  断言动作: GREAT_THEN
  关联表达式: $[0].price
  期望值: {{second_price}}
  说明: 验证价格按降序排列（第一个价格大于等于第二个价格）
```

---

## 📊 第五步：执行测试

### 5.1 单个用例执行

1. 进入"接口自动化" → "用例管理"
2. 选择要执行的用例
3. 选择测试环境
4. 点击"执行"按钮
5. 查看实时执行日志
6. 查看执行结果报告

### 5.2 批量执行

1. 选择用例模块
2. 勾选多个用例
3. 点击"批量执行"
4. 查看批量执行报告

### 5.3 定时任务

1. 进入"任务管理"
2. 创建定时任务
3. 选择用例集合
4. 配置执行时间（Cron表达式）
5. 设置通知方式

---

## 🎨 第六步：演示要点

### 6.1 核心功能展示

✅ **项目管理**：多项目隔离、环境配置  
✅ **接口管理**：RESTful接口定义、分模块管理  
✅ **用例管理**：多步骤流程编排、变量传递  
✅ **断言验证**：状态码、JSONPath、自定义断言  
✅ **测试报告**：详细的执行日志、统计图表

### 6.2 技术亮点

✅ **变量关联**：支持跨步骤的数据传递  
✅ **JSONPath提取**：灵活的数据提取能力  
✅ **参数化**：支持时间戳、随机数等内置变量  
✅ **完整流程**：覆盖CRUD的完整业务场景  
✅ **环境隔离**：测试环境和生产环境独立配置

### 6.3 面试话术参考

> "这是我开发的Glen自动化云测平台，我用一个在线教育平台的场景来演示。这里我启动了本地Mock Server模拟测试环境。"

> "您看，这个用例覆盖了完整的业务流程：首先查询课程分类，通过JSONPath提取分类ID；然后使用这个ID查询课程列表，再提取课程ID；最后查询课程详情。所有步骤通过变量关联自动传递数据。"

> "平台支持多种断言方式：状态码断言、JSONPath断言、以及自定义断言。这里我验证了返回的分类ID与请求参数一致，还验证了响应数据的结构。"

> "这个用例还展示了POST和PUT请求：创建新课程，然后更新课程信息。创建时我用了时间戳变量保证数据唯一性，更新后通过断言验证价格修改成功。"

> "测试报告非常详细，包含每个步骤的请求参数、响应数据、断言结果，以及整体的执行统计。"

---

## 🔧 第七步：故障排查

### 7.1 Mock Server无法启动

**问题**：执行`npm start`报错

**解决方案**：
1. 检查Node.js版本：`node -v`（需要v14+）
2. 重新安装依赖：`npm install`
3. 检查端口占用：`netstat -ano | findstr 3000`
4. 修改端口：编辑`package.json`中的端口号

### 7.2 接口请求失败

**问题**：用例执行时接口返回404

**解决方案**：
1. 确认Mock Server已启动
2. 检查接口路径是否正确（区分大小写）
3. 检查环境配置中的域名和端口
4. 浏览器访问接口测试：`http://localhost:3000/courses`

### 7.3 变量提取失败

**问题**：后续步骤无法使用提取的变量

**解决方案**：
1. 检查JSONPath表达式是否正确
2. 在浏览器访问接口，查看响应结构
3. 使用在线JSONPath工具测试表达式
4. 查看执行日志中的变量提取结果

### 7.4 断言失败

**问题**：断言一直失败

**解决方案**：
1. 检查期望值类型（字符串 vs 数字）
2. 查看实际响应数据
3. 调整断言表达式
4. 使用`contains`操作符代替精确匹配

---

## 📚 附录

### A. JSONPath语法快速参考

| 表达式 | 说明 | 示例 |
|-------|------|------|
| `$` | 根对象 | `$` |
| `$.field` | 访问字段 | `$.id` |
| `$[0]` | 访问数组第一个元素 | `$[0].name` |
| `$[-1]` | 访问数组最后一个元素 | `$[-1].id` |
| `$..*` | 递归下降 | `$..name` |
| `$[?(@.price > 200)]` | 条件过滤 | `$[?(@.status == 1)]` |

### B. json-server查询参数速查表

| 参数 | 说明 | 示例 |
|-----|------|------|
| `_page` | 页码 | `_page=1` |
| `_limit` | 每页数量 | `_limit=10` |
| `_sort` | 排序字段 | `_sort=price` |
| `_order` | 排序方式 | `_order=desc` |
| `field_like` | 模糊搜索 | `name_like=Python` |
| `field_gte` | 大于等于 | `price_gte=200` |
| `field_lte` | 小于等于 | `price_lte=500` |

### C. 内置变量参考

| 变量 | 说明 | 示例 |
|-----|------|------|
| `{{$timestamp}}` | 当前时间戳（毫秒） | `1705132800000` |
| `{{$datetime}}` | 当前日期时间 | `2024-01-13 10:00:00` |
| `{{$random}}` | 随机数 | `123456` |
| `{{$uuid}}` | UUID | `550e8400-e29b-41d4-a716-446655440000` |

---

## 📝 总结

本配置手册提供了完整的Glen自动化云测平台演示方案：

✅ **环境搭建**：本地Mock Server，5分钟启动  
✅ **接口配置**：涵盖课程、考试、证书等8大类接口  
✅ **用例设计**：4个完整业务流程用例，展示变量传递和断言  
✅ **数据准备**：真实业务数据，支持增删改查  
✅ **故障排查**：常见问题的解决方案

使用本方案，您可以快速搭建一个功能完整的演示环境，充分展示Glen自动化云测平台的核心能力。

---

**维护者**: Glen Lee  
**联系方式**: [您的联系方式]  
**最后更新**: 2026-01-13
