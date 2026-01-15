@echo off
REM 在本地 Windows 上导出 MySQL 5.7 镜像

echo ==========================================
echo   导出 MySQL 5.7 镜像
echo ==========================================
echo.

mkdir docker-images 2>NUL

echo [1/2] 拉取 MySQL 5.7 镜像...
docker pull mysql:5.7
if %errorlevel% neq 0 (
    echo 错误：无法拉取 MySQL 5.7 镜像
    pause
    exit /b 1
)

echo.
echo [2/2] 导出镜像...
docker save mysql:5.7 -o docker-images/mysql-5.7.tar
if %errorlevel% neq 0 (
    echo 错误：导出失败
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   导出完成！
echo ==========================================
echo.
echo 镜像文件：docker-images\mysql-5.7.tar
echo.
echo 下一步：
echo 1. 使用 SCP 上传到服务器：
echo    scp docker-images\mysql-5.7.tar root@115.190.216.91:/root/docker-images/
echo.
echo 2. 在服务器上导入：
echo    docker load < /root/docker-images/mysql-5.7.tar
echo.
pause
