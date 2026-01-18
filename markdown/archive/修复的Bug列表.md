
（按技术难度和业务价值排序）
### Bug 1：项目切换数据不刷新

- 问题描述：在"接口自动化-接口管理"中，从"贝好学"项目切换到"贝壳公益"项目后，前端仍显示旧项目的接口数据

- 根本原因：项目ID变化时，前端未清空旧数据源，未强制刷新模块选择状态

- 技术难点：涉及 Vue 3 状态管理、watchEffect 响应式监听、数据同步逻辑

- 修复方案：在 TableModal.vue 中添加 isProjectSwitching 状态跟踪，清空 tableDataSource，强制选择新项目第一个模块

- 业务价值：⭐⭐⭐⭐⭐（严重影响多项目使用场景，数据混淆会导致测试错误）

---

### Bug 2：新增API用例页面无响应

- 问题描述：点击"新增API用例"保存按钮无响应，前端控制台无错误，后端日志显示权限检查但未保存成功

- 根本原因：前端未正确处理异步请求，数据字段名不匹配（stepList vs list），后端未处理空数组导致 NullPointerException

- 技术难点：涉及前后端数据交互、异步处理、字段映射、空安全检查

- 修复方案：

- 前端：handleSave 改为 async/await，将 stepList 映射为 list 传给后端

- 后端：在 ApiCaseServiceImpl.save() 中添加 req.getList() 空检查

- 业务价值：⭐⭐⭐⭐⭐（核心功能无法使用，直接影响用例创建）

---

### Bug 3：删除空模块系统异常

- 问题描述：删除没有关联测试用例的模块时返回"系统异常"

- 根本原因：对空的 caseIdList 执行 deleteBatchIds() 导致 MyBatis Plus 生成的 SQL in () 语法异常

- 技术难点：涉及 ORM 框架边界条件处理、数据库 SQL 语法限制

- 修复方案：在 ApiCaseModuleServiceImpl.del() 中添加 !caseIdList.isEmpty() 判断，仅在列表非空时执行删除

- 业务价值：⭐⭐⭐⭐（影响模块管理功能，但可通过先删除用例再删除模块绕过）

---

### Bug 4：删除模块404错误

- 问题描述：删除模块时请求 /api/v1/api_case_module/del 端点返回 404 Not Found

- 根本原因：后端 ApiCaseModuleController 缺少 /del 端点映射，只有 /delete 端点

- 技术难点：涉及 Spring MVC 路由配置、前后端接口规范统一

- 修复方案：在 ApiCaseModuleController 中添加 @PostMapping("/del") 端点，委托给 apiCaseModuleService.del()

- 业务价值：⭐⭐⭐⭐（影响模块管理功能）

---

### Bug 5：用户权限配置缺失

- 问题描述：用户登录后提示"无此权限：PROJECT_READ_WRITE"，无法访问项目管理功能

- 根本原因：数据库 glen_account 中未为该账号分配相应权限

- 技术难点：涉及 RBAC 权限模型、SQL 动态查询、权限分配逻辑

- 修复方案：编写 SQL 脚本 Mysql/快速分配权限-通用版.sql，自动插入权限、创建角色、分配角色

- 业务价值：⭐⭐⭐（影响新用户使用，但可通过 SQL 脚本快速修复）

---

### Bug 6：请求头文本显示过长

- 问题描述：接口管理-新建/编辑页面-请求头输入框文本显示太长，影响可读性

- 根本原因：表格单元格未实现文本长度限制和省略逻辑

- 技术难点：涉及 Vue 组件通用性改造、CSS 文本截断、hover 交互

- 修复方案：在 EditableTable.vue 中实现 truncateText() 方法，60字符截断+省略号+title 属性显示完整内容

- 业务价值：⭐⭐（UI 体验优化，不影响功能使用）

---

### Bug 7：IDEA启动后端服务失败

- 问题描述：启动 EngineApplication 时提示 ClassNotFoundException: com.glen.autotest.EngineApplication

- 根本原因：IntelliJ IDEA 未启用 Lombok 注解处理，导致编译时未生成 Getter/Setter 方法

- 技术难点：涉及 IDE 配置、编译时注解处理器（APT）原理

- 修复方案：在 IDEA 设置中启用 Annotation Processing，然后执行 Rebuild Project

- 业务价值：⭐⭐⭐（环境配置问题，解决后不会再出现）