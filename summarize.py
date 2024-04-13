import json
import matplotlib.pyplot as plt
import os
import argparse

def read_json(file_path):
    """Read and return the content of a JSON file."""
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def plot_data(data, label, file_names):
    """Generate and save a plot comparing the same attribute across multiple JSON files."""
    fig, ax = plt.subplots()
    
    for file_data, name in zip(data, file_names):
        values = [float(v) for v in file_data[label]]
        ax.plot(range(len(values)), values, label=f'{os.path.basename(name)}', marker='o')
    
    ax.set_ylabel('Probability')
    ax.set_title(f'{label.capitalize()} probabilities comparison')
    ax.legend()
    
    # Save the plot
    plt.savefig(f"{label}_comparison.png")
    plt.close()

def plot_inference(data, file_names):
    """Plot inference time comparison across JSON files."""
    inferences = [float(file_data["inference"]) for file_data in data]
    fig, ax = plt.subplots()
    ax.bar(file_names, inferences, color='blue')
    
    ax.set_ylabel('Inference Time (ms)')
    ax.set_title('Inference Time Comparison')
    ax.set_xticklabels(file_names, rotation=45)
    
    # Save the plot
    plt.savefig("inference_comparison.png")
    plt.close()

def main(file_paths):
    """Process each JSON file and generate comparative plots."""
    data = [read_json(path) for path in file_paths]
    keys = set(data[0].keys()) - {'inference'}
    
    # Plot comparisons for each key except 'inference'
    for key in keys:
        plot_data(data, key, file_paths)
    
    # Plot inference comparison
    plot_inference(data, file_paths)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot comparative data from multiple JSON files.")
    parser.add_argument('file_paths', nargs='+', help='The file paths of the JSON files to process.')
    args = parser.parse_args()
    main(args.file_paths)
