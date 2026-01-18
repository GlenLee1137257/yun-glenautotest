# Glen 自动化云测平台 - 完整配置使用手册

> **文档版本**: v2.0  
> **更新日期**: 2026年1月13日  
> **适用项目**: 贝好学、贝壳公益、红手指  
> **目的**: 使用自动化云测平台完整介入测试工作

---

## 📋 目录

- [一、平台概述](#一平台概述)
- [二、项目管理配置](#二项目管理配置)
- [三、环境管理配置](#三环境管理配置)
- [四、接口自动化配置](#四接口自动化配置)
- [五、UI自动化配置](#五ui自动化配置)
- [六、压测引擎配置](#六压测引擎配置)
- [七、测试报告查看](#七测试报告查看)
- [八、完整使用流程](#八完整使用流程)

---

## 一、平台概述

### 1.1 平台功能

Glen 自动化云测平台支持以下测试类型:
- ✅ **接口自动化测试**: 支持多步骤接口编排、参数关联、多种断言
- ✅ **UI自动化测试**: 支持Selenium Web自动化测试
- ✅ **压力测试**: 支持JMeter压测(上传JMX或在线配置)
- ✅ **多项目管理**: 支持多个项目并行测试，数据完全隔离
- ✅ **多环境配置**: 支持测试/生产等多环境切换

### 1.2 介入的测试项目

| 项目名称 | 项目类型 | 测试重点 |
|---------|---------|---------|
| 贝好学 | 在线培训平台 | 课程、考试、证书功能 |
| 贝壳公益 | 社区公益平台 | 成长体系、PK功能、数据准确性 |
| 红手指 | (示例项目) | 接口测试、压测 |

---

## 二、项目管理配置

### 2.1 操作路径
**公共菜单 → 项目管理 → + 新增**

### 2.2 配置步骤

#### 项目1: 贝好学
```yaml
名称: 贝好学培训平台
描述: 在线教育培训平台，包含课程学习、考试系统、证书管理等核心功能。测试范围覆盖V2.3.13.1课程分类优化、V2.9.6 SCORM课程接入、V2.9.21独立考试、V2.9.23独立证书管理等重点版本。
负责人: 测试团队
```

**项目背景**:
- **项目规模**: 多端应用(PC端、H5端、管理后台)
- **技术架构**: Spring Boot + React/Vue
- **核心功能**: 
  - 课程管理(普通课程、SCORM课程)
  - 考试系统(独立考试、在线答题、自动评分)
  - 证书管理(证书生成、发放、查询)
- **测试重点**: 业务流程测试、数据准确性验证

#### 项目2: 贝壳公益
```yaml
名称: 贝壳公益平台
描述: 社区公益平台，包含公益活动管理、成长体系(公益分/公益币)、徽章系统、PK功能等。测试范围覆盖V6.21.1打通C端公益分/公益币体系、善贝GO v6.22 PK功能等重点版本。
负责人: 测试团队
```

**项目背景**:
- **项目规模**: 多端应用(PC管理端、H5移动端、善贝GO小程序)
- **技术架构**: Spring Boot + React/Vue
- **核心功能**:
  - 公益活动管理
  - 成长体系(公益分/公益币计算和发放)
  - PK功能(用户间公益数据比拼)
  - 徽章系统
- **测试重点**: 数据准确性(100%)、并发测试、多端数据同步

#### 项目3: 红手指
```yaml
名称: 红手指
描述: (示例项目)接口自动化测试和性能测试平台
负责人: 测试团队
```

---

## 三、环境管理配置

### 3.1 操作路径
**公共菜单 → 环境管理 → + 新增**

### 3.2 配置步骤

#### 贝好学 - 测试环境(前端用户侧)
```yaml
选择项目: 贝好学培训平台
名称: 贝好学测试环境(PC端用户侧)
协议: HTTP
域名: test-study.ke.com
端口: 80
描述: 贝好学测试环境 - PC端用户侧接口，用于课程学习、考试、证书等用户端功能测试
```

#### 贝好学 - 测试环境(后端管理侧)
```yaml
选择项目: 贝好学培训平台
名称: 贝好学测试环境(管理后台)
协议: HTTP
域名: test-admin-study.ke.com
端口: 80
描述: 贝好学测试环境 - 管理后台接口，用于课程管理、考试管理、学员管理等管理端功能测试
```

#### 贝好学 - 生产环境(前端用户侧)
```yaml
选择项目: 贝好学培训平台
名称: 贝好学生产环境(PC端用户侧)
协议: HTTPS
域名: study.ke.com
端口: 443
描述: 贝好学生产环境 - PC端用户侧接口，仅用于生产环境验证测试
```

#### 贝壳公益 - 测试环境(移动端)
```yaml
选择项目: 贝壳公益平台
名称: 贝壳公益测试环境(H5移动端)
协议: HTTP
域名: test-gongyi-mobile.ke.com
端口: 80
描述: 贝壳公益测试环境 - H5移动端接口，用于公益活动、成长体系、PK功能等移动端测试
```

#### 贝壳公益 - 测试环境(PC管理端)
```yaml
选择项目: 贝壳公益平台
名称: 贝壳公益测试环境(PC管理端)
协议: HTTP
域名: test-gongyi-admin.ke.com
端口: 80
描述: 贝壳公益测试环境 - PC管理端接口，用于活动管理、数据统计等后台管理功能测试
```

#### 贝壳公益 - 测试环境(善贝GO小程序)
```yaml
选择项目: 贝壳公益平台
名称: 贝壳公益测试环境(善贝GO小程序)
协议: HTTP
域名: test-shanbeigo.ke.com
端口: 80
描述: 贝壳公益测试环境 - 善贝GO小程序接口，用于C端用户公益分/公益币、PK功能等测试
```

#### 贝壳公益 - 生产环境(移动端)
```yaml
选择项目: 贝壳公益平台
名称: 贝壳公益生产环境(H5移动端)
协议: HTTPS
域名: gongyi-mobile.ke.com
端口: 443
描述: 贝壳公益生产环境 - H5移动端接口，仅用于生产环境验证测试
```

---

## 四、接口自动化配置

### 4.1 接口管理

#### 操作路径
**接口自动化 → 接口管理 → (选择项目) → + 新增接口**

#### 4.1.1 贝好学 - 课程模块

##### 模块配置
```yaml
模块名称: 课程模块
模块描述: 贝好学课程相关接口，包含课程列表、课程详情、课程分类、SCORM课程等
```

##### 接口1: 查询课程列表
```yaml
接口名称: PC端查询课程列表
接口描述: 查询课程分页列表，支持关键词搜索和分类筛选 (V2.3.13.1课程分类优化)
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /p/online-course/v2/course/page
方法: GET
查询参数:
{
  "current": 1,
  "size": 10,
  "keyword": "",
  "typeConfigId": ""
}
请求头:
【表格形式填写】(根据平台界面表格，无需引号):
  请求头名称: Content-Type
  请求头内容: application/json
  
  请求头名称: Cookie
  请求头内容: lianjia_token=xxx; renovation-token=xxx

【JSON格式填写】(如果平台支持JSON输入框):
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}

注意: 根据实际平台界面选择填写方式。表格形式直接填写名称和值(不带引号)，JSON格式需要完整的JSON语法(带引号)。
请求体: (空，GET请求)
Body类型: JSON
```

##### 接口2: 查询课程分类
```yaml
接口名称: 查询课程分类列表
接口描述: 查询课程分类，支持分类可见性控制 (V2.3.13.1版本优化)
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /p/online-course/v1/course/typeList
方法: GET
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

##### 接口3: 查询课程详情
```yaml
接口名称: 查询课程详情
接口描述: 根据课程ID查询课程完整信息，包含SCORM课程标识
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /p/online-course/v2/course/info
方法: GET
查询参数:
{
  "id": "课程ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

#### 4.1.2 贝好学 - 考试模块

##### 模块配置
```yaml
模块名称: 考试模块
模块描述: 贝好学考试系统接口，包含独立考试管理、答题、评分等 (V2.9.21独立考试)
```

##### 接口1: 查询独立考试列表
```yaml
接口名称: 查询独立考试分页列表
接口描述: 后台管理端查询独立考试列表 (V2.9.21独立考试)
等级: P0
环境: 贝好学测试环境(管理后台)
路径: /alone-exam/v1/getAloneExamPage
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体:
{
  "current": 1,
  "size": 10,
  "keyword": "",
  "status": ""
}
Body类型: JSON
```

##### 接口2: 查询考试详情
```yaml
接口名称: 查询独立考试详情
接口描述: 根据考试ID查询考试完整信息
等级: P0
环境: 贝好学测试环境(管理后台)
路径: /alone-exam/v1/getAlongExam
方法: GET
查询参数:
{
  "id": "考试ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

##### 接口3: 查询考试配置
```yaml
接口名称: 查询独立考试配置
接口描述: 查询考试的题目配置和评分规则
等级: P0
环境: 贝好学测试环境(管理后台)
路径: /alone-exam/v1/getAloneExamConf
方法: GET
查询参数:
{
  "id": "考试ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

##### 接口4: 移动端查询我的考试
```yaml
接口名称: 移动端获取我的所有考试
接口描述: 用户端查询当前用户的所有考试信息
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /my-mobile/v1/allMyAloneExamInfo
方法: GET
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

#### 4.1.3 贝好学 - 证书模块

##### 模块配置
```yaml
模块名称: 证书模块
模块描述: 贝好学证书管理接口，包含证书查询、下载、配置等 (V2.9.23独立证书管理)
```

##### 接口1: 查询证书列表
```yaml
接口名称: 查询个人证书列表
接口描述: 用户端查询个人所有证书 (V2.9.23独立证书管理)
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /free-certificate/v1/certificate/list
方法: GET
查询参数:
{
  "userCode": "用户编码",
  "trainId": ""
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

##### 接口2: 获取证书图片
```yaml
接口名称: 获取证书图片/PDF
接口描述: 根据证书ID获取证书图片或PDF文件
等级: P0
环境: 贝好学测试环境(PC端用户侧)
路径: /free-certificate/v1/certificate/picture
方法: GET
查询参数:
{
  "certificateId": "证书ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

##### 接口3: 配置考试证书
```yaml
接口名称: 添加考试证书配置
接口描述: 后台管理端为考试配置证书信息
等级: P1
环境: 贝好学测试环境(管理后台)
路径: /alone-exam/v1/addAloneExamCertificateConf
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体:
{
  "examId": "考试ID",
  "certificateTemplate": "证书模板URL",
  "certificateBackground": "证书背景URL",
  "certificateName": "证书名称",
  "passScore": 60
}
Body类型: JSON
```

#### 4.1.4 贝壳公益 - 成长体系模块

##### 模块配置
```yaml
模块名称: 成长体系模块
模块描述: 贝壳公益成长体系接口，包含公益分/公益币计算、发放、查询等 (V6.21.1版本)
```

##### 接口1: 查询用户成长信息
```yaml
接口名称: 查询用户成长信息
接口描述: 查询用户的公益分、公益币、成长等级等信息
等级: P0
环境: 贝壳公益测试环境(H5移动端)
路径: /growth-system/v1/getUserGrowthInfo
方法: GET
查询参数:
{
  "userCode": "用户编码"
}
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体: (空)
Body类型: JSON
```

##### 接口2: 获取公益币流水
```yaml
接口名称: 查询公益币流水明细
接口描述: 查询用户公益币获取和消费明细
等级: P0
环境: 贝壳公益测试环境(H5移动端)
路径: /growth-system/v1/getPointsFlow
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体:
{
  "userCode": "用户编码",
  "current": 1,
  "size": 20
}
Body类型: JSON
```

##### 接口3: 获取成长规则配置
```yaml
接口名称: 查询成长规则配置
接口描述: 查询公益分/公益币获取规则配置
等级: P1
环境: 贝壳公益测试环境(PC管理端)
路径: /growth-system/v1/getRuleConfig
方法: GET
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体: (空)
Body类型: JSON
```

#### 4.1.5 贝壳公益 - PK功能模块

##### 模块配置
```yaml
模块名称: PK功能模块
模块描述: 贝壳公益PK功能接口，包含PK发起、结果计算、排名查询等 (善贝GO v6.22)
```

##### 接口1: 发起PK
```yaml
接口名称: 发起PK挑战
接口描述: 用户发起PK挑战，选择PK对手
等级: P0
环境: 贝壳公益测试环境(善贝GO小程序)
路径: /pk/v1/startPK
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体:
{
  "userCode": "发起人用户编码",
  "targetUserCode": "对手用户编码",
  "pkType": 1,
  "duration": 7
}
Body类型: JSON
```

##### 接口2: 查询PK结果
```yaml
接口名称: 查询PK结果
接口描述: 查询PK的实时结果和排名
等级: P0
环境: 贝壳公益测试环境(善贝GO小程序)
路径: /pk/v1/getPKResult
方法: GET
查询参数:
{
  "pkId": "PK记录ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体: (空)
Body类型: JSON
```

##### 接口3: 查询我的PK记录
```yaml
接口名称: 查询我的PK记录
接口描述: 查询用户的所有PK记录(进行中、已结束)
等级: P0
环境: 贝壳公益测试环境(善贝GO小程序)
路径: /pk/v1/getMyPKList
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体:
{
  "userCode": "用户编码",
  "current": 1,
  "size": 10,
  "status": ""
}
Body类型: JSON
```

#### 4.1.6 贝壳公益 - 徽章模块

##### 模块配置
```yaml
模块名称: 徽章模块
模块描述: 贝壳公益徽章系统接口，包含徽章获取、展示、配置等
```

##### 接口1: 查询用户徽章
```yaml
接口名称: 查询用户获得的徽章
接口描述: 查询用户已获得的徽章列表
等级: P1
环境: 贝壳公益测试环境(H5移动端)
路径: /badge/v1/getUserBadges
方法: GET
查询参数:
{
  "userCode": "用户编码"
}
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体: (空)
Body类型: JSON
```

##### 接口2: 查询徽章配置
```yaml
接口名称: 查询徽章配置信息
接口描述: 查询徽章的获取规则和可见人群配置 (V6.21.1版本)
等级: P1
环境: 贝壳公益测试环境(PC管理端)
路径: /badge/v1/getBadgeConfig
方法: GET
查询参数:
{
  "badgeId": "徽章ID"
}
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体: (空)
Body类型: JSON
```

### 4.2 用例管理

#### 操作路径
**接口自动化 → 用例管理 → (选择项目) → + 新增用例**

#### 4.2.0 用例管理逻辑说明

**重要概念理解**:

1. **接口管理 vs 用例管理的区别**:
   - **接口管理**: 单独管理和测试接口(可选功能)
     - 作用: 可以单独定义和测试接口，方便接口文档管理
     - 使用场景: 单接口测试、接口文档记录
     - 注意: 接口管理与用例管理是**独立的**，用例步骤不关联接口管理中的接口
   
   - **用例管理**: 直接在步骤中配置完整的接口信息，组合成测试场景
     - 作用: 将多个接口步骤组合成完整的业务流程测试
     - 配置内容: 每个步骤直接配置接口地址、请求方式、请求头、请求体等
     - 可以理解为: 实际执行的"测试脚本"

2. **用例管理的三层结构**:
   ```
   用例模块 (如: 课程业务流程测试)
     ↓
   用例 (如: 课程查询完整流程) ← 一个用例可以包含多个步骤
     ↓
   步骤 (步骤1、步骤2、步骤3...) ← 每个步骤直接配置接口信息
   ```

3. **操作流程**:
   ```
   第一步: 创建用例模块
      → 接口自动化 → 用例管理 → 左侧模块区域 → "+"按钮 → 输入模块名称
   
   第二步: 创建用例
      → 选择用例模块 → "+ 新增"按钮 → 填写用例名称、描述、等级 → 保存
   
   第三步: 添加用例步骤(可以添加多个步骤)
      → 选择用例 → 用例详情页 → "+ 新增步骤"按钮 → 配置步骤信息
      → 用例阶段名称: 步骤名称(如: 步骤1-查询课程分类)
      → 用例阶段描述: 步骤描述
      → 请求方式: GET/POST/PUT/DELETE等
      → 接口地址: 接口路径(如: /p/online-course/v1/course/typeList)
      → 接口等级: p0/p1/p2
      → 环境选择: 选择测试环境
      → 请求头: 配置HTTP请求头
      → 请求体: 配置请求体内容
      → 查询参数: 配置URL参数
      → 关联变量: 提取响应中的变量(用于后续步骤)
      → 断言: 配置响应验证规则
   ```

4. **步骤中的配置项详解**:
   
   **基础配置**:
   - 用例阶段名称: 步骤名称
   - 用例阶段描述: 步骤说明
   - 请求方式: GET/POST/PUT/DELETE等
   - 接口地址: 接口路径(可使用变量，如: {{course_id}})
   - 接口等级: p0/p1/p2
   - 环境选择: 选择测试环境
   
   **请求头**:
   - 表格形式配置多个请求头
   - 请求头名称: Content-Type
   - 请求头内容: application/json
   
   **请求体**:
   - 配置请求体内容(JSON/form-data等)
   - 可使用变量: {{variable_name}}
   
   **查询参数**:
   - 配置URL查询参数
   - 可使用变量: {{variable_name}}
   
   **关联变量**(重要):
   - 关联来源: request_header(请求头)、response_header(响应头)、response_body(响应体)
   - 关联类型: regexp(正则表达式)、jsonPath(JSON路径)
   - 关联表达式: 提取表达式(如: $.data[0].id)
   - 关联变量名: 变量名(如: category_id)，后续步骤可使用 {{category_id}}
   
   **断言**:
   - 配置响应验证规则
   - 验证状态码、响应内容等

5. **接口管理与用例管理的关系**:
   - **独立管理**: 接口管理和用例管理是独立的模块
   - **不存在关联**: 用例步骤不关联接口管理中的接口
   - **各自用途**:
     - 接口管理: 用于单接口测试和接口文档记录
     - 用例管理: 用于业务流程测试，步骤中直接配置接口信息
   - **可以参考**: 在配置用例步骤时，可以参考接口管理中的接口定义，但需要手动填写

6. **典型使用场景**:
   - **场景 - 多步骤业务流程测试**:
     - 用例管理: 创建1个用例，包含多个步骤
       - 步骤1: 配置登录接口 → 提取token变量
       - 步骤2: 配置查询接口 → 请求头使用{{token}} → 提取数据ID变量
       - 步骤3: 配置修改接口 → 请求头使用{{token}}，参数使用{{data_id}}

#### 4.2.1 贝好学 - 课程业务流程测试

##### 用例模块配置
```yaml
模块名称: 课程业务流程测试
模块描述: 测试课程相关完整业务流程
```

##### 用例1: 课程查询流程测试
```yaml
用例名称: 课程查询完整流程
用例描述: 测试课程分类查询→课程列表查询→课程详情查询的完整流程
等级: P0
```

**步骤配置**:

**步骤1: 查询课程分类**
```yaml
用例阶段名称: 步骤1-查询课程分类
用例阶段描述: 获取课程分类列表，提取分类ID用于后续筛选
请求方式: GET
接口地址: /p/online-course/v1/course/typeList
接口等级: p0
环境选择: 贝好学测试环境(PC端用户侧)
请求头:
  请求头名称: Content-Type
  请求头内容: application/json
  
  请求头名称: Cookie
  请求头内容: lianjia_token=xxx; renovation-token=xxx
查询参数: (无)
请求体: (空)
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data", "operator": "notNull"}
  ]
}
关联变量(提取变量):
  关联来源: response_body
  关联类型: jsonPath
  关联表达式: $.data[0].id
  关联变量名: category_id
  
  关联来源: response_body
  关联类型: jsonPath
  关联表达式: $.data[0].name
  关联变量名: category_name
```

**步骤2: 按分类查询课程列表**
```yaml
用例阶段名称: 步骤2-按分类筛选课程
用例阶段描述: 使用提取的分类ID查询课程列表
请求方式: GET
接口地址: /p/online-course/v2/course/page
接口等级: p0
环境选择: 贝好学测试环境(PC端用户侧)
请求头:
  请求头名称: Content-Type
  请求头内容: application/json
  
  请求头名称: Cookie
  请求头内容: lianjia_token=xxx; renovation-token=xxx
查询参数(使用步骤1提取的变量):
{
  "current": 1,
  "size": 10,
  "keyword": "",
  "typeConfigId": "{{category_id}}"
}
请求体: (空)
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data.records", "operator": "notNull"}
  ]
}
关联变量(提取变量):
  关联来源: response_body
  关联类型: jsonPath
  关联表达式: $.data.records[0].id
  关联变量名: course_id
  
  关联来源: response_body
  关联类型: jsonPath
  关联表达式: $.data.records[0].name
  关联变量名: course_name
```

**步骤3: 查询课程详情**
```yaml
用例阶段名称: 步骤3-查询课程详情
用例阶段描述: 使用提取的课程ID查询课程完整信息
请求方式: GET
接口地址: /p/online-course/v2/course/info
接口等级: p0
环境选择: 贝好学测试环境(PC端用户侧)
请求头:
  请求头名称: Content-Type
  请求头内容: application/json
  
  请求头名称: Cookie
  请求头内容: lianjia_token=xxx; renovation-token=xxx
查询参数(使用步骤2提取的变量):
{
  "id": "{{course_id}}"
}
请求体: (空)
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data.id", "operator": "equals", "value": "{{course_id}}"},
    {"path": "$.data.name", "operator": "notNull"},
    {"path": "$.data.courseDuration", "operator": "notNull"}
  ]
}
关联变量: (此步骤不需要提取变量)
```

#### 4.2.2 贝好学 - 考试业务流程测试

##### 用例模块配置
```yaml
模块名称: 考试业务流程测试
模块描述: 测试考试系统完整业务流程 (V2.9.21独立考试)
```

##### 用例1: 考试查询流程测试
```yaml
用例名称: 考试信息查询流程
用例描述: 测试考试列表查询→考试详情查询→考试配置查询的完整流程
等级: P0
```

**步骤配置**:

**步骤1: 查询考试列表**
```yaml
用例阶段名称: 步骤1-查询考试列表
用例阶段描述: 获取独立考试分页列表
请求方式: POST
接口地址: /alone-exam/v1/getAloneExamPage
接口等级: p0
环境选择: 贝好学测试环境(管理后台)
请求头:
  请求头名称: Content-Type
  请求头内容: application/json
  
  请求头名称: Cookie
  请求头内容: lianjia_token=xxx; renovation-token=xxx
查询参数: (无)
请求体:
{
  "current": 1,
  "size": 10,
  "keyword": "",
  "status": ""
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data.list", "operator": "notNull"}
  ]
}
关联关系(提取变量):
{
  "exam_id": "$.data.list[0].id",
  "exam_name": "$.data.list[0].examName"
}
```

**步骤2: 查询考试详情**
```yaml
步骤名称: 步骤2-查询考试详情
步骤描述: 使用提取的考试ID查询考试详细信息
关联接口: 查询独立考试详情
查询参数(使用变量):
{
  "id": "{{exam_id}}"
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data.id", "operator": "equals", "value": "{{exam_id}}"},
    {"path": "$.data.examName", "operator": "notNull"}
  ]
}
关联关系(无需提取)
```

**步骤3: 查询考试配置**
```yaml
步骤名称: 步骤3-查询考试配置
步骤描述: 查询考试的题目配置和评分规则
关联接口: 查询独立考试配置
查询参数(使用变量):
{
  "id": "{{exam_id}}"
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data", "operator": "notNull"}
  ]
}
关联关系(无需提取)
```

#### 4.2.3 贝好学 - 证书业务流程测试

##### 用例模块配置
```yaml
模块名称: 证书业务流程测试
模块描述: 测试证书管理完整业务流程 (V2.9.23独立证书管理)
```

##### 用例1: 证书查询流程测试
```yaml
用例名称: 用户证书查询流程
用例描述: 测试证书列表查询→证书图片获取的完整流程
等级: P0
```

**步骤配置**:

**步骤1: 查询证书列表**
```yaml
步骤名称: 步骤1-查询用户证书列表
步骤描述: 获取用户所有证书
关联接口: 查询个人证书列表
查询参数:
{
  "userCode": "TEST_USER_CODE",
  "trainId": ""
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data", "operator": "notNull"}
  ]
}
关联关系(提取变量):
{
  "certificate_id": "$.data[0].certificateId",
  "certificate_name": "$.data[0].certificateName"
}
```

**步骤2: 获取证书图片**
```yaml
步骤名称: 步骤2-获取证书图片/PDF
步骤描述: 使用提取的证书ID获取证书图片或PDF
关联接口: 获取证书图片/PDF
查询参数(使用变量):
{
  "certificateId": "{{certificate_id}}"
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.errno", "operator": "equals", "value": "0"},
    {"path": "$.data", "operator": "notNull"}
  ],
  "custom": [
    {"description": "应返回图片URL或PDF URL", "condition": "data.pictureUrl != null or data.pdfUrl != null"}
  ]
}
关联关系(无需提取)
```

#### 4.2.4 贝壳公益 - 成长体系测试

##### 用例模块配置
```yaml
模块名称: 成长体系测试
模块描述: 测试公益分/公益币计算和数据准确性 (V6.21.1版本)
```

##### 用例1: 用户成长信息查询
```yaml
用例名称: 查询用户成长信息
用例描述: 测试用户成长信息查询，验证数据准确性
等级: P0
```

**步骤配置**:

**步骤1: 查询用户成长信息**
```yaml
步骤名称: 步骤1-查询用户成长数据
步骤描述: 获取用户公益分、公益币等成长数据
关联接口: 查询用户成长信息
查询参数:
{
  "userCode": "TEST_USER_CODE"
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.code", "operator": "equals", "value": 0},
    {"path": "$.data.publicWelfarePoints", "operator": "notNull"},
    {"path": "$.data.publicWelfareCoins", "operator": "notNull"},
    {"path": "$.data.growthLevel", "operator": "notNull"}
  ],
  "dataValidation": [
    {"field": "publicWelfarePoints", "type": "number", "min": 0},
    {"field": "publicWelfareCoins", "type": "number", "min": 0}
  ]
}
关联关系(提取变量):
{
  "user_points": "$.data.publicWelfarePoints",
  "user_coins": "$.data.publicWelfareCoins"
}
```

**步骤2: 查询公益币流水**
```yaml
步骤名称: 步骤2-查询公益币流水明细
步骤描述: 获取用户公益币获取和消费明细，验证数据一致性
关联接口: 查询公益币流水明细
请求体:
{
  "userCode": "TEST_USER_CODE",
  "current": 1,
  "size": 20
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.code", "operator": "equals", "value": 0},
    {"path": "$.data.list", "operator": "notNull"}
  ]
}
关联关系(无需提取)
```

#### 4.2.5 贝壳公益 - PK功能测试

##### 用例模块配置
```yaml
模块名称: PK功能测试
模块描述: 测试PK功能完整流程和并发场景 (善贝GO v6.22)
```

##### 用例1: PK业务流程测试
```yaml
用例名称: PK发起和查询流程
用例描述: 测试PK发起→PK结果查询→PK记录查询的完整流程
等级: P0
```

**步骤配置**:

**步骤1: 发起PK**
```yaml
步骤名称: 步骤1-发起PK挑战
步骤描述: 用户发起PK挑战
关联接口: 发起PK挑战
请求体:
{
  "userCode": "USER_A",
  "targetUserCode": "USER_B",
  "pkType": 1,
  "duration": 7
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.code", "operator": "equals", "value": 0},
    {"path": "$.data.pkId", "operator": "notNull"}
  ]
}
关联关系(提取变量):
{
  "pk_id": "$.data.pkId"
}
```

**步骤2: 查询PK结果**
```yaml
步骤名称: 步骤2-查询PK实时结果
步骤描述: 使用提取的PK ID查询PK结果和排名
关联接口: 查询PK结果
查询参数(使用变量):
{
  "pkId": "{{pk_id}}"
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.code", "operator": "equals", "value": 0},
    {"path": "$.data.pkStatus", "operator": "notNull"},
    {"path": "$.data.myRank", "operator": "notNull"}
  ]
}
关联关系(无需提取)
```

**步骤3: 查询我的PK记录**
```yaml
步骤名称: 步骤3-查询我的所有PK记录
步骤描述: 查询用户所有PK记录，验证新创建的PK是否在列表中
关联接口: 查询我的PK记录
请求体:
{
  "userCode": "USER_A",
  "current": 1,
  "size": 10,
  "status": ""
}
断言:
{
  "responseCode": 200,
  "jsonPath": [
    {"path": "$.code", "operator": "equals", "value": 0},
    {"path": "$.data.list", "operator": "notNull"}
  ],
  "custom": [
    {"description": "列表中应包含刚创建的PK记录", "condition": "any(item.pkId == {{pk_id}} for item in data.list)"}
  ]
}
关联关系(无需提取)
```

---

## 五、UI自动化配置

### 5.1 操作路径
**UI自动化 → 用例管理 → (选择项目) → + 新增用例**

### 5.2 贝好学 - 课程学习流程UI测试

#### 用例模块配置
```yaml
模块名称: 课程学习流程UI测试
模块描述: 测试PC端课程学习完整流程
```

#### 用例1: 课程搜索和学习流程
```yaml
用例名称: 课程搜索和查看详情流程
用例描述: 测试用户搜索课程→查看课程详情→开始学习的完整流程
浏览器: Chrome
等级: P0
```

**步骤配置**:

| 步骤 | 操作类型 | 定位方式 | 定位表达式 | 值 | 描述 |
|-----|---------|---------|-----------|-----|------|
| 1 | 打开窗口 | - | - | http://test-study.ke.com | 打开贝好学首页 |
| 2 | 强制等待 | - | - | 2000 | 等待页面加载 |
| 3 | 键盘输入 | ID | search-input | 自动化测试 | 在搜索框输入关键词 |
| 4 | 强制等待 | - | - | 500 | 等待输入完成 |
| 5 | 鼠标左键点击 | ID | search-btn | - | 点击搜索按钮 |
| 6 | 强制等待 | - | - | 3000 | 等待搜索结果加载 |
| 7 | 断言 | 网页URL | - | /course | 验证跳转到课程列表页 |
| 8 | 鼠标左键点击 | CSS选择器 | .course-item:first-child | - | 点击第一个课程 |
| 9 | 强制等待 | - | - | 3000 | 等待课程详情加载 |
| 10 | 断言 | 网页URL | - | /course/detail | 验证跳转到课程详情页 |
| 11 | 断言 | 元素文本 | CSS选择器 | .course-title | 包含课程名称 | 验证课程标题存在 |
| 12 | 截图 | - | - | - | 截图保存课程详情页 |

### 5.3 贝壳公益 - PK功能UI测试

#### 用例模块配置
```yaml
模块名称: PK功能UI测试
模块描述: 测试善贝GO小程序或H5端PK功能UI流程
```

#### 用例1: PK发起流程
```yaml
用例名称: 发起PK挑战流程
用例描述: 测试用户在移动端发起PK挑战的完整流程
浏览器: Chrome
等级: P0
```

**步骤配置**:

| 步骤 | 操作类型 | 定位方式 | 定位表达式 | 值 | 描述 |
|-----|---------|---------|-----------|-----|------|
| 1 | 打开窗口 | - | - | http://test-shanbeigo.ke.com/pk | 打开PK功能页面 |
| 2 | 强制等待 | - | - | 2000 | 等待页面加载 |
| 3 | 鼠标左键点击 | ID | start-pk-btn | - | 点击发起PK按钮 |
| 4 | 强制等待 | - | - | 1000 | 等待弹窗出现 |
| 5 | 键盘输入 | ID | opponent-input | USER_B | 输入对手用户编码 |
| 6 | 鼠标左键点击 | ID | pk-duration-7days | - | 选择PK时长7天 |
| 7 | 鼠标左键点击 | ID | confirm-pk-btn | - | 确认发起PK |
| 8 | 强制等待 | - | - | 3000 | 等待PK创建完成 |
| 9 | 断言 | 元素文本 | CSS选择器 | .pk-status | 进行中 | 验证PK状态为进行中 |
| 10 | 截图 | - | - | - | 截图保存PK详情页 |

---

## 六、压测引擎配置

### 6.1 操作路径
**压测 → 用例管理 → (选择项目) → + 新增用例**

### 6.2 压测类型选择

#### 方式1: 上传JMX脚本(推荐)
适用于复杂压测场景，在本地使用JMeter GUI工具创建和调试脚本，然后上传到平台执行。

#### 方式2: 在线配置(SIMPLE)
适用于简单的单接口压测场景，在平台上直接配置即可。

### 6.3 贝好学 - 课程列表接口压测

#### 用例模块配置
```yaml
模块名称: 课程接口压测
模块描述: 对课程列表等高频接口进行压力测试
```

#### 压测用例1: 课程列表接口压测(在线配置方式)
```yaml
用例名称: 课程列表接口并发压测
用例描述: 测试课程列表接口在高并发下的性能表现
压测来源类型: SIMPLE (在线配置)
环境: 贝好学测试环境(PC端用户侧)
```

**线程组配置**:
```yaml
线程数(并发用户数): 100
Ramp-Up时间(秒): 10
循环次数: 永远
持续时间(秒): 60
```

**含义**: 100个并发用户，在10秒内全部启动，持续压测60秒

**HTTP请求配置**:
```yaml
路径: /p/online-course/v2/course/page
方法: GET
查询参数:
{
  "current": 1,
  "size": 10,
  "keyword": "",
  "typeConfigId": ""
}
请求头:
{
  "Content-Type": "application/json",
  "Cookie": "lianjia_token=xxx; renovation-token=xxx"
}
请求体: (空)
Body类型: JSON
```

**断言配置(可选)**:
```yaml
响应码断言: 200
响应内容断言: errno":"0
```

**期望性能指标**:
- **平均响应时间**: < 500ms
- **错误率**: < 1%
- **TPS**: > 50

### 6.4 贝壳公益 - PK功能并发压测

#### 用例模块配置
```yaml
模块名称: PK功能压测
模块描述: 对PK功能进行并发压测，验证数据一致性和性能
```

#### 压测用例1: PK发起接口并发压测
```yaml
用例名称: PK发起接口高并发测试
用例描述: 测试多用户同时发起PK时的系统性能和数据一致性
压测来源类型: SIMPLE (在线配置)
环境: 贝壳公益测试环境(善贝GO小程序)
```

**线程组配置**:
```yaml
线程数(并发用户数): 50
Ramp-Up时间(秒): 5
循环次数: 1
持续时间(秒): 30
```

**HTTP请求配置**:
```yaml
路径: /pk/v1/startPK
方法: POST
查询参数: (无)
请求头:
{
  "Content-Type": "application/json",
  "Authorization": "Bearer token_value"
}
请求体:
{
  "userCode": "${__UUID()}",
  "targetUserCode": "TARGET_USER",
  "pkType": 1,
  "duration": 7
}
Body类型: JSON
```

**CSV数据文件配置(可选)**:
如果需要使用真实用户数据进行压测，可以准备CSV文件:

**users.csv**:
```csv
userCode,targetUserCode
USER_001,USER_002
USER_003,USER_004
USER_005,USER_006
...
```

在请求体中使用CSV变量:
```json
{
  "userCode": "${userCode}",
  "targetUserCode": "${targetUserCode}",
  "pkType": 1,
  "duration": 7
}
```

**期望性能指标**:
- **平均响应时间**: < 1000ms
- **错误率**: < 0.5%
- **TPS**: > 30
- **数据一致性**: 100% (无数据重复或丢失)

### 6.5 压测结果分析

执行压测后，查看以下关键指标:

#### 聚合报告指标
- **样本数(Samples)**: 总请求数
- **平均响应时间(Average)**: 所有请求的平均响应时间
- **最小响应时间(Min)**: 最快响应时间
- **最大响应时间(Max)**: 最慢响应时间
- **错误率(Error %)**: 失败请求的百分比
- **吞吐量(Throughput)**: 每秒处理的请求数(TPS)

#### 性能指标分析标准

**响应时间分析**:
- **< 200ms**: 优秀
- **200ms - 500ms**: 良好
- **500ms - 1000ms**: 一般，需要关注
- **> 1000ms**: 需要优化

**错误率分析**:
- **< 0.5%**: 优秀
- **0.5% - 1%**: 良好
- **1% - 5%**: 需要关注
- **> 5%**: 严重问题，需要立即优化

---

## 七、测试报告查看

### 7.1 操作路径
**测试报告 → (选择报告类型)**

### 7.2 报告类型

#### 7.2.1 接口测试报告
**路径**: 测试报告 → 接口测试

**报告内容**:
- 用例名称
- 执行状态(执行中/成功/失败)
- 开始时间/结束时间
- 消耗时间
- 通过数量/失败数量

**详细报告包含**:
- 每个步骤的请求和响应
- 断言结果
- 执行时间
- 错误信息(如果有)
- 变量提取结果

#### 7.2.2 UI测试报告
**路径**: 测试报告 → UI测试

**报告内容**:
- 用例名称
- 执行状态
- 开始时间/结束时间
- 浏览器类型

**详细报告包含**:
- 每个步骤的执行状态
- 元素定位信息
- 断言结果
- 截图(如果配置了截图)
- 错误信息(如果有)

#### 7.2.3 压测报告
**路径**: 测试报告 → 压力测试

**报告内容**:
- 用例名称
- 执行状态
- 开始时间/结束时间
- 并发数
- 持续时间

**详细报告包含**:
- 聚合报告(样本数、平均响应时间、TPS等)
- 响应时间分布
- 错误率统计
- 每个请求的详细数据
- 性能趋势图表

---

## 八、完整使用流程

### 8.1 初次配置流程(一次性)

```
1. 创建项目
   ↓
2. 配置环境
   ↓
3. 创建接口模块和接口
   ↓
4. 创建测试用例模块
   ↓
5. 配置测试用例和步骤
```

### 8.2 日常测试流程

```
1. 选择项目
   ↓
2. 选择测试类型(接口/UI/压测)
   ↓
3. 选择或创建测试用例
   ↓
4. 执行测试用例
   ↓
5. 查看测试报告
   ↓
6. 分析测试结果
   ↓
7. 修复问题(如果有)
   ↓
8. 回归测试验证
```

### 8.3 版本迭代测试流程

```
1. 接收版本需求
   ↓
2. 更新/新增接口定义
   ↓
3. 更新/新增测试用例
   ↓
4. 执行冒烟测试(P0用例)
   ↓
5. 执行完整回归测试
   ↓
6. 执行性能压测(如果需要)
   ↓
7. 生成测试报告
   ↓
8. 版本上线
```

### 8.4 并发测试流程(贝壳公益PK功能)

```
1. 创建PK功能压测用例
   ↓
2. 配置并发参数(50-200并发)
   ↓
3. 执行压测(建议先小并发测试)
   ↓
4. 查看压测报告
   ↓
5. 分析性能指标和数据一致性
   ↓
6. 数据库验证(检查数据是否一致)
   ↓
7. 发现问题记录和优化
   ↓
8. 回归验证
```

---

## 九、最佳实践建议

### 9.1 接口自动化最佳实践

#### 模块化组织
- 按业务模块划分接口(课程、考试、证书)
- 按业务流程组织测试用例
- 接口命名清晰明了

#### 变量管理
- 使用有意义的变量名(`course_id`、`exam_id`)
- 统一变量命名规范(蛇形命名法)
- 及时清理不用的变量

#### 断言设计
- 关键字段必须断言(状态码、业务code)
- 使用多种断言方式组合(JSONPath、响应码、响应时间)
- 数据准确性断言(数字范围、非空验证)

### 9.2 UI自动化最佳实践

#### 元素定位
- 优先使用ID定位(最稳定)
- 避免使用绝对XPath(容易失效)
- 使用相对稳定的定位方式(CSS选择器、链接文本)

#### 等待机制
- 合理使用强制等待(2-3秒)
- 关键操作后增加等待时间
- 避免过度等待影响执行速度

#### 截图策略
- 关键步骤截图(登录成功、数据展示)
- 失败步骤必须截图(便于问题定位)
- 定期清理旧截图(避免占用存储空间)

### 9.3 压测最佳实践

#### 压测策略
- 从低并发开始(10-50)，逐步增加
- 观察系统响应时间变化趋势
- 找到系统性能瓶颈点

#### 数据准备
- 使用测试数据(避免影响生产数据)
- 准备足够的测试数据(CSV文件)
- 压测后清理测试数据

#### 监控指标
- 关注响应时间(平均值、最大值)
- 关注错误率(应< 1%)
- 关注TPS变化趋势
- 关注系统资源使用率(CPU、内存、数据库连接)

### 9.4 数据准确性测试最佳实践(贝壳公益)

#### 数据验证方法
- 接口返回验证(检查计算结果)
- 数据库直接验证(查询数据库记录)
- 多次执行验证(确保计算逻辑稳定)
- 边界条件验证(0值、负数、最大值)

#### 数据一致性测试
- C端和M端数据对比(贝壳公益)
- 不同统计口径数据对比
- 实时数据和历史数据对比

---

## 十、常见问题

### Q1: 接口执行失败怎么办?
**A**: 
1. 检查环境配置是否正确(域名、端口)
2. 检查接口路径是否正确
3. 检查Cookie/Token是否过期
4. 检查请求参数格式是否正确
5. 查看详细错误信息定位问题

### Q2: UI自动化元素定位失败?
**A**:
1. 检查定位表达式是否正确
2. 检查元素是否已加载(增加等待时间)
3. 尝试其他定位方式
4. 查看截图确认元素是否存在

### Q3: 压测结果不准确?
**A**:
1. 检查压测环境是否独立(避免干扰)
2. 检查网络延迟影响
3. 检查服务器资源使用情况
4. 多次执行取平均值

### Q4: 如何验证数据准确性(贝壳公益公益币)?
**A**:
1. 记录操作前的数据(公益币余额)
2. 执行操作(完成任务获取公益币)
3. 记录操作后的数据
4. 计算差值并与预期对比
5. 数据库验证(直接查询数据库记录)

### Q5: 并发测试发现数据不一致怎么办?
**A**:
1. 记录不一致的具体场景
2. 降低并发数尝试复现
3. 检查数据库事务隔离级别
4. 检查是否有并发控制机制(锁)
5. 提供详细复现步骤给开发

---

## 十一、技术支持

### 问题反馈
如在使用过程中遇到问题，请提供以下信息:
- 项目名称
- 测试用例名称
- 执行时间
- 错误截图
- 详细错误信息

### 平台地址
- **前端地址**: http://localhost:5173
- **后端地址**: http://localhost:8080
- **默认账号**: admin / 123456

---

**文档版本**: v2.0  
**最后更新**: 2026年1月13日  
**维护者**: 测试团队
