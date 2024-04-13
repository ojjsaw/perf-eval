#!/bin/bash

# Check if all required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <model_name> <half_boolean> <output_file>"
    exit 1
fi

# Assign the input parameters to variables
model_name=$1
half_boolean=$2
output_file=$3

# Ensure the output file has a .json extension
if [[ $output_file != *.json ]]; then
    output_file="${output_file}.json"
fi

# Run the command with the provided model name and half precision setting
output=$(yolo detect val model=$model_name data=coco8.yaml imgsz=640 half=$half_boolean device=cpu)

# Extract inference time
inference_time_line=$(echo "$output" | grep "inference")
inference=$(echo "$inference_time_line" | grep -oP '\d+\.\d+(?=ms inference)')

# Extract mAP scores for each class into an associative array
declare -A class_scores

while IFS= read -r line; do
    if echo "$line" | grep -q "Speed"; then
        continue
    fi
    class=$(echo "$line" | awk '{print $1}')
    map50=$(echo "$line" | awk '{print $6}')
    map95=$(echo "$line" | awk '{print $7}')
    class_scores["$class"]="[\"$map50\", \"$map95\"]"
done < <(echo "$output" | grep -A 7 "^                   all")

# Prepare the JSON object
json_object="{\"inference\": \"$inference\","

for class in "${!class_scores[@]}"; do
    json_object+="\"$class\": ${class_scores[$class]},"
done

json_object="${json_object%,}}"
echo "$json_object" > "$output_file"

# Print the JSON output to the console
cat "$output_file"
