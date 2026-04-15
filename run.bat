@echo off

:: 如果在 PowerShell 中运行，则在 cmd.exe 中重新启动
if defined PSModulePath if not defined __RUN_CMD (
    set "__RUN_CMD=1"
    cmd /c "%~f0" %*
    exit /b %errorlevel%
)

chcp 65001 >nul
cd /d "%~dp0"

:: 检查虚拟环境是否存在
if not exist "venv\Scripts\python.exe" (
    echo [错误] 未找到虚拟环境。请先运行 install.bat。
    pause
    exit /b 1
)

:: 设置 HuggingFace 缓存目录
set "HF_HOME=%~dp0.hf_cache"

:: 启动 WebUI
echo 正在启动 See-through WebUI...
call venv\Scripts\python.exe tools\webui.py

if %errorlevel% neq 0 (
    echo.
    echo [错误] WebUI 因错误而退出。
    pause
)
