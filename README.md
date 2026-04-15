<div align="center">

# See-through WebUI

**一张动漫插图 → 自动分解为最多 23 个图层**

[![原始项目](https://img.shields.io/badge/Original-shitagaki--lab%2Fsee--through-blue)](https://github.com/shitagaki-lab/see-through)
[![arXiv](https://img.shields.io/badge/arXiv-2602.03749-b31b1b.svg)](https://arxiv.org/abs/2602.03749)
[![许可证](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

<img src="common/assets/representative.jpg" width="600">

*这是 [See-through](https://github.com/shitagaki-lab/see-through) 的本地运行用 WebUI。*
*仅限 Windows + NVIDIA GPU。无需 Python 或命令行知识——只需双击即可使用。*

<img src="docs/img.png" width="800">

</div>

---

## 🚀 使用方法（仅需 3 步）

### 步骤 0：下载

👉 **[下载最新版本（ZIP）](https://github.com/BeamManP/see-through-webui/releases/latest)**

从 Releases 页面下载 `see-through-webui.zip`，并解压到任意位置。

### 步骤 1：安装

双击展开文件夹中的 **`install.bat`**。

接下来只需等待。以下操作将全部自动完成：
- ✅ 如果没有 Python，将自动安装
- ✅ 自动下载 AI 模型（约 3GB）
- ✅ 安装所有必需的软件

> 💡 首次运行需要 **15〜30 分钟**（取决于网络速度）。
> 首次下载总量约为 **6GB**（Python + PyTorch + AI 模型）。
> 如果中途停止，再次运行 `install.bat` 即可从中断处继续。

### 步骤 2：启动

双击 **`run.bat`**。

浏览器将自动打开。只需拖放图像并按"生成"按钮即可！

---

## 💻 系统要求

| 要求 | 条件 |
|-----------|------|
| **操作系统** | Windows 10 / 11（64 位） |
| **GPU** | NVIDIA RTX 2060 或更高（Turing 架构及以后） |
| **VRAM** | 8GB 或更高 |
| **内存** | 8GB 或更高 |
| **可用空间** | 20GB 或更高 |
| **Python** | 不需要（将自动安装） |
| **Git** | 不需要（请从 Releases 下载 zip 文件） |

> ⚠️ **GTX 10xx / 16xx 系列无法运行。**
> 因为 NF4 量化需要 Turing 架构（RTX 20xx）及以后的 GPU 才支持的功能。

### VRAM 与分辨率参考

提高分辨率可获得更高质量的输出，但会消耗更多 VRAM。
可在 WebUI 中通过滑块进行调整。

| 分辨率 | VRAM 使用量 | 推荐环境 |
|--------|-----------|------------|
| 512    | 约 5GB    | RTX 2060 / RTX 3060 |
| 768    | 约 5.5GB  | RTX 3060 / RTX 4060 |
| 1024   | 约 7GB    | RTX 3060 Ti / RTX 4060 Ti |
| 1280   | 约 9GB    | RTX 3080 / RTX 4070 或更高 |

---

## ❓ 遇到问题时

<details>
<summary><b>下载或运行时出现 Windows 警告</b></summary>

从浏览器下载 ZIP 文件时，Windows Defender SmartScreen 可能会发出警告。
这是对未签名分发文件的常见警告，并非病毒。

- Chrome: "保存" → "详细信息" → "保留"
- Edge: "..." → "保留"
- 运行时："详细信息" → "仍要运行"
</details>

<details>
<summary><b>install.bat 出现错误</b></summary>

- 请尝试再次双击 `install.bat`（可从中断处继续）
- 如果仍然不行，请删除整个 `venv` 文件夹后重试
- 错误详情记录在 `install.log` 中
</details>

<details>
<summary><b>显示 "NVIDIA GPU not detected"</b></summary>

本工具**仅限 NVIDIA GPU**（不支持 AMD / Intel GPU）。
如果有 NVIDIA GPU 但仍报错，请将驱动程序更新至最新版本。
→ https://www.nvidia.com/drivers
</details>

<details>
<summary><b>生成过程中出现 "Out of Memory"</b></summary>

VRAM 不足。请尝试将 WebUI 的分辨率滑块调低至 **512 〜 768**。
</details>

<details>
<summary><b>显示 "Error named symbol not found"</b></summary>

GTX 10xx / 16xx 系列 GPU 无法运行。
因为 NF4 量化（节省 VRAM 的技术）需要 RTX 20xx 及以后的 GPU。
</details>

<details>
<summary><b>浏览器未自动打开</b></summary>

将 `run.bat` 窗口中显示的 URL（如 `http://127.0.0.1:7860`）
复制粘贴到浏览器的地址栏中即可。
</details>

---

## 📁 文件结构

```
see-through-webui/
├── 📄 install.bat          … 安装程序（仅首次使用）
├── 📄 run.bat              … 启动器（每次使用）
├── 📁 tools/
│   └── webui.py            … WebUI 主体
├── 📁 webui/
│   └── requirements.txt    … 依赖包列表
├── 📁 inference/           … See-through 推理引擎（源自原版）
├── 📁 common/              … 通用工具（源自原版）
├── 📁 venv/                … Python 虚拟环境（由 install.bat 创建）
└── 📁 .hf_cache/           … AI 模型缓存
```

---

## 🙏 致谢

本项目是 **[See-through](https://github.com/shitagaki-lab/see-through)** 的分支。

**原论文:**
> Jian Lin, Chengze Li, Haoyun Qin, Kwun Wang Chan, Yanghua Jin, Hanyuan Liu, Stephen Chun Wang Choy, Xueting Liu.
> "See-through: Single-image Layer Decomposition for Anime Characters"
> *ACM SIGGRAPH 2026 Conference Proceedings* — [arXiv:2602.03749](https://arxiv.org/abs/2602.03749)

衷心感谢原项目的作者们。

## 📄 许可证

[Apache License 2.0](LICENSE) — 与原项目相同的许可证。
