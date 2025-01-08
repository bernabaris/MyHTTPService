#!/bin/bash

DOCKERFILE_DIR="./server"

IMAGE_NAME="myapp_image"

CONTAINER_NAME="myapp_container"

PORT_MAPPING="5000:5000"

echo "Building the Docker image..."
docker build -t "$IMAGE_NAME" -f "$DOCKERFILE_DIR/Dockerfile" .
if [ $? -ne 0 ]; then
    echo "Docker build failed!"
    exit 1
fi

echo "Checking for existing container..."
if docker ps -a --format '{{.Names}}' | grep -Eq "^$CONTAINER_NAME\$"; then
    echo "Stopping and removing existing container..."
    docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
fi

echo "Running the Docker container..."
docker run -d --name "$CONTAINER_NAME" -p "$PORT_MAPPING" "$IMAGE_NAME"
if [ $? -eq 0 ]; then
    echo "Container started successfully. Access the application at http://localhost:${PORT_MAPPING%:*}"
else
    echo "Failed to start the container!"
    exit 1
fi
