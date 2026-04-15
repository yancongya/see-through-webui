@echo off

:: 如果在 PowerShell 中运行，则在 cmd.exe 中重新启动
if defined PSModulePath if not defined __INSTALL_CMD (
    set "__INSTALL_CMD=1"
    cmd /c "%~f0" %*
    pause
    exit /b %errorlevel%
)

chcp 65001 >nul
setlocal EnableDelayedExpansion

echo ============================================================
echo   See-through WebUI 安装程序
echo ============================================================
echo.

cd /d "%~dp0"

:: --- 初始化日志 ---
echo See-through WebUI 安装日志 > install.log
echo 日期：%date% %time% >> install.log
echo. >> install.log

:: ============================================================
:: 预检查
:: ============================================================

:: --- NVIDIA GPU ---
echo [0] 检查 NVIDIA GPU ...
nvidia-smi >nul 2>&1
if not %errorlevel%==0 goto :err_no_gpu
echo   通过
echo.

:: --- 磁盘空间 ---
echo [0] 检查磁盘空间 ...
for /f "tokens=3" %%f in ('dir /-C "%~dp0." 2^>nul ^| findstr /C:"bytes free"') do set "FREE_BYTES=%%f"
if defined FREE_BYTES (
    for /f %%n in ('powershell -Command "[math]::Floor(%FREE_BYTES% / 1GB)"') do set "FREE_GB=%%n"
    if !FREE_GB! LSS 15 goto :err_disk_space
    echo   可用：!FREE_GB! GB
)
echo   通过
echo.

:: ============================================================
:: 查找或安装 Python
:: ============================================================
echo [1] Python ...

set "PYTHON_CMD="

:: --- py launcher ---
where py >nul 2>&1
if not %errorlevel%==0 goto :check_path_python

py -3.12 --version >nul 2>&1
if %errorlevel%==0 (
    set "PYTHON_CMD=py -3.12"
    echo   通过：Python 3.12
    goto :python_ok
)
py -3.11 --version >nul 2>&1
if %errorlevel%==0 (
    set "PYTHON_CMD=py -3.11"
    echo   通过：Python 3.11
    goto :python_ok
)
py -3.10 --version >nul 2>&1
if %errorlevel%==0 (
    set "PYTHON_CMD=py -3.10"
    echo   通过：Python 3.10
    goto :python_ok
)

:check_path_python
where python >nul 2>&1
if not %errorlevel%==0 goto :install_python

for /f "tokens=2 delims= " %%v in ('python --version 2^>^&1') do set "PY_VER_STR=%%v"
echo   PATH: python !PY_VER_STR!
for /f "tokens=1,2 delims=." %%a in ("!PY_VER_STR!") do (
    if "%%a"=="3" if %%b GEQ 10 if %%b LEQ 12 (
        set "PYTHON_CMD=python"
        goto :python_ok
    )
)

:install_python
echo.
echo   未找到 Python 3.10+。正在安装 Python 3.12 ...
echo.
set "PY_INSTALLER=python-3.12.9-amd64.exe"
set "PY_URL=https://www.python.org/ftp/python/3.12.9/%PY_INSTALLER%"

echo   下载中 ...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PY_URL%' -OutFile '%PY_INSTALLER%' -UseBasicParsing"
if not exist "%PY_INSTALLER%" goto :err_python_dl

echo   安装中 ...
"%PY_INSTALLER%" /passive InstallAllUsers=0 PrependPath=1 Include_launcher=1 Include_pip=1
if %errorlevel% neq 0 goto :err_python_install
del "%PY_INSTALLER%" 2>nul
set "PATH=%LOCALAPPDATA%\Programs\Python\Python312;%LOCALAPPDATA%\Programs\Python\Python312\Scripts;%LOCALAPPDATA%\Programs\Python\Launcher;%PATH%"

:: 查找 Python 的实际安装位置
set "PYTHON_CMD=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
if not exist "!PYTHON_CMD!" (
    echo   标准路径未找到，正在搜索...
    for /f "delims=" %%p in ('where python 2^>nul') do (
        set "PYTHON_CMD=%%p"
        goto :python_found
    )
    for /f "delims=" %%p in ('where py 2^>nul') do (
        set "PYTHON_CMD=%%p -3.12"
        goto :python_found
    )
    goto :err_python_install
)
:python_found
echo   通过：Python 3.12 已安装。

:python_ok
echo   使用：!PYTHON_CMD!
echo   PYTHON_CMD=!PYTHON_CMD! >> install.log
echo.

:: ============================================================
:: 创建虚拟环境
:: ============================================================
echo [2] 创建虚拟环境 ...
if exist "venv\Scripts\python.exe" (
    echo   通过：虚拟环境已存在。
    goto :venv_ok
)

:: 首先尝试标准 venv
!PYTHON_CMD! -m venv venv 2>nul
if exist "venv\Scripts\python.exe" goto :venv_created

:: venv 模块可能缺失 - 尝试使用 virtualenv 作为后备
echo   venv 模块未找到，正在安装 virtualenv ...
!PYTHON_CMD! -m pip install virtualenv --quiet 2>nul
if %errorlevel% neq 0 (
    !PYTHON_CMD! -m ensurepip --default-pip 2>nul
    !PYTHON_CMD! -m pip install virtualenv --quiet 2>nul
)
!PYTHON_CMD! -m virtualenv venv 2>nul
if not exist "venv\Scripts\python.exe" goto :err_venv

:venv_created
echo   通过：虚拟环境已创建。
:venv_ok
echo.

:: ============================================================
:: 转交至 Python 设置脚本
:: ============================================================
echo [3] 运行设置 ...
echo.
call venv\Scripts\python.exe webui\setup.py
if %errorlevel% neq 0 goto :err_setup
echo.
echo   日志保存至：install.log
pause
exit /b 0

:: ============================================================
:: 错误处理程序
:: ============================================================

:err_no_gpu
echo.
echo   [错误] 未检测到 NVIDIA GPU。
echo   此工具需要支持 CUDA 的 NVIDIA GPU。
echo   https://www.nvidia.com/drivers
echo.
echo   日志：install.log
pause
exit /b 1

:err_disk_space
echo.
echo   [错误] 磁盘空间不足（需要 15GB 以上）。
echo   可用：!FREE_GB! GB
echo.
echo   日志：install.log
pause
exit /b 1

:err_python_dl
echo.
echo   [错误] Python 下载失败。
echo   手动安装：https://www.python.org/downloads/
echo   日志：install.log
pause
exit /b 1

:err_python_install
echo   [错误] Python 安装失败。
del "%PY_INSTALLER%" 2>nul
echo   日志：install.log
pause
exit /b 1

:err_venv
echo.
echo   [错误] 创建虚拟环境失败。
echo   如果 conda 处于活动状态，请打开新的命令提示符并重试。
echo   日志：install.log
pause
exit /b 1

:err_setup
echo.
echo   [错误] 设置失败。详细信息请查看 install.log。
echo   您可以通过再次运行 install.bat 来重试。
echo   日志：install.log
pause
exit /b 1
