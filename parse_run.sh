#!/bin/bash

# Run your command here and store the output in a variable
# Replace 'your_command' with the actual command you need to execute
output=$(yolo detect val model=yolov8s.pt data=coco8.yaml imgsz=640 half=False)

# Extract inference time
# Use a more general regex to ensure capturing
inference_time_line=$(echo "$output" | grep "inference")
inference=$(echo "$inference_time_line" | grep -oP '\d+\.\d+(?=ms inference)')

# Extract mAP scores for each class into an associative array
declare -A class_scores

# Using a loop to parse each class line after identifying the line "all"
while IFS= read -r line; do
    # Skip processing if the line contains the word 'Speed'
    if echo "$line" | grep -q "Speed"; then
        continue
    fi
    class=$(echo "$line" | awk '{print $1}')
    map50=$(echo "$line" | awk '{print $6}')
    map95=$(echo "$line" | awk '{print $7}')
    # Append mAP50 and mAP95 to an array under the class key
    class_scores["$class"]="[\"$map50\", \"$map95\"]"
done < <(echo "$output" | grep -A 7 "^                   all")

# Prepare the JSON object
json_object="{\"inference\": \"$inference\","

# Append each class and its mAP scores to the JSON object
for class in "${!class_scores[@]}"; do
    json_object+="\"$class\": ${class_scores[$class]},"
done

# Remove the last comma and close the JSON object
json_object="${json_object%,}}"
echo "$json_object" > output.json

# Print the JSON output to the console
cat output.json