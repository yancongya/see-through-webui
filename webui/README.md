# See-through WebUI — 一键安装指南

## 概述

这是 [See-through](https://github.com/shitagaki-lab/see-through) 的本地 WebUI，可从单张动漫插图生成最多 23 个图层的语义分解。

**目标系统**: Windows 10/11 + NVIDIA GPU (推荐 VRAM 8GB 以上)

---

## 快速开始

### 1. 安装

只需双击 `install.bat`。将自动执行以下操作：

1. 检查 Python 3.12（如果没有则自动下载并安装）
2. 创建虚拟环境 (venv)
3. 安装 PyTorch 2.8 + CUDA 12.8
4. 安装依赖包
5. 下载 NF4 量化模型 (~3GB)

**所需时间**: 首次运行 15〜30 分钟（取决于网络速度）

### 2. 启动

双击 `run.bat` → 浏览器将自动打开。

---

## 文件结构

```
see-through/
├── install.bat          ← 安装程序（仅首次使用）
├── run.bat              ← 启动器（每次使用）
├── webui/
│   ├── README.md        ← 本文件
│   └── requirements.txt ← WebUI 依赖包
├── tools/
│   └── webui.py         ← WebUI 主体
├── venv/                ← 虚拟环境（由 install.bat 创建）
└── .hf_cache/           ← 模型缓存
```

---

## 系统要求

| 项目 | 最低要求 | 推荐配置 |
|------|------|------|
| 操作系统 | Windows 10 (64 位) | Windows 11 |
| GPU | NVIDIA (VRAM 6GB) | NVIDIA (VRAM 10GB+) |
| 内存 | 8GB | 16GB |
| 存储空间 | 15GB 可用 | 20GB 可用 |
| Python | 自动安装 | - |

### VRAM 参考 (NF4 模式)

| 分辨率 | VRAM 消耗 |
|--------|----------|
| 512    | ~5GB     |
| 768    | ~5.5GB   |
| 1024   | ~7GB     |
| 1280   | ~9GB     |

VRAM 8GB 环境下建议使用 768 或更低的分辨率。

---

## 故障排除

### "找不到 Python"
→ install.bat 将自动安装 Python 3.12。
  如需手动安装：https://www.python.org/downloads/

### "CUDA error"
→ 请将 NVIDIA 驱动程序更新至最新版本。
  https://www.nvidia.com/drivers

### "模型下载中途停止"
→ 再次运行 install.bat 即可从中断处继续。

### "VRAM 不足 / Out of Memory"
→ 请降低 WebUI 的分辨率滑块（建议 512〜768）。
