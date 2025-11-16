#!/bin/bash

set -e

echo "======================================"
echo "  GOTK8S - Building Kingdom Images"
echo "======================================"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Build The North Backend
echo -e "${BLUE}Building The North - Ravens API...${NC}"
cd the-north/backend
docker build -t gotk8s/the-north-api:1.0 .
echo -e "${GREEN}✓ The North API built${NC}"

# Build The North Frontend
echo -e "${BLUE}Building The North - Frontend...${NC}"
cd ../frontend
docker build -t gotk8s/the-north-frontend:1.0 .
echo -e "${GREEN}✓ The North Frontend built${NC}"

cd ../..

echo ""
echo -e "${GREEN}======================================"
echo "  All images built successfully!"
echo "======================================${NC}"
echo ""
echo "Images created:"
echo "  - gotk8s/the-north-api:1.0"
echo "  - gotk8s/the-north-frontend:1.0"
echo ""
echo "Next step: Deploy to Kubernetes"
echo "  kubectl apply -f ../manifests/gotk8s/"
