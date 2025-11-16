#!/bin/bash

set -e

echo "======================================"
echo "  Loading images to K8s nodes"
echo "======================================"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérifier que les images tar.gz existent
if [ ! -f "the-north-api.tar.gz" ] || [ ! -f "the-north-frontend.tar.gz" ]; then
    echo "Error: Image tar.gz files not found!"
    echo "Run './build-images.sh' first"
    exit 1
fi

echo -e "${BLUE}Copying images to master node...${NC}"
cd ../vagrant/k8s-cluster
vagrant upload ../../kingdoms/the-north-api.tar.gz /tmp/ master
vagrant upload ../../kingdoms/the-north-frontend.tar.gz /tmp/ master

echo -e "${BLUE}Loading images on master...${NC}"
vagrant ssh master -c 'sudo ctr -n k8s.io images import /tmp/the-north-api.tar.gz'
vagrant ssh master -c 'sudo ctr -n k8s.io images import /tmp/the-north-frontend.tar.gz'

echo -e "${GREEN}✓ Images loaded on master${NC}"

# Pour chaque worker
for i in 1 2; do
    echo -e "${BLUE}Copying images to worker${i}...${NC}"
    vagrant upload ../../kingdoms/the-north-api.tar.gz /tmp/ worker${i}
    vagrant upload ../../kingdoms/the-north-frontend.tar.gz /tmp/ worker${i}

    echo -e "${BLUE}Loading images on worker${i}...${NC}"
    vagrant ssh worker${i} -c 'sudo ctr -n k8s.io images import /tmp/the-north-api.tar.gz'
    vagrant ssh worker${i} -c 'sudo ctr -n k8s.io images import /tmp/the-north-frontend.tar.gz'

    echo -e "${GREEN}✓ Images loaded on worker${i}${NC}"
done

echo ""
echo -e "${GREEN}======================================"
echo "  All images loaded successfully!"
echo "======================================${NC}"
echo ""
echo "Verify with:"
echo "  vagrant ssh master -c 'sudo crictl images | grep gotk8s'"
echo ""
echo "Next step: Deploy to Kubernetes"
echo "  cd ../../kingdoms && ./deploy-gotk8s.sh"
