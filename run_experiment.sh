#!/bin/bash

VENV_DIR="my_venv"
PACKAGE_TO_INSTALL="ultralytics"

########################
#### ONNX
########################

echo "Starting ONNX"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install $PACKAGE_TO_INSTALL

yolo export model=yolov8s.pt format=onnx imgsz=640 half=False int8=False
bash parse_run.sh yolov8s.onnx False yolov8s_onnx

deactivate
rm -rf $VENV_DIR
rm yolov8s.onnx
echo "Completed ONNX and venv removed."

########################
#### PyTorch
########################

echo "Starting PyTorch"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install $PACKAGE_TO_INSTALL

bash parse_run.sh yolov8s.pt False yolov8s_pytorch

deactivate
rm -rf $VENV_DIR
echo "Completed PyTorch and venv removed."

#######################
#### TensorFlow
#######################

echo "Starting Tensorflow"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install $PACKAGE_TO_INSTALL

yolo export model=yolov8s.pt format=saved_model imgsz=640 half=False int8=False
bash parse_run.sh yolov8s_saved_model False yolov8s_tensorflow

deactivate
rm -rf $VENV_DIR
rm -rf yolov8s_saved_model
echo "Completed TensorFlow and venv removed."

#######################
#### OpenVINO
#######################

echo "Starting OpenVINO"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install $PACKAGE_TO_INSTALL

yolo export model=yolov8s.pt format=openvino imgsz=640 half=False int8=False
bash parse_run.sh yolov8s_openvino_model False yolov8s_openvino

deactivate
rm -rf $VENV_DIR
rm -rf yolov8s_openvino_model
echo "Completed OpenVINO and venv removed."

#######################
#### PaddlePaddle
#######################

echo "Starting PaddlePaddle"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install $PACKAGE_TO_INSTALL

yolo export model=yolov8s.pt format=paddle imgsz=640 half=False int8=False
bash parse_run.sh yolov8s_paddle_model False yolov8s_paddlepaddle

deactivate
rm -rf $VENV_DIR
rm -rf yolov8s_paddle_model
echo "Completed PaddlePaddle and venv removed."


#######################
#### Summarize
#######################

echo "Starting Comparison graphs export."

python summarize.py yolov8s_pytorch.json yolov8s_torchscript.json yolov8s_tensorflow.json yolov8s_tflite.json yolov8s_openvino.json yolov8s_paddlepaddle.json yolov8s_onnx.json
