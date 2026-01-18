# WSL外部访问配置指南

> 本指南用于配置WSL中运行的自动化测试平台，使其能够被局域网内的其他设备访问

---

## 📋 目录

- [配置概述](#配置概述)
- [前置条件](#前置条件)
- [方法一：配置WSL端口转发（推荐）](#方法一配置wsl端口转发推荐)
- [方法二：配置Windows防火墙](#方法二配置windows防火墙)
- [方法三：修改服务监听地址](#方法三修改服务监听地址)
- [网络访问配置](#网络访问配置)
- [访问地址说明](#访问地址说明)
- [常见问题](#常见问题)

---

## 配置概述

项目在WSL中运行，默认情况下只能通过`localhost`在Windows主机上访问。要让他人访问，需要：

1. **配置端口转发** - 将Windows端口映射到WSL端口
2. **开放防火墙** - 允许Windows防火墙放行相关端口
3. **获取IP地址** - 获取Windows主机在局域网中的IP地址

### 项目端口列表

| 服务 | 端口 | 说明 |
|------|------|------|
| **前端服务** | 5173 | Vue3开发服务器 |
| **网关服务** | 8000 | API网关入口 |
| **账号服务** | 8081 | 后端微服务 |
| **数据服务** | 8082 | 后端微服务 |
| **引擎服务** | 8083 | 后端微服务 |
| **Nacos** | 8848, 9848, 9849 | 服务注册中心 |
| **MinIO** | 9000, 9001 | 对象存储 |
| **MySQL** | 3307 | 数据库 |
| **Redis** | 6379 | 缓存 |
| **Kafka** | 9092 | 消息队列 |
| **Zookeeper** | 2181 | Kafka依赖 |

---

## 前置条件

### 1. 获取Windows主机IP地址

在Windows PowerShell或CMD中执行：

```powershell
# 查看IP地址
ipconfig

# 查找"以太网适配器"或"无线局域网适配器"中的IPv4地址
# 例如：192.168.1.100
```

### 2. 确认服务正常运行

在WSL中执行：

```bash
# 检查前端服务
curl http://localhost:5173

# 检查网关服务
curl http://localhost:8000

# 检查Docker服务
docker ps
```

---

## 方法一：配置WSL端口转发（推荐）

这是最简单可靠的方法，适合Windows 10/11。

### 步骤1：创建端口转发脚本

在Windows中创建PowerShell脚本：`setup-wsl-port-forward.ps1`

```powershell
# WSL端口转发配置脚本
# 需要以管理员权限运行

# 获取WSL的IP地址
$wslIP = (wsl hostname -I).Trim()

Write-Host "WSL IP地址: $wslIP" -ForegroundColor Green

# 需要转发的端口列表
$ports = @(
    @{Name="前端服务"; Port=5173},
    @{Name="网关服务"; Port=8000},
    @{Name="账号服务"; Port=8081},
    @{Name="数据服务"; Port=8082},
    @{Name="引擎服务"; Port=8083},
    @{Name="Nacos-HTTP"; Port=8848},
    @{Name="Nacos-gRPC"; Port=9848},
    @{Name="Nacos-gRPC2"; Port=9849},
    @{Name="MinIO-API"; Port=9000},
    @{Name="MinIO-Console"; Port=9001},
    @{Name="MySQL"; Port=3307},
    @{Name="Redis"; Port=6379},
    @{Name="Kafka"; Port=9092},
    @{Name="Zookeeper"; Port=2181}
)

foreach ($item in $ports) {
    $port = $item.Port
    $name = $item.Name
    
    # 删除已存在的转发规则（如果存在）
    $existing = netsh interface portproxy show v4tov4 | Select-String ":$port "
    if ($existing) {
        Write-Host "删除已存在的端口转发规则: $port" -ForegroundColor Yellow
        netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 | Out-Null
    }
    
    # 创建新的转发规则
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIP | Out-Null
    Write-Host "✅ 配置端口转发: $name (端口 $port)" -ForegroundColor Green
}

Write-Host "`n端口转发配置完成！" -ForegroundColor Green
Write-Host "`n查看当前转发规则：" -ForegroundColor Cyan
netsh interface portproxy show v4tov4
```

### 步骤2：执行脚本

1. **以管理员身份运行PowerShell**（右键 -> 以管理员身份运行）

2. **执行脚本**：

```powershell
# 如果脚本在项目根目录
cd D:\your-project-path\yun-glenautotest
.\setup-wsl-port-forward.ps1

# 或者直接执行（需要先设置执行策略）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup-wsl-port-forward.ps1
```

### 步骤3：配置防火墙规则

在PowerShell中执行：

```powershell
# 需要开放的端口
$ports = 5173, 8000, 8081, 8082, 8083, 8848, 9848, 9849, 9000, 9001, 3307, 6379, 9092, 2181

foreach ($port in $ports) {
    # 添加入站规则
    New-NetFirewallRule -DisplayName "WSL Port $port" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow -ErrorAction SilentlyContinue
    Write-Host "✅ 防火墙规则已添加: 端口 $port" -ForegroundColor Green
}

Write-Host "`n防火墙配置完成！" -ForegroundColor Green
```

### 步骤4：验证配置

```powershell
# 查看端口转发规则
netsh interface portproxy show v4tov4

# 查看防火墙规则
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*WSL Port*"} | Select-Object DisplayName, Enabled, Direction
```

---

## 方法二：配置Windows防火墙

如果方法一不适用，可以手动配置防火墙。

### 步骤1：打开防火墙高级设置

1. 按`Win + R`，输入`wf.msc`，回车
2. 点击"入站规则" -> "新建规则"

### 步骤2：为每个端口添加规则

对每个端口重复以下操作：

1. **规则类型**：选择"端口"
2. **协议和端口**：TCP，特定本地端口（例如：5173）
3. **操作**：允许连接
4. **配置文件**：全部勾选
5. **名称**：例如"WSL前端服务-5173"

需要添加的端口：
- 5173（前端）
- 8000（网关）
- 8081, 8082, 8083（后端服务）
- 8848, 9848, 9849（Nacos）
- 9000, 9001（MinIO）
- 3307（MySQL）
- 6379（Redis）
- 9092（Kafka）
- 2181（Zookeeper）

---

## 方法三：修改服务监听地址

### 修改后端服务监听地址

默认情况下，Spring Boot服务只监听`localhost`。要让外部访问，需要修改配置：

#### 方法A：使用配置文件

在各个后端服务的`application.properties`中添加：

```properties
# 允许外部访问（监听所有网络接口）
server.address=0.0.0.0
```

**需要修改的文件：**
- `backend/glen-gateway/src/main/resources/application.properties`
- `backend/glen-account/src/main/resources/application.properties`
- `backend/glen-data/src/main/resources/application.properties`
- `backend/glen-engine/src/main/resources/application.properties`

#### 方法B：使用启动参数

在启动脚本中添加：

```bash
mvn spring-boot:run -Dspring-boot.run.arguments="--server.address=0.0.0.0"
```

**⚠️ 注意：** 如果修改了`server.address`，服务间调用可能需要调整。建议保持`localhost`，仅通过端口转发实现外部访问。

### 前端服务配置

前端服务在`vite.config.ts`中已经配置了`host: '0.0.0.0'`，无需修改：

```typescript
server: {
  host: '0.0.0.0', // 允许外部访问
  port: 5173,
}
```

---

## 网络访问配置

### 获取Windows主机IP

在Windows命令行中：

```cmd
ipconfig
```

查找局域网IP（通常是`192.168.x.x`或`10.x.x.x`）

### 配置WSL防火墙（如果需要）

WSL默认不启用防火墙，但如果需要配置：

```bash
# 在WSL中检查防火墙状态
sudo ufw status

# 如果需要开放端口（通常不需要）
sudo ufw allow 5173/tcp
sudo ufw allow 8000/tcp
```

---

## 访问地址说明

配置完成后，其他人可以通过以下地址访问：

### 假设Windows主机IP为 `192.168.1.100`

| 服务 | 访问地址 | 说明 |
|------|----------|------|
| **前端应用** | http://192.168.1.100:5173 | 主要访问入口 |
| **API网关** | http://192.168.1.100:8000 | 后端API入口 |
| **Nacos控制台** | http://192.168.1.100:8848/nacos | 服务注册中心 |
| **MinIO控制台** | http://192.168.1.100:9001 | 对象存储管理 |

### 测试访问

在局域网内的其他设备上测试：

```bash
# 测试前端服务
curl http://192.168.1.100:5173

# 测试网关服务
curl http://192.168.1.100:8000

# 测试Nacos
curl http://192.168.1.100:8848/nacos
```

---

## 常见问题

### 1. 端口转发不生效

**问题**：配置了端口转发，但仍然无法访问

**解决方案**：

1. **确认WSL IP地址**：
```powershell
wsl hostname -I
```

2. **重新运行端口转发脚本**（WSL重启后IP可能改变）

3. **检查端口是否被占用**：
```powershell
netstat -ano | findstr :5173
```

4. **检查防火墙规则**：
```powershell
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*WSL*"}
```

### 2. WSL IP地址变化

**问题**：WSL每次重启后IP地址可能变化

**解决方案**：

1. **创建自动更新脚本**：将端口转发脚本添加到Windows启动项
2. **使用静态IP**：配置WSL使用固定IP（较复杂）
3. **使用`.wslconfig`**：在Windows用户目录创建`.wslconfig`文件

```ini
[wsl2]
networkingMode=mirrored
dnsTunneling=true
firewall=true
autoProxy=true
```

### 3. 防火墙阻止访问

**问题**：配置了端口转发，但防火墙阻止访问

**解决方案**：

```powershell
# 检查防火墙状态
Get-NetFirewallProfile | Select-Object Name, Enabled

# 临时关闭防火墙（不推荐，仅用于测试）
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 推荐：添加防火墙规则（见方法一）
```

### 4. 前端可以访问，但API调用失败

**问题**：前端页面可以打开，但请求后端API失败

**解决方案**：

1. **检查前端代理配置**：确保`vite.config.ts`中的代理配置正确
2. **检查网关服务**：确认网关服务（端口8000）正常运行
3. **检查CORS配置**：后端可能需要配置CORS允许跨域访问

```properties
# 在后端配置中添加CORS
spring.web.cors.allowed-origins=*
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
```

### 5. 服务间通信失败

**问题**：微服务之间无法通信

**解决方案**：

- **保持服务监听localhost**：如果使用端口转发，服务仍应监听`localhost`
- **检查Nacos配置**：确保服务都注册到Nacos
- **检查网络配置**：确保Docker容器在同一网络中

### 6. 开发环境vs生产环境

**开发环境**（当前配置）：
- 适合团队内部开发测试
- 使用端口转发和防火墙规则
- 前端通过Vite代理访问后端

**生产环境**：
- 建议使用Nginx作为反向代理
- 配置域名和SSL证书
- 使用专业防火墙和负载均衡

---

## 快速配置脚本

创建完整的配置脚本：`setup-external-access.ps1`

```powershell
# 需要以管理员权限运行

Write-Host "=== WSL外部访问配置脚本 ===" -ForegroundColor Cyan

# 1. 获取WSL IP
$wslIP = (wsl hostname -I).Trim()
$winIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*"}).IPAddress | Select-Object -First 1

Write-Host "`nWSL IP: $wslIP" -ForegroundColor Green
Write-Host "Windows IP: $winIP" -ForegroundColor Green

# 2. 配置端口转发
$ports = 5173, 8000, 8081, 8082, 8083, 8848, 9848, 9849, 9000, 9001, 3307, 6379, 9092, 2181

foreach ($port in $ports) {
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 2>$null
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIP | Out-Null
}

Write-Host "`n✅ 端口转发配置完成" -ForegroundColor Green

# 3. 配置防火墙
foreach ($port in $ports) {
    New-NetFirewallRule -DisplayName "WSL Port $port" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow -ErrorAction SilentlyContinue
}

Write-Host "✅ 防火墙规则配置完成" -ForegroundColor Green

# 4. 显示访问地址
Write-Host "`n=== 访问地址 ===" -ForegroundColor Cyan
Write-Host "前端: http://$winIP:5173" -ForegroundColor Yellow
Write-Host "网关: http://$winIP:8000" -ForegroundColor Yellow
Write-Host "Nacos: http://$winIP:8848/nacos" -ForegroundColor Yellow
Write-Host "MinIO: http://$winIP:9001" -ForegroundColor Yellow

Write-Host "`n配置完成！" -ForegroundColor Green
```

---

## 总结

要让其他人访问WSL中的服务，推荐流程：

1. ✅ **配置端口转发**（方法一）- 将Windows端口映射到WSL
2. ✅ **开放防火墙规则**（方法一中的步骤3）
3. ✅ **获取Windows主机IP地址**（`ipconfig`）
4. ✅ **分享访问地址**（例如：`http://192.168.1.100:5173`）

**注意事项**：
- WSL重启后可能需要重新运行端口转发脚本
- 确保所有服务正常运行后再配置外部访问
- 生产环境建议使用专业的反向代理和负载均衡

---

**配置完成后，团队成员就可以通过局域网IP访问您的开发环境了！** 🎉
