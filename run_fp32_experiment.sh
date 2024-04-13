#!/bin/bash

VENV_DIR="my_venv"
PACKAGE_TO_INSTALL="ultralytics"

# Configuration array that holds the settings for each model type
declare -A model_types=(
    [ONNX]="onnx yolov8s.onnx yolov8s_onnx"
    [PyTorch]="pt yolov8s.pt yolov8s_pytorch"
    [TensorFlow]="saved_model yolov8s_saved_model yolov8s_tensorflow"
    [OpenVINO]="openvino yolov8s_openvino_model yolov8s_openvino"
    [PaddlePaddle]="paddle yolov8s_paddle_model yolov8s_paddlepaddle"
    [TorchScript]="torchscript yolov8s.torchscript yolov8s_torchscript"
    [TensorFlowLite]="tflite yolov8s_saved_model/yolov8s_float32.tflite yolov8s_tflite"
)

# Function to handle model processing
process_model() {
    local export_format=$1
    local file_name=$2
    local run_name=$3

    echo "Starting $run_name"
    python3 -m venv $VENV_DIR
    source $VENV_DIR/bin/activate
    pip install $PACKAGE_TO_INSTALL

    if [ "$export_format" != "pt" ]; then
        yolo export model=yolov8s.pt format=$export_format imgsz=640 half=False int8=False
    fi

    bash parse_run.sh $file_name False $run_name

    deactivate
    rm -rf $VENV_DIR
    [[ "$export_format" != "pt" ]] && rm -rf $file_name
    echo "Completed $run_name and venv removed."
}

# Loop through each model type and process
for model in "${!model_types[@]}"; do
    IFS=' ' read -ra ARGS <<< "${model_types[$model]}"
    process_model "${ARGS[0]}" "${ARGS[1]}" "${ARGS[2]}"
done

# Summarize task
echo "Starting Comparison graphs export."
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate
pip install matplotlib
python summarize.py yolov8s_pytorch.json yolov8s_torchscript.json yolov8s_tensorflow.json yolov8s_tflite.json yolov8s_openvino.json yolov8s_paddlepaddle.json yolov8s_onnx.json
deactivate
rm -rf $VENV_DIR
rm -rf datasets
rm *.npy
rm *.json
echo "Completed summarization and venv removed."