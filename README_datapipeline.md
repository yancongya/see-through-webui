### Live2D 提取
按照以下步骤构建提取程序并提取示例：
https://github.com/shitagaki-lab/CubismPartExtr

### 生成伪标签
假设您已将提取目录放置在 `workspace/datasets/partextr_output`，运行

```
python inference/scripts/parse_live2d.py build_live2d_exec_list --srcd workspace/datasets/partextr_output

python inference/scripts/parse_live2d.py sam_infer_l2d --exec_list workspace/datasets/partextr_output/exec_list.txt

python inference/scripts/parse_live2d.py label_l2d_wsamsegs --exec_list workspace/datasets/partextr_output/exec_list.txt --extr_more
```

之后，您可以在 UI 中打开 `workspace/datasets/partextr_output/exec_list.txt` 并手动修正标签。

### 生成训练数据

准备背景图像
```
cd workspace/datasets
hf download 24yearsold/anime_segmentation_bg --local-dir ./ --repo-type dataset
7z x anime_segmentation_bg.zip.001
rm -rf ./anime_segmentation_bg.zip.*

```

运行合成脚本
```
python inference/scripts/syn_data.py render_body_samples --exec_list workspace/datasets/partextr_output/exec_list.txt --bg_list workspace/datasets/anime_segmentation_bg/exec_list.txt \
--save_dir workspace/datasets/test_bodysamples

python inference/scripts/syn_data.py get_tgt_list --src_dir workspace/datasets/partextr_bodysamples
```

