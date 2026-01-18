# WSL端口转发配置脚本
# 需要以管理员权限运行PowerShell
# 使用方法: 右键PowerShell -> 以管理员身份运行 -> 执行此脚本

param(
    [switch]$Remove  # 如果指定此参数，则删除所有端口转发规则
)

Write-Host "=== WSL端口转发配置工具 ===" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ 错误: 需要以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "请右键点击PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    exit 1
}

# 获取WSL的IP地址
Write-Host "[1/3] 获取WSL IP地址..." -ForegroundColor Yellow
try {
    $wslIP = (wsl hostname -I).Trim()
    if ([string]::IsNullOrWhiteSpace($wslIP)) {
        Write-Host "❌ 无法获取WSL IP地址，请确认WSL已启动" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ WSL IP地址: $wslIP" -ForegroundColor Green
} catch {
    Write-Host "❌ 获取WSL IP地址失败: $_" -ForegroundColor Red
    exit 1
}

# 获取Windows主机IP地址
$winIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    ($_.IPAddress -like "192.168.*") -or 
    ($_.IPAddress -like "10.*") -or 
    ($_.IPAddress -like "172.16.*")
}).IPAddress | Select-Object -First 1

Write-Host "✅ Windows主机IP: $winIP" -ForegroundColor Green
Write-Host ""

# 需要转发的端口列表
$ports = @(
    @{Name="前端服务"; Port=5173; Description="Vue3开发服务器"},
    @{Name="网关服务"; Port=8000; Description="API网关入口"},
    @{Name="账号服务"; Port=8081; Description="后端微服务"},
    @{Name="数据服务"; Port=8082; Description="后端微服务"},
    @{Name="引擎服务"; Port=8083; Description="后端微服务"},
    @{Name="Nacos-HTTP"; Port=8848; Description="服务注册中心HTTP"},
    @{Name="Nacos-gRPC"; Port=9848; Description="服务注册中心gRPC"},
    @{Name="Nacos-gRPC2"; Port=9849; Description="服务注册中心gRPC"},
    @{Name="MinIO-API"; Port=9000; Description="对象存储API"},
    @{Name="MinIO-Console"; Port=9001; Description="MinIO控制台"},
    @{Name="MySQL"; Port=3307; Description="数据库"},
    @{Name="Redis"; Port=6379; Description="缓存"},
    @{Name="Kafka"; Port=9092; Description="消息队列"},
    @{Name="Zookeeper"; Port=2181; Description="Kafka依赖"}
)

# 如果指定删除，则删除所有规则
if ($Remove) {
    Write-Host "[删除模式] 正在删除所有端口转发规则..." -ForegroundColor Yellow
    foreach ($item in $ports) {
        $port = $item.Port
        netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 2>$null
        Write-Host "  ✓ 删除端口 $port" -ForegroundColor Gray
    }
    Write-Host "`n✅ 所有端口转发规则已删除" -ForegroundColor Green
    exit 0
}

# 配置端口转发
Write-Host "[2/3] 配置端口转发..." -ForegroundColor Yellow
$successCount = 0
$failCount = 0

foreach ($item in $ports) {
    $port = $item.Port
    $name = $item.Name
    
    try {
        # 删除已存在的转发规则（如果存在）
        netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 2>$null
        
        # 创建新的转发规则
        $result = netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIP 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ $name (端口 $port)" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  ❌ $name (端口 $port) - 配置失败" -ForegroundColor Red
            $failCount++
        }
    } catch {
        Write-Host "  ❌ $name (端口 $port) - 错误: $_" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""

# 配置防火墙规则
Write-Host "[3/3] 配置Windows防火墙规则..." -ForegroundColor Yellow
$firewallCount = 0

foreach ($item in $ports) {
    $port = $item.Port
    $ruleName = "WSL Port $port - Glen自动化测试平台"
    
    try {
        # 删除已存在的规则（如果存在）
        Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
        
        # 创建新的防火墙规则
        $rule = New-NetFirewallRule `
            -DisplayName $ruleName `
            -Direction Inbound `
            -LocalPort $port `
            -Protocol TCP `
            -Action Allow `
            -Description "允许访问Glen自动化测试平台的$($item.Name)" `
            -ErrorAction SilentlyContinue
        
        if ($rule) {
            Write-Host "  ✅ 防火墙规则: 端口 $port" -ForegroundColor Green
            $firewallCount++
        }
    } catch {
        # 如果规则已存在，忽略错误
        if ($_.Exception.Message -notlike "*已存在*") {
            Write-Host "  ⚠️  防火墙规则: 端口 $port - $($_.Exception.Message)" -ForegroundColor Yellow
        } else {
            Write-Host "  ✅ 防火墙规则: 端口 $port (已存在)" -ForegroundColor Green
            $firewallCount++
        }
    }
}

Write-Host ""

# 显示配置结果
Write-Host "=== 配置结果 ===" -ForegroundColor Cyan
Write-Host "端口转发: $successCount/$($ports.Count) 成功" -ForegroundColor $(if ($successCount -eq $ports.Count) { "Green" } else { "Yellow" })
Write-Host "防火墙规则: $firewallCount/$($ports.Count) 配置" -ForegroundColor $(if ($firewallCount -eq $ports.Count) { "Green" } else { "Yellow" })
Write-Host ""

# 显示访问地址
Write-Host "=== 访问地址 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 前端应用:     http://$winIP:5173" -ForegroundColor Yellow
Write-Host "🔌 API网关:      http://$winIP:8000" -ForegroundColor Yellow
Write-Host "📊 Nacos控制台:  http://$winIP:8848/nacos" -ForegroundColor Yellow
Write-Host "🗄️  MinIO控制台:  http://$winIP:9001" -ForegroundColor Yellow
Write-Host ""
Write-Host "其他团队成员可以通过上述地址访问您的开发环境！" -ForegroundColor Green
Write-Host ""

# 显示当前端口转发规则
Write-Host "=== 当前端口转发规则 ===" -ForegroundColor Cyan
netsh interface portproxy show v4tov4

Write-Host ""
Write-Host "✅ 配置完成！" -ForegroundColor Green
Write-Host ""
Write-Host "提示: " -ForegroundColor Yellow
Write-Host "  - WSL重启后IP地址可能变化，需要重新运行此脚本" -ForegroundColor Gray
Write-Host "  - 删除端口转发规则: .\setup-wsl-port-forward.ps1 -Remove" -ForegroundColor Gray
Write-Host ""
