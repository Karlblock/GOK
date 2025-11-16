#!/bin/bash

set -e

echo "======================================"
echo "  GOTK8S - Deploying to Kubernetes"
echo "======================================"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Creating Westeros namespace...${NC}"
kubectl apply -f ../manifests/gotk8s/00-namespace/

echo -e "${BLUE}Step 2: Deploying Redis (The Citadel's Cache)...${NC}"
kubectl apply -f ../manifests/gotk8s/01-redis/

echo -e "${BLUE}Step 3: Waiting for Redis to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=redis -n westeros --timeout=60s

echo -e "${BLUE}Step 4: Deploying The North...${NC}"
kubectl apply -f ../manifests/gotk8s/02-the-north/

echo -e "${BLUE}Step 5: Deploying Ingress...${NC}"
kubectl apply -f ../manifests/gotk8s/03-ingress/

echo ""
echo -e "${GREEN}======================================"
echo "  GOTK8S Deployed Successfully!"
echo "======================================${NC}"
echo ""
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l kingdom=the-north -n westeros --timeout=120s

echo ""
echo -e "${YELLOW}Access URLs:${NC}"
echo "  Frontend:  http://192.168.56.10:30100"
echo "  API:       http://192.168.56.10:30101"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  kubectl get all -n westeros"
echo "  kubectl logs -f deployment/the-north-api -n westeros"
echo "  kubectl logs -f deployment/the-north-frontend -n westeros"
echo ""
echo -e "${GREEN}Winter is Coming... 🐺${NC}"
