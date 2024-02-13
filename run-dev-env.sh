#!/bin/bash

IMAGE_NAME="dev-environment"
CONTAINER_NAME="dev-environment"

# Check if the image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Building Docker image: $IMAGE_NAME"
    docker build -t $IMAGE_NAME .
else
    echo "Docker image $IMAGE_NAME already exists."
fi

# Check if the container exists
if [[ "$(docker ps -aq --filter name=$CONTAINER_NAME 2> /dev/null)" == "" ]]; then
    # Run the container if it doesn't exist
    echo "Creating and running Docker container: $CONTAINER_NAME"
    docker run -d --name $CONTAINER_NAME $IMAGE_NAME
else
    # Start the container if it exists but is not running
    if [[ "$(docker ps -q --filter name=$CONTAINER_NAME 2> /dev/null)" == "" ]]; then
        echo "Starting Docker container: $CONTAINER_NAME"
        docker start $CONTAINER_NAME
    else
        echo "Docker container $CONTAINER_NAME is already running."
    fi
fi

# Enter the container's terminal
docker exec -it $CONTAINER_NAME bash

