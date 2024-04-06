# perf-eval

### Installation
```sh
pip install ultralytics
wget https://github.com/ultralytics/ultralytics/blob/main/ultralytics/cfg/datasets/coco8.yaml
wget https://ultralytics.com/assets/coco8.zip
unzip coco8.zip
wget https://github.com/ultralytics/assets/releases/download/v8.1.0/yolov8s.pt
sudo apt-get update && sudo apt-get install -y libgl1 && sudo apt install -y libusb-1.0-0
```

### Inference
```sh
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=False int8=False
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=True int8=False
yolo detect benchmark model=yolov8s.pt data='coco8.yaml' imgsz=640 device=cpu half=False int8=True
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