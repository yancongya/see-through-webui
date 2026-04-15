# ui

桌面 UI 子代码库：用于 Live2D 模型标注和管理的 Qt6 应用程序。

使用 `see_through` conda 环境。设置请参阅 [根目录 README](../README.md)。

## 使用方法

**始终将仓库根目录作为工作目录运行：**

```bash
cd /path/to/see-through
conda activate see_through
python ui/ui/launch.py
```

`assets` 符号链接必须存在于仓库根目录（请参阅根目录 README）。
如果没有它，UI 将在启动时因 `FileNotFoundError` 而崩溃。

### 工作区设置

UI 期望项目数据位于 `workspace/datasets/` 下。每个项目是一个包含已标注 Live2D 模型文件夹的目录：

```
workspace/
└── datasets/
    └── <project_name>/
        ├── exec_list.txt              # 模型路径列表（每行一个）
        └── <model_name>/
            ├── final.jxl              # 源图像（JXL 格式）
            ├── final.json             # 项目元数据（由 UI 自动创建）
            ├── instances.json         # 实例标注
            └── *_masks.json           # 分割掩码（来自推理）
```

要打开项目，请使用 **文件 > 打开** 并选择 `exec_list.txt` 或项目 `.json` 文件，或直接使用以下命令启动：

```bash
python ui/ui/launch.py --proj workspace/datasets/<project_name>
```

有关如何从 Live2D 模型文件准备工作区数据，请参阅 [CubismPartExtr](https://github.com/shitagaki-lab/CubismPartExtr)。

### Windows

从 `ui/` 目录双击 `launch_ui_win.bat`。

### 无头测试 (Xvfb)

在无头 Linux 上进行视觉测试：

```bash
sudo bash ui/install_system_deps.sh
Xvfb :99 -screen 0 1920x1080x24 &
DISPLAY=:99 python ui/ui/launch.py
```
