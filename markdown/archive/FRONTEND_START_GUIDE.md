# 🎨 前端服务启动指南

**更新时间**: 2026-01-18  
**环境**: WSL2 Ubuntu

---

## ✅ 前置条件检查

### 1. 后端服务必须运行

确保以下后端服务都已启动：

- ✅ account-service (端口 8081)
- ✅ data-service (端口 8082)
- ✅ engine-service (端口 8083)
- ✅ gateway-service (端口 8000)

**检查方法**:
```bash
for port in 8081 8082 8083 8000; do
    timeout 2 bash -c "echo > /dev/tcp/localhost/$port" 2>/dev/null && echo "✅ 端口 $port: 运行中" || echo "❌ 端口 $port: 未运行"
done
```

### 2. 前端环境要求

- ✅ Node.js: 18+ (当前: v20.20.0)
- ✅ pnpm: 8.8.0+ (当前: 10.28.0)

**检查方法**:
```bash
node -v  # 应显示 v18.x.x 或更高
pnpm -v  # 应显示 8.8.0 或更高
```

---

## 🚀 启动前端服务

### 方式1: 使用启动脚本（推荐）

```bash
cd /home/hinkad/yun-glenautotest
./start-frontend.sh
```

启动脚本会：
1. ✅ 检查运行环境（Node.js、pnpm）
2. ✅ 检查后端服务状态
3. ✅ 检查并安装依赖（如果需要）
4. ✅ 启动前端开发服务器

### 方式2: 手动启动

#### 步骤1: 进入前端目录

```bash
cd /home/hinkad/yun-glenautotest/frontend
```

#### 步骤2: 安装依赖（首次运行）

```bash
pnpm install
```

**预计时间**: 2-5分钟（首次安装）

#### 步骤3: 启动开发服务器

```bash
pnpm dev
```

---

## 🌐 访问地址

### 前端应用

- **本地访问**: http://localhost:5173
- **网络访问**: http://[WSL2-IP]:5173（如果需要从Windows访问）

### 后端服务（已配置代理）

前端会自动代理以下路径到网关服务：

- `/account-service/*` → `http://localhost:8000/account-service/*`
- `/engine-service/*` → `http://localhost:8000/engine-service/*`
- `/data-service/*` → `http://localhost:8000/data-service/*`
- `/server-api/*` → `http://localhost:8000/*`

---

## ⚙️ 配置文件

### Vite配置 (`vite.config.ts`)

**已修复的配置**:
- ✅ 代理目标已从 `192.168.117.237:8000` 改为 `localhost:8000`
- ✅ 服务器监听 `0.0.0.0`，允许外部访问
- ✅ 端口设置为 `5173`（Vite默认端口）

---

## 📋 完整系统访问地址

| 服务 | 访问地址 | 说明 |
|------|---------|------|
| **前端应用** | **http://localhost:5173** | ⭐ 主要访问地址 |
| 网关服务 | http://localhost:8000 | API网关 |
| account-service | http://localhost:8081 | 账号服务 |
| data-service | http://localhost:8082 | 数据服务 |
| engine-service | http://localhost:8083 | 引擎服务 |
| Nacos控制台 | http://localhost:8848/nacos | 服务注册中心（用户名: nacos, 密码: nacos） |
| MinIO控制台 | http://localhost:9001 | 对象存储（用户名: admin, 密码: glen123456） |
| MinIO API | http://localhost:9000 | 对象存储API |

---

## 🔍 验证前端启动

### 1. 检查端口监听

```bash
netstat -tlnp | grep 5173
# 或
lsof -i :5173
```

**期望输出**:
```
tcp6  0  0  :::5173  :::*  LISTEN  进程ID/node
```

### 2. 访问前端页面

在浏览器中访问: **http://localhost:5173**

应该看到：
- ✅ 前端页面正常加载
- ✅ 可以正常登录（如果配置了登录页面）

### 3. 检查控制台

启动后，终端会显示：

```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://[IP]:5173/
  ➜  press h to show help
```

---

## 🛑 停止前端服务

### 方式1: 在当前终端

按 `Ctrl+C` 停止服务

### 方式2: 查找并停止进程

```bash
# 查找前端进程
ps aux | grep "vite\|pnpm dev" | grep -v grep

# 停止进程（替换<PID>为实际进程ID）
kill -9 <PID>

# 或停止所有node进程（谨慎使用）
pkill -f "vite"
```

---

## 🐛 常见问题

### Q1: 端口5173被占用

**错误**: `Port 5173 is in use`

**解决**:
```bash
# 查找占用端口的进程
lsof -ti :5173 | xargs kill -9

# 或修改端口
# 在 vite.config.ts 中修改:
server: {
  port: 5174  # 改为其他端口
}
```

### Q2: 依赖安装失败

**错误**: `pnpm install` 失败

**解决**:
```bash
# 清除缓存重新安装
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### Q3: 无法连接到后端

**错误**: 前端页面报错 "无法连接到服务器"

**检查**:
1. ✅ 后端服务是否运行（检查端口8081、8082、8083、8000）
2. ✅ `vite.config.ts` 中的代理配置是否正确（应为 `localhost:8000`）
3. ✅ 网关服务是否可访问：`curl http://localhost:8000/actuator/health`

### Q4: 跨域问题

**错误**: CORS错误

**解决**: Vite已经配置了代理，如果仍有问题，检查：
1. 后端服务的CORS配置
2. `vite.config.ts` 中的 `changeOrigin: true` 是否配置

### Q5: 页面空白或加载失败

**检查**:
1. 查看浏览器控制台错误信息
2. 检查网络请求是否成功
3. 检查后端服务日志

---

## 📊 开发工具

### Vite开发服务器特性

- ✅ 热模块替换（HMR）
- ✅ 快速刷新
- ✅ 自动重载

### 常用命令

```bash
# 启动开发服务器
pnpm dev

# 构建生产版本
pnpm build

# 预览生产构建
pnpm preview

# 类型检查
pnpm type-check
```

---

## 🎯 部署完成检查清单

- [x] Docker中间件已启动
- [x] 数据库已初始化
- [x] 后端服务已启动（4个服务）
- [ ] 前端依赖已安装
- [ ] 前端服务已启动
- [ ] 前端页面可正常访问
- [ ] 前后端通信正常

---

## 🎯 下一步

前端启动成功后：

1. ✅ 访问 http://localhost:5173
2. ✅ 测试登录功能
3. ✅ 测试各功能模块
4. ✅ 验证前后端通信

---

## 📝 相关文档

- `markdown/BACKEND_START_GUIDE.md` - 后端启动指南
- `markdown/项目启动指南.md` - 完整项目启动指南

---

**文档位置**: `/home/hinkad/yun-glenautotest/markdown/FRONTEND_START_GUIDE.md`  
**最后更新**: 2026-01-18
