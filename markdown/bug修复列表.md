### 子服务器Engine服务无法启动
原因：主服务器的安全组未开Redis的端口入向规则，
修复：增加规则即可

### 用户输入 test 时，登录失败
原因：前端会设置 identityType='phone'，但数据库是 'mail'。
修复：调整登录逻辑，支持多类型查询：如果identityType为空，默认使用mail

### 公共菜单-项目管理-编辑取消还原原始数据
原因：取消编辑时未保存原始数据快照，导致无法还原
修复：在编辑时保存原始数据深拷贝，取消时还原

### 接口管理-接口模块前端调用接口
原因：前端调用：/api/v1/api_module/del
修复：后端 Controller 的删除路由从 /delete 改为 /del

### 测试报告搜索框问题
原因：前端传递字符串日期时间，后端直接与时间戳字段比较导致类型不匹配
修复：将字符串日期转换为 Date 对象，使用 gmt_create 字段进行时间范围查询

### 测试报告批量删除失败
原因：report_detail_api 表不存在，且 ReportDetail*DO 模型类未指定数据库前缀
修复：创建 report_detail_api 表，修复所有 ReportDetail*DO 的 @TableName 注解添加数据库前缀

