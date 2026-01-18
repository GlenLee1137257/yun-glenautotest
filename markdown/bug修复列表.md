### 子服务器Engine服务无法启动
原因：主服务器的安全组未开Redis的端口入向规则，
修复：增加规则即可

### 用户输入 test 时，登录失败
原因：前端会设置 identityType='phone'，但数据库是 'mail'。
修复：调整登录逻辑，支持多类型查询：如果identityType为空，默认使用mail

### 公共菜单-项目管理-编辑取消还原原始数据

### 接口管理-接口模块前端调用接口
原因：前端调用：/api/v1/api_module/del
修复：后端 Controller 的删除路由从 /delete 改为 /del