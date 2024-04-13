# Use the official Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Set environment variables to avoid interactive dialogues during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install Python and pip
RUN apt-get update && apt-get install -y \
    libgl1 \
    libusb-1.0-0 \
    libglib2.0-0 \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

COPY . .

RUN chmod +x /app/*.sh

# Set the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
