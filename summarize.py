import json
import matplotlib.pyplot as plt
import os
import argparse

def read_json(file_path):
    """Read and return the content of a JSON file."""
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def plot_data(data, file_names):
    """Generate and save plots comparing the same index across multiple JSON files."""
    # Prepare data structures to hold the values of each index
    indices_data = {key: {'index_1': [], 'index_2': []} for key in data[0] if key != 'inference'}
    
    # Populate the data structure
    for file_data in data:
        for key in file_data:
            if key != 'inference':
                indices_data[key]['index_1'].append(float(file_data[key][0]))
                indices_data[key]['index_2'].append(float(file_data[key][1]))

    # Function to create plots
    def create_plot(index_key, file_label, ylabel):
        fig, ax = plt.subplots()
        x_labels = list(indices_data.keys())
        x_positions = range(len(x_labels))
        
        for i, file_name in enumerate(file_names):
            y_values = [indices_data[key][index_key][i] for key in x_labels]
            file_name = file_name.removesuffix('.json') 
            ax.plot(x_labels, y_values, label=os.path.basename(file_name), marker='o')
        
        ax.set_xlabel('Class')
        ax.set_ylabel(ylabel)
        ax.set_title(f'Comparison of {ylabel} Across frameworks')
        ax.legend()
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig(f"{file_label}.png")
        plt.close()

    # Create plots for both indices with specified labels and filenames
    create_plot('index_1', 'mAP50', 'mAP50')
    create_plot('index_2', 'mAP50-95', 'mAP50-95')

def plot_inference(data, file_names):
    """Plot inference time comparison across JSON files with exact values labeled on each bar."""
    inferences = [float(file_data["inference"]) for file_data in data]
    fig, ax = plt.subplots()
    bars = ax.bar([os.path.basename(name).replace('.json', '') for name in file_names], inferences, color='blue')
    
    ax.set_ylabel('Inference Time (ms)')
    ax.set_title('Inference Time Comparison')
    
    # Removing ".json" and setting customized x-tick labels
    ax.set_xticklabels([os.path.basename(name).replace('.json', '') for name in file_names], rotation=45, ha="right")
    
    # Labeling the exact inference values above each bar
    for bar, value in zip(bars, inferences):
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height(), f'{value:.2f}',
                ha='center', va='bottom')

    plt.tight_layout()  # Adjust layout to make room for rotated x-labels
    plt.savefig("inference_comparison.png")
    plt.close()

def main(file_paths):
    """Process each JSON file and generate comparative plots."""
    data = [read_json(path) for path in file_paths]
    
    # Plot comparisons for index values
    plot_data(data, file_paths)
    
    # Plot inference comparison
    plot_inference(data, file_paths)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot comparative data from multiple JSON files.")
    parser.add_argument('file_paths', nargs='+', help='The file paths of the JSON files to process.')
    args = parser.parse_args()
    main(args.file_paths)
