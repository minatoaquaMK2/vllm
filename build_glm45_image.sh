#!/bin/bash

# Build script for GLM 4.5 AMD MI300X Docker image
# This script builds a Docker image for serving GLM 4.5 on AMD MI300X GPUs

set -e

# Configuration
IMAGE_NAME="${IMAGE_NAME:-vllm-glm45-mi300x}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building GLM 4.5 AMD MI300X Docker Image${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Image name: ${YELLOW}${FULL_IMAGE_NAME}${NC}"
echo ""

# Check if Dockerfile exists
if [ ! -f "Dockerfile.glm45-mi300x" ]; then
    echo -e "${RED}Error: Dockerfile.glm45-mi300x not found!${NC}"
    exit 1
fi

# Check if rocm-requirements.txt exists
if [ ! -f "rocm-requirements.txt" ]; then
    echo -e "${RED}Error: rocm-requirements.txt not found!${NC}"
    exit 1
fi

# Build the Docker image
echo -e "${GREEN}Starting Docker build...${NC}"
echo ""

docker build \
    -f Dockerfile.glm45-mi300x \
    -t "${FULL_IMAGE_NAME}" \
    --progress=plain \
    .

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Build completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "Image: ${YELLOW}${FULL_IMAGE_NAME}${NC}"
    echo ""
    echo -e "${GREEN}To run the container:${NC}"
    echo ""
    echo -e "${YELLOW}docker run -it --rm \\${NC}"
    echo -e "${YELLOW}  --cap-add=SYS_PTRACE \\${NC}"
    echo -e "${YELLOW}  -e SHELL=/bin/bash \\${NC}"
    echo -e "${YELLOW}  --network=host \\${NC}"
    echo -e "${YELLOW}  --security-opt seccomp=unconfined \\${NC}"
    echo -e "${YELLOW}  --device=/dev/kfd \\${NC}"
    echo -e "${YELLOW}  --device=/dev/dri \\${NC}"
    echo -e "${YELLOW}  --group-add video \\${NC}"
    echo -e "${YELLOW}  --ipc=host \\${NC}"
    echo -e "${YELLOW}  --name vllm_glm45 \\${NC}"
    echo -e "${YELLOW}  -e HF_TOKEN=\${HF_TOKEN} \\${NC}"
    echo -e "${YELLOW}  ${FULL_IMAGE_NAME}${NC}"
    echo ""
    echo -e "${GREEN}To start the GLM 4.5 server inside the container:${NC}"
    echo -e "${YELLOW}/app/start_glm_server.sh${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Build failed!${NC}"
    echo -e "${RED}========================================${NC}"
    exit 1
fi

