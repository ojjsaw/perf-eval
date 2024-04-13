# perf-eval

### Installation
```sh
pip install ultralytics && sudo apt-get update && sudo apt-get install -y libgl1 && sudo apt install -y libusb-1.0-0

wget https://github.com/ultralytics/ultralytics/blob/main/ultralytics/cfg/datasets/coco8.yaml
wget https://ultralytics.com/assets/coco8.zip
unzip coco8.zip
wget https://github.com/ultralytics/assets/releases/download/v8.1.0/yolov8s.pt
```

### Model Conversion
```sh
yolo export model=yolov8s.pt format=openvino imgsz=640 half=False int8=False
yolo export model=yolov8s.pt format=onnx imgsz=640 half=False int8=False
yolo export model=yolov8s.pt format=saved_model imgsz=640 half=False int8=False
yolo export model=yolov8s.pt format=torchscript imgsz=640 half=False int8=False
yolo export model=yolov8s.pt format=tflite imgsz=640 half=False int8=False
yolo export model=yolov8s.pt format=paddle imgsz=640 half=False int8=False

yolo detect val model=yolov8s.pt data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s_openvino_model data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s.onnx data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s_saved_model data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s_saved_model/yolov8s_float32.tflite data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s.torchscript data=coco8.yaml imgsz=640 half=False
yolo detect val model=yolov8s_paddle_model data=coco8.yaml imgsz=640 half=False

```

### Inference
```sh
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=False int8=False
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=True int8=False
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=False int8=True
```

### util
```sh
bash parse_run.sh yolov8s.pt False yolov8s_torchscript

python summarize.py yolov8s_pytorch.json yolov8s_torchscript.json
```

### Yolo-v8
| Framework  | FP32    | FP16    |  INT8    |
| :---:      | :---:   | :---:   |  :---:   |
| TensorFlow | - | X | - |
| TensorFlow Lite | - | - | - |
| PyTorch | - | X | X |
| TorchScript | - | X | X |
| ONNX | - | - | X |
| OpenVINO | - | - | - |
| PaddlePaddle | - | X | X |