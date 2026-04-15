@echo off
chcp 65001 >nul
cd /d "%~dp0"

set "OUT=%~dp0diagnostic.txt"

echo See-through WebUI 诊断报告 > "%OUT%"
echo ============================== >> "%OUT%"
echo 日期：%date% %time% >> "%OUT%"
echo. >> "%OUT%"

echo --- 操作系统 --- >> "%OUT%"
ver >> "%OUT%"
echo. >> "%OUT%"

echo --- 当前目录 --- >> "%OUT%"
echo %cd% >> "%OUT%"
echo. >> "%OUT%"

echo --- GPU --- >> "%OUT%"
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv 2>&1 >> "%OUT%"
if %errorlevel% neq 0 (
    echo nvidia-smi 失败，尝试基础模式： >> "%OUT%"
    nvidia-smi 2>&1 | findstr /i "NVIDIA driver" >> "%OUT%"
)
echo. >> "%OUT%"

echo --- Python (py launcher) --- >> "%OUT%"
where py 2>&1 >> "%OUT%"
py --list 2>&1 >> "%OUT%"
echo. >> "%OUT%"

echo --- Python (PATH) --- >> "%OUT%"
where python 2>&1 >> "%OUT%"
python --version 2>&1 >> "%OUT%"
echo. >> "%OUT%"

echo --- Python312 默认路径 --- >> "%OUT%"
set "PY312=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
echo 预期路径：%PY312% >> "%OUT%"
if exist "%PY312%" (
    echo 存在：是 >> "%OUT%"
    "%PY312%" --version >> "%OUT%" 2>&1
    "%PY312%" -c "import venv; print('venv 模块：正常')" >> "%OUT%" 2>&1
) else (
    echo 存在：否 >> "%OUT%"
)
echo. >> "%OUT%"

echo --- 虚拟环境文件夹 --- >> "%OUT%"
if exist "venv" (
    echo venv 文件夹：存在 >> "%OUT%"
    if exist "venv\Scripts\python.exe" (
        echo venv\Scripts\python.exe: 存在 >> "%OUT%"
        venv\Scripts\python.exe --version >> "%OUT%" 2>&1
    ) else (
        echo venv\Scripts\python.exe: 缺失 >> "%OUT%"
        dir /b venv 2>&1 >> "%OUT%"
    )
) else (
    echo venv 文件夹：未找到 >> "%OUT%"
)
echo. >> "%OUT%"

echo --- 文件夹内容 --- >> "%OUT%"
dir /b 2>&1 >> "%OUT%"
echo. >> "%OUT%"

echo --- Conda 检查 --- >> "%OUT%"
where conda 2>&1 >> "%OUT%"
if defined CONDA_DEFAULT_ENV (
    echo CONDA_DEFAULT_ENV=%CONDA_DEFAULT_ENV% >> "%OUT%"
) else (
    echo Conda: 未激活 >> "%OUT%"
)
echo. >> "%OUT%"

echo --- 环境变量 --- >> "%OUT%"
echo PATH=%PATH% >> "%OUT%"
echo LOCALAPPDATA=%LOCALAPPDATA% >> "%OUT%"
echo. >> "%OUT%"

echo --- install.log --- >> "%OUT%"
if exist "install.log" (
    type install.log >> "%OUT%"
) else (
    echo install.log 未找到 >> "%OUT%"
)

echo.
echo 完成！结果已保存至：
echo   %OUT%
echo.
echo 请将此文件发送给开发者。
pause
