
# 安装

## 运行源代码
### Windows
Python > 3.11 可能会破坏 mmcv，Python==3.10 运行良好
``` shell
pip install -r requirements.txt
pip install -U openmim
# torch > 2.1 可能无法用于 mmcv
pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118 
pip install numpy==1.26.4
mim install mmcv==2.1.0
mim install mmdet==3.3.0
python launch.py
```

### MacOS
已使用 Python==3.11 测试
``` shell
pip install -r requirements.txt
pip install -U openmim
# torch != 2.1.0 可能无法用于 mmcv
pip install torch==2.1.0 torchvision torchaudio
pip install numpy==1.26.4
pip install mmcv==2.1.0 -f https://download.openmmlab.com/mmcv/dist/cpu/torch2.1/index.html
mim install mmdet==3.3.0
python launch.py
```

# 使用方法
打开（或拖放）包含要处理的图像的文件夹，然后点击运行


## 提示和快捷键
* ``` Ctrl ```（按住）+ 鼠标滚轮缩放画布 
* ```A```/```D``` 或 ```pageUp```/```Down``` 翻页
* 可以选择、移动和删除实例
* ```Ctrl+Z```、```Ctrl+Shift+Z```、```Ctrl+Y```、```Ctrl+Shift+Y``` 可以撤销/重做大多数操作。（注意：翻页后撤销栈将被清除）
* ```W``` 进入/退出框提示模式。在画布上，按住鼠标右键拖动可创建框。注意：如果**有选中的内容**，将弹出上下文菜单而不是创建框。框模式和批处理共享同一个运行按钮，退出框模式才能运行批处理。
