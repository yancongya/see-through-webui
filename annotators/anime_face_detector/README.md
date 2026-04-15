# anime_face_detector

**Conda 环境：** `live2d_ann_mmpose`

## 设置

```bash
conda create -n live2d_ann_mmpose python=3.10 -c conda-forge
conda activate live2d_ann_mmpose
pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 \
  --extra-index-url https://download.pytorch.org/whl/cu117
pip install openmim==0.3.6 numpy==1.26.4 opencv-python==4.10.0.84
mim install mmcv-full==1.7.0
mim install mmdet==2.28.2
mim install mmpose==0.29.0
```

## 已知问题

- 与 `common/` 的环境兼容性未验证。参见 `../../ISSUES.md`。
