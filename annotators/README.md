# annotators

推理管道的标注器插件。作为 Python 包通过根目录的统一 `requirements.txt` 安装（`-e ./annotators`）。

## 包结构

| 模块 | 用途 | 需要额外依赖 |
|--------|---------|---------------|
| `wdv3_tagger` | WDv3 图像标签 | (基础) |
| `gradcam` | GradCAM 热力图生成 | (基础) |
| `lama_inpainter` | LaMa 图像修复 | (基础) |
| `bizarre_tagger` | Bizarre 姿态估计 + 背景分割 | `[bizarre_tagger]` |
| `lang_sam` | 语言引导的 SAM 分割 | `[lang_sam]` |
| `animeinsseg` | 动漫实例分割 (mmdet3) | `[animeinsseg]` |
| `anime_face_detector` | 动漫人脸检测 (旧版) | 独立的 `ann_mmpose` 环境 |

## 可选额外依赖

基础标注器随统一环境安装。对于较重的额外依赖：

```bash
# 身体解析 + 语言 SAM（约 10 分钟，需要 C++ 编译器）
pip install -e annotators[bizarre_tagger,lang_sam]

# 实例分割（需要 CUDA 工具包以构建 mmcv）
pip install -e annotators[animeinsseg]

# 或使用预配置的层级文件：
pip install -r requirements-inference-mmdet.txt

# 全部安装
pip install -e annotators[all]
```

### 动漫人脸检测（独立环境）

`anime_face_detector` 需要与统一环境不兼容的旧版依赖（PyTorch 1.13, mmcv-full 1.7）。需要设置专用的 conda 环境：

```bash
conda create -n ann_mmpose python=3.10
conda activate ann_mmpose
pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 \
  --extra-index-url https://download.pytorch.org/whl/cu117
pip install openmim==0.3.6 numpy==1.26.4 opencv-python==4.10.0.84
mim install mmcv-full==1.7.0
mim install mmdet==2.28.2
mim install mmpose==0.29.0
pip install -e ./common
```

从仓库根目录运行：
```bash
conda run --no-capture-output -n ann_mmpose \
  python inference/scripts/parse_live2d.py facedet \
  --exec_list workspace/datasets/.../exec_list.txt
```
